require 'capistrano-rbenv'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'thinking_sphinx/deploy/capistrano'

set :rbenv_ruby_version, "1.9.3-p448"
set :rbenv_install_dependencies, false

#require 'thinking_sphinx/deploy/capistrano'  # strange: tasks do exist although not required ?
set :application, "kluuu2"
set :repository,  "git@github.com:munen/voicerepublic_dev.git"
set :scm, :git
set :keep_releases, 5
set :user, "rails"
set :use_sudo, false
set :default_run_options, { :pty => true }
set :ssh_options, { :forward_agent => true }

set :deploy_to, "/home/rails/app"
set :rails_env, "production"

# set :template_dir, "~/templates"
# set :stages , %w{staging production}
# set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"
set :whenever_environment, "production"
set :whenever_roles, [:app]
#TODO update bundler on the servers for using: require 'whenever/capistrano'
require "whenever/capistrano/recipes"
after "deploy:finalize_update", "whenever:update_crontab"
after "deploy:rollback", "whenever:update_crontab"

task :update_config_links, :roles => [:app] do
  run "ln -sf #{shared_path}/config/* #{release_path}/config/"
end
after "deploy:update_code", :update_config_links

after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "RAILS_ENV=#{rails_env} $HOME/bin/unicorn_wrapper restart"
  end
end

before 'deploy:update_code', 'thinking_sphinx:stop'
after  'deploy:update_code', 'thinking_sphinx:start'

#after "deploy:setup", "dbconf:setup"
#after "deploy:finalize_update", "dbconf", 'sphinx:symlink_indexes', 'whenever:update_crontab', 'kluuu:link_paypal_certs' #, 'sphinx:start'
#after "deploy:finalize_update", 'sphinx:symlink_indexes'

# # If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#    task :start do ; end
#    task :stop do ; end
#    task :restart, :roles => :app, :except => { :no_release => true } do
#      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#    end
# end


# namespace :dbconf do
#
#   task :default do
#     on_app
#     on_db
#   end
#
#   desc "create a 'config' directory in shared_path for database.yml - to symlink it with everey deploy"
#   task :setup do
#     run "mkdir -p #{shared_path}/config"
#     puts "you should place your database.yml into shared_path/config..."
#   end
#
#   desc "symlink database yml to prod-host"
#   task :on_app, :roles => :app do
#     puts "linking database.yml from shared_path to current on app"
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#   end
#
#   desc "symlink database yml to db-host"
#   task :on_db, :roles => :db do
#     puts "linking database.yml from shared_path to current on db"
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#   end
# end


# namespace :kluuu do
#
# 	desc "link paypal-certs to production-host"
# 	task :link_paypal_certs, :roles => :web do
# 		puts "linking paypal-certs"
# 		run "ln -nfs #{shared_path}/config/certs_production #{release_path}/config/certs_production"
# 	end
#
#   desc "Prints the available releases on webserver"
#   task :show_releases, :roles => :app do
#     puts capture("cd #{releases_path}; ls;")
#   end
#
#   desc "Prints available space on server"
#   task :free_space, :roles => [:app, :db] do
#     puts capture("df -h")
#   end
#
#   namespace :faye do
#     desc "start faye server with private_pub"
#     task :start, :roles => :app do
#       run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rackup -d private_pub.ru -s thin -E production -P tmp/pids/faye.pid -D "
#     end
#     desc "stop faye server"
#     task :stop, :roles => :app do
#       run "cd #{current_path}; kill -9 `cat tmp/pids/faye.pid`; rm tmp/pids/faye.pid"
#     end
#     desc "restart faye server"
#     task :restart, :roles => :app do
#       run "cd #{current_path}; kill -HUP `cat tmp/pids/faye.pid`"
#     end
#   end
# end

