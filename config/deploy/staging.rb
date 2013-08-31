raise "TEMPORARY BROKEN: need to set up correct paths to private pubs etc, \nFOR PRODUCTION USE: cap production deploy:migrations"

server 'kluuu-production.panter.ch', :app, :web, :db, :primary => true
set :branch, "develop"
set :rails_env, "production"
