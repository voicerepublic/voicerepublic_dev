namespace :kluuu do
  desc "start faye server with private_pub"
  task :start_private_pub do
    exec "bundle exec rackup private_pub.ru -s thin -E production -P tmp/pids/faye.pid -D"
  end

  desc "stop private_pub - faye with simple kill"
  task :stop_private_pub do
    exec "kill -9 `cat tmp/pids/faye.pid`"
    exec "rm tmp/pids/faye.pid"
  end
end
