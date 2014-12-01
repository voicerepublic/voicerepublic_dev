namespace :talks do

  desc "Save all archived talks to update popularity"
  task popularity: :environment do
    Talk.archive.find_each do |talk|
      talk.save! # tiggers: `before_save :set_popularity`
    end
  end

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
    total = Talk.archived.count
    Talk.archived.each_with_index do |t, i|
      puts "#{i}/#{total} Update manifest file for talk (#{t.id}) #{t.title}"
      t.send(:update_manifest_file!)
    end
  end

end
