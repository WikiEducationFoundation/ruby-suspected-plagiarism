Ruby API for accessing recent suspected plagiarism detected by CopyPatrol

This is essentially a rewrite of just the webservice from https://github.com/valhallasw/plagiabot/blob/master/webservice/api.py

Toolforge webservice implementation based on https://phabricator.wikimedia.org/T141388#6258714
## Setup

* create a tool and log in to it
* clone this repo into `www/ruby/src`
* turn `replica.my.cnf` into `cnf.yml` and move it to the git directory
* add `ithenticate_user` and `ithenticate_password` values to `cnf.yml`.
* create `service.template` like this:
  ```
  backend: kubernetes
  type: ruby2.7
  ```
* Enter a webservice shell then install the gems from within the shell. This will install them using the bundler version of the `ruby2.7` Docker container (rather than the version available to the tool account) so that it will be run successfully.
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
* `webservice ruby2.7 start $HOME/start.sh`

## Deploying updates

* stop the webservice: `webservice stop`
* pull in the new code:
  * `cd www/ruby/src`
  * `git pull`
* repeat `bundle install` process from a shell, if any gem requirements changed
* restart the webservice: `webservice ruby2.7 start $HOME/start.sh`
