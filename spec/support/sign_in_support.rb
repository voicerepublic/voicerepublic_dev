# module for helping request specs
require 'capybara/rails'

module ValidUserRequestHelper

  def login_user(user)
    visit new_user_session_path()
    page.fill_in('user_email', :with => user.email)
    page.fill_in('user_password', :with => user.password)
    page.find('.button-login').click
  end

  def click_to_signin
    within('.top-bar') { click_link('Sign In') }
  end

  def click_to_signup
    within('.top-bar') { click_link('Join For Free') }
  end

  def click_forgot_password
    visit root_path
    within('.top-bar') { click_link('Sign In') }
    click_on "Forgot password?"
  end

end
