# the idead behind fix:all is that this can be run after each
# deploy. the key to success is idempotency.
namespace :fix do
  task all: [:language, :storage, :slugs]

  task language: :environment do
    Talk.where(language: nil).each do |talk|
      talk.update_column :language, 'en'
    end
  end

  task storage: :environment do
    Talk.where(storage: nil).each do |talk|
      talk.update_column :storage, {}
    end
  end

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
end
