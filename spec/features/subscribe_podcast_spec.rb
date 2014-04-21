require 'spec_helper'

describe 'Subscribe Podcast' do
  before do
    @venue = FactoryGirl.create(:venue)
    @talks = FactoryGirl.create_list(:talk, 2, state: :archived, venue: @venue)
  end

  describe 'Venue' do
    it '#podcast' do
      visit venue_path(@venue)
      page.should have_link 'rss'
    end
  end
end
