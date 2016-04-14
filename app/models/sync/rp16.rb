# coding: utf-8
#
# On console run with
#
#    Sync::Rp16.new(dryrun: true).sync
#
# Update local copies with
#
#   curl 'https://re-publica.de/rest/sessions.json?args\[0\]=6553' > tmp/rp16_sessions.json
#   curl 'https://re-publica.de/rest/speakers.json?args\[0\]=6553' > tmp/rp16_speakers.json
#   curl 'https://re-publica.de/rest/rooms.json?args\[0\]=6553' > tmp/rp16_rooms.json
#
module Sync
  class Rp16

    TAGS = {
      're:publica'                => 'republica, Conference, Konferenz',
      'Media Convention'          => 'republica, Media, Medien, Convention',
      're:cord Musicday'          => 'republica, record, Musicday',
      're:health'                 => 'republica, Health, Gesundheit',
      'Health'                    => 'republica, Health, Gesundheit',
      're:think Mobility'         => 'republica, rethink, Mobility, Mobilität',
      'City Of The Future'        => 'republica, CityOfTheFuture, StadtDerZukunft',
      'Culture'                   => 'republica, Culture, Kultur',
      'Politics &amp; Society'    => 'republica, Politics, Politik, Society, '+
                                     'Gesellschaft',
      'Media'                     => 'republica, Media, Medien',
      'GIG'                       => 'republica, GIG',
      'Research &amp; Education'  => 'republica, Research, Forschung, Education, '+
                                     'Bildung',
      'Business &amp; Innovation' => 'republica, Business, Innovation, Wirtschaft',
      'Fashiontech'               => 'republica, Fashiontech',
      'Science &amp; Technology'  => 'republica, Science, Wissenschaft, '+
                                     'Technology, Technologie'
    }

    VENUES_OPTS = {
      no_email: true,
      jingle_in: 'https://voicerepublic.com/audio/rp14_podcast_en.wav',
      jingle_out: 'https://voicerepublic.com/audio/rp14_podcast_en.wav'
    }

    LANGCODE = {
      'Deutsch'          => 'de',
      'Englisch'         => 'en',
      'Deutsch/Englisch' => 'en'
    }

    TEXT_LIMIT   = Settings.limit.text
    STRING_LIMIT = Settings.limit.string

    DATETIME_REGEX = /(\d\d)\.(\d\d)\.(\d\d\d\d)/

    SESSIONS = 'https://re-publica.de/rest/sessions.json?args[0]=6553'
    SPEAKERS = 'https://re-publica.de/rest/speakers.json?args[0]=6553'
    ROOMS = 'https://re-publica.de/rest/rooms.json?args[0]=6553'

    attr_accessor :metrics, :warnings, :errors, :changes, :opts

    def initialize(opts={})
      self.opts = opts
      self.metrics = Hash.new { |h, k| h[k] = 0 }
      self.warnings, self.errors, self.changes = [], [], []
    end

    def sync

      raise 'No rep16.user_id' unless Settings.try(:rep16).try(:user_id)

      uris = []

      sessions.map do |session|
        #pp session.to_h; gets
        begin
          # --- skip special cases ---

          #next if %w( 6111 6134 ).include?(session.nid)
          #next if session.title == 'FluxFM_MUTation'
          #next if session.room == 'newthinking'

          nid = nil
          category = nil
          start_time = nil
          end_time = nil
          duration = nil

          # --- sanity check: nid ---

          nid = session.nid
          raise 'No nid' if nid.blank?

          # --- sanity check: category ---

          category = rep_string(session.category).strip
          if category.blank?
            self.warnings << "% 4s: Category missing, using 're:publica'." % nid
            category = 're:publica'
          else
            if TAGS[category].nil?
              self.errors << "% 4s: No tags defined for category: %s" % [nid, category]
            end
          end

          # --- sanity check: time ---

          if empty_array?(session.start_iso)
            self.warnings << "% 4s: Start time blank, assuming first slot." % nid
            duration = 60
          end

          start_time_iso = rep_string(session.start_iso) ||
                           session.event_date_start_iso
          end_time_iso = rep_string(session.end_iso)

          start_time = Time.strptime(start_time_iso, '%F')
          end_time   = Time.strptime(end_time_iso, '%F') if end_time_iso
          duration ||= (end_time - start_time) / 60

          # --- update series ---

          series_uri = "rp16-#{category.tr_s(' &', '-').downcase}"
          series = Series.find_or_initialize_by(uri: series_uri)
          series.title = category
          series.teaser = session.event_description.to_s.strip.truncate(STRING_LIMIT)
          series.description = session.event_description.to_s.strip.truncate(TEXT_LIMIT)
          series.tag_list = TAGS[category]
          series.user = user

          self.changes << "#{series_uri}: #{series.changed * ', '}" if series.changed?
          metric = series.persisted? ? :series_updated : :series_created
          self.metrics[metric] += 1 if opts[:dryrun] || series.save!

          # --- update talk ---

          talk_uri = "rp16-#{nid}"
          uris << talk_uri
          talk = Talk.find_or_initialize_by(uri: talk_uri)
          next unless talk.prelive? or talk.created?
          talk.series = series
          talk.title = session.title.strip.truncate(STRING_LIMIT)
          talk.teaser = session.description_short.to_s.strip.truncate(STRING_LIMIT)
          talk.description = ([ 'Room: ' + session.room.to_s.strip,
                                session.speaker_names.map(&:strip) * ', ',
                                session.description.to_s.strip ] * '<br><br>' ).
                             truncate(TEXT_LIMIT)
          talk.tag_list = TAGS[category]
          talk.language = LANGCODE[session.language]
          talk.speakers = (session.speaker_names.map(&:strip) * ', ').
                          truncate(STRING_LIMIT)
          talk.starts_at_date = start_time.strftime('%Y-%m-%d')
          talk.starts_at_time = start_time.strftime('%H:%M')
          talk.duration = duration
          talk.venue_name = rep_string(session.room)
          talk.social_links = session.speaker_uids.map do |uid|
            #p uid
            if sp3aker = speaker(uid)
              sp3aker.link_uris#.grep(/twitter|facebook/)
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

      # --- remove the talks which didn't show up ---

      user.talks.where("talks.uri NOT IN (?)", uris).destroy_all


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
        metrics[:series_created],
        metrics[:series_updated],
        user.series.count,
        metrics[:talks_created],
        metrics[:talks_updated],
        user.talks.count
      ]
    end

    def report_changes
      "#{changes.size} CHANGES\n\n" + (changes * "\n") + "\n"
    end

    def report_warnings
      "#{warnings.size} WARNINGS\n\n" + (warnings * "\n") + "\n"
    end

    def report_errors
      "#{errors.size} ERRORS\n\n" + (errors * "\n") + "\n"
    end

    def sessions
      return @sessions unless @sessions.nil?
      url = SESSIONS
      # test with local copy
      url = 'tmp/rp16_sessions.json' if File.exist?(Rails.root.join('tmp/rp16_sessions.json'))
      print 'Fetching sessions data...'
      json = open(url).read
      puts 'done.'
      data = JSON.load(json)
      @sessions = data.map { |i| OpenStruct.new(i) }
      puts "Found #{@sessions.size} sessions."
      @sessions
    end

    def speakers
      return @speakers unless @speakers.nil?
      url = SPEAKERS
      # test with local copy
      url = 'tmp/rp16_speakers.json' if File.exist?(Rails.root.join('tmp/rp16_speakers.json'))
      print 'Fetching speakers data...'
      json = open(url).read
      puts 'done.'
      data = JSON.load(json)
      @speakers = data.map { |i| OpenStruct.new(i) }
      puts "Found #{@speakers.size} speakers."
      @speakers
    end

    def rooms
      return @rooms unless @rooms.nil?
      url = ROOMS
      # test with local copy
      url = 'tmp/rp16_rooms.json' if File.exist?(Rails.root.join('tmp/rp16_rooms.json'))
      print 'Fetching rooms data...'
      json = open(url).read
      puts 'done.'
      data = JSON.load(json)
      @rooms = data.map { |i| OpenStruct.new(i) }
      puts "Found #{@rooms.size} rooms."
      @rooms
    end

    def speaker(uid)
      speakers.find { |s| s.uid == uid }
    end

    def user
      @user ||= User.find(Settings.rep16.user_id)
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
      @slack ||= Slack.new(Settings.rep16.slack_channel, 'Doomguy', icon)
    end

    def rep_string(value)
      return nil if value == []
      value
    end

    def empty_array?(arg)
      arg.is_a?(Array) and arg.empty?
    end

  end
end
