require 'spec_helper'

describe "Talks" do

  before do
    @user = FactoryGirl.create(:user)
    login_user(@user)
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
