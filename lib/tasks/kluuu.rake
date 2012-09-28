namespace :kluuu do
  desc "start faye server with private_pub"
  task :start_private_pub do
    exec "bundle exec rackup -d private_pub.ru -s thin -E production -P tmp/pids/faye.pid -D"
  end
end