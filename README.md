Ruby API for accessing recent suspected plagiarism detected by eranbot / plagiabot.

This is essentially a rewrite of just the webservice from https://github.com/valhallasw/plagiabot/blob/master/webservice/api.py

Toolforge webservice implementation based on https://phabricator.wikimedia.org/T141388#6258714
## Setup

* create a tool and log in to it
* clone this repo into `www/ruby/src`
* turn `replica.my.cnf` into `cnf.yml` and move it to the git directory
* create `service.template` like this:
  ```
  backend: kubernetes
  type: ruby25
  ```
* Enter a webservice shell then install the gems within the shell:
  * `webservice shell`
  * `cd www/ruby/src`
  * `bundle install --path $HOME/www/ruby/vendor`

* Create a `start.sh` script to start the server:
  ```
  #!/bin/sh
  cd $HOME/www/ruby/src
  APP_ENV=production bundle exec ruby server.rb
  ```
* Make the script executable
* `webservice ruby25 start $HOME/start.sh`
