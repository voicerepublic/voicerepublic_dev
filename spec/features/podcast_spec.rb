require 'spec_helper'

feature 'Podcast' do

  let(:rss) { '//link[@rel="alternate"][@type="application/rss+xml"]' }

  feature 'for root on landing_page#index' do

    scenario 'link to rss in head' do
      visit root_path
      links = Nokogiri::HTML(source).xpath(rss)
      expect(links).to_not be_empty
    end

    scenario 'landing_page#index.rss' do
      visit root_path(format: 'rss')
      page.should have_xpath('//rss')
    end

  end

  feature 'for user on users#show' do

    let(:user) { FactoryGirl.create(:user) }

    scenario 'link to rss in head' do
      visit user_path(user)
      links = Nokogiri::HTML(source).xpath(rss)
      expect(links).to_not be_empty
    end

    scenario 'users#show.rss' do
      user = FactoryGirl.create(:user)
      visit user_path(user, format: 'rss')
      page.should have_xpath('//rss')
    end

  end

  feature 'for venue on venues#show' do

    let(:venue) { FactoryGirl.create(:venue) }
    
    scenario 'venues#show' do
      visit venue_path(venue)
      links = Nokogiri::HTML(source).xpath(rss)
      expect(links).to_not be_empty
    end
    
    scenario 'venues#show.rss' do
      visit venue_path(venue, format: 'rss')
      page.should have_xpath('//rss')
    end
    
  end

end
