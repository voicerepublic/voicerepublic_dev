require 'spec_helper'

describe TalkAudio do

  it 'generates fake journals' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      path = audio.send(:journal_path)
      expect(File.exist?(path)).to be_false
      audio.journal
      expect(File.exist?(path)).to be_true
    end
  end
  
  it 'parses journals' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      expect(audio.journal).to be_a(Hash) 
    end
  end

  it 'merges' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      result = audio.merge!
      expect(File.exist?(result)).to be_true
    end
  end

  it 'trims' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      audio.merge!

      audio_start = audio.journal['record_done'].first.last.to_i
      talk_start = audio_start + 3 # 3s later
      talk_stop = audio_start + 6 # 6s later
      result = audio.trim!(talk_start, talk_stop)
      cmd = "soxi -D #{result}"
      duration = %x[ #{cmd} ].to_f.round
      expect(duration).to eq(3)
    end
  end

  it 'transcodes' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      audio.merge!
      result = audio.transcode!
      expect(File.exist?(result)).to be_true
    end
  end

end
