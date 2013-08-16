
require 'spec_helper'

describe "Venues" do

  before do
    @user = FactoryGirl.create(:user)
    unless Role.find_by_name('venue_host')
      Role.create!(:name => 'venue_host')
    end
    @user.roles << Role.find_by_name('venue_host')
    @user.save
    @user.reload
    @time = 1.day.from_now
    @venue = FactoryGirl.create(:venue, user: @user)
    FactoryGirl.create(:event, venue: @venue, start_time: @time)
    login_user(@user)
  end

  describe "GET /venues" do
    it "works! (now write some real specs)" do
      visit venues_path
      page.should have_selector(".venue-list")
    end
  end

  describe "GET a specific venue page" do
    it "will render the venues page" do
      visit venue_path(:id => @venue)
      page.should have_selector(".venue-header")
    end

    # FIXME
    it "will render the chat area with a specific field rendering host-info" do
      visit venue_path(:id => @venue)
      @venue.start_time.should eq(@time)
      #page.should have_css('div.host-info')
    end

    # FIXME
    it "will have a button for venue-host to broadcast new info" do
      visit venue_path(:id => @venue)
      # find_button('broadcast')
    end
  end
end
