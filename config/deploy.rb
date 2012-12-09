require 'capistrano/ext/multistage'
require 'thinking_sphinx/deploy/capistrano'

set :application, "kluuu.com"
set :repository,  "gitosis@devel.spampark.com:kluuu2.git"
set :scm, :git
set :scm_verbose, true
set :keep_releases, 3
set :user, "rp"
set :group, "www-data"
set :scm_username, "gitosis"
set :template_dir, "~/templates"
set :stages , %w{staging production}
set :default_stage, "staging"

default_run_options[:pty] = true


#role :web, "staging2.kluuu.com"                          # Your HTTP server, Apache/etc
#role :app, "staging2.kluuu.com"                          # This may be the same as your `Web` server
#role :db,  "db.kluuu.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"




before 'deploy:update_code', 'sphinx:stop'
after "deploy:restart", "deploy:cleanup"
after "deploy:setup", "dbconf:setup" 
after "deploy:finalize_update", "dbconf", 'sphinx:symlink_indexes'
after 'deploy:update_code', 'sphinx:start'



# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end




namespace :dbconf do
  
  task :default do
    on_app
    on_db
  end
  
  desc "create a 'config' directory in shared_path for database.yml - to symlink it with everey deploy"
  task :setup do
    run "mkdir -p #{shared_path}/config"
    puts "you should place your database.yml into shared_path/config..."
  end

  desc "symlink database yml to prod-host"
  task :on_app, :roles => :app do
    puts "linking database.yml from shared_path to current on app"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc "symlink database yml to db-host"
  task :on_db, :roles => :db do
    puts "linking database.yml from shared_path to current on db"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end




namespace :sphinx do
  desc "Symlink Sphinx indexes"
  task :symlink_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end
  
  task :stop, :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:stop RAILS_ENV=#{rails_env}"
  end
  
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:start RAILS_ENV=#{rails_env}"
  end
end


namespace :kluuu do
  
  desc "Prints the available releases on webserver"
  task :show_releases, :roles => :app do
    puts capture("cd #{releases_path}; ls;")
  end
  
  desc "Prints available space on server"
  task :free_space, :roles => [:app, :db] do
    puts capture("df -h")
  end
  
  namespace :faye do
    desc "start faye server with private_pub"
    task :start, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rackup -d private_pub.ru -s thin -E production -P tmp/pids/faye.pid -D "
    end
    desc "stop faye server"
    task :stop, :roles => :app do
      run "cd #{current_path}; kill -9 `cat tmp/pids/faye.pid`; rm tmp/pids/faye.pid"
    end
    desc "restart faye server"
    task :restart, :roles => :app do
      run "cd #{current_path}; kill -HUP `cat tmp/pids/faye.pid`"
    end
  end
end

