require 'spec_helper'

describe TalkAudio do

  pending 'generates fake journals' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      path = audio.send(:journal_path)
      expect(File.exist?(path)).to be_false
      audio.journal
      expect(File.exist?(path)).to be_true
    end
  end
  
  pending 'parses journals' do
    audio_fixture('spec/support/fixtures/normalize0', 1) do |base|
      audio = TalkAudio.new(base)
      expect(audio.journal).to be_a(Hash) 
    end
  end

end
