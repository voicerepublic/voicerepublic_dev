require 'spec_helper'

# feature is in fact just an alias for describe ..., :type =>
# :feature, background is an alias for before, scenario for it, and
# given/given! aliases for let/let!, respectively.
#
describe "Venues" do

  before do
    @user = FactoryGirl.create(:user)
    login_user(@user)
  end

  describe "GET venues" do
    it "renders index" do
      visit venues_path
      page.should have_selector(".venues-index")
    end
  end

  describe "GET a specific venue" do
    before do
      @venue = FactoryGirl.create(:venue, user: @user)
    end
    it "renders show" do
      visit venue_path(id: @venue)
      page.should have_selector(".venues-show")
    end
    it "renders edit" do
      visit edit_venue_path(id: @venue)
      page.should have_selector(".venues-edit")
    end
    it "updates title" do
      visit edit_venue_path(id: @venue)
      page.should have_selector(".venues-edit")
      page.fill_in 'venue_title', with: new_title = "A completely new title"
      page.click_button 'Save'
      page.should have_content(new_title)
    end
  end

  describe "GET a new venue" do
  end

end
