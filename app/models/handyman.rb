# Handyman knows what to do. Handyman is a collection of strategies to
# make invalid models valid. Sometimes that means fixing, sometimes it
# means destroying. It depends. You have to break an egg to make an
# omelette. When done the Handyman reports to the system channel on
# Slack.
#
# Run all strategies (this is generally a good idea)
#
#     rails r Handyman.call
#
# or just a selection defined by a pattern
#
#     rails r 'Handyman.call /duplicates/'
#
class Handyman

  class Tasks

    def talk_set_icon
      log '-> Check for default icons...'
      query = Talk.where(icon: 'default')
      total = query.count
      return unless total > 0

      log 'Found %s talks with default icon.' % total
      query.each_with_index do |talk, idx|
        log '%s/%s Setting icon for talk %s.' %
            [ idx+1, total, talk.id ]
        talk.send(:set_icon)
        talk.save!
      end
    end

    def user_create_default_venue
      log '-> Check for missing venue on talks...'
      query = Talk.where(venue_id: nil)
      return unless query.count > 0

      log 'Found %s talks with missing venue.' % query.count
      query = User.joins(:talks).where('talks.venue_id IS NULL')
      utot = query.count
      query.each_with_index do |user, uidx|
        talk_ids = user.talks.where(venue_id: nil).pluck(:id)
        next if talk_ids.empty?
        log '%s/%s Creating default venue for user %s and apply to %s talks' %
            [ uidx+1, utot, user.id, talk_ids.size ]
        venue = user.venues.create name: 'Default venue' # TODO centralize name
        sql = 'UPDATE talks SET venue_id=%s WHERE id IN (%s)' %
              [ venue.id, talk_ids * ',' ]
        ActiveRecord::Base.connection.execute(sql)
      end
    end

    def series_options_rename_autoend
      log '-> Check series for old option no_auto_end_talk...'

      query = Series.where("options LIKE '%autoend%'")
      if query.count > 0
        log "PRIOR RUN DETECTED & NOT IDEMPOTENT. SKIPPING. REMOVE THIS METHOD."
        return
      end

      query = Series.where("options NOT LIKE '%no_auto_end%'")
      total = query.count
      query.each_with_index do |series, index|
        log "%s/%s Set option autoend for series %s" %
            [ index+1, total, series.id ]
        series.options[:autoend] = true
        series.save
      end

      query = Series.where("options LIKE '%no_auto_end%'")
      total = query.count
      query.each_with_index do |series, index|
        log "%s/%s Unset option no_auto_end_talk for series %s" %
            [ index+1, total, series.id ]
        series.options.delete :no_auto_end_talk
        series.save
      end
    end

    def appearances_nonextistent_talks
      log "-> Check appearances for nonexistent talks..."
      condition = "talk_id NOT IN (?)"
      ids = Talk.pluck(:id)
      Appearance.where(condition, ids).each do |a|
        log "Destroy invalid appearance %s" % a.id
        a.destroy
      end
    end

    def appearances_nonextistent_users
      log "-> Check appearances for nonexistent users..."
      condition = "user_id NOT IN (?)"
      ids = User.pluck(:id)
      Appearance.where(condition, ids).each do |a|
        log "Destroy invalid appearance %s" % a.id
        a.destroy
      end
    end

    def participations_missing_series
      log "-> Check participations for missing series..."
      Participation.where(series_id: nil).each do |pa|
        log "Destroy invalid participation %s (series missing)" % pa.id
        pa.destroy
      end
    end

    def participations_nonexistent_series
      log "-> Check participations for nonexistent series..."
      condition = "series_id NOT IN (?)"
      ids = Series.pluck(:id)
      Participation.where(condition, ids).each do |pa|
        log "Destroy invalid participation %s (series nonexistent)" % pa.id
        pa.destroy
      end

    end

    def participations_nonexistent_users
      log "-> Check participations for nonexistent users..."
      condition = "user_id NOT IN (?)"
      ids = User.pluck(:id)
      Participation.where(condition, ids).each do |pa|
        log "Destroy invalid participation %s (user nonexistent)" % pa.id
        pa.destroy
      end
    end

    def participations_duplicates
      log "-> Check participations for duplicates..."
      fields = [:user_id,:series_id]
      query = Participation.select(fields).group(*fields).having("count(*) > 1")
      query.each do |pa|
        conditions = { user_id: pa.user_id,
                       series_id: pa.series_id }
        log "Destroy duplicate entries for participation user %s" % conditions.inspect
        Participation.where(conditions).order('id ASC').offset(1).destroy_all
      end
    end

    def reminders_missing_rememberable
      log "-> Check reminders for missing rememberable..."
      Reminder.where(rememberable_id: nil).each do |r|
        log "Destroy invalid reminder %s (rememberable nonexistent)" % r.id
        r.destroy
      end

    end

    def reminders_nonexistent_rememberable
      log "-> Check reminders for nonexistent rememberable... [TODO]"
      # condition = "series_id NOT IN (?)"
      # ids = Series.pluck(:id)
      # Reminder.where(condition, ids).each do |r|
      #   log "Destroy invalid reminder %s (series nonexistent)" % r.id
      #   r.destroy
      # end
    end

    def reminders_nonexistent_user
      log "-> Check reminders for nonexistent user..."
      condition = "user_id NOT IN (?)"
      ids = User.pluck(:id)
      Reminder.where(condition, ids).each do |r|
        log "Destroy invalid reminder %s (user nonexistent)" % r.id
        r.destroy
      end
    end

    def reminders_duplicates
      log "-> Check reminders for duplicates..."
      fields = [:user_id, :rememberable_id, :rememberable_type]
      Reminder.select(fields).group(*fields).having("count(*) > 1").each do |r|
        conditions = { user_id: r.user_id,
                       rememberable_id: r.rememberable_id,
                       rememberable_type: r.rememberable_type }
        log "Destroy duplicate entries for reminder user %s" % conditions.inspect
        Reminder.where(conditions).order('id ASC').offset(1).destroy_all
      end
    end

    def messages_nonextistent_talks
      log "-> Check messages for nonexistent talks..."
      condition = "talk_id NOT IN (?)"
      ids = Talk.pluck(:id)
      Message.where(condition, ids).each do |m|
        log "Destroy invalid message %s (talk nonexistent)" % m.id
        m.destroy
      end
    end

    def talks_make_valid
      log "-> Check all talks for validity (this might take a while)..."
      Talk.find_each do |t|
        unless t.valid?
          if t.series_id.nil?
            log "Destroy orphaned talk %s (series nonexistent)" % t.id
            t.destroy
          else
            log "Fixing invalid talk %s" % t.id
            t.tag_list = 'no_tag' if t.tag_list.blank?
            t.description = 'No description.' if t.description.blank?

            # h = ActionController::Base.helpers
            # text = h.truncate(t.description, length: Settings.limit.text)
            t.description = t.description[0, Settings.limit.text]

            t.save!
          end
        end
      end
    end

    def users_truncate_about_and_summary
      log "-> Check users for about or summary over limit..."
      conditions = 'LENGTH(about) > ? OR LENGTH(summary) > ?'
      query = User.where(conditions,
                         Settings.limit.text,
                         Settings.limit.string); nil
      total = query.count
      query.each_with_index do |user, index|
        log "%s/%s Fix user %s, truncate about and summary" %
            [ index + 1, total, user.id ]
        user.about = user.about[0, Settings.limit.text]
        user.summary = user.summary[0, Settings.limit.string]
        user.save
      end
    end

    def talks_archived_missing_processed_at
      log "-> Check archived talks for missing processed_at..."
      Talk.archived.where(processed_at: nil).each do |t|
        t.update_attribute :processed_at, t.ends_at
        log "Fix talk #{t.id}, set processed_at to ends_at (#{t.ends_at})"
      end
    end

    def talks_missing_language
      log "-> Check talks for missing language..."
      Talk.where(language: nil).each do |t|
        log "Fix language of talk %s" % t.id
        t.update_column :language, 'en'
      end
    end

    def talks_missing_storage
      log "-> Check talks for missing storage..."
      Talk.where(storage: nil).each do |t|
        log "Fix storage of talk %s" % t.id
        t.update_column :storage, {}
      end
    end

    def series_missing_slug
      log "-> Check series for missing slug..."
      series = Series.where(slug: nil)
      series.each_with_index do |series, index|
        log "Fix slug of series #{index+1}/#{series.size} #{series.title}"
        series.save!
      end
    end

    def talks_missing_slug
      log "-> Check talks for missing slug..."
      talks = Talk.where(slug: nil)
      talks.each_with_index do |t, index|
        log "Fix slug of talk #{index+1}/#{talks.size} #{t.title}"
        t.save!
      end
    end

    def users_missing_default_series
      log "-> Check users for missing default_series..."
      query = User.where(default_series_id: nil)
      total = query.count
      counter = 0
      query.each do |user|
        counter += 1
        log "Fix default series for user #{counter}/#{total} #{user.name}"
        user.build_and_set_default_series
        user.save!
      end
    end

    def users_missing_authentication_token
      log "-> Check users for missing authentication_token..."
      User.where(authentication_token: nil) do |user|
        log "Fix authentication_token for user %s" % user.id
        unless user.save
          log "INVALID USER #{user.id}"
          log '  ' + user.errors.to_a * "\n  "
        end
      end
    end

    def users_missing_names
      log "-> Check users for missing firstname or lastname..."
      User.where('firstname IS NULL OR lastname IS NULL') do |user|
        log "Fix naming of user %s" % user.id
        user.firstname ||= 'noname'
        user.lastname ||= 'noname'
        user.slug = nil if user.slug.empty?
        user.save!
      end
    end

    def users_missing_about
      log "-> Check users for missing about..."
      User.where(about: nil).each do |u|
        log "Fix about of user %s" % user.id
        u.update_attribute :about, ""
      end
    end

    def users_missing_summary
      log "-> Check users for missing summary..."
      User.where(summary: nil) do |user|
        log "Fix summary for user %s" % user.id
        text = user.about_as_plaintext
        text = ActionController::Base.helpers.truncate(text, length: 140)
        user.summary = text
        user.save!
      end
    end

    def talks_missing_description
      log "-> Check talks for blank description..."
      Talk.where(description: '').each do |t|
        log "Fix description of talk %s" % t.id
        t.update_attribute :description, '*blank description*'
      end
    end

    def series_nonexistent_users
      log "-> Check series for nonexistent users..."
      cond = 'user_id NOT IN (?)'
      ids = User.pluck(:id)
      orphans = Series.where(cond, ids)
      if orphans.count > 0
        log "Deleting #{orphans.count} orphaned series."
        Series.delete_all([cond, ids])
      end

      # this belpongs to the previous step, do not rip apart
      log "-> Check for obsolete search documents, due to deleted series..."
      cond = "searchable_type = 'Series' AND searchable_id NOT IN (?)"
      ids = Series.pluck(:id)
      docs = PgSearch::Document.where(cond, ids)
      if docs.count > 0
        log "Deleting #{docs.count} orphaned search docs."
        PgSearch::Document.delete_all([cond, ids])
      end
    end

    def tags_reset_counters
      log "-> Reset counters of #{ActsAsTaggableOn::Tag.count} tags."
      ActsAsTaggableOn::Tag.find_each do |t|
        ActsAsTaggableOn::Tag.reset_counters t.id, :taggings
      end
    end

    def user_flag_paying
      log "-> Set flag paying on paying users."
      sql = 'UPDATE users SET paying = TRUE WHERE purchases_count > 0'
      ActiveRecord::Base.connection.execute(sql)
    end

    def talks_set_description_as_html
      log "-> Check talks for missing description_as_html."
      query = Talk.where(description_as_html: nil).order(:id)
      total = query.count
      query.each_with_index do |talk, index|
        log "%s/%s Fix desciption_as_html on talk %s." %
            [ index+1, total, talk.id ]
        talk.send(:set_description_as_html)
        talk.save
      end
    end

    private

    def log(msg)
      msg = "   #{msg}" unless msg.match(/^-> /)
      puts msg
      @log ||= []
      @log << msg
    end

  end

  class << self
    def call(pattern=nil)
      methods = Tasks.public_instance_methods(false)
      methods = methods.grep(pattern) unless pattern.nil?
      tasks = Tasks.new
      methods.sort.each { |key| tasks.send(key) }

      channel = Settings.slack.system_channel
      slack = Slack.new(channel, 'Handyman', ':construction_worker:')
      slack.send tasks.instance_variable_get(:@log) * "\n"
    end
  end

end
