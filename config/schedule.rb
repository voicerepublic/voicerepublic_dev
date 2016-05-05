# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# rbenv setup
set :job_template, "bash -l -c 'export PATH=/home/app/.rbenv/shims:$PATH && :job'"
set :output, "/home/app/app/shared/log/whenever-cron.log"

# Task invokation should be once in an hour
every 40.minutes, :roles => [:app] do
  rake "talks:remind"
end

every 60.minutes, :roles => [:app] do
  rake "cleanup:fix_abandoned_talk_state"
end

every 60.minutes, :roles => [:app] do
  rake "validity:check"
end

every 3.hours, roles: [:app] do
  rake 'talks:popularity'
end

every 24.hours, at: '2:00 am', roles: [:app] do
  runner "Metric.snapshot!"
end

every 24.hours, at: '11:00 pm', roles: [:app] do
  rake 'build:sitemap'
end

#every 1.hour, roles: [:app] do
#  runner 'Sync::Rp16.new.sync'
#end

every 1.minute, roles: [:app] do
  rake 'sync:ftp'
end
