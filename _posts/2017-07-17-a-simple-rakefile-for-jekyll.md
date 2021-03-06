---
layout: post
published: true
title: A Simple Rakefile for Jekyll
date: 2017-07-17T08:29:10-07:00
---

I knocked together a `Rakefile` for use with my shiny new jekyll-based
site. I wanted an easy way to kick out new posts with little work.

With the rakefile below, it's as easy as:

``` shell
$ rake post title="The Curious Etymology of Jute"
```

That command will create a new templated markdown file with front matter
including the current date and point your `$EDITOR` (or vim) at it.

Here's the whole file:

``` ruby
# vim: set ft=ruby sw=2 ts=2:

require 'date'

task :default => [:serve]

desc 'Serve the static site locally.'
task :serve do
  exec 'jekyll serve --watch --livereload'
end

desc 'Deploy the site to production'
task :deploy do
  exec 'ansible-playbook -i ansible/inventory ansible/deploy.yaml'
end

desc 'Clean up.'
task :clean do
  exec 'jekyll clean'
end

desc 'Create a new post.'
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
