require 'spec_helper'

feature "User edits own profile" do
  background do
    @user = FactoryGirl.create(:user, password: '123456',
                               password_confirmation: '123456')
    visit root_path
    page.fill_in 'user_login', with: @user.email
    page.fill_in 'user_password', with: '123456'
    page.click_button 'Log In'
    page.should have_content('Edit Account')
    page.click_link 'Edit Account'
    page.should have_css('.edit_user')
  end

  scenario "setting a new password", js: :true do
    page.find("button[data-enable-fields*=change-password]").click
    find('.user_password input').set '654321'
    find('.user_password_confirmation input').set '654321'

    page.click_button 'Save'
    page.should_not have_css('.error')
    page.should_not have_css('.edit_user')
    page.should_not have_content(I18n.t('simple_form.error_notification.default_notification'))
    page.should have_content(I18n.t('flash.actions.update.notice'))
  end

  scenario "uploading a header image" do
    some_image = Rails.root.join('app/assets/images/logo.png')
    page.attach_file 'user_header', some_image
    page.click_button 'Save'
    page.should have_content(I18n.t('flash.actions.update.notice'))
  end

  scenario "uploading a avatar image", js: true do
    some_image = Rails.root.join('app/assets/images/logo.png')
    @user.reload.avatar_uid.should be_nil
    # This is a workaround since we are using a button that will trigger a file
    # input box while the normal <input type=file> is hidden. Therefore this is
    # not a completely safe spec; if the button JS fails, this spec will still
    # run.
    page.execute_script "$('#user_avatar').parents().show()"
    sleep 0.1
    page.attach_file 'user_avatar', some_image
    page.click_button 'Save'
    page.should have_content(I18n.t('flash.actions.update.notice'))
    @user.reload.avatar_uid.should match(/logo/)
  end
end


feature "User visits another user" do
  background do
    @user = FactoryGirl.create(:user)
    #@klu = FactoryGirl.create(:published_kluuu, :user => @user)
  end

  scenario "user visits user-page" do
    visit user_path(:id => @user)
    page.should have_content(@user.name)
  end

end

feature "User can register" do
  scenario "user supplies correct values" do
    visit root_path()
    page.fill_in('user_firstname', :with => "Jim")
    page.fill_in('user_lastname', :with => "Beam")
    page.fill_in('user_email', :with => "jim@beam.com")
    page.click_button('Sign Up to KluuU!')
    page.should have_css(".signup")
    page.fill_in('user_password', :with => "foobar")
    page.fill_in('user_password_confirmation', :with => "foobar")
    page.check('user_accept_terms_of_use')
    page.click_button('Sign Up')
    # FIXME
    page.should_not have_css("#error_explanation")
    #page.should have_css(".user-container")
    #page.should have_css(".venue-new")
  end

  scenario "User misses email during registration" do
    visit root_path()
    page.fill_in('user_firstname', :with => "Jim")
    page.fill_in('user_lastname', :with => "Beam")
    page.click_button('Sign Up to KluuU!')
    page.click_button('Sign Up')
    page.should have_content("Email can't")
  end
end

feature "User gets notifications via push" do

  before :each do
    @user = FactoryGirl.create(:user)
    #_klus = FactoryGirl.create(:published_no_kluuu, :user => @user)
  end


  # scenario "User sees number of notifications in actionbar - with css-id 'alerts-count-'" do
  #   login_user(@user)
  #   visit dashboard_path()
  #   page.should have_xpath("//*[@id='alerts-count-#{@user.id}']")
  # end
  #
  # scenario "User with alert-notifications has a dropdown-list with latest notifications" do
  #   login_user(@user)
  #   FactoryGirl.create_list(:notification_new_comment, 2, :user => @user)
  #   visit dashboard_path()
  #   page.should have_xpath("//*[@id='actionbar-notifications-#{@user.id}']")
  #   page.should have_xpath("//*[@id='actionbar-notifications-#{@user.id}']/li")
  # end

end

feature "there is a link to participation venues, host venues and create-venue-link'" do

  # FIXME
  scenario "there is a link to users venues visible on his profile" do
    include Rails.application.routes.url_helpers
    venue = FactoryGirl.create(:venue)
    visit user_path(:id => venue.user.id)
    #page.should have_link('Participants')
    #page.should have_link('Host')
  end

end
