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
    describe "Sharing" do

      it "can be shared via email" do
        visit venue_path(id: @venue)
        within("#social_share .mail") do
          page.should have_link("")
          find('a')['href'].should =~ /#{ERB::Util.url_encode(I18n.t('social_share.mail_body'))}/
        end
      end

      it "can be shared to social networks and saves statistics", driver: :chrome do
        SocialShare.count.should eq(0)
        visit venue_path(id: @venue)
        page.execute_script('$("#social_share .facebook").click()')
        sleep 0.1

        share_window = page.driver.browser.window_handles.last
        page.within_window share_window do
          current_url.should match(/facebook.com/)
        end

        SocialShare.count.should eq(1)
      end
    end
  end

end
