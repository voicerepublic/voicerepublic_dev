require 'spec_helper'

describe TalkSetting do

  pending 'generates fake journals' do
    audio_fixture('spec/support/fixtures/normalize0', '*.flv') do |path|
      setting = TalkSetting.new(path)
      path = setting.send(:journal_path)
      expect(File.exist?(path)).to be_true
    end
  end
  
  pending 'parses journals' do
    audio_fixture('spec/support/fixtures/normalize0', '*.flv') do |path|
      audio = TalkSetting.new(path)
      expect(setting.journal).to be_a(Hash) 
    end
  end

end
