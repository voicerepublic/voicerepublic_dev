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

set :job_template, "bash -l -c 'export PATH=/home/rails/.rbenv/shims:$PATH && :job'"
set :output, "/home/rails/app/shared/log/whenever-cron.log"

every 60.minutes, :roles => [:app] do
  runner 'Venue.notify_next_day; Venue.notify_next_2_hour'
end

every 67.minutes, :roles => [:app] do
  rake "thinking_sphinx:reindex"
end

every :day, :at => '03:15am', :roles => [:app] do
  rake "recordings:merge"
end
