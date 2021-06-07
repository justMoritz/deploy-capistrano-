set :stage, :staging

# Simple Role Syntax
# ==================
role :app, %w{moritz@31.220.53.195}
role :web, %w{moritz@31.220.53.195}
role :db,  %w{moritz@31.220.53.195}

# Extended Server Syntax
# ======================
server '31.220.53.195', user: 'moritz', roles: %w{web app db}

# set :wpcli_remote_url, "ranch.moritz.work"
# set :wpcli_local_url, "hines.moritz"
# set :tmp_dir, "/home/moritz/tmp"
# set :deploy_to, -> { "/home/moritz/deployments/hines"  }
# set :branch, "master"
#
#
set :wpcli_remote_url, "#{ENV['CAP_WPCLI_REMOTE_URL']}"
set :wpcli_local_url, "#{ENV['CAP_WPCLI_LOCAL_URL']}"
set :tmp_dir, "#{ENV['CAP_TMP_DIR']}"
set :deploy_to, -> { "#{ENV['CAP_DEPLOY_TO']}"  }
set :branch, "#{ENV['CAP_GIT_REPO_BRANCH']}"

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(~/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }

fetch(:default_env).merge!(wp_env: :staging)

