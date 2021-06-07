set :application, 'capistrano_bedrock'
# set :repo_url, "git@bitbucket.org:mixedmediacreations/#{ENV['CAP_GIT_REPO_NAME']}.git"
# set :repo_url, "git@github.com:justMoritz/senih.git"
set :repo_url, "#{ENV['CAP_GIT_REPO']}"

# this will force a regex search-replace for development-domain when you push to staging/production
namespace :wpcli do
  namespace :db do
    before :push, :replace_url_devserver do
      set :wpcli_local_url_original, fetch(:wpcli_local_url)
      set :wpcli_local_url, "'" + fetch(:wpcli_local_url).sub(".#{ENV['USER']}.", '\..*?\.') + "'"
      set :wpcli_args, "--regex --url=" + fetch(:wpcli_local_url_original)
    end
  end
end

namespace :wpcli do
  namespace :uploads do
    namespace :rsync do
      before :pull, :set_pull_config do
        set :wpcli_rsync_options, "-avz --rsh=ssh --progress --omit-dir-times"
      end
    end
  end
end

# Branch options
# Prompts for the branch name (defaults to current branch)
#ask :branch, -> { `git rev-parse --abbrev-ref HEAD`.chomp }

# Hardcodes branch to always be master
# This could be overridden in a stage config file
set :branch, :master

# Use :debug for more verbose output when troubleshooting
set :log_level, :info

# Apache users with .htaccess files:
# it needs to be added to linked_files so it persists across deploys:
set :linked_files, fetch(:linked_files, []).push('.env', 'web/.htaccess')
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('web/app/uploads')
set :linked_dirs, fetch(:linked_dirs, []).push('web/app/webp-express')

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :service, :nginx, :reload
    end
  end
end

# The above restart task is not run by default
# Uncomment the following line to run it on deploys if needed
# after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc 'Update WordPress template root paths to point to the new release'
  task :update_option_paths do
    on roles(:app) do
      within fetch(:release_path) do
        if test :wp, :core, 'is-installed'
          [:stylesheet_root, :template_root].each do |option|
            # Only change the value if it's an absolute path
            # i.e. The relative path "/themes" must remain unchanged
            # Also, the option might not be set, in which case we leave it like that
            value = capture :wp, :option, :get, option, raise_on_non_zero_exit: false
            if value != '' && value != '/themes'
              execute :wp, :option, :set, option, fetch(:release_path).join('web/wp/wp-content/themes')
            end
          end
        end
      end
    end
  end
end

# The above update_option_paths task is not run by default
# Note that you need to have WP-CLI installed on your server
# Uncomment the following line to run it on deploys if needed
# after 'deploy:publishing', 'deploy:update_option_paths'

# make sure that file is on the server. This will use composer v1(.7 I think) to work properly
SSHKit.config.command_map[:composer] = "php /usr/bin/composer-one.phar"
# SSHKit.config.command_map[:wp] =       "wp-cli-php /usr/bin/wp-cli.phar"

set :theme_path, Pathname.new("web/app/themes/#{ENV['CAP_THEME_NAME']}") #change to theme name
set :local_app_path, Pathname.new("#{ENV['CAP_LOCAL_APP_PATH']}") #absolute Path to physical Folder
set :local_theme_path, fetch(:local_app_path).join(fetch(:theme_path))

namespace :assets do
  task :compile do
    run_locally do
      within fetch(:local_theme_path) do
        execute :gulp, '--production'
      end
    end
  end

  task :copy do
    on roles(:web) do
      upload! "#{fetch(:local_theme_path).join('dist')}/", release_path.join(fetch(:theme_path)), recursive: true
    end
  end

  task deploy: %w(compile copy)
end

before 'deploy:updated', 'assets:deploy'



## WebpExpress ##

# These options are passed directly to rsync
# Append your options, overwriting the defaults may result in malfunction
# Ex: --recursive --delete --exclude .git*
set :wpcli_rsync_options, "-avz --rsh=ssh --progress"

# Local dir where WP stores the uploads
# IMPORTANT: Add trailing slash!
set :wpcli_local_webpexpress_dir, "web/app/webp-express/"

# Remote dir where WP stores the Webp-express
# IMPORTANT: Add trailing slash!
set :wpcli_remote_webpexpress_dir, -> {"#{shared_path.to_s}/web/app/webp-express/"}

set :ssh_options, { forward_agent: true, user: "deploy", auth_methods: ['publickey'], keys: %w(~/.ssh/id_rsa) }

namespace :wpcli do
  namespace :webpexpress do
    namespace :rsync do

      desc "Push local webp-express delta to remote machine"
      task :push do
        roles(:web).each do |role|
          puts role.netssh_options[:port]
          port = role.netssh_options[:port] || 22
          set :wpcli_rsync_options, fetch(:wpcli_rsync_options) + (" -e 'ssh -p #{port}'")
          run_locally do
            execute :rsync, fetch(:wpcli_rsync_options), fetch(:wpcli_local_webpexpress_dir), "#{role.user}@#{role.hostname}:#{fetch(:wpcli_remote_webpexpress_dir)}"
          end
        end
      end

      desc "Pull remote webp-express delta to local machine"
      task :pull do
        roles(:web).each do |role|
          run_locally do
            execute :rsync, fetch(:wpcli_rsync_options), "#{role.user}@#{role.hostname}:#{fetch(:wpcli_remote_webpexpress_dir)}", fetch(:wpcli_local_webpexpress_dir)
          end
        end
      end
    end
  end
end