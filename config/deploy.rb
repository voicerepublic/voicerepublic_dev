# TODO setup thinking sphinx
# TODO setup whenever
# see https://semaphoreapp.com/blog/2013/11/26/capistrano-3-upgrade-guide.html

# config valid only for Capistrano 3.1
lock '3.1.0'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '1.9.3-p448'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}
#set :rbenv_roles, :all # default value

set :application, 'kluuu2'
set :repo_url, 'git@github.com:munen/voicerepublic_dev.git'

set :ssh_options, { forward_agent: true }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/rails/app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{ config/database.yml }

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache
#                      tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{ log tmp/pids public/system }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rails_env, 'production'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "RAILS_ENV=#{fetch(:rails_env)} $HOME/bin/unicorn_wrapper restart"
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
  end

end
