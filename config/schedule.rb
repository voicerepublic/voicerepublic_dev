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
  rake "cleanup:guests"
end

every 60.minutes, :roles => [:app] do
  rake "cleanup:fix_abandoned_talk_state"
end

every 60.minutes, :roles => [:app] do
  rake "cleanup:check_validity"
end
