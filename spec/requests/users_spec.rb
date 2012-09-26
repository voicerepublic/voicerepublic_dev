require 'spec_helper'



feature "User visits another user" do
  background do
    @user = FactoryGirl.create(:user)
  end
  
  scenario "user visits user-page" do
    visit user_path(:id => @user)
    page.should have_content(@user.name)
  end
  
end


feature "User can register" do
  scenario "user supplies correct values" do
    visit root_path()
    click_link("Sign Up")
    page.fill_in('user_firstname', :with => "Jim")
    page.fill_in('user_lastname', :with => "Beam")
    page.fill_in('user_email', :with => "jim@beam.com")
    page.fill_in('user_password', :with => "foobar")
    page.fill_in('user_password_confirmation', :with => "foobar")
    page.click_button('Sign up!')
    page.should have_content("Success")
  end
  
  scenario "User misses email during registration" do
    visit root_path()
    click_link('Sign Up')
    page.fill_in('user_firstname', :with => "Jim")
    page.fill_in('user_lastname', :with => "Beam")
    page.fill_in('user_password', :with => "foobar")
    page.fill_in('user_password_confirmation', :with => "foobar")
    page.click_button('Sign up!')
    page.should have_content("Email can't")
  end
end
