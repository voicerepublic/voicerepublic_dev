# encoding: UTF-8
require 'spec_helper'

describe Talk do

  before do
    Timecop.freeze(Time.local(2036))
  end
  after do
    Timecop.return
  end

  describe 'built' do
    before do
      @talk = FactoryGirl.build :talk
    end

    it 'has a valid factory' do
      expect(@talk).to be_valid
    end
    it 'validates presence of venue' do
      @talk.venue = nil
      expect(@talk).to_not be_valid
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

  describe 'on class level' do
    it 'provides a scope audio_format(format)' do
      t1 = FactoryGirl.create :talk
      t2 = FactoryGirl.create :talk

      t1.audio_formats << 'mp3'
      t1.save
      Talk.audio_format('mp4').count.should be(0)
      Talk.audio_format('mp3').count.should be(1)
      t2.audio_formats << 'mp3'
      t2.save
      Talk.audio_format('mp3').count.should be(2)
    end

    it 'provides a scope without_audio_format(format)' do
      t1 = FactoryGirl.create :talk
      t2 = FactoryGirl.create :talk

      Talk.without_audio_format('mp4').count.should be(2)
      t2.audio_formats << 'mp3'
      t2.save
      Talk.without_audio_format('mp3').count.should be(1)
    end

    it 'has a scope featured' do
      talk0 = FactoryGirl.create(:talk, featured_from: 2.days.ago, state: :prelive)
      talk1 = FactoryGirl.create(:talk, featured_from: 1.day.ago, state: :live)
      talk2 = FactoryGirl.create(:talk, featured_from: 1.day.from_now, state: :prelive)
      expect(Talk.featured).to eq([talk1, talk0])
      expect(Talk.featured).to include(talk0)
    end
  end

  describe 'created' do
    before do
      @talk = FactoryGirl.create(:talk)
    end
    it 'sets the time of starts_at via starts_at_time' do
      @talk.starts_at_time = '12:34'
      @talk.save
      @talk.starts_at.strftime('%H:%M').should eq('12:34')
    end
    it 'sets the date of starts_at via starts_at_date' do
      @talk.starts_at_date = '2013-12-31'
      @talk.save
      @talk.starts_at.strftime('%Y-%m-%d').should eq('2013-12-31')
    end
    it 'computes starts_in for use in prelive' do
      expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
    end
  end

  it 'nicely follows the life cycle' do
    Delayed::Worker.delay_jobs = true # activate
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
    Delayed::Worker.delay_jobs = false # deactivate
  end

  # NOTE: times set in a factory are not affected by `Timecop.freeze`
  # in a before block
  it 'provides a method starts_in' do
    attrs = { starts_at_date: 1.hour.from_now.strftime('%Y-%m-%d') }
    talk = FactoryGirl.create(:talk, attrs)
    expect(talk.starts_in).to be > 0
  end

  it 'generate ephemeral paths' do
    talk = FactoryGirl.create(:talk, recording: 'invalid_id')
    base = Settings.rtmp.archive_path
    FileUtils.mkdir_p(base) # (!)
    source = "#{base}/invalid_id.wav"
    FileUtils.touch(source)
    loc = talk.generate_ephemeral_path! '.wav'
    target = "public/#{loc}"
    expect(File.exist?(target)).to be_true
    # cleanup
    FileUtils.rm(target)
    FileUtils.rm(source)
  end

  it 'does not send email with option no_emails' do
    ActionMailer::Base.deliveries = []
    venue = FactoryGirl.create(:venue, options: { no_email: true })
    talk = FactoryGirl.create(:talk, venue: venue)
    ActionMailer::Base.deliveries.should be_empty
  end

  # TODO resolve code duplication in this section
  describe 'nicely processes audio' do

    it 'in state postlive' do
      talk = FactoryGirl.create(:talk, record: true)

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
      VCR.use_cassette 'talk_postprocess' do
        talk.send :postprocess!
      end

      # assert
      result = File.join(Settings.rtmp.archive_path, talk.recording + '.m4a')
      expect(File.exist?(result)).to be_true
    end

    it 'in state archived' do
      talk = FactoryGirl.create(:talk, record: true)

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
      VCR.use_cassette 'talk_postprocess' do
        talk.send :postprocess!
      end
      result = File.join(Settings.rtmp.archive_path, talk.recording + '.m4a')
      ctime = File.ctime(result)

      # no we are in state `archived`, so we can do a `reprocess`
      VCR.use_cassette 'talk_reprocess' do
        talk.send :reprocess!
      end

      # assert
      expect(File.ctime(result)).not_to eq(ctime)
    end

    it 'in state archived with override' do
      talk = FactoryGirl.create(:talk, record: true)

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
      VCR.use_cassette 'talk_postprocess' do
        talk.send :postprocess!
      end
      result = File.join(Settings.rtmp.archive_path, talk.recording + '.m4a')
      ctime = File.ctime(result)
      # all of these should work, but for speed we only resort to the local file
      override = 'https://staging.voicerepublic.com/sonar.ogg'
      override = 'https://www.dropbox.com/s/z5sur3qt65xybav/testfoo.wav'
      override = File.expand_path('spec/support/fixtures/sonar.ogg', Rails.root)
      talk.update_attribute :recording_override, override
      
      # no we are in state `archived`, so we can do a `process_override`
      VCR.use_cassette 'talk_override' do
        talk.send :process_override!
      end

      # assert
      expect(File.ctime(result)).not_to eq(ctime)
      expect(talk.recording_override).not_to eq(override)
    end

  end

  describe 'nicely handles callbacks' do

    it 'running after_start' do
      pending 'Please write a spec, pretty please!'
    end

    it 'running after_end' do
      pending 'Please write a spec, pretty please!'
    end

  end

end
