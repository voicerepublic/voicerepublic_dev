# module for helping request specs
require 'capybara/rails'

module ValidUserRequestHelper

  def login_user(user)
    visit new_user_session_path()
    page.fill_in('user_email', :with => user.email)
    page.fill_in('user_password', :with => user.password)
    page.find('.button-login').click
  end

end
