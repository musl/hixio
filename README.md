# hix.io
This is my jekyll-based blog.

## Manual Workflow
1. git clone https://github.com/musl/hixio
1. cd `hix.io`
1. `bundle install`
1. `jekyll build`
1. `rsync --delete -aPve ssh _site/ hix.io:/usr/local/hix.io/www/`

## Automated Workflow
1. git clone https://github.com/musl/hixio
1. cd `hix.io`
1. `bundle install`
1. `ansible-playbook ansible/deploy.yaml`

