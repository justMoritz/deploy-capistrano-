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
THE BRUTE-FORCE FIX


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


