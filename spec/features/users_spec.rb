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

  scenario "setting a new password" do
    pending 'capybara click does not work here'
    #page.find('#set_new_password').click
    page.execute_script "$('#change-password').toggle()"
    page.fill_in 'user_password', with: '654321'
    page.fill_in 'user_password_confirmation', with: '654321'
    page.click_button 'Save'
    page.should_not have_css('.edit_user')
  end

  scenario "uploading a header image" do
    some_image = Rails.root.join('app/assets/images/logo.png')
    page.attach_file 'user_header', some_image
    page.click_button 'Save'
    page.should have_content('User was successfully updated.')
  end

  scenario "uploading a avatar image" do
    pending 'activate spec when upload-avater branch is merged'
    some_image = Rails.root.join('app/assets/images/logo.png')
    page.attach_file 'user_avatar', some_image
    page.click_button 'Save'
    page.should have_content('User was successfully updated.')
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
