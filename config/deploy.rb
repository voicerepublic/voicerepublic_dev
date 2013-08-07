require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'whenever/capistrano'

#require 'thinking_sphinx/deploy/capistrano'  # strange: tasks do exist although not required ?
set :application, "kluuu2"
set :repository,  "gitosis@git.panter.ch:klu-001.git"
set :scm, :git
set :scm_verbose, true
set :keep_releases, 5
set :user, "rails"
set :use_sudo, false
set :default_run_options, { :pty => true }
set :ssh_options, { :forward_agent => true }

set :rails_env, "production"

# set :template_dir, "~/templates"
# set :stages , %w{staging production}
# set :default_stage, "staging"
set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
set :whenever_roles, [:app]

task :update_config_links, :roles => [:app] do
  run "ln -sf #{shared_path}/config/* #{release_path}/config/"
end
after "deploy:update_code", :update_config_links

after "deploy", "deploy:cleanup"

#before 'deploy:update_code', 'sphinx:stop'
#after "deploy:setup", "dbconf:setup" 
#after "deploy:finalize_update", "dbconf", 'sphinx:symlink_indexes', 'whenever:update_crontab', 'kluuu:link_paypal_certs' #, 'sphinx:start'
##after 'deploy:update_code'#, 'sphinx:start'


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




# namespace :sphinx do
#   
#   desc "Symlink Sphinx indexes"
#   task :symlink_indexes, :roles => [:app] do
#     run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
#     run "ln -nfs #{shared_path}/config/#{rails_env}.sphinx.conf #{release_path}/config/#{rails_env}.sphinx.conf"
#   end
#   
#   desc "stop Sphinx"
#   task :stop, :roles => :app do
#     run "cd #{current_path}; bundle exec rake ts:stop RAILS_ENV=#{rails_env}"
#     run "ps ax | grep search"
#   end
#   
#   desc "start Sphinx"
#   task :start, :roles => :app do
#     run "ps ax | grep search"
#     run "cd #{release_path}; bundle exec rake ts:start RAILS_ENV=#{rails_env}"
#   end
#   
#   desc "restart Sphinx"
#   task :restart, :roles => :app do
#     run "cd #{current_path}; bundle exec rake ts:restart RAILS_ENV=#{rails_env}"
#   end
#   
#   desc "reindex sphinx"
#   task :reindex, :roles => :app do
#     run "cd #{current_path}; bundle exec rake ts:reindex RAILS_ENV=#{rails_env}"
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

