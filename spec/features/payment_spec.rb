require 'rails_helper'

feature "General payment" do

  describe "Purchases#index" do
    it 'should require a login on purchase', js: true do
      visit '/purchases'
      #page.execute_script "$('img alt=[xpresscheckout]').parent().click()"
      find('.new_purchase', match: :first).click
      expect(current_path).to eq('/users/sign_in')
    end
  end

  describe "Logged in user" do
    background do
      @user = FactoryGirl.create(:user, password: '123456',
                                 password_confirmation: '123456')
      visit root_path
      page.click_link('Log In')
      page.fill_in 'user_email', with: @user.email
      page.fill_in 'user_password', with: '123456'
      page.find('.button-login').click
    end

  end
end
