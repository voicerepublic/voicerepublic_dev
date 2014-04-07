namespace :cleanup do
  desc 'Delete guest users that are no longer active'
  task :guests => :environment do
    User.where('firstname like ?', '%guest%').
      where('last_request_at < ?', 4.hours.ago).destroy_all
  end

  # When a talk has been created, but the host never shows, the talk will never
  # proceed to further states. For the time being, this is corrected here.
  # TODO: Maybe it's better to implement an additional state machine state
  # 'abandoned'
  desc 'Set abandoned talks(host never showed up) to state postlive'
  task :fix_abandoned_talk_state => :environment do
    Talk.prelive.where("ends_at < ?", DateTime.now).each do |t|
      t.update_attribute :state, :postlive
      t.save!
    end
  end
end
