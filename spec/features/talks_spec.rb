require 'rails_helper'

# it renders specs
describe 'TalksController' do
  describe 'renders' do
    describe 'without talk' do
      it 'index on GET /talks' do # index
        visit '/talks'
        expect(page).to have_selector(".talks-index")
      end
      it 'index on GET /talks/featured' do # featured
        visit '/talks/featured'
        expect(page).to have_selector(".talks-featured")
      end
      it 'index on GET /talks/popular' do # popular
        visit '/talks/popular'
        expect(page).to have_selector(".talks-popular")
      end
      it 'index on GET /talks/upcoming' do # upcoming
        visit '/talks/upcoming'
        expect(page).to have_selector(".talks-upcoming")
      end
      it 'index on GET /talks/live' do # live
        visit '/talks/live'
        expect(page).to have_selector(".talks-live")
      end
      it 'index on GET /talks/recent' do # recent
        visit '/talks/recent'
        expect(page).to have_selector(".talks-recent")
      end
      it 'new on GET /talks/new' do # new
        visit '/talks/new'
        expect(page).to have_selector(".talks-new")
      end
    end
    describe 'with talk' do
      before do
        @talk = FactoryGirl.create(:talk)
      end
      it "show on GET /talks/:id" do # show
        skip
        visit talk_path(@talk)
        expect(page).to have_selector(".talks-show")
      end
      it "edit on GET /talks/:id/edit" do # edit
        skip
        login_talk @talk
        visit edit_talk_path(@talk)
        expect(page).to have_selector(".talks-edit")
      end
    end
  end
end

describe "Talks as anonymous user" do
  describe 'redirect to login/sign up', js: true do
    skip 'redirects to talk after login' do
      talk = FactoryGirl.create(:talk)
      user = FactoryGirl.create(:user, email: 'foo@bar.com')
      user.set_password! "123123"

      talk.update_attribute :state, :live
      visit talk_path(talk)
      find(".request-mic-box a").click
      within(".reveal-modal") do
        expect(page).to have_content("Please sign up or login to use this feature")
        click_on "Login"
      end
      fill_in "user_email", with: "foo@bar.com"
      fill_in "user_password", with: "123123"
      find("button[name=Login]").click

      expect(current_path).to match(/#{talk_path(talk)}/)
    end
    it 'asks users to login on request mic and redirects to talk after login' do
      skip 'fails when run in suite, succeed when run standalone'
      talk = FactoryGirl.create(:talk)
      user = FactoryGirl.create(:user, email: 'foo@bar.com')
      user.set_password! "123123"

      talk.update_attribute :state, :live
      visit talk_path(talk)
      find(".request-mic-box a").click
      within(".reveal-modal") do
        expect(page).to have_content("Please sign up or login to use this feature")
        click_on "Login"
      end
    end
  end
end
describe "Talks as logged in user" do

  before do
    @user = FactoryGirl.create(:user)
    login_user(@user)
  end

  describe "Live talk", js: :true do
    before do
      # !! BEWARE !!
      # These specs are the mother of all tightly coupled specs. I gave up on
      # trying to create specs that are properly mocked for live talks, but
      # within reason.
      `netcat localhost 9292 -w 1 -q 0 </dev/null`
      skip 'Needs PrivatePub to run' if $?.exitstatus != 0
      WebMock.disable!
    end
    after do
      WebMock.enable!
    end

    describe "Visitor" do
      it 'shows a countdown' do
        skip RSpec::RACECOND
        @talk = FactoryGirl.create(:talk,
                                   starts_at_time: 5.minutes.from_now.strftime("%H:%M"),
                                   starts_at_date: Date.today)
        visit talk_path(@talk)
        expect(page).to have_content "THIS TALK IS LIVE IN"
        expect(page).to have_content "computing"
        retry_with_delay do
          expect(page).to have_content /00:04:\d{2}/
        end
        Timecop.travel(2.minutes.from_now)
        visit talk_path(@talk)
        retry_with_delay do
          expect(page).to have_content /00:02:\d{2}/
        end
        Timecop.return
      end


      it "sets correct state for visitor/listener" do
        skip RSpec::RACECOND
        @talk = FactoryGirl.create(:talk)
        @talk.update_attribute :state, :live
        visit talk_path(@talk)
        retry_with_delay do
          expect(@talk.reload.session[@user.id][:state]).to eq("Registering")
        end
        retry_with_delay do
          expect(@talk.reload.session[@user.id][:state]).to eq("Listening")
        end
      end
    end

    describe "Host" do
      it "sets correct state for host" do
        skip RSpec::RACECOND
        @talk = FactoryGirl.create(:talk)
        venue = @talk.venue
        venue.user = @user
        venue.save!

        @talk.update_attribute :state, :live
        visit talk_path(@talk)
        retry_with_delay do
          expect(@talk.reload.session[@user.id][:state]).to eq("HostRegistering")
        end
        retry_with_delay do
          expect(@talk.reload.session[@user.id][:state]).to eq("HostOnAir")
        end
      end

      it "goes live on it's own", driver: :chrome do
        skip 'omit on ci' if ENV['CI']

        @talk = FactoryGirl.create(:talk,
                                   starts_at_time: 5.minutes.from_now.strftime("%H:%M"),
                                   starts_at_date: Date.today,
                                   duration: 30)
        venue = @talk.venue
        venue.user = @user
        venue.save!

        Timecop.travel(5.minutes.from_now)
        visit talk_path(@talk)
        retry_with_delay do
          within '.talk-state-info' do
            expect(page).to have_content I18n.t('.talks.show.state_text')
          end
        end
        Timecop.return
      end
    end

  end


  describe "Exploring Talks" do

    before do
      @talk = FactoryGirl.create(:talk)
    end

    describe 'flash dependency' do
      it "live talk requires flash", js: true do
        @talk.update_attribute :state, :live
        visit talk_path(@talk)
        expect(page).to have_css('#flash_error_for_listener')
      end

      it 'archived talk requires no flash', js: true do
        @talk.update_attribute :state, :archive
        visit talk_path(@talk)
        expect(page).not_to have_css('#flash_error_for_listener')
      end
    end

    describe "as user on all pages" do
      it 'shows explore in talk_path' do
        visit talk_path(@talk)
        expect(page).to have_selector('.explore-link')
        expect(page).to have_content('Explore')
      end

      it 'shows explore in venue_talk_path' do
        visit venue_talk_path(@talk.venue, @talk)
        expect(page).to have_selector('.explore-link')
        expect(page).to have_content('Explore')
      end

      it 'shows explore in user_path' do
        visit user_path(@user)
        expect(page).to have_selector('.explore-link')
        expect(page).to have_content('Explore')
      end
    end

    describe "visiting talks#index" do
      it 'displays talks overview' do
        visit talks_path
        expect(page).to have_selector('.see-all-link')
        expect(page).to have_content('Explore')
      end

      it 'has "more" and displays 25 talks a time on recent' do
        FactoryGirl.create_list(:talk, 26, :archived, :featured)
        visit talks_path
        within(".recent") do
          click_on "MORE"
        end
        expect(current_path).to match(/talks\/recent/)
        expect(page).to have_selector('.talk-medium-box', count: 25)
        expect(page).to have_selector('.pagination')
        within(".pagination") do
          expect(page).to have_link('2')
          expect(page).not_to have_link('3')
        end
      end
    end
  end

  describe "Talk#new" do
    it 'has default time and date' do
      skip 'this feature has been disabled for the moment'
      venue = FactoryGirl.create(:venue, user: @user)
      visit new_talk_path
      # Time is being written in the frontend. Cannot use Timecop to mock that.
      expect(find('#talk_starts_at_date').value).to eq(Date.today.strftime "%Y-%m-%d")
      expect(find('#talk_starts_at_time').value).to eq(Time.now.strftime "%H:%M")
    end
    it 'creates a new talk', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit new_talk_path

      fill_in :talk_title, with: 'spec talk title'
      fill_in :talk_teaser, with: 'spec talk teaser'
      # NOTE: Since the WYSIWYG editor is creating an iframe, we cannot fill in
      # the text with Capybara. jQuery to the rescue.
      page.execute_script('$("iframe").contents().find("body").text("iwannabelikeyou")')
      # fill in tags
      fill_in 's2id_autogen3', with: 'a,b,c,'
      fill_in 'talk_starts_at_date', with: '2014-04-29'
      fill_in 'talk_starts_at_time', with: '05:12'

      click_button 'Save'
      expect(page).to have_selector('.talks-show')
      expect(page).to have_content('spec talk title')
    end

    it 'shows validation errors', driver: :chrome do
      venue = FactoryGirl.create(:venue, user: @user)
      visit new_talk_path

      fill_in 'talk_starts_at_date', with: ''
      fill_in 'talk_starts_at_time', with: ''

      click_button 'Save'
      expect(page).to have_content(I18n.t(:invalid_date))
      expect(page).to have_content(I18n.t(:invalid_time))
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
        skip "Close to working, see comments"
        @venue = FactoryGirl.create :venue
        @talk = FactoryGirl.create :talk, venue: @venue
        visit venue_talk_path @venue, @talk
        find(".participate-button-box a").click
        find(".chat-input-box input").set("my message")
        find(".chat-input-box input").native.send_keys(:return)
        # This spec works until here. The message is never being shown in
        # testing mode, though. Faye published it, however. And of course it
        # works in development.
        within "#discussion" do
          expect(page).to have_content "my message"
          expect(find(".chat-message")).to be_visible
        end
      end
      it "it works with reload" do
        skip "fails on circleci" if ENV['CIRCLECI']
        @venue = FactoryGirl.create :venue
        @talk = FactoryGirl.create :talk, venue: @venue
        visit venue_talk_path @venue, @talk
        visit venue_talk_path @venue, @talk
        find(".chat-input-box input").set("my message")
        find(".chat-input-box input").native.send_keys(:return)
        visit(current_path)
        page.execute_script('$("a[href=#discussion]").click()')
        within "#discussion" do
          expect(page).to have_content "my message"
          expect(page).to have_content "01 Sep 10:05"
        end
      end
    end
  end

  describe "Active tab", js: true do
    it 'has no tab and contents in chat' do
      skip "really weird ActionController::RoutingError 3/4"
      @venue = FactoryGirl.create :venue
      @venue.options[:suppress_chat] = true
      @venue.save!
      @talk = FactoryGirl.create :talk, venue: @venue, tag_list: "test, foo, bar"
      visit venue_talk_path @venue, @talk
      expect(page.evaluate_script(
        '$("a[href=#discussion]").parent().hasClass("active")
          ')).not_to be(true)
      within ".tabs.vr-tabs" do
        expect(page).not_to have_css(".discussion")
      end
    end
    it 'shows chat active by default' do
      skip "really weird ActionController::RoutingError 4/4"
      @venue = FactoryGirl.create :venue
      @talk = FactoryGirl.create :talk, venue: @venue, tag_list: "test, foo, bar"
      visit venue_talk_path @venue, @talk
      expect(page.evaluate_script(
        '$("a[href=#discussion]").parent().hasClass("active")'
      )).to be(true)
    end
  end

  describe "Social Sharing" do
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
    it "can be shared to social networks and saves statistics", driver: :chrome do
      skip "T H I S   S P E C   F A I L S   O N   C I"
      expect(SocialShare.count).to eq(0)
      visit venue_talk_path 'en', @venue, @talk
      page.execute_script('$("#social_share .facebook").click()')
      sleep 0.2

      share_window = page.driver.browser.window_handles.last
      page.within_window share_window do
        expect(current_url).to match(/facebook.com/)
      end

      expect(SocialShare.count).to eq(1)
    end

    it 'has meta tags for google/fb/twitter' do
      visit venue_talk_path @venue, @talk
      # as of Capybara 2.0, <head> attributes cannot be found. resorting to
      # using a manual matcher.
      # google
      source = Nokogiri::HTML(page.source)
      expect(source.xpath("//meta[@name='description']")).not_to(be_empty)
      # fb
      expect(source.xpath("//meta[@property='og:title']")).not_to(be_empty)
      expect(source.xpath("//meta[@content='#{@talk.user.name}']")).not_to(be_empty)
      # twitter
      expect(source.xpath("//meta[@property='og:url']")).not_to(be_empty)
    end
  end

  describe 'related talk' do
    before do
      @talk = FactoryGirl.create(:talk)
    end
    it 'shows when set' do
      FactoryGirl.create(:talk, featured_talk: @talk)
      visit talk_path(@talk)
      expect(page).to have_css('.related-talk')
      expect(page).to have_content(I18n.t('talks.show.related_talk'))
    end

    it 'does not show when not set' do
      visit talk_path(@talk)
      expect(page).not_to have_css('.related-talk')
      expect(page).not_to have_content(I18n.t('talks.show.related_talk'))
    end

    it 'shows the next coming up talk if there is one' do
      @talk.venue.talks << FactoryGirl.create(:talk)
      visit talk_path(@talk)
      expect(page).to have_content(I18n.t('talks.show.next_talk'))
    end
  end

  describe "validation" do
    before do
      @venue = FactoryGirl.create :venue
      @talk = FactoryGirl.create :talk, venue: @venue, tag_list: "test, foo, bar"
    end

    # FIXME sometimes failing spec (BT see above)
    it "does not lose tags on failed validation", js: true do
      skip "T H I S   S P E C   F A I L S   F A I R L Y   R E G U L A R"
      visit edit_venue_talk_path 'en', @venue, @talk
      fill_in :talk_title, with: ""
      click_on I18n.t 'helpers.submit.submit'
      expect(page).to have_content "Please review the problems below"
      within '#s2id_talk_tag_list.tagList' do
        expect(page).to have_content "test"
        expect(page).to have_content "foo"
        expect(page).to have_content "bar"
      end
    end
  end
end
