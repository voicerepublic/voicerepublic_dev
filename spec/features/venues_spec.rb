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
      fill_in 'venue_title', with: new_title = "A completely new title"
      click_button 'Save'
      page.should have_content(new_title)
    end

    describe "Sharing" do
      it "can be shared via email" do
        visit venue_path(id: @venue)
        within("#social_share .mail") do
          page.should have_link("")
          pat = /#{ERB::Util.url_encode(I18n.t('social_share.mail_body'))}/
          find('a')['href'].should =~ pat
        end
      end

      it "can be shared to social networks and saves statistics",
         driver: :chrome, slow: true do
        SocialShare.count.should eq(0)
        visit venue_path(id: @venue)
        page.execute_script('$("#social_share .facebook").click()')
        sleep 0.2

        share_window = page.driver.browser.window_handles.last
        page.within_window share_window do
          current_url.should match(/facebook.com/)
        end

        SocialShare.count.should eq(1)
      end
    end
  end

  describe "GET a new venue" do
    it 'renders new' do
      visit new_venue_path
      page.should have_selector(".venues-new")
    end
  end

  describe "POST a new venue" do
    it 'creates a venue' do
      visit new_venue_path
      fill_in 'venue_title', with: 'schubidubi'
      fill_in 'venue_teaser', with: 'some teaser'
      fill_in 'venue_description', with: 'iwannabelikeyou'
      fill_in 'venue_tag_list', with: 'a,b,c'

      fill_in 'venue_talks_attributes_0_title', with: 'some talk title'
      fill_in 'venue_talks_attributes_0_teaser', with: 'some talk teaser'
      fill_in 'venue_talks_attributes_0_starts_at_date', with: 1.day.from_now
      fill_in 'venue_talks_attributes_0_starts_at_time', with: 1.day.from_now
      select '60', from: 'venue_talks_attributes_0_duration'
      fill_in 'venue_talks_attributes_0_tag_list', with: 'd,e,f'
      fill_in 'venue_talks_attributes_0_description', with: 'some talk description'

      click_button 'Save'
      page.should have_selector('.venues-show')
      page.should have_content('schubidubi')
      page.should have_content('iwannabelikeyou')
    end
  end

  describe "PATCH an existing venue" do
    it 'uploads an image and displays it' do
      venue = FactoryGirl.create(:venue, user: @user)
      visit venue_path(id: venue.id)
      find('.header-block')['style'].should include('venue-image.jpg')
      click_link 'Edit Venue'
      attach_file :venue_image, 'spec/support/fixtures/dummy.png'
      click_button 'Save'
      find('.header-block')['style'].should_not include('venue-image.jpg')
    end
  end
  
end
