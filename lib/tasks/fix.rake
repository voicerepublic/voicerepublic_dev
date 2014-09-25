# the idead behind fix:all is that this can be run after each
# deploy. the key to success is idempotency.
namespace :fix do
  task all: [:language, :storage, :slugs, :reminder, :default_venues]

  desc 'prepopulate talk#language with "en"'
  task language: :environment do
    Talk.where(language: nil).each do |talk|
      talk.update_column :language, 'en'
    end
  end

  desc 'prepopulate talk#storage with an empty hash'
  task storage: :environment do
    Talk.where(storage: nil).each do |talk|
      talk.update_column :storage, {}
    end
  end

  desc 'create slugs for all venues and talks wihtout slug'
  task slugs: :environment do
    venues = Venue.where(slug: nil)
    venues.each_with_index do |venue, index|
      puts "Venue #{index}/#{venues.size} #{venue.title}"
      venue.save!
    end

    talks = Talk.where(slug: nil)
    talks.each_with_index do |talk, index|
      puts "Talk #{index}/#{talks.size} #{talk.title}"
      talk.save!
    end
  end

  desc 'delete all reminders which have no valid rememberable'
  task reminder: :environment do
    Reminder.all.each do |reminder|
      reminder.destroy if reminder.rememberable.nil?
    end
  end

  desc 'create missing default_venues'
  task default_venues: :environment do
    conds = { default_venue_id: nil, guest: nil }
    total = User.where(conds).count
    counter = 0
    User.find_each(conditions: conds, batch_size: 100) do |user|
      counter += 1
      puts "Create default venue for user #{counter}/#{total} #{user.name}"
      user.create_and_set_default_venue!
    end
  end

end
