# coding: utf-8

require 'cgi'

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
      're:publica'            => 'republica, Conference, Konferenz',
      'Media Convention'      => 'republica, Media, Medien, Convention',
      're:cord Musicday'      => 'republica, record, Musicday',
      're:health'             => 'republica, Health, Gesundheit',
      'Health'                => 'republica, Health, Gesundheit',
      're:think Mobility'     => 'republica, rethink, Mobility, Mobilität',
      'City Of The Future'    => 'republica, CityOfTheFuture, StadtDerZukunft',
      'Culture'               => 'republica, Culture, Kultur',
      'Politics & Society'    => 'republica, Politics, Politik, Society, '+
                                 'Gesellschaft',
      'Media'                 => 'republica, Media, Medien',
      'GIG'                   => 'republica, GIG',
      'Global Innovation Gathering (GIG)' => 'republica, GIG',
      'Research & Education'  => 'republica, Research, Forschung, Education, '+
                                 'Bildung',
      'Business & Innovation' => 'republica, Business, Innovation, Wirtschaft',
      'Fashiontech'           => 'republica, Fashiontech',
      'Science & Technology'  => 'republica, Science, Wissenschaft, '+
                                 'Technology, Technologie'
    }

    VENUES_OPTS = {
      no_email: true,
      jingle_in: 'https://voicerepublic.com/audio/rp14_podcast_en.wav',
      jingle_out: 'https://voicerepublic.com/audio/rp14_podcast_en.wav'
    }

    LANGCODE = {
      'Deutsch'           => 'de',
      'Englisch'          => 'en',
      'Deutsch/Englisch'  => 'en',
      'Live Dolmetschung' => 'de'
    }

    TEXT_LIMIT   = Settings.limit.text
    STRING_LIMIT = Settings.limit.string

    DATETIME_REGEX = /(\d\d)\.(\d\d)\.(\d\d\d\d)/

    SESSIONS = 'https://re-publica.de/rest/sessions.json?args[0]=6553'
    SPEAKERS = 'https://re-publica.de/rest/speakers.json?args[0]=6553'
    ROOMS = 'https://re-publica.de/rest/rooms.json?args[0]=6553'

    attr_accessor :metrics, :warnings, :errors, :changes, :opts

    def self.update
      %x[ curl 'https://re-publica.de/rest/sessions.json?args\\[0\\]=6553' > tmp/rp16_sessions.json ]
      %x[ curl 'https://re-publica.de/rest/speakers.json?args\\[0\\]=6553' > tmp/rp16_speakers.json ]
      %x[ curl 'https://re-publica.de/rest/rooms.json?args\\[0\\]=6553' > tmp/rp16_rooms.json ]
    end

    def initialize(opts={})
      self.opts = opts
      self.metrics = Hash.new { |h, k| h[k] = 0 }
      self.warnings, self.errors, self.changes = [], [], []
    end

    def sync

      raise 'No rep16.user_id' unless Settings.try(:rep16).try(:user_id)

      uris = []

      uri_prefix = 'rp16-'

      all_talks = Talk.where("uri LIKE '#{uri_prefix}%'")
      all_talks = all_talks.reduce({}) { |r, t| r.merge t.uri => t }
      puts 'Loaded %s existing talks.' % all_talks.count
      all_series = Series.where("uri LIKE '#{uri_prefix}%'")
      all_series = all_series.reduce({}) { |r, s| r.merge s.uri => s }
      puts 'Loaded %s existing series.' % all_series.count

      @observed_languages = Hash.new { |h, k| h[k] = 0 }
      @observed_durations = Hash.new { |h, k| h[k] = 0 }
      @observed_categories = Hash.new { |h, k| h[k] = 0 }

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

          category = unescape(rep_string(session.category).strip)
          if category.blank?
            self.warnings << "% 4s: Category missing, using 're:publica'." % nid
            category = 're:publica'
          else
            if TAGS[category].nil?
              self.errors << "% 4s: No tags defined for category: %s" % [nid, category]
            end
          end
          @observed_categories[category] += 1

          # --- sanity check: time ---

          if empty_array?(session.start_iso)
            self.warnings << "% 4s: Start time blank, assuming first slot." % nid
            duration = 60
          end

          start_time_iso = rep_string(session.start_iso) ||
                           session.event_date_start_iso
          end_time_iso = rep_string(session.end_iso)

          start_time = Time.strptime(start_time_iso, '%FT%T%:z')
          end_time   = Time.strptime(end_time_iso, '%FT%T%:z') if end_time_iso
          duration ||= (end_time - start_time) / 60 # in minutes

          @observed_durations[duration] += 1

          if duration < 0
            self.warnings << "% 4s: Negative duration: %s minutes." % [nid, duration]
          end

          # --- update series ---

          series_uri = "#{uri_prefix}#{category.tr_s(' &', '-').downcase}"
          series = all_series[series_uri] || Series.new(uri: series_uri)
          series.title = category
          series.teaser = session.event_description.to_s.strip.truncate(STRING_LIMIT)
          series.description = session.event_description.to_s.strip.truncate(TEXT_LIMIT)
          series.tag_list = TAGS[category]
          series.user = user

          self.changes << "#{series_uri}: #{series.changed * ', '}" if series.changed?
          metric = series.persisted? ? :series_updated : :series_created
          self.metrics[metric] += 1 if opts[:dryrun] || series.save!
          all_series[series_uri] = series

          # --- update talk ---

          talk_uri = "#{uri_prefix}#{nid}"
          uris << talk_uri
          talk = all_talks[talk_uri] || Talk.new(uri: talk_uri)
          next unless talk.prelive? or talk.created?
          talk.series = series
          talk.title = unescape(session.title.strip).truncate(STRING_LIMIT)
          talk.teaser = session.description_short.to_s.strip.truncate(STRING_LIMIT)
          talk.description = ([ 'Room: ' + session.room.to_s.strip,
                                session.speaker_names.map(&:strip) * ', ',
                                session.description.to_s.strip ] * '<br><br>' ).
                             truncate(TEXT_LIMIT)
          talk.tag_list = TAGS[category]
          @observed_languages[session.language] += 1
          talk.language = LANGCODE[session.language]
          talk.speaker_list = (session.speaker_names.map(&:strip) * ', ').
                          truncate(STRING_LIMIT)
          talk.starts_at_date = start_time.strftime('%Y-%m-%d')
          talk.starts_at_time = start_time.strftime('%H:%M')
          talk.duration = duration
          talk.venue_name = rep_string(session.room)

          talk.social_links = session.speaker_uids.flat_map do |uid|
            #p uid
            if sp3aker = speaker(uid)
              sp3aker.links.map { |l| l['url'] }
            else
              self.errors << "% 4s No speaker found for uid: #{uid}" % nid
            end
          end

          self.changes << "#{talk_uri}: #{talk.changed * ', '}" if talk.changed?
          metric = talk.persisted? ? :talks_updated : :talks_created
          self.metrics[metric] += 1 if opts[:dryrun] || talk.save!
          all_talks[talk_uri] = talk

          #if talk.persisted? && talk.ends_at.strftime('%H:%M') != session.end
          #  self.warnings << '% 4s: Bogus times: %s %s' %
          #    [nid, session.datetime, session.duration]
          #end

          print '.'

        rescue Exception => e
          self.errors << '% 4s: %s' % [nid, e.message.tr("\n", '; ')]
          print 'x'
          #puts nid
          #puts talk.attributes.to_yaml
          #puts e.message
          #puts category
          #return
        end

      end

      puts

      # --- remove the talks which didn't show up ---

      p perishable = all_talks.keys - uris

      # TODO change to delete perishable
      user.talks.where("talks.uri LIKE '#{uri_prefix}%' "+
                       "AND talks.uri NOT IN (?)", uris).destroy_all


      if opts[:dryrun]
        puts report_summary
        puts report_langs
        puts report_durations
        puts report_categories
        puts report_errors
        puts report_warnings
        #puts report_changes
      else
        attachments = []
        attachments << { color: 'danger',  text: report_errors } if errors.size > 0
        attachments << { color: 'warning', text: report_warnings } if warnings.size > 0
        attachments << { color: 'good',    text: report_langs +
                                                 report_categories +
                                                 report_durations }
        slack.send report_summary, attachments: attachments
      end
    end



    def report_summary
      tmpl=<<-EOF.strip_heredoc
       SYNC RP16 REPORT

       Input: %s sessions, %s speakers, %s rooms

       > Series: % 4s / % 4s / % 4s
       > Talks:  % 4s / % 4s / % 4s
       > (created / updated / total)

      EOF
      tmpl % [
        sessions.size,
        speakers.size,
        rooms.size,
        metrics[:series_created],
        metrics[:series_updated],
        user.series.count,
        metrics[:talks_created],
        metrics[:talks_updated],
        user.talks.count
      ]
    end

    def report_langs
      "LANGUAGES\n\n" +
      @observed_languages.map do |lang, count|
        "%-40s % 4s" % [lang, count]
      end * "\n" + "\n\n"
    end

    def report_categories
      "CATEGORIES\n\n" +
      @observed_categories.map do |lang, count|
        "%-40s % 4s" % [lang, count]
      end * "\n" + "\n\n"
    end

    def report_durations
      "DURATIONS\n\n" +
      @observed_durations.map do |lang, count|
        "%-40s % 4s" % [lang, count]
      end * "\n" + "\n\n"
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

    def unescape(str)
      CGI.unescapeHTML(str)
    end

  end
end
