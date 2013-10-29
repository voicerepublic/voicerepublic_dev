#TODO nginx startup: ~/nginx-rtmp/nginx -p /home/rails/nginx-rtmp -c ~/nginx-rtmp/nginx.conf
#TODO RAILS_ENV=production bundle exec rackup -d private_pub.ru -s thin -E production -P tmp/pids/faye.pid -D

server 'kluuu-staging.panter.ch', :app, :web, :db, :primary => true
set :branch, "develop"
set :rails_env, "production"
