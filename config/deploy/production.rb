set :deploy_to, "/var/www/www.#{application}/production"
set :rails_env, "production"
set :branch, "production"

role :web, "a.www.kluuu.com"       # Your HTTP server, Apache/etc
role :app, "a.www.kluuu.com" # This may be the same as your `Web` server
role :db, "a.db.kluuu.com", :primary => true       # This is where Rails migrations will run