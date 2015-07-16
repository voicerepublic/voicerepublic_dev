# the idead behind fix:all is that this can be run after each
# deploy. the key to success is idempotency.
#
namespace :fix do
  task all: %w( appearances
                participations
                reminders
                messages
                talks
                language
                storage
                slugs
                default_venues
                orphaned_venues
                tag_taggings_count
                user
                user_summary ).map(&:to_sym) do

    puts "\n   Hey, I did my best to fix what needed fixing.\n"
  end

  desc 'destroy invalid appearances'
  task appearances: :environment do
    puts "-> Check appearances for nonexistent talks..."
    condition = "talk_id NOT IN (?)"
    ids = Talk.pluck(:id)
    Appearance.where(condition, ids).each do |appearance|
      puts "   Destroy invalid appearance %s" % appearance.id
      appearance.destroy
    end

    puts "-> Check appearances for nonexistent users..."
    condition = "user_id NOT IN (?)"
    ids = User.pluck(:id)
    Appearance.where(condition, ids).each do |appearance|
      puts "   Destroy invalid appearance %s" % appearance.id
      appearance.destroy
    end
  end

  desc 'destroy invalid participations'
  task participations: :environment do
    # missing venues
    puts "-> Check participations for missing venues..."
    Participation.where(venue_id: nil).each do |participation|
      puts "   Destroy invalid participation %s (venue missing)" % participation.id
      participation.destroy
    end

    # nonexistent venues
    puts "-> Check participations for nonexistent venues..."
    condition = "venue_id NOT IN (?)"
    ids = Venue.pluck(:id)
    Participation.where(condition, ids).each do |participation|
      puts "   Destroy invalid participation %s (venue nonexistent)" % participation.id
      participation.destroy
    end

    # nonexistent users
    puts "-> Check participations for nonexistent users..."
    condition = "user_id NOT IN (?)"
    ids = User.pluck(:id)
    Participation.where(condition, ids).each do |participation|
      puts "   Destroy invalid participation %s (user nonexistent)" % participation.id
      participation.destroy
    end

    # duplicates
    puts "-> Check participations for duplicates..."
    fields = [:user_id,:venue_id]
    Participation.select(fields).group(*fields).having("count(*) > 1").each do |participation|
      conditions = { user_id: participation.user_id, venue_id: participation.venue_id }
      puts "   Destroy duplicate entries for participation user %s" % conditions.inspect
      Participation.where(conditions).order('id ASC').offset(1).destroy_all
    end
  end

  desc 'destroy invalid reminders'
  task reminders: :environment do
    puts "-> Check reminders for missing rememberable..."
    Reminder.where(rememberable_id: nil).each do |reminder|
      puts "   Destroy invalid reminder %s (rememberable nonexistent)" % reminder.id
      reminder.destroy
    end

    puts "-> Check reminders for nonexistent rememberable... [TODO]"
    # condition = "venue_id NOT IN (?)"
    # ids = Venue.pluck(:id)
    # Reminder.where(condition, ids).each do |reminder|
    #   puts "   Destroy invalid reminder %s (venue nonexistent)" % reminder.id
    #   reminder.destroy
    # end

    puts "-> Check reminders for nonexistent user..."
    condition = "user_id NOT IN (?)"
    ids = User.pluck(:id)
    Reminder.where(condition, ids).each do |reminder|
      puts "   Destroy invalid reminder %s (user nonexistent)" % reminder.id
      reminder.destroy
    end

    # duplicates
    puts "-> Check reminders for duplicates..."
    fields = [:user_id, :rememberable_id, :rememberable_type]
    Reminder.select(fields).group(*fields).having("count(*) > 1").each do |reminder|
      conditions = { user_id: reminder.user_id,
                     rememberable_id: reminder.rememberable_id,
                     rememberable_type: reminder.rememberable_type }
      puts "   Destroy duplicate entries for reminder user %s" % conditions.inspect
      Reminder.where(conditions).order('id ASC').offset(1).destroy_all
    end
  end

  desc 'destroy invalid messages'
  task messages: :environment do
    puts "-> Check messages for nonexistent talks..."
    condition = "talk_id NOT IN (?)"
    ids = Talk.pluck(:id)
    Message.where(condition, ids).each do |message|
      puts "   Destroy invalid message %s (talk nonexistent)" % message.id
      message.destroy
    end
  end

  # ------------------------------------------------------------

  desc 'make all talks valid'
  task talks: :environment do
    puts "-> Check all talks for validity (this might take a while)..."
    Talk.find_each do |t|
      unless t.valid?
        if t.venue_id.nil?
          puts "   Destroy orphaned talk %s (venue nonexistent)" % t.id
          t.destroy
        else
          puts "   Fixing invalid talk %s" % t.id
          t.tag_list = 'no_tag' if t.tag_list.blank?
          t.description = 'No description.' if t.description.blank?

          # h = ActionController::Base.helpers
          # text = h.truncate(t.description, length: Settings.limit.text)
          t.description = t.description[0, Settings.limit.text]

          t.save!
        end
      end
    end

    puts "-> Check archived talks for missing processed_at..."
    Talk.archived.where(processed_at: nil).each do |talk|
      talk.update_attribute :processed_at, talk.ends_at
      puts "   Fix talk #{talk.id}, set processed_at to ends_at (#{talk.ends_at})"
    end
  end

  desc 'prepopulate talk#language with "en"'
  task language: :environment do
    puts "-> Check talks for missing language..."
    Talk.where(language: nil).each do |talk|
      puts "   Fix language of talk %s" % talk.id
      talk.update_column :language, 'en'
    end
  end

  desc 'prepopulate talk#storage with an empty hash'
  task storage: :environment do
    puts "-> Check talks for missing storage..."
    Talk.where(storage: nil).each do |talk|
      puts "   Fix storage of talk %s" % talk.id
      talk.update_column :storage, {}
    end
  end

  desc 'create slugs for all venues and talks wihtout slug'
  task slugs: :environment do
    puts "-> Check venues for missing slug..."
    venues = Venue.where(slug: nil)
    venues.each_with_index do |venue, index|
      puts "   Fix slug of venue #{index}/#{venues.size} #{venue.title}"
      venue.save!
    end

    puts "-> Check talks for missing slug..."
    talks = Talk.where(slug: nil)
    talks.each_with_index do |talk, index|
      puts "   Fix slug of talk #{index}/#{talks.size} #{talk.title}"
      talk.save!
    end
  end

  desc 'create missing default_venues'
  task default_venues: :environment do
    puts "-> Check users for missing default_venue... [TODO]"
    # conds = { default_venue_id: nil, guest: nil }
    # total = User.where(conds).count
    # counter = 0
    # User.find_each(conditions: conds, batch_size: 100) do |user|
    #   counter += 1
    #   puts "   Fix default venue for user #{counter}/#{total} #{user.name}"
    #   user.create_and_set_default_venue!
    # end
  end

  desc 'generate tokens for users'
  task user_tokens: :environment do
    puts "-> Check users for missing authentication_token..."
    User.find_each(conditions: { authentication_token: nil }) do |user|
      puts "   Fix authentication_token for user %s" % user.id
      unless user.save
        puts "   INVALID USER #{user.id}"
        puts '  ' + user.errors.to_a * "\n  "
      end
    end
  end

  desc 'fix invalid users'
  task user: :environment do
    puts "-> Check users for missing firstname or lastname..."
    User.where('firstname IS NULL OR lastname IS NULL') do |user|
      puts "   Fix naming of user %s" % user.id
      user.firstname ||= 'noname'
      user.lastname ||= 'noname'
      user.slug = nil if user.slug.empty?
      user.save!
    end

    puts "-> Check users for missing about..."
    User.where(about: nil).each do |u|
      puts "   Fix about of user %s" % user.id
      u.update_attribute :about, ""
    end
  end

  desc 'populate users summary'
  task user_summary: :environment do
    puts "-> Check users for missing summary..."
    User.where(summary: nil) do |user|
      puts "   Fix summary for user %s" % user.id
      text = user.about_as_plaintext
      text = ActionController::Base.helpers.truncate(text, length: 140)
      user.summary = text
      user.save!
    end
  end

  desc 'set a dummy of talk#description is blank'
  task talk_descriptions: :environment do
    puts "-> Check talks for blank description..."
    Talk.where(description: '').each do |talk|
      puts "   Fix description of talk %s" % talk.id
      talk.update_attribute :description, '*blank description*'
    end
  end

  desc 'destroy orphaned venues'
  task orphaned_venues: :environment do
    puts "-> Check venues for nonexistent users..."
    cond = 'user_id NOT IN (?)'
    ids = User.pluck(:id)
    orphans = Venue.where(cond, ids)
    if orphans.count > 0
      puts "   Deleting #{orphans.count} orphaned venues."
      Venue.delete_all([cond, ids])
    end

    # this belpongs to the previous step, do not rip apart
    puts "-> Check for obsolete search documents, due to deleted venues..."
    cond = "searchable_type = 'Venue' AND searchable_id NOT IN (?)"
    ids = Venue.pluck(:id)
    docs = PgSearch::Document.where(cond, ids)
    if docs.count > 0
      puts "   Deleting #{docs.count} orphaned search docs."
      PgSearch::Document.delete_all([cond, ids])
    end
  end

  desc 'set all counter caches on tags'
  task tag_taggings_count: :environment do
    puts "-> Reset counters of #{ActsAsTaggableOn::Tag.count} tags."
    ActsAsTaggableOn::Tag.find_each do |tag|
      ActsAsTaggableOn::Tag.reset_counters tag.id, :taggings
    end
  end

end
