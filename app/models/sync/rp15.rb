# coding: utf-8
#
# On console run with
#
#    Sync::Rp15.new(dryrun: true).sync
#
# Update local copies with
#
#    curl http://re-publica.de/event/3013/json/sessions > rp15_sessions.json
#    curl http://re-publica.de/event/3013/json/speakers > rp15_speakers.json
#
module Sync
  class Rp15

    TAGS = {
      're:publica'            => 'republica, Conference, Konferenz',
      'Media Convention'      => 'republica, Media, Medien, Convention',
      're:cord Musicday'      => 'republica, record, Musicday',
      're:health'             => 'republica, Health, Gesundheit',
      're:think Mobility'     => 'republica, rethink, Mobility, Mobilität',
      'City Of The Future'    => 'republica, CityOfTheFuture, StadtDerZukunft',
      'Culture'               => 'republica, Culture, Kultur',
      'Politics & Society'    => 'republica, Politics, Politik, Society, Gesellschaft',
      'Media'                 => 'republica, Media, Medien',
      'GIG'                   => 'republica, GIG',
      'Research & Education'  => 'republica, Research, Forschung, Education, Bildung',
      'Business & Innovation' => 'republica, Business, Innovation, Wirtschaft',
      'Fashiontech'           => 'republica, Fashiontech',
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
      'Deutsch'          => 'de',
      'Englisch'         => 'en',
      'Deutsch/Englisch' => 'en'
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

      raise 'No rep15.user_id' unless Settings.try(:rep15).try(:user_id)

      sessions.map do |session|
        begin
          # sanity checks
          nid = session.nid
          raise 'No nid' if nid.blank?
          category = session.category.strip
          if category.blank?
            self.warnings << "% 4s: Category missing, using 're:publica'." % nid
            category = 're:publica'
          else
            if TAGS[category].nil?
              self.errors << "% 4s: No tags defined for category: %s" % [nid, category]
            end
          end
          _, d, m, y = session.datetime.match(DATETIME_REGEX).to_a
          unless _
            self.warnings << ("% 4s: Unknown datetime format '%s', "+
              "assuming first day.") % [nid, session.datetime]
            y, m, d = %w(2015 05 05)
          end
          start_time = session.start
          if start_time.blank?
            self.warnings << "% 4s: Start time blank, assuming 9am." % nid
            start_time = '09:00'
          end
          end_time = session.end
          if end_time.blank?
            self.warnings << "% 4s: End time blank, assuming 10am." % nid
            end_time = '10:00'
          end

          duration = (Time.parse(end_time) - Time.parse(start_time)) / 60

          # update venue
          venue_uri = "rp15-#{category.tr_s(' &', '-').downcase}"
          venue = Venue.find_or_initialize_by(uri: venue_uri)
          venue.title = category
          venue.teaser = session.event_description.strip.truncate(STRING_LIMIT)
          venue.description = session.event_description.strip.truncate(TEXT_LIMIT)
          venue.tag_list = TAGS[category]
          venue.user = user
          venue.options = VENUE_OPTS

          self.changes << "#{venue_uri}: #{venue.changed * ', '}" if venue.changed?
          metric = venue.persisted? ? :venues_updated : :venues_created
          self.metrics[metric] += 1 if opts[:dryrun] || venue.save!

          # update talk
          talk_uri = "rp15-#{nid}"
          talk = Talk.find_or_initialize_by(uri: talk_uri)
          next unless talk.created?
          talk.venue = venue
          talk.title = session.title.strip.truncate(STRING_LIMIT)
          talk.teaser = session.description_short.strip.truncate(STRING_LIMIT)
          talk.description = ([ 'Room: ' + session.room.strip,
                                session.speaker_names.map(&:strip) * ', ',
                                session.description.strip ] * '<br><br>' ).
                             truncate(TEXT_LIMIT)
          talk.tag_list = TAGS[category]
          talk.language = LANGCODE[session.language]
          talk.speakers = session.speaker_names.map(&:strip) * ', '
          talk.starts_at_date = [y, m, d] * '-'
          talk.starts_at_time = start_time
          talk.duration = duration
          talk.social_links = session.speaker_uids.map do |uid|
            if sp3aker = speaker(uid)
              sp3aker.link_uris.grep(/twitter|facebook/)
            else
              self.errors << "% 4s No speaker found for uid: #{uid}" % nid
            end
          end.flatten

          self.changes << "#{talk_uri}: #{talk.changed * ', '}" if talk.changed?
          metric = talk.persisted? ? :talks_updated : :talks_created
          self.metrics[metric] += 1 if opts[:dryrun] || talk.save!

          if talk.persisted? && talk.ends_at.strftime('%H:%M') != session.end
            self.warnings << '% 4s: Bogus times: %s %s' %
              [nid, session.datetime, session.duration]
          end

        rescue Exception => e
          self.errors << '% 4s: %s' % [nid, e.message.tr("\n", '; ')]
          #puts nid
          #puts talk.attributes.to_yaml
          #puts e.message
          #puts category
          #return
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
      tmpl=<<-EOF.strip_heredoc
       SYNC RP15 REPORT

       Input: %s sessions, %s speakers

       > Series: % 4s / % 4s / % 4s
       > Talks:  % 4s / % 4s / % 4s
       > (created / updated / total)
      EOF
      tmpl % [
        sessions.size,
        speakers.size,
        metrics[:venues_created],
        metrics[:venues_updated],
        user.venues.count,
        metrics[:talks_created],
        metrics[:talks_updated],
        user.talks.count
      ]
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

    def sessions
      return @sessions unless @sessions.nil?
      url = SESSIONS
      # test with local copy
      url = 'rp15_sessions.json' if File.exist?(Rails.root.join('rp15_sessions.json'))
      print 'Fetching sessions data...'
      json = open(url).read
      puts 'done.'
      data = JSON.load(json)
      @sessions = data['items'].map { |i| OpenStruct.new(i) }
      puts "Found #{@sessions.size} sessions."
      @sessions
    end

    def speakers
      return @speakers unless @speakers.nil?
      url = SPEAKERS
      # test with local copy
      url = 'rp15_speakers.json' if File.exist?(Rails.root.join('rp15_speakers.json'))
      print 'Fetching speakers data...'
      json = open(url).read
      puts 'done.'
      data = JSON.load(json)
      @speakers = data['items'].map { |i| OpenStruct.new(i) }
      puts "Found #{@speakers.size} speakers."
      @speakers
    end

    def speaker(uid)
      speakers.find { |s| s.uid == uid }
    end

    def user
      @user ||= User.find(Settings.rep15.user_id)
    end

    def icon
      return ':finnadie:' if errors.size > 0
      return ':godmode:' if warnings.size == 0

      ratio = sessions.size / warnings.size.to_f
      return ':suspect:'     if ratio < 0.25
      return ':hurtrealbad:' if ratio < 0.5
      return ':feelsgood:'   if ratio < 0.75
      ':goberserk:'
    end

    def slack
      @slack ||= Slack.new(Settings.rep15.slack_channel, 'Doomguy', icon)
    end

  end
end
