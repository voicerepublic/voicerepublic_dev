require 'spec_helper'

describe "Talks" do

  before do
    @user = FactoryGirl.create(:user)
    login_user(@user)
  end

  describe "Exploring Talks" do

    before do
      @talk = FactoryGirl.create(:talk)
    end

    describe "as user on all pages" do
      it 'shows explore in talk_path' do
        visit talk_path(@talk)
        page.should have_selector('.explore-link')
        page.should have_content('Explore')
      end

      it 'shows explore in venue_talk_path' do
        visit venue_talk_path(@talk.venue, @talk)
        page.should have_selector('.explore-link')
        page.should have_content('Explore')
      end

      it 'shows explore in user_path' do
        visit user_path(@user)
        page.should have_selector('.explore-link')
        page.should have_content('Explore')
      end
    end

    describe "visiting talks#index" do
      it 'displays talks overview' do
        visit talks_path
        page.should have_selector('.see-all-link')
        page.should have_content('Explore')
      end

      it 'has "more" and displays 25 talks a time on recent' do
        FactoryGirl.create_list(:talk, 26, state: :archived)
        visit talks_path
        within(".recent-box") do
          click_on "more..."
        end
        current_path.should =~ /talks\/recent/
        page.should have_selector('.talk-medium-text-box', count: 25)
        page.should have_selector('.pagination')
        within(".pagination") do
          page.should have_link('2')
          page.should_not have_link('3')
        end
      end
    end
  end

  describe "Talk#new" do
    it 'creates a new talk', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit new_venue_talk_path(venue)

      fill_in :talk_title, with: 'spec talk title'
      fill_in :talk_teaser, with: 'spec talk teaser'
      # NOTE: Since the WYSIWYG editor is creating an ifrage, we cannot fill in
      # the text with Capybara. jQuery to the rescue.
      page.execute_script('$("iframe").contents().find("body").text("iwannabelikeyou")')
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

  describe "Talk#show" do
    describe "Chat", driver: :chrome do
      before do
        Timecop.travel(Time.local(2008, 9, 1, 10, 5, 0))
      end
      after do
        Timecop.return
      end
      it "it works live" do
        pending "Close to working, see comments"
        VCR.use_cassette 'talk_with_chat' do
          @venue = FactoryGirl.create :venue
          @talk = FactoryGirl.create :talk, venue: @venue
          visit venue_talk_path @venue, @talk
          find(".participate-button-box a").click
          find(".chat-input-box input").set("my message")
          find(".chat-input-box input").native.send_keys(:return)
          # This spec works until here. The message is never being shown in
          # testing mode, though. Faye published it, however. And of course it
          # works in development.
          within "#talk-tab-discussion" do
            page.should have_content "my message"
          end
        end
      end
      it "it works with reload" do
        VCR.use_cassette 'talk_with_chat' do
          @venue = FactoryGirl.create :venue
          @talk = FactoryGirl.create :talk, venue: @venue
          visit venue_talk_path @venue, @talk
          find(".participate-button-box a").click
          find(".chat-input-box input").set("my message")
          find(".chat-input-box input").native.send_keys(:return)
          visit(current_path)
          page.execute_script('$("a[href=#discussion]").click()')
          within "#discussion" do
            page.should have_content "my message"
            page.should have_content "01 Sep 10:05"
          end
        end
      end

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
