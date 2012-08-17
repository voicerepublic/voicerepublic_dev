set :application, "kluuu.com"
set :repository,  "gitosis@devel.spampark.com:kluuu2.git"
set :scm, :git
set :scm_verbose, true
set :keep_releases, 3
set :user, "rp"
set :group, "www-data"
set :scm_username, "gitosis"
set :template_dir, "~/templates"



role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end


# Thinking Sphinx typing shortcuts
namespace :ts do
  
  desc "create ths-directories in shared dirs"
  task :setup, :roles => :app do
    puts "creating shared dirs for sphinx"
    run "mkdir -p #{shared_path}/db"
    run "mkdir -p #{shared_path}/db/sphinx"   
  end
  
  desc "configure thinking sphinx in production"
  task :conf , :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:config RAILS_ENV=production"
  end
  
  desc "initialize indexes in thinking sphinx"
  task :in , :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:index RAILS_ENV=production"
  end
  
  desc "start thinking sphinx in production"
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:start RAILS_ENV=production"
  end
  
  desc "stop running sphinx in production"
  task :stop, :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:stop RAILS_ENV=production"
  end
  
  desc "restart running sphinx-searchd in production"
  task :restart, :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:restart RAILS_ENV=production"
  end
  
  desc "rebuild indexes"
  task :rebuild, :roles => :app do
    run "cd #{current_path}; bundle exec rake ts:rebuild RAILS_ENV=production"
  end
end

