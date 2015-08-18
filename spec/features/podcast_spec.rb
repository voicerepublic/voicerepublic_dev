# coding: utf-8
require 'rails_helper'

feature 'Podcast' do

  let(:rss) { '//link[@rel="alternate"][@type="application/rss+xml"]' }

  feature 'for root on landing_page#index' do

    scenario 'properly encodeds html entities' do
      talk = FactoryGirl.create( :talk, :archived, :featured,
                                 title: 'Hello Wörld.' )
      expect(Talk.recent).to eq [talk]

      talk.storage = { "#{talk.uri}/#{talk.id}.mp3" =>
                         { duration: '1', size: '2' } }
      talk.save

      visit root_path(format: 'rss')
      expect(page).to have_xpath('//rss')
      expect(page.body).to include(talk.title)
    end

    scenario 'link to rss in head' do
      visit root_path
      links = Nokogiri::HTML(source).xpath(rss)
      expect(links).to_not be_empty
    end

    scenario 'landing_page#index.rss' do
      visit root_path(format: 'rss')
      expect(page).to have_xpath('//rss')
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
      expect(page).to have_xpath('//rss')
    end

  end

  feature 'for series on series#show' do

    let(:series) { FactoryGirl.create(:series) }

    scenario 'series#show' do
      visit series_path(series)
      links = Nokogiri::HTML(source).xpath(rss)
      expect(links).to_not be_empty
    end

    scenario 'series#show.rss' do
      visit series_path(series, format: 'rss')
      expect(page).to have_xpath('//rss')
    end

  end

  feature 'for all podcasts' do
    scenario 'there is a link in item' do
      # prepare
      talk = FactoryGirl.create(:talk, :archived, :featured)
      # fake the presence of a suitable file for podcasting
      talk.storage["#{talk.uri}/#{talk.id}.mp3"] = {}
      talk.save

      # visit
      visit root_path(format: 'rss')
      expect(page).to have_xpath("//link")
    end
  end

  feature "different OSs see different protocol URLs" do

    before do
      @user = FactoryGirl.create(:user)
      login_user(@user)
    end

    let(:series) { FactoryGirl.create(:series) }

    describe "ITPC protocol" do
      scenario "safari 7" do
        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71"+
                     " (KHTML, like Gecko) Version/7.0 Safari/537.71"
        page.driver.browser.header('User-Agent', user_agent)
        visit series_path(series)
        expect(page).to have_xpath("//a[contains(@href,'itpc')]")
      end
      scenario "iPad" do
        user_agent = "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26"+
                     " (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25"
        page.driver.browser.header('User-Agent', user_agent)
        visit series_path(series)
        expect(page).to have_xpath("//a[contains(@href,'feed')]")
      end
      scenario "iPad" do
        user_agent = "Mozilla/5.0 (iPhone; U; ru; CPU iPhone OS 4_2_1 like Mac OS X;"+
                     " ru) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2"+
                     " Mobile/8C148a Safari/6533.18.5"
        page.driver.browser.header('User-Agent', user_agent)
        visit series_path(series)
        expect(page).to have_xpath("//a[contains(@href,'feed')]")
      end
      scenario "Firefox/Linux" do
        user_agent = "Mozilla/5.0 (X11; Linux x86_64; rv:28.0) Gecko/20100101"+
                     " Firefox/28.0"
        page.driver.browser.header('User-Agent', user_agent)
        visit series_path(series)
        xpath = "//a[contains(@href,'series/#{series.to_param}.rss')]"
        expect(page).to have_xpath(xpath)
      end
    end

  end

end
