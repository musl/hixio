---
layout: post
published: true
title: A simple rakefile for jekyll
date: 2017-07-17T08:29:10-07:00
---

I knocked together a `Rakefile` for use with my shiny new jekyll-based site.

```ruby
#!/usr/bin/env rake
# vim: set ft=ruby sw=2 ts=2:

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
```
