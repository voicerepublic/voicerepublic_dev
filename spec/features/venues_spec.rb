require 'rails_helper'

# it renders specs
describe 'VenuesController' do
  describe 'it renders' do
    describe 'without venue' do
      it 'new on GET /venues/new' do # new
        login_user FactoryGirl.create(:user)
        visit new_venue_path
        expect(page).to have_selector(".venues-new")
      end
    end
    describe 'with venue' do
      before do
        @user = FactoryGirl.create(:user)
        @venue = FactoryGirl.create(:venue, user: @user)
      end
      it "show on GET /venues/:id" do # show
        login_user @user
        visit venue_path(id: @venue)
        expect(page).to have_selector(".venues-show")
      end
      it "edit on GET /venues/:id/edit" do # edit
        login_user(@user)
        visit edit_venue_path(id: @venue)
        expect(page).to have_selector(".venues-edit")
      end
    end
  end
end

# feature is in fact just an alias for describe ..., :type =>
# :feature, background is an alias for before, scenario for it, and
# given/given! aliases for let/let!, respectively.
#
describe "Venues", js: true do

  describe "As registered user" do
    before do
      @user = FactoryGirl.create(:user)
      login_user(@user)
    end

    describe "Participate" do
      it 'lets registered users participate' do
        user2 = FactoryGirl.create(:user)
        venue = FactoryGirl.create(:venue, user: user2)
        expect(Participation.count).to eq(0)
        visit venue_path(venue)
        # Click "Subscribe" button
        find("a[data-method=post]").click
        expect(current_url).to match(/#{venue_path(venue)}/)
        expect(Participation.count).to eq(1)
      end
    end

    describe "GET a specific venue" do
      before do
        @venue = FactoryGirl.create(:venue, user: @user)
      end

      it "updates title" do
        skip RSpec::SOMETIMES
        visit edit_venue_path(id: @venue)
        expect(page).to have_selector(".venues-edit")
        fill_in 'venue_title', with: new_title = "A completely new title"
        click_button 'Save'
        expect(page).to have_content(new_title)
      end

      describe "Sharing" do
        it "can be shared via email" do
          visit venue_path(id: @venue)
          within("#social_share .mail") do
            expect(page).to have_link("")
            pat = /#{ERB::Util.url_encode(I18n.t('social_share.mail_body'))}/
              expect(find('a')['href']).to match(pat)
          end
        end

        it 'has meta tags for google/fb/twitter' do
          visit venue_path @venue
          # as of Capybara 2.0, <head> attributes cannot be found. resorting to
          # using a manual matcher.
          # google
          source = Nokogiri::HTML(page.source)
          expect(source.xpath("//meta[@name='description']")).not_to(be_empty)
          # fb
          expect(source.xpath("//meta[@property='og:title']")).not_to(be_empty)
          expect(source.xpath("//meta[@content='#{@venue.user.name}']")).not_to(be_empty)
          # twitter
          expect(source.xpath("//meta[@property='og:url']")).not_to(be_empty)
        end

        it "can be shared to social networks and saves statistics",
          driver: :chrome, slow: true do
          skip 'omit on ci' if ENV['CI']

          expect(SocialShare.count).to eq(0)
          visit venue_path(id: @venue)
          page.execute_script('$("#social_share .facebook").click()')
          sleep 0.2

          share_window = page.driver.browser.window_handles.last
          page.within_window share_window do
            expect(current_url).to match(/facebook.com/)
          end

          expect(SocialShare.count).to eq(1)
          end
      end
    end

    describe "POST a new venue" do
      it 'creates a venue', driver: :chrome do
        visit new_venue_path
        fill_in 'venue_title', with: 'schubidubi'
        fill_in 'venue_teaser', with: 'some teaser'
        fill_in 'venue_description', with: 'iwannabelikeyou'

        click_button 'Save'
        expect(page).to have_selector('.venues-show')
        expect(page).to have_content('schubidubi')
        expect(page).to have_content('iwannabelikeyou')
      end
    end

    describe "PATCH an existing venue" do
      it 'uploads an image and displays it', driver: :chrome do
        skip 'fails on circleci' if ENV['CIRCLECI']

        venue = FactoryGirl.create(:venue, user: @user)
        visit venue_path(id: venue.id)
        expect(find('.image')['src']).to include('venue-image.jpg')
        find('.title-edit').click
        # NOTE: This is not a perfect test, because it's exposing the real input
        # field while the app itself uses a Foundation button. Couldn't get it to
        # work using the button, though.
        page.execute_script('$("input#venue_image").show().removeClass("display-none")')
        attach_file :venue_image, Rails.root.join('spec/support/fixtures/dummy.png')
        click_button 'Save'
        expect(find('.image')['src']).not_to include('venue-image.jpg')
      end
    end

    # TEMPORARELY THERE ARE NO COMMENTS
    # describe "Comments" do
    #   it 'has an active comments tab after writing a comment', driver: :chrome do
    #     venue = FactoryGirl.create(:venue, user: @user)
    #     visit venue_path(id: venue.id)
    #     find("span.icon-bubble-multi").click
    #     fill_in 'comment_content', with: 'spec comment'
    #     click_button 'Post'
    #     find("#comments.active").should_not be_nil
    #   end
    # end

  end

end
