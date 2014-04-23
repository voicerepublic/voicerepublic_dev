require 'spec_helper'

describe 'podcast feed' do
  before do
    @venue = FactoryGirl.create(:venue)
    @talks = FactoryGirl.create_list(:talk, 2, 
                                     state: :archived,
                                     processed_at: Date.today,
                                     venue: @venue)
  end

  describe 'feed' do
    it 'rss format' do
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to include('xml')
    end
  end

  describe 'audio format' do
    it 'default mp3' do
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to include("example.com/vrmedia/#{@talks.first.id}.mp3")
    end

  end

  describe 'contains' do
    it 'only :archived' do
      talk = FactoryGirl.create(:talk, venue: @venue)
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to_not include("#{talk.id}.mp3")
    end

    it 'venue image' do
      get venue_talks_path(@venue, format: :rss)
      expect(response.body).to include(@venue.image.path.split('/')[-1])
    end
    
  end


end
