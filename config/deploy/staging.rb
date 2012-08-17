set :deploy_to, "/var/www/staging.#{application}/staging"
set :rails_env, "staging"
set :branch, "staging"

role :web, "staging.kluuu.com"       # Your HTTP server, Apache/etc
role :app, "staging.kluuu.com"       # This may be the same as your `Web` server
role :db,  "db.kluuu.com", :primary => true        # This is where Rails migrations will run