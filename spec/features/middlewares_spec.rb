require 'spec_helper'

feature 'MediaTracker' do

  include AudioFixtureHelper

  scenario 'tracks a play' do
    skip 'NEEDS TO BE COMPLETELY REWRITTEN TO WORK WITH FOG'
    audio_fixture('spec/support/fixtures/complex', '1.wav') do |path|
      talk = FactoryGirl.create(:talk, recording: "#{path}/1")
      expect(talk.play_count).to be(0)
      visit "/vrmedia/#{talk.id}.wav"
      expect(talk.reload.play_count).to be(1)
    end
  end

  scenario 'returns a redirect to temporary location' do
    skip 'NEEDS TO BE COMPLETELY REWRITTEN TO WORK WITH FOG'
    audio_fixture('spec/support/fixtures/complex', '1.wav') do |path|
      talk = FactoryGirl.create(:talk, recording: "#{path}/1")
      visit "/vrmedia/#{talk.id}.wav"
      # capybara follows the redirect automatically
      content = File.open("#{path}/1.wav", 'rb') { |f| f.read }
      expect(page.body).to eq(content)
    end
  end
end

