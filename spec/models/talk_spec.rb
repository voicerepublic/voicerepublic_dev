# encoding: UTF-8
require 'rails_helper'
include DjHelpers

describe Talk do

  before do
    Timecop.freeze(Time.local(2036))
  end
  after do
    Timecop.return
  end

  describe 'user uploads a talk' do
    describe 'with user upload' do
      it 'allows only a time of the past' do
        expect {
          FactoryGirl.create :talk,
            starts_at_date: Time.now.strftime('2037-01-01'),
            user_override_uuid: '038ee6b8-0557-4172-8ad6-2548dccd4793'
        }.to raise_error(ActiveRecord::RecordInvalid)

        talk = FactoryGirl.build :talk,
          starts_at_date: Time.now.strftime('2037-01-01'),
          user_override_uuid: '038ee6b8-0557-4172-8ad6-2548dccd4793'

        talk.valid?
        expect(talk.errors[:starts_at_date]).to include("needs to be in the past")
        expect(talk.errors[:starts_at_time]).to include("needs to be in the past")
      end

      it 'uploads go directly into state "pending"' do
        talk = FactoryGirl.build :talk
        # do not test override feature
        allow(talk).to receive(:user_override!).and_return(true)
        expect(talk).not_to be_pending
        talk.user_override_uuid = '038ee6b8-0557-4172-8ad6-2548dccd4793'
        talk.save
        expect(talk).to be_pending
      end
    end

    describe 'guard: with no user upload' do
      it 'also allows a time of the future' do
        expect {
          FactoryGirl.create :talk,
          starts_at_date: Time.now.strftime('2037-01-01')
        }.to change{Talk.count}.from(0).to(1)
      end
      it 'saves into other state than "postlive"' do
        talk = FactoryGirl.create :talk
        expect(talk.state).not_to eq(:postlive)
      end
    end

  end

  describe 'built' do
    before do
      @talk = FactoryGirl.build :talk
    end

    it 'has a valid factory' do
      expect(@talk).to be_valid
    end
    it 'validates presence of title' do
      @talk.title = nil
      expect(@talk).to_not be_valid
    end
    it 'validates presence of starts_at_date' do
      @talk.starts_at_date = nil
      expect(@talk).to_not be_valid
    end
    it 'validates presence of starts_at_time' do
      @talk.starts_at_time = nil
      expect(@talk).to_not be_valid
    end
    it "validates presence of new_series_title if series_id is not set" do
      @talk.series = nil
      expect(@talk).to_not be_valid
    end
    it "is valid when series_id is not set but new_series_title is set" do
      @talk.series = nil
      @talk.new_series_title = "Some title"
      @talk.series_user = FactoryGirl.create(:user)
      expect(@talk).to be_valid
    end
    it "creates a series on the fly if new_series_title is set" do
      @talk.series_id = nil
      @talk.new_series_title = "Some title"
      @talk.series_user = FactoryGirl.create(:user)
      @talk.save!
      expect(@talk.series.title).to eq("Some title")
    end
    it 'should store what is written to processed_at' do
      @talk.processed_at = time = Time.zone.now
      @talk.save!
      @talk.reload
      expect(@talk.processed_at).to eq(time)
    end
    # FIXME Hello future self, this will fail when run during daylight
    # saving time. Sophia suggested to test with a time zone that
    # doesn't have daylight saving time
    it 'assembles starts_at correctly when saved' do
      expect(Time.zone.name).to eq('Berlin')
      @talk.starts_at_date = '1942-05-22' # local
      @talk.starts_at_time = '12:42' # local
      @talk.save!
      expect(@talk.reload.starts_at.utc.strftime('%H:%M')).to eq('10:42')
    end
  end

  describe 'related talk' do
    it 'has a related talk' do
      featured_talk = FactoryGirl.create :talk
      related_talk = FactoryGirl.create :talk

      featured_talk.related_talk = related_talk
      featured_talk.save

      expect(related_talk.reload.featured_talk).to eq(featured_talk)
    end
    context 'next talk' do
      before do
        @talk = FactoryGirl.create :talk
      end
      it 'returns nil when there is no next talk' do
        expect(@talk.series.talks.count).to eq(1)
        expect(@talk.next_talk).to be_nil
      end

      it 'returns the next talk' do
        @talk.series.talks << FactoryGirl.create(:talk, title: 'first')
        @talk.series.talks << FactoryGirl.create(:talk, title: 'second')
        @talk.series.talks << FactoryGirl.create(:talk, title: 'third')

        expect(@talk.next_talk.title).to                     eq('first')
        expect(@talk.next_talk.next_talk.title).to           eq('second')
        expect(@talk.next_talk.next_talk.next_talk.title).to eq('third')
      end
    end
  end

  describe 'on class level' do
    it 'has a scope featured which does not include live talks' do
      talk0 = FactoryGirl.create(:talk, featured_from: 2.days.ago, state: :prelive)
      talk1 = FactoryGirl.create(:talk, featured_from: 1.day.ago, state: :live)
      talk2 = FactoryGirl.create(:talk, featured_from: 1.day.from_now, state: :prelive)
      expect(Talk.scheduled_featured.count).to eq(1)
      expect(Talk.scheduled_featured).to include(talk0)
      expect(Talk.scheduled_featured).to_not include(talk1)
      expect(Talk.scheduled_featured).to_not include(talk2)
    end

    describe 'saves the Content-Type' do
      before { @talk = FactoryGirl.create(:talk) }
      it 'works for m4a' do
        skip 'find a way to spec the mime type hack "m4a -> audio/mp4"'
        m4a_file = File.expand_path("spec/support/fixtures/transcode0/1.m4a", Rails.root)
        @talk.send(:upload_file, '1.m4a', m4a_file)

        media_storage = Storage.directories.new(key: Settings.storage.media, prefix: @talk.uri)
        expect(media_storage.files.get('1.m4a').content_type).to eq('audio/mp4')
      end
      it 'works for mp3' do
        mp3_file = File.expand_path("spec/support/fixtures/transcode0/1.mp3", Rails.root)
        @talk.send(:upload_file, '1.mp3', mp3_file)

        media_storage = Storage.directories.new(key: Settings.storage.media, prefix: @talk.uri)
        expect(media_storage.files.get('1.mp3').content_type).to eq('audio/mpeg')
      end
      it 'works for ogg' do
        ogg_file = File.expand_path("spec/support/fixtures/transcode0/1.ogg", Rails.root)
        @talk.send(:upload_file, '1.ogg', ogg_file)

        media_storage = Storage.directories.new(key: Settings.storage.media, prefix: @talk.uri)
        expect(media_storage.files.get('1.ogg').content_type).to eq('audio/ogg')
      end
    end

  end

  describe 'created' do
    before do
      @talk = FactoryGirl.create(:talk)
    end
    it 'sets the time of starts_at via starts_at_time' do
      @talk.starts_at_time = '12:34'
      @talk.save
      expect(@talk.starts_at.strftime('%H:%M')).to eq('12:34')
    end
    it 'sets the date of starts_at via starts_at_date' do
      @talk.starts_at_date = '2013-12-31'
      @talk.save
      expect(@talk.starts_at.strftime('%Y-%m-%d')).to eq('2013-12-31')
    end
    it 'computes starts_in for use in prelive' do
      expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
    end
  end

  it 'nicely follows the life cycle' do
    with_dj_enabled do
      VCR.use_cassette 'talk_dummy' do
        talk = FactoryGirl.create(:talk)
        expect(talk.current_state).to be(:prelive)
        talk.start_talk!
        expect(talk.current_state).to be(:live)
        talk.end_talk!
        expect(talk.current_state).to be(:postlive)
        talk.process!
        expect(talk.current_state).to be(:processing)
        talk.archive!
        expect(talk.current_state).to be(:archived)
      end
    end
  end

  # NOTE: times set in a factory are not affected by `Timecop.freeze`
  # in a before block
  it 'provides a method starts_in' do
    attrs = { starts_at_date: 1.hour.from_now.strftime('%Y-%m-%d') }
    talk = FactoryGirl.create(:talk, attrs)
    expect(talk.starts_in).to be > 0
  end

  it 'generate ephemeral paths' do
    talk = FactoryGirl.create(:talk)
    url = talk.generate_ephemeral_path!
    expect(url).to match(/^http.*\.mp3$/)
  end

  # TODO resolve code duplication in this section
  describe 'nicely processes audio' do

    it 'in state postlive', slow: true do
      skip 'omit in CI' if ENV['CI']
      talk = FactoryGirl.create(:talk)

      # move fixtures in place
      fixbase = File.expand_path("../../support/fixtures/talk_a", __FILE__)
      fixglob = "#{fixbase}/*.flv"
      fixflvs = Dir.glob(fixglob)
      target = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
      flvs = fixflvs.map { |f| f.sub(fixbase, target).sub("t1-", "t#{talk.id}-") }
      fixflvs.each_with_index { |fixflv, idx| FileUtils.cp(fixflv, flvs[idx]) }

      # prepare talk
      t_base = flvs.map { |f| f.match(/-(\d+)\./)[1].to_i }
      talk.update_attribute :started_at, Time.at(t_base.min).to_datetime
      talk.update_attribute :ended_at, Time.at(t_base.max + 1).to_datetime
      talk.update_current_state :postlive, true

      # run
      talk.send :postprocess!

      # assert
      base = File.expand_path(Settings.fog.storage.local_root, Rails.root)
      result = File.join(base, Settings.storage.media,
                         talk.uri, talk.id.to_s + '.m4a')
      expect(File.exist?(result)).to be_truthy
    end

    it 'in state archived', slow: true do
      skip 'omit in CI' if ENV['CI']
      talk = FactoryGirl.create(:talk)

      # move fixtures in place
      fixbase = File.expand_path("../../support/fixtures/talk_a", __FILE__)
      fixglob = "#{fixbase}/*.flv"
      fixflvs = Dir.glob(fixglob)
      target = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
      flvs = fixflvs.map { |f| f.sub(fixbase, target).sub("t1-", "t#{talk.id}-") }
      fixflvs.each_with_index { |fixflv, idx| FileUtils.cp(fixflv, flvs[idx]) }

      # prepare talk
      t_base = flvs.map { |f| f.match(/-(\d+)\./)[1].to_i }
      talk.update_attribute :started_at, Time.at(t_base.min).to_datetime
      talk.update_attribute :ended_at, Time.at(t_base.max + 1).to_datetime
      talk.update_current_state :postlive, true
      talk.send :postprocess!
      base = File.expand_path(Settings.fog.storage.local_root, Rails.root)
      result = File.join(base, Settings.storage.media,
                         talk.uri, talk.id.to_s + '.m4a')
      ctime = File.ctime(result)

      # no we are in state `archived`, so we can do a `reprocess`
      talk.send :reprocess!

      # assert
      expect(File.ctime(result)).not_to eq(ctime)
    end

    it 'in state archived with override', slow: true do
      skip 'omit in CI' if ENV['CI']
      talk = FactoryGirl.create(:talk)

      # move fixtures in place
      fixbase = File.expand_path("../../support/fixtures/talk_a", __FILE__)
      fixglob = "#{fixbase}/*.flv"
      fixflvs = Dir.glob(fixglob)
      target = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
      flvs = fixflvs.map { |f| f.sub(fixbase, target).sub("t1-", "t#{talk.id}-") }
      fixflvs.each_with_index { |fixflv, idx| FileUtils.cp(fixflv, flvs[idx]) }

      # prepare talk
      t_base = flvs.map { |f| f.match(/-(\d+)\./)[1].to_i }
      talk.update_attribute :started_at, Time.at(t_base.min).to_datetime
      talk.update_attribute :ended_at, Time.at(t_base.max + 1).to_datetime
      talk.update_current_state :postlive, true
      talk.send :postprocess!
      base = File.expand_path(Settings.fog.storage.local_root, Rails.root)
      result = File.join(base, Settings.storage.media,
                         talk.uri, talk.id.to_s + '.m4a')
      ctime = File.ctime(result)
      # all of these should work, but for speed we only resort to the local file
      override = 'https://staging.voicerepublic.com/sonar.ogg'
      override = 'https://www.dropbox.com/s/z5sur3qt65xybav/testfoo.wav'
      override = File.expand_path('spec/support/fixtures/sonar.ogg', Rails.root)
      talk.update_attribute :recording_override, override

      # no we are in state `archived`, so we can do a `process_override`
      talk.send :process_override!

      # assert
      expect(File.ctime(result)).not_to eq(ctime)
      expect(talk.recording_override).not_to eq(override)
    end

  end

  describe 'nicely handles callbacks' do

    it 'running after_start' do
      skip 'Please write a spec, pretty please!'
    end

    it 'running after_end' do
      skip 'Please write a spec, pretty please!'
    end

  end

  describe 'with indexing' do
    before do
      Thread.current["PgSearch.enable_multisearch"] = true
      @talk = FactoryGirl.create :talk
    end

    after do
      Thread.current["PgSearch.enable_multisearch"] = false
    end

    it 'properly limits fields' do
      # if the cumulated lengths of all indexed fields is to long
      # this will raise an error
      expect do
        @talk.title       = '-' * Settings.limit.string
        @talk.teaser      = '-' * Settings.limit.string
        @talk.description = '-' * Settings.limit.text
        @talk.save!
      end.to_not raise_error
    end
  end

  describe 'penalty' do

    it 'has a default penalty of 1' do
      talk = FactoryGirl.create(:talk)
      expect(talk.penalty).to eq(1)
    end

    it 'inherits its penalty from its series' do
      series = FactoryGirl.create(:series)
      series.penalty = 0.5
      series.save!
      talk = FactoryGirl.create(:talk, series: series)
      expect(talk.penalty).to eq(0.5)
    end

    it 'set penalty with set_penalty' do
      talk = FactoryGirl.create(:talk, :archived)
      talk.set_penalty!(0.5)
      expect(talk.penalty).to eq(0.5)
    end

  end

  describe 'debit' do
    it 'reduces the owners credits by one' do
      user = FactoryGirl.create(:user)
      user_credits = user.reload.credits
      FactoryGirl.create(:talk, series: user.default_series)
      expect(user.reload.credits).to eq(user_credits - 1)
    end
  end

  describe 'dryrun' do
    it 'automatically destroys the talk after a while' do
      with_dj_enabled do
        expect(Delayed::Job.count).to eq(0)
        talk = FactoryGirl.create :talk, dryrun: true

        expect_scheduled_job_to_have_run_in_the_future

        expect(Talk.where(id: talk.id)).to be_empty
      end
    end
  end

  describe 'markdown' do
    it 'should sanitize user input' do
      talk = FactoryGirl.create(:talk)
      talk.update_attribute :description, "<script>alert('hello')</script>"
      expect(talk.description_as_html).to_not include('script')
    end
  end

  describe 'venues' do
    it 'created implicitly' do
      talk = FactoryGirl.create(:talk, venue_name: 'A brand new venue')
      expect(talk.venue).to be_present
      expect(talk.venue.name).to eq('A brand new venue')
      expect(talk.venue).to be_persisted
      expect(talk.user.venues.count).to eq(1)

      # subsequent uses of the same name will reuse the existing venue
      talk = FactoryGirl.create(:talk)
      talk.venue_name = 'A brand new venue'
      expect(talk.user.venues.count).to eq(1)
    end

    it 'finds the next talk via venue' do
      venue = FactoryGirl.create(:venue)
      talks = FactoryGirl.create_list(:talk, 3, venue: venue)
      talks[0].update_attribute :starts_at_time, '15:00'
      talks[1].update_attribute :starts_at_time, '14:00'
      talks[2].update_attribute :starts_at_time, '13:00'
      expect(talks[2].lined_up).to eq(talks[1])
      expect(talks[1].lined_up).to eq(talks[0])
      expect(talks[0].lined_up).to be_nil
    end
  end

  describe 'urls' do
    let(:talk) { FactoryGirl.create(:talk) }

    it 'provides self_url' do
      expect(talk).to respond_to(:self_url)
      expect(talk.self_url).to match(%r{/#{talk.to_param}$})
    end
    it 'provides image_url' do
      expect(talk).to respond_to(:image_url)
      expect(talk.image_url).to match(%r{/?sha=[0-9a-f]{8}$})
    end
    it 'provides slides_url' do
      talk.update_attribute(:slides_uuid, 'asdf')
      expect(talk).to respond_to(:slides_url)
      expect(talk.slides_url).to match(%r{/slides/#{talk.id}$})
    end
    it 'provides media_url' do
      expect(talk).to respond_to(:media_url)
      expect(talk.media_url).to match(%r{/#{talk.id}.mp3$})
    end
  end

  describe 'live' do
    it 'saves unique listeners' do
      talk = FactoryGirl.create :talk
      expect(talk.listeners.size).to eq(0)

      talk.add_listener! "some_uuid"
      expect(talk.listeners.size).to eq(1)

      # Unique listeners will only be added once
      talk.add_listener! "some_uuid"
      expect(talk.listeners.size).to eq(1)
    end
  end

end
