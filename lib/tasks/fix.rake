# the idead behind fix:all is that this can be run after each
# deploy. the key to success is idempotency.
#
namespace :fix do
  task all: %w( talks
                language
                storage
                slugs
                reminder
                default_venues
                orphaned_venues
                user
                user_summary ).map(&:to_sym)

  desc 'make all talks valid'
  task talks: :environment do
    Talk.find_each do |t|
      unless t.valid?
        if t.venue_id.nil?
          t.destroy
        else
          t.tag_list = 'no_tag' if t.tag_list.blank?
          t.description = 'No description.' if t.description.blank?

          # h = ActionController::Base.helpers
          # text = h.truncate(t.description, length: Settings.limit.text)
          t.description = t.description[0, Settings.limit.text]

          t.save!
        end
      end
    end

    Talk.archived.where(processed_at: nil).each do |talk|
      talk.update_attribute :processed_at, talk.ends_at
      puts "Talk #{talk.id} set processed_at to ends_at (#{talk.ends_at})"
    end
  end

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

  desc 'generate tokens for users'
  task user_tokens: :environment do
    User.find_each(conditions: { authentication_token: nil }) do |user|
      unless user.save
        puts "INVALID USER #{user.id}"
        puts '  ' + user.errors.to_a * "\n  "
      end
    end
  end

  desc 'fix invalid users'
  task user: :environment do
    h = ActionController::Base.helpers
    users = []

    conditions = [
      { summary: nil },
      "length(about) > #{Settings.limit.text}",
      "length(summary) > #{Settings.limit.string}",
      { firstname: nil },
      { lastname: nil }
    ]

    users = conditions.map { |cond|
      User.where(cond)
    }.flatten

    users.each do |user|
      unless user.firstname
        puts "setting firstname for user #{user.id}"
        user.firstname ||= 'noname'
      end

      unless user.lastname
        puts "setting lastname for user #{user.id}"
        user.lastname ||= 'noname'
      end

      if user.slug.empty?
        puts "re-setting slug for user #{user.id}"
        user.slug = nil
      end

      unless user.summary
        puts "setting summary for user #{user.id}"
        text = user.about_as_plaintext
        text = h.truncate(text, length: Settings.limit.string)
        user.summary = text
      end

      if user.summary.length >= Settings.limit.string
        user.summary = h.truncate(user.summary, length: Settings.limit.string)
        puts "shortening user summary for user #{user.id}"
      end

      if user.about.length >= Settings.limit.text
        puts "before: length is according to puts: #{user.about.length}"
        puts "before: \n: #{user.about}"
        user.about = h.truncate(user.about, length: Settings.limit.text)
        puts "after: length is according to puts: #{user.about.length}"
        puts "after: \n: #{user.about}"
        puts "shortening user about for user #{user.id}"
      end

      user.save!
    end

  end

  desc 'set a dummy of talk#description is blank'
  task talk_descriptions: :environment do
    Talk.where(description: '').each do |talk|
      talk.update_attribute :description, '<i>blank description</i>'
    end
  end

  desc 'destroy orphaned venues'
  task orphaned_venues: :environment do
    orphans = Venue.where('user_id NOT IN (?)', User.pluck(:id))
    puts "Destroying #{orphans.count} orphanened venues." if orphans.count
    orphans.destroy_all
  end

end
