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
    it 'validates presence of starts_at' do
      @talk.starts_at = nil
      expect(@talk).to_not be_valid
    end
    it 'sets the time of starts_at via starts_at_time' do
      @talk.starts_at_time = '12:34'
      @talk.starts_at.strftime('%H:%M').should eq('12:34')
    end
    it 'sets the date of starts_at via starts_at_date' do
      @talk.starts_at_date = '2013-12-31'
      @talk.starts_at.strftime('%Y-%m-%d').should eq('2013-12-31')
    end
    it 'provides a method starts_in' do
      expect(@talk.starts_in).to be > 0
    end
  end

  describe 'built relying on callbacks' do
    it 'sets ends_at based on starts_at and duration' do
      talk = FactoryGirl.build(:talk, duration: 45)
      talk.valid? # triggers before_validation callbacks
      expect(talk.ends_at).to eq(talk.starts_at + 45.minutes)
    end
    it 'does not crash when required parameters are missing' do
      talk = FactoryGirl.build(:talk, duration: nil)
      expect { talk.save }.to_not raise_exception
    end
  end

  describe 'on class level' do
    it 'provides a scope upcoming' do
      expected, unexpected = [], []
      expected << FactoryGirl.create(:talk, starts_at: 1.day.from_now)
      expected << FactoryGirl.create(:talk, starts_at: 1.hour.from_now)
      expected << FactoryGirl.create(:talk, starts_at: 1.minute.from_now)
      expected << FactoryGirl.create(:talk, starts_at: 1.minute.ago)
      unexpected << FactoryGirl.create(:talk, starts_at: 1.day.ago)
      expect(Talk.upcoming).to eq(expected)
    end

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
  end

  describe 'created' do
    before do
      @talk = FactoryGirl.create(:talk)
    end
    it 'computes starts_in for use in prelive' do
      expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
    end
  end

  describe 'customized' do
    it 'computes starts_in for use in prelive' do
      date_str = '2014-03-20 11:11'
      @talk = FactoryGirl.create(:talk, starts_at: date_str)
      expect(@talk.starts_at.strftime('%Y-%m-%d %H:%M')).to eq(date_str)
      expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
    end
  end

  # the spec works for me, on circleci it fails, since the generated talks
  # id is 5 instead of 1, this doesn't work well with the fixtures
  it 'nicely postprocesses audio' do
    pending 'does not work currently, because it uses legacy talk attributes'
    pending "WORKS ON MY MACHINE -- FAILS ON CIRCLECI" if ENV["CI"]
    begin
      talk = FactoryGirl.create(:talk, record: true)
      # move fixtures in place
      fixbase = File.expand_path("../../support/fixtures/talk_a", __FILE__)
      fixglob = "#{fixbase}/*.flv"
      flvs = Dir.glob(fixglob)
      target = File.dirname(talk.recording_path)
      FileUtils.mkdir_p(target)
      FileUtils.cp(flvs, target, verbose: true)
      talk.update_current_state(:postlive, true)
      # assert pre state
      result = "#{talk.recording_path}.m4a"
      expect(File.exist?(result)).to be_false
      # process
      talk.send :postprocess!
      # assert post state
      expect(File.exist?(result)).to be_true
    ensure
      # cleanup
      files = flvs.map { |f| f.sub(fixbase, target) }
      FileUtils.rm(files)
      files = files.map { |f| f.sub('.flv', '.wav') }
      FileUtils.rm(files)
      FileUtils.rm(result)
      # %x[ aplay #{result.sub('.m4a', '.wav')} ]
      FileUtils.rm(result.sub('.m4a', '.wav'))
      FileUtils.rm("#{talk.recording_path}.journal")
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

  it 'has a scope featured' do
    talk0 = FactoryGirl.create(:talk, featured_from: 2.days.ago)
    talk1 = FactoryGirl.create(:talk, featured_from: 1.day.ago)
    talk2 = FactoryGirl.create(:talk, featured_from: 1.day.from_now)
    expect(Talk.featured).to eq([talk1, talk0])
    expect(Talk.featured).to include(talk0)
  end

  it 'does not send email with option no_emails' do
    ActionMailer::Base.deliveries = []
    venue = FactoryGirl.create(:venue, options: { no_email: true })
    talk = FactoryGirl.create(:talk, venue: venue)
    ActionMailer::Base.deliveries.should be_empty
  end

end
