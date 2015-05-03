# coding: utf-8
require 'rails_helper'

feature "General payment" do

  describe "Purchases#index" do
    it 'should require a login on purchase', js: true do
      visit '/purchases'
      click_on('Save')
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

    scenario 'purchase more credits accessible from profile' do
      visit user_path @user
      click_on 'Purchase more credits'
      expect(current_path).to eq(purchases_path)
    end

    scenario "user gets redirected when low on credits" do
      @user.reload.update_attribute :credits, 0
      visit user_path @user
      click_on "Create new Talk"
      expect(current_path).to eq(purchases_path)
    end

  end
end
