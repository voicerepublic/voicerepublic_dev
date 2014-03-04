# FIXME: still expecting events
namespace :talks do
  desc "Notify all participants of event about upcoming talk"
  task :remind => :environment do
    Event.not_past.find_each do |event|
      hours = ((event.start_time  - Time.now.in_time_zone) / 1.hour).round

      if [24, 3].include?(hours)
        event.venue.users.each do |user|
          UserMailer.reminder_notification(event, user).deliver
        end        
      end
    end
  end
end
