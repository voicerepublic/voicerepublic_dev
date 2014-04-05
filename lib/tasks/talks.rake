namespace :talks do
  desc "Notify all participants of event about upcoming talk"
  task remind: :environment do
    Talk.prelive.find_each do |talk|
      hours = ((talk.starts_at  - Time.now.in_time_zone) / 1.hour).round

      if [24, 3].include?(hours)
        talk.venue.users.each do |user|
          UserMailer.reminder(talk, user).deliver
        end
      end
    end
  end
end
