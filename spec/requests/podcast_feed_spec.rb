require 'spec_helper'

describe 'podcast feed' do
  before do
    @venue = FactoryGirl.create(:venue)
    @talks = FactoryGirl.create_list(:talk, 2, state: :archived, venue: @venue)
  end

  describe 'feed' do
    it 'rss format' do
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to include('xml')
    end
  end

  describe 'audio format' do
    it 'default ogg' do
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to include("voicerepublic.com/vrmedia/#{@talks.first.id}.ogg")
    end

    it 'format mp3' do
      get venue_talks_path(@venue, format: :rss, audio_format: 'mp3')
      expect(response.body).to include("voicerepublic.com/vrmedia/#{@talks.first.id}.mp3")
    end
    
    it 'format m4a' do
      get venue_talks_path(@venue, format: :rss, audio_format: 'm4a')
      expect(response.body).to include("voicerepublic.com/vrmedia/#{@talks.first.id}.m4a")
    end
    
    it 'format ogg' do
      get venue_talks_path(@venue, format: :rss, audio_format: 'ogg')
      expect(response.body).to include("voicerepublic.com/vrmedia/#{@talks.first.id}.ogg")
    end

  end

  describe 'contains' do
    it 'only :archived' do
      talk = FactoryGirl.create(:talk, venue: @venue)
      get venue_talks_path(@venue, format: :rss, audio_format: 'ogg')
      expect(response.body).to_not include("#{talk.id}.ogg")
    end

    it 'venue image' do
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to include(@venue.image.url)
    end
    
  end


end
