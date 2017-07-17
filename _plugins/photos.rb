# vim: set ft=ruby sw=2 ts=2:

require 'fileutils'
require 'pathname'
require 'pp'

require 'mini_magick'

module HixIO
  class Photos < Jekyll::Generator

    DEFAULTS = {
      'photo_path' => 'assets/photos',
      'photo_matcher' => '*.{gif,jpg,jpeg,png}',
      'thumbnail_path' => 'assets/photos/thumbnails',
      'thumbnail_size' => '100x100',
      'thumbnail_gravity' => 'center',
    }.freeze

    def thumbnail( src, dst, opts )
      return if dst.exist? && src.mtime <= dst.mtime

      image = MiniMagick::Image.open( src )
      image.combine_options do |i|
        i.resize( '%s^' % [opts['thumbnail_size']] )
        i.extent( opts['thumbnail_size'] )
        i.gravity( opts['thumbnail_gravity'] )
      end
      image.write( dst )
    end

    def generate( site )
      site.config['photos'] = DEFAULTS.merge( site.config['photos'] || {} )
      config = site.config['photos']

      page = site.pages.detect { |page| page.name == 'photos.html' }
      root = Pathname.new( site.source )
      photos = Pathname.glob( root.join( config['photo_path'], config['photo_matcher'] ), File::FNM_CASEFOLD )
      thumbnail_dir = root.join( config['thumbnail_path'] )

      FileUtils.mkdir_p thumbnail_dir

      page.data['photos'] = photos.reduce( [] ) do |obj,path|
        thumbnail_path = thumbnail_dir.join( path.basename )
        thumbnail( path, thumbnail_path, config )

        obj << {
          'path' => '/%s' % [path.relative_path_from( root )],
          'thumbnail' => '/%s' % [thumbnail_path.relative_path_from( root )],
          'alt' => path.basename.to_s,
          'date' => path.mtime,
        }
      end

      # Order by date, descending.
      page.data['photos'].sort! { |a,b| b['date'] <=> a['date'] }
    end
  end
end
