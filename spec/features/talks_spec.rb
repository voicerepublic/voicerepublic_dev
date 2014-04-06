require 'spec_helper'

describe "Talks" do

  before do
    @user = FactoryGirl.create(:user)
    login_user(@user)
  end

  describe "Talk#new" do

    it 'creates a new talk', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit new_venue_talk_path(venue)

      fill_in :talk_title, with: 'spec talk title'
      fill_in :talk_teaser, with: 'spec talk teaser'
      # fill in tags
      fill_in 's2id_autogen2', with: 'a,b,c,'
      fill_in 'talk_starts_at_date', with: '2014-04-29'
      fill_in 'talk_starts_at_time', with: '05:12'

      click_button 'Save'
      page.should have_selector('.talks-show')
      page.should have_content('spec talk title')
    end

    it 'shows validation errors', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit new_venue_talk_path(venue)

      fill_in 'talk_starts_at_date', with: ''
      fill_in 'talk_starts_at_time', with: ''

      click_button 'Save'
      page.should have_content(I18n.t(:invalid_date))
      page.should have_content(I18n.t(:invalid_time))

    end



  end

  describe "validation" do

    before do
      @venue = FactoryGirl.create :venue
      @talk = FactoryGirl.create :talk, venue: @venue, tag_list: "test, foo, bar"
    end

    # FIXME sometimes failing spec
    #
    #     Failure/Error: Unable to find matching line from backtrace
    #     ActiveRecord::RecordNotFound:
    #       ActiveRecord::RecordNotFound
    #
    it "can be shared to social networks and saves statistics", retry: 3, driver: :chrome, slow: true do
      pending "T H I S   S P E C   F A I L S   O N   C I"
      SocialShare.count.should eq(0)
      VCR.use_cassette 'talk_dummy' do
        visit venue_talk_path 'en', @venue, @talk
        page.execute_script('$("#social_share .facebook").click()')
        sleep 0.2

        share_window = page.driver.browser.window_handles.last
        page.within_window share_window do
         current_url.should match(/facebook.com/)
        end
      end

      SocialShare.count.should eq(1)
    end

    # FIXME sometimes failing spec (BT see above)
    it "does not lose tags on failed validation", js: true, retry: 3 do
      pending "T H I S   S P E C   F A I L S   F A I R L Y   R E G U L A R"
      VCR.use_cassette 'talk_dummy' do
        visit edit_venue_talk_path 'en', @venue, @talk
        fill_in :talk_title, with: ""
        click_on I18n.t 'helpers.submit.submit'
      end
      page.should have_content "Please review the problems below"
      within '#s2id_talk_tag_list.tagList' do
        page.should have_content "test"
        page.should have_content "foo"
        page.should have_content "bar"
      end
    end
  end
end
