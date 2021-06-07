set :stage, :production

# Simple Role Syntax
# ==================
role :app, ["#{ENV['CAP_PRODUCTION_REMOTE_USER']}@ftp.hostingbymmc.com"]
role :web, ["#{ENV['CAP_PRODUCTION_REMOTE_USER']}@ftp.hostingbymmc.com"]
role :db,  ["#{ENV['CAP_PRODUCTION_REMOTE_USER']}@ftp.hostingbymmc.com"]

# Extended Server Syntax
# ======================
server 'ftp.hostingbymmc.com', user: ENV['CAP_PRODUCTION_REMOTE_USER'], roles: %w{web app db}

set :wpcli_remote_url, URI(ENV['CAP_PRODUCTION_URL']).host
set :wpcli_local_url, "#{ENV['CAP_DEV_SUBDOMAIN']}.#{ENV['USER']}.mmcdevserver"
set :tmp_dir, "/home/#{ENV['CAP_PRODUCTION_REMOTE_USER']}/tmp"
set :deploy_to, -> { "/home/#{ENV['CAP_PRODUCTION_REMOTE_USER']}/deployments"  }
set :branch, "#{ENV['CAP_PRODUCTION_GIT_REPO_BRANCH']}"

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(~/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }

fetch(:default_env).merge!(wp_env: :production)
