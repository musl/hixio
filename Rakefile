
require 'date'

task :default => [:serve]

desc 'Serve the static site locally.'
task :serve do
  exec 'jekyll serve --watch --livereload'
end

task :post do
  title = ENV['title'] or
    abort 'Missing environment variable "title". Example: rake post title="some title"'

  date = DateTime.now

  POST = '_posts/%s-%s.md' % [
    date.strftime( '%F' ),
    title.downcase.split( /\s+/ ).join( '-' ),
  ]

  TEMPLATE = <<-TEMPLATE
---
layout: post
published: true
title: #{title}
date: #{date.iso8601}
---

  TEMPLATE

  File.write( POST, TEMPLATE )
  system(ENV['EDITOR'] || 'vim', POST)
end

