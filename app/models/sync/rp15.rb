module Sync
  class Rp15

    TAGS = {
      're:publica'            => 'republica, Conference, Konferenz',
      'Culture'               => 'republica, Culture, Kultur',
      'Politics & Society'    => 'republica, Politics, Politik, Society, Gesellschaft',
      'Media'                 => 'republica, Media, Medien',
      'Research & Education'  => 'republica, Research, Forschung, Education, Bildung',
      'Business & Innovation' => 'republica, Business, Innovation, Wirtschaft',
      'Science & Technology'  => 'republica, Science, Wissenschaft, '+
                                 'Technology, Technologie'
    }

    VENUE_OPTS = {
      no_email: true,
      suppress_chat: true,
      # TODO set jingle
      jingle_in: 'asdf',
      jingle_out: 'asdf'
    }

    LANGCODE = {
      'Deutsch'  => 'de',
      'Englisch' => 'en'
    }

    TEXT_LIMIT   = Settings.limit.text
    STRING_LIMIT = Settings.limit.string

    DATETIME_REGEX = /(\d\d)\.(\d\d)\.(\d\d\d\d)/

    SESSIONS = 'http://re-publica.de/event/3013/json/sessions'
    SPEAKERS = 'http://re-publica.de/event/3013/json/speakers'

    attr_accessor :metrics, :warnings, :errors, :changes, :opts

    def initialize(opts={})
      self.opts = opts
      self.metrics = Hash.new { |h, k| h[k] = 0 }
      self.warnings, self.errors, self.changes = [], [], []
    end

    def sync

      raise 'No rep15_user_id' unless Settings.rep15_user_id
      rp15_user = User.find(Settings.rep15_user_id)

      items.map do |item|
        begin
          # sanity checks
          nid = item.nid
          raise 'No nid' if nid.blank?
          category = item.category.strip
          if category.blank?
            self.warnings << "% 4s: Category missing, using 're:publica'." % nid
            category = 're:publica'
          end
          _, d, m, y = item.datetime.match(DATETIME_REGEX).to_a
          unless _
            self.warnings << ("% 4s: Unknown datetime format '%s', "+
              "assuming first day.") % [nid, item.datetime]
            y, m, d = %w(2015 05 05)
          end
          start_time = item.start
          if start_time.blank?
            self.warnings << "% 4s: Start time blank, assuming 9am." % nid
            start_time = '9:00'
          end
          end_time = item.end
          if end_time.blank?
            self.warnings << "% 4s: End time blank, assuming 10am." % nid
            end_time = '10:00'
          end

          duration = (Time.parse(end_time) - Time.parse(start_time)) / 60

          # update venue
          venue_uri = "rp15-#{category.tr_s(' &', '-').downcase}"
          venue = Venue.find_or_initialize_by(uri: venue_uri)
          venue.title = category
          venue.teaser ||= item.event_description.strip.truncate(STRING_LIMIT)
          venue.description ||= 'tbd.' # FIXME
          venue.tag_list = TAGS[category]
          venue.user = rp15_user
          venue.options = VENUE_OPTS

          self.changes << "#{venue_uri}: #{venue.changed * ', '}" if venue.changed?
          metric = venue.persisted? ? :venues_updated : :venues_created
          self.metrics[metric] += 1 if opts[:dryrun] || venue.save!

          # update talk
          talk_uri = "rp15-#{nid}"
          talk = Talk.find_or_initialize_by(uri: talk_uri)
          next unless talk.created?
          talk.venue = venue
          talk.title = item.title.strip.truncate(STRING_LIMIT)
          talk.teaser = item.description_short.strip.truncate(STRING_LIMIT)
          talk.description = ([ 'Room: ' + item.room.strip,
                                item.speaker_names.map(&:strip) * ', ',
                                item.description.strip ] * '<br><br>' ).
                             truncate(TEXT_LIMIT)
          talk.tag_list = TAGS[category]
          talk.language = LANGCODE[item.language]
          talk.speakers = item.speaker_names.map(&:strip) * ', '
          talk.starts_at_date = [y, m, d] * '-'
          talk.starts_at_time = start_time
          talk.duration = duration

          self.changes << "#{talk_uri}: #{talk.changed * ', '}" if talk.changed?
          metric = talk.persisted? ? :talks_updated : :talks_created
          self.metrics[metric] += 1 if opts[:dryrun] || talk.save!

          if talk.persisted? && talk.ends_at.strftime('%H:%M') != item.end
            self.warnings << '% 4s: Bogus times: %s %s' %
              [nid, item.datetime, item.duration]
          end

        rescue Exception => e
          self.errors << '% 4s: %s' % [nid, e.message.tr("\n", '; ')]
          #puts nid
          #puts e.message
          #exit
        end
      end

      if opts[:dryrun]
        puts report_summary
        puts report_errors
        puts report_warnings
        puts report_changes
      else
        attachments = []
        attachments << { color: 'danger',  text: report_errors } if errors.size > 0
        attachments << { color: 'warning', text: report_warnings } if warnings.size > 0
        attachments << { color: 'good',    text: report_changes } if changes.size > 0
        slack.send report_summary, attachments: attachments
      end
    end

    def report_summary
      <<-EOF.strip_heredoc
       SYNC RP15 REPORT

       > Series: #{metrics[:venues_created]} / #{metrics[:venues_updated]}
       > Talks: #{metrics[:talks_created]} / #{metrics[:talks_updated]}
       > (created / updated)
      EOF
    end

    def report_changes
      "#{changes.size} CHANGES\n\n" + changes * "\n"
    end

    def report_warnings
      "#{warnings.size} WARNINGS\n\n" + warnings * "\n"
    end

    def report_errors
      "#{errors.size} ERRORS\n\n" + errors * "\n"
    end

    def items
      return @items unless @items.nil?
      url = SESSIONS
      url = 'rp15_sessions.json' # test with local copy
      print 'Fetching data...'
      json = open(url).read
      puts 'done.'
      data = JSON.load(json)
      @items = data['items'].map { |i| OpenStruct.new(i) }
      puts "Found #{@items.size} items."
      @items
    end

    def icon
      return ':finnadie:' if errors.size > 0
      return ':godmode:' if warnings.size == 0

      ratio = items.size / warnings.size.to_f
      return ':suspect:'     if ratio < 0.25
      return ':hurtrealbad:' if ratio < 0.5
      return ':feelsgood:'   if ratio < 0.75
      ':goberserk:'
    end

    def slack
      @slack ||= Slack.new('@branch14', 'Doomguy', icon)
      #@slack ||= Slack.new('#rp15', 'Doomguy', icon)
    end

  end
end
