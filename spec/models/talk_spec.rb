require 'spec_helper'

describe Talk do

  describe 'built' do
    before do
      @talk = FactoryGirl.build(:talk)
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
    # FIXME: I have seen this spec fail in a 'sometimes fashion'
    pending 'provides a method starts_in' do
      expect(@talk.starts_in).to be > 0
    end
  end

  describe 'built relying on callbacks' do
    it 'sets ends_at based on starts_at and duration' do
      talk = FactoryGirl.build(:talk, duration: 45)
      talk.valid? # triggers before_validation callbacks
      expect(talk.ends_at).to eq(talk.starts_at + 45.minutes)
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
      Timecop.freeze do
        expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
      end
    end
  end

  describe 'customized' do
    it 'computes starts_in for use in prelive' do
      date_str = '2014-03-20 11:11'
      @talk = FactoryGirl.create(:talk, starts_at: date_str)
      expect(@talk.starts_at.strftime('%Y-%m-%d %H:%M')).to eq(date_str)
      Timecop.freeze do
        expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
      end
    end
  end

  # the spec works for me, on circleci it fails, since the generated talks
  # id is 5 instead of 1, this doesn't work well with the fixtures
  pending 'nicely postprocesses audio' do
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


  it 'does not send email with option no_emails' do
    venue = FactoryGirl.create(:venue, options: { no_emails: true })
    talk = FactoryGirl.create(:talk, venue: venue)
    expect(ActionMailer::Base.deliveries).to be_empty
  end

end
