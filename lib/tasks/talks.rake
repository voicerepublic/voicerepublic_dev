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

  desc "Update or create manifest for all talks (caution: this might take a while)"
  task manifests: :environment do
    Talk.all.each do |t|
      puts "Update manifest file for talk (#{t.id}) #{t.title}"
      t.send(:update_manifest_file!)
    end
  end

end
