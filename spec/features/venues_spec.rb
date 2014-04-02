require 'spec_helper'

# feature is in fact just an alias for describe ..., :type =>
# :feature, background is an alias for before, scenario for it, and
# given/given! aliases for let/let!, respectively.
#
describe "Venues", js: true do

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
      # NOTE: Since the WYSIWYG editor is creating an ifrage, we cannot fill in
      # the text with Capybara. jQuery to the rescue.
      page.execute_script('$("iframe").contents().find("body").text("iwannabelikeyou")')
      fill_in 'venue_tag_list', with: 'a,b,c'

      click_button 'Save'
      page.should have_selector('.venues-show')
      page.should have_content('schubidubi')
      page.should have_content('iwannabelikeyou')
    end
  end

  describe "PATCH an existing venue" do
    it 'uploads an image and displays it', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit venue_path(id: venue.id)
      find('.header-block')['style'].should include('venue-image.jpg')
      click_link 'Edit Venue'
      # NOTE: This is not a perfect test, because it's exposing the real input
      # field while the app itself uses a Foundation button. Couldn't get it to
      # work using the button, though.
      page.execute_script('$("input#venue_image").show()')
      attach_file :venue_image, Rails.root.join('spec/support/fixtures/dummy.png')
      click_button 'Save'
      find('.header-block')['style'].should_not include('venue-image.jpg')
    end
  end

  describe "Comments" do
    it 'has an active comments tab after writing a comment', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit venue_path(id: venue.id)
      find(".fi-comments").click
      fill_in 'comment_content', with: 'spec comment'
      click_button 'Save'
      find("#tab-comments.active").should_not be_nil
    end
  end
end

