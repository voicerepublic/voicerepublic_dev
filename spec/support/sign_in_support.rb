#module for helping controller specs
#module ValidUserHelper
#  def signed_in_as_a_valid_user
#    @user ||= FactoryGirl.create :user
#    sign_in @user # method from devise:TestHelpers
#  end
#end

# module for helping request specs

require 'capybara/rails'

module ValidUserRequestHelper
  
  def login_user(user)
    visit new_user_session_path()
    save_and_open_page
    page.fill_in('user_email', :with => user.email)
    page.fill_in('user_password', :with => user.password)
    page.click_button('Log In')
  end
end

#RSpec.configure do |config|
  ##config.include ValidUserHelper, :type => :controller
  #config.include ValidUserRequestHelper, :type => :request
#end
