#TODO nginx startup: ~/nginx-rtmp/nginx-1.5.3/objs/nginx -p ~/nginx-rtmp/nginx-run/ -c ~/nginx-rtmp/nginx-run/conf/nginx.conf
#TODO RAILS_ENV=production bundle exec rackup -d private_pub.ru -s thin -E production -P tmp/pids/faye.pid -D

server 'kluuu-production.panter.ch', :app, :web, :db, :primary => true
set :branch, "develop"
