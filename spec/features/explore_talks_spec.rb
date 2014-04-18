require 'spec_helper'

describe "Exploring Talks" do
  
  before do
    @user = FactoryGirl.create(:user)
    login_user(@user)
    @talk = FactoryGirl.create(:talk)
  end

  describe "as user on all pages" do
    it 'shows explore in talk_path' do
      visit talk_path(@talk)
      page.should have_selector('.explore')
      page.should have_content('Explore')
    end
    
    it 'shows explore in venue_talk_path' do
      visit venue_talk_path(@talk.venue, @talk)
      page.should have_selector('.explore')
      page.should have_content('Explore')
    end

    it 'shows explore in user_path' do
      visit user_path(@user)
      page.should have_selector('.explore')
      page.should have_content('Explore')
    end
  end

  describe "visiting talks#index" do
    it 'displays talks' do
      visit talks_path
      page.should have_selector('.explore-talks')
      page.should have_content('TalkExplorer')
    end

    it 'displays 25 talks a time' do
      FactoryGirl.create_list(:talk, 26)
      visit talks_path
      page.should have_selector('.talk-medium-text-box', count: 25)
      page.should have_selector('.pagination')
      page.should have_link('2')
      page.should_not have_link('3')
    end
  end
end
