# hix.io
This is my jekyll-based blog.

## Cold-Start
1. Install Ansible, bundler gem
1. git clone https://github.com/musl/hixio
1. cd `hix.io`
1. `bundle install`

## Server Setup
1. Install nginx
1. Configure nginx to serve static content
1. Set up SSH access for the deploy user
1. `chown deploy_user:www /path/to/www/root`

## Deploy
1. As the deploy user: `rake deploy`

