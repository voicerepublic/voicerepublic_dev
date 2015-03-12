require 'rails_helper'

# it renders specs
describe 'UsersController' do
  describe 'renders' do
    describe 'without user' do
      it 'index on GET /users' do # index
        expect { visit '/users' }.to raise_error(ActionController::RoutingError)
      end
      it 'new on GET /users/new' do # new
        skip "Shouldn't this raise a routing error?"
        expect { visit '/users/new' }.to raise_error(ActionController::RoutingError)
      end
    end
    describe 'with user' do
      before do
        @user = FactoryGirl.create(:user)
      end
      it "show on GET /users/:id" do # show
        visit user_path(@user)
        expect(page).to have_selector(".users-show")
      end
      it "edit on GET /users/:id/edit" do # edit
        login_user @user
        visit edit_user_path(@user)
        expect(page).to have_selector(".users-edit")
      end
    end
  end
end

feature "Anonymous users", js: true do
  scenario "will be authenticated as guest user" do
    expect(User.count).to eq(0)
    talk = FactoryGirl.create(:talk)
    visit talk_path(talk)
    # one for the talks and one for the logged in user
    expect(User.count).to eq(2)
    # user names are generated with uuids to minimize collisions (chance is1 in
    # 17 billion)
    expect(User.last.name).to match(/.*-.*-.*-.*-.*/)
    expect(User.last.email).to match(/.*-.*-.*-.*-.*@example.com/)
  end
end

feature "User edits own profile", js: true do
  background do
    @user = FactoryGirl.create(:user, password: '123456',
                               password_confirmation: '123456')
    visit root_path
    page.click_link('Log In')
    page.fill_in 'user_email', with: @user.email
    page.fill_in 'user_password', with: '123456'
    page.find('.button-login').click
    page.click_link 'Edit Profile'
    expect(page).to have_css('#user_firstname')
  end

  scenario "setting a new password" do
    page.find("button[data-enable-fields*=change-password]").click
    sleep 0.1
    find('.user_password input').set '654321'
    find('.user_password_confirmation input').set '654321'

    page.click_button 'Save'
    expect(page).not_to have_css('.error')
    expect(page).not_to have_css('.edit_user')
    expect(page).not_to have_content(I18n.t('simple_form.error_notification.default_notification'))
    expect(page).to have_content(I18n.t('flash.actions.update.notice'))
  end

  scenario "uploading a avatar image" do
    some_image = Rails.root.join('app/assets/images/logo.png')
    expect(@user.reload.avatar_uid).to be_nil
    make_upload_field_visible('user_avatar')
    page.attach_file 'user_avatar', some_image
    page.click_button 'Save'
    expect(page).to have_content(I18n.t('flash.actions.update.notice'))
    expect(@user.reload.avatar_uid).to match(/logo/)
  end
end


feature "User visits another user" do
  background do
    @user = FactoryGirl.create(:user)
    #@klu = FactoryGirl.create(:published_kluuu, :user => @user)
  end

  scenario "user visits user-page" do
    visit user_path(:id => @user)
    expect(page).to have_content(@user.name)
  end

end

feature "Password" do
  describe "Reset" do
    scenario "User email is validated" do
      click_forgot_password
      fill_in :user_email, with: 'not an email'
      click_on "Reset password"
      expect(page).to have_content "not found"
    end

    scenario "sends email and validates new password" do
      user = FactoryGirl.create(:user)
      click_forgot_password
      fill_in :user_email, with: user.email
      click_on "Reset password"
      expect(current_path).to eq('/users/sign_in')
      expect(page).to have_content("You will receive an email with instructions about how to reset your password in a few minutes.")
      expect(last_email.to).to include(user.email)
      token = extract_token_from_email(:reset_password) # Here I call the MailHelper form above
      visit edit_user_password_url(reset_password_token: token)
      fill_in "user_password", :with => "foobar"
      click_on "Save"
      fill_in "user_password_confirmation", :with => "foobar1"
      expect(page).to have_content "Password confirmation doesn't match Password"
      fill_in "user_password", :with => "foobar"
      fill_in "user_password_confirmation", :with => "foobar"
      click_on "Save"
      expect(page).to have_content "Your password was changed successfully. You are now signed in."
    end
  end
end

feature "User can register" do
  describe "Welcome page on UserProfile" do
    before do
      @user = FactoryGirl.create(:user)
    end
    describe "New User" do
      scenario "Sees a welcome page" do
        login_user(@user)
        expect(page).to have_content("Welcome")
        expect(page).to have_content("Thank you for signing up")
        expect(page).to have_content("Create your first Talk")
      end
    end
    describe "User already has talks" do
      scenario "Does not see a welcome page" do
        t = FactoryGirl.create :talk
        t.venue.update_attribute :user, @user
        login_user(@user)
        expect(page).not_to have_content("Welcome")
        expect(page).not_to have_content("Thank you for signing up")
        expect(page).not_to have_content("Create your first Talk")
      end
    end
  end
  describe "Facebook" do
    scenario 'user registers with facebook' do
      expect(User.count).to eq(0)
      mock_oauth :facebook
      visit root_path
      page.click_link 'Sign Up'
      page.click_link 'REGISTER WITH FACEBOOK'
      expect(page).to have_content "Successfully authenticated from Facebook account"
      expect(User.where(guest: nil).count).to eq(1)
      expect(User.last.email).not_to be_nil
    end

    scenario 'user logs in with facebook' do
      FactoryGirl.create :user, uid: '123123123', provider: 'facebook', email: 'foo@example.com'
      expect(User.where(guest: nil).count).to eq(1)
      mock_oauth :facebook
      visit root_path
      page.click_link 'Sign Up'
      page.click_link 'REGISTER WITH FACEBOOK'
      expect(page).to have_content "Successfully authenticated from Facebook account"
      # User count did not increase => logged in with the same account
      expect(User.where(guest: nil).count).to eq(1)
    end
  end
  scenario "user supplies correct values" do
    visit root_path
    page.click_link('Sign Up')
    page.fill_in('user_firstname', :with => "Jim")
    page.fill_in('user_lastname', :with => "Beam")
    page.fill_in('user_email', :with => "jim@beam.com")
    page.fill_in('user_password', :with => "foobar")
    page.fill_in('user_password_confirmation', :with => "foobar")
    page.check('user_accept_terms_of_use')
    page.find('.button-signup').click
    expect(current_url).to include('/onboard')
  end

  scenario "Validations" do
    visit root_path
    page.click_link('Sign Up')
    page.fill_in('user_firstname', :with => "Jim")
    page.fill_in('user_lastname', :with => "Beam")
    page.find('.button-signup').click
    within(".input.email.error") do
      expect(page).to have_content("can't be blank")
    end
    expect(page).to have_content "I accept the Terms of Use"
  end

end

private
def click_forgot_password
  visit root_path
  page.click_link('Sign Up')
  click_on "Forgot password?"
end

# This is a workaround since we are using a button that will trigger a file
# input box while the normal <input type=file> is hidden. Therefore this is
# not a completely safe spec; if the button JS fails, this spec will still
# run.
def make_upload_field_visible(element)
  page.execute_script "$('##{element}').parents().show()"
  sleep 0.1
end
