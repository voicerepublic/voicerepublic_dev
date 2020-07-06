require 'json'

# config valid only for Capistrano 3.1
lock '3.4.1'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.4.9'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}
#set :rbenv_roles, :all # default value
#set :rbenv_custom_path, '/home/app/.rbenv'

set :application, 'voice_republic'
set :repo_url, 'git@github.com:voicerepublic/voicerepublic_dev.git'

set :ssh_options, { forward_agent: true }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/app/app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
#set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{ config/database.yml
                       config/bumpy_bridge.yml
                       config/settings.local.yml }

# Default value for linked_dirs is []
set :linked_dirs, %w{ log
                      tmp/processing
                      tmp/pids
                      public/system
                      public/versions
                      public/releases }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rails_env, 'production'

set :me, %x[whoami;hostname].split.join('@')

namespace :deploy do

  task :slack_started do
    slack "#{fetch(:me)} STARTED a deployment of "+
          "#{fetch(:application)} (#{fetch(:branch)}) to #{fetch(:stage)}"
  end
  after :started, :slack_started


  task :slack_finished do
    slack "#{fetch(:me)} FINISHED a deployment of "+
          "#{fetch(:application)} (#{fetch(:branch)}) to #{fetch(:stage)}"
  end
  after :finished, :slack_finished


  task :cljsbuild do
    on release_roles(fetch(:assets_roles)) do
      path = release_path + 'lib/vrng'
      # requires java & leinigen
      execute "cd #{path} && $HOME/bin/lein clean"
      execute "cd #{path} && $HOME/bin/lein cljsbuild once min"
    end
  end
  before :compile_assets, :cljsbuild


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "RAILS_ENV=#{fetch(:rails_env)} $HOME/bin/unicorn_wrapper restart"

      monit_restart 'flux_capacitor',
                    'dj-trigger-0',
                    'dj-mail-0',
                    'mediator',
                    'slacker'

      # Will deliberately keep private_pub and rtmpd running
      # since we'll almost never have to change their code base
      # resp. config. If a restart is nescesarry use the web
      # interface of monit to restart those processes.
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end

    # unfortunately it does not work like this
    # on roles(:web) do
    #   execute :rake, 'build:sitemap'
    # end
  end



  task :clear_old_caches do
    on roles(:app) do
      within release_path do
        execute :rake, "deploy:cleanup:clear_old_caches"
      end
    end
  end
  after :finishing, :clear_old_caches

end



def slack(message)
  url = "https://voicerepublic.slack.com/services/hooks/incoming-webhook"+
        "?token=VtybT1KujQ6EKstsIEjfZ4AX"
  payload = {
    channel: '#voicerepublic_tech',
    username: 'capistrano',
    text: message,
    icon_emoji: ':floppy_disk:'
  }
  json = JSON.unparse(payload)
  cmd = "curl -X POST --data-urlencode 'payload=#{json}' '#{url}' 2>&1"
  %x[ #{cmd} ]
end


def monit_restart(*names)
  names.each do |name|
    execute "curl -s 'http://localhost:2812/#{name}' "+
            "--data 'action=restart' 2>&1 1>/dev/null"
  end
end
