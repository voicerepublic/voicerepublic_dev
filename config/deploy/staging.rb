set :deploy_to, "/var/www/staging2.#{application}/staging"
set :rails_env, "production"
set :branch, "master"

role :web, "staging2.kluuu.com"       # Your HTTP server, Apache/etc
role :app, "staging2.kluuu.com"       # This may be the same as your `Web` server
role :db,  "db.kluuu.com", :primary => true        # This is where Rails migrations will run