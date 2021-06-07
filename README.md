# capistrano
cap for own server

If permissions issue from cap
https://stackoverflow.com/questions/48124385/capistrano-deploy-failing-on-gitcheck-permission-denied-publickey#answer-48127662


### Cap Commands
    bundle exec cap staging deploy

    bundle exec cap staging wpcli:db:push
    bundle exec cap staging wpcli:uploads:rsync:push

    bundle exec cap staging wpcli:db:pull
    bundle exec cap staging wpcli:uploads:rsync:pull


### Composer Auth File

Edit the composer authentication configuration file `~/.composer/auth.json.`
Alternatively, this file might be in `~/.config.composer/`

`nano ~/.composer/auth.json`
Then replace the following.

    "github-oauth": {
      "github.com": "ghp_[YOUR-PERSONAL-TOKEN]"
    }
With this (basic auth):

    "http-basic": {
      "github.com": {
        "username": "[YOUR-GITHUB-USERNAME]",
        "password": "ghp_[YOUR-PERSONAL-TOKEN]"
      }
    }
Source: https://stackoverflow.com/questions/26691681/composer-unexpectedvalueexception-error-will-trying-to-use-composer-to-install/67041384#67041384


### Use Composer v1
place `#other/composer.phar` in `/user/bin` if need be


### Use MySQL 5.7
- Install via brew like so: https://msanatan.com/2018/08/15/revert-mysql-from-8-to-5-in-homebrew/
- or find and ln the MAMP version like so: https://stackoverflow.com/questions/36610619/mysql-is-not-found-anywhere-on-computer
    - Run `ps aux | grep mysql`
    - Note location of mysql binary
    - link into `ln -s /Applications/MAMP/Library/bin/mysqld /usr/bin/mysql`


### php ini
Make sure you have enough mem https://make.wordpress.org/cli/handbook/guides/common-issues/#php-fatal-error-allowed-memory-size-of-999999-bytes-exhausted-tried-to-allocate-99-bytes



