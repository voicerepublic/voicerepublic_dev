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

    scenario 'purchase more credits', driver: :chrome, slow: true do
      # Paypal is slow, therefore enhance the default waiting time
      default_wait_time = Capybara.default_wait_time
      Capybara.default_wait_time = 10

      # For a real acceptance test, do not use a bogus or test gateway, but the
      # real thing
      active_merchant_gateway = ActiveMerchant.express_gateway
      options = Settings.paypal.to_hash
      ActiveMerchant.express_gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(options)

      visit purchases_path
      click_on('Save')
      page.should have_content("€150.00")
      fill_in "username", with: "billing-buyer@voicerepublic.com"
      fill_in "password", with: "sandburg"
      click_on "Log In to PayPal"

      # Wait until the Login modal disappears
      expect(page).to have_no_css("#spinner", visible: true)

      page.should have_content("€150.00")
      click_on("Continue", match: :first)

      page.should have_content "Please confirm to buy 5 VR talk credits for the price of EUR150.00"
      click_on "Complete your purchase"
      page.should have_content "Thank You for Your purchase"
      expect(current_path).to eq(purchase_path(Purchase.last))

      # Set back the configured defaults for Capybara and ActiveMerchant
      Capybara.default_wait_time = default_wait_time
      ActiveMerchant.express_gateway = active_merchant_gateway
    end

    scenario "user gets redirected when low on credits" do
      @user.reload.update_attribute :credits, 0
      visit user_path @user
      click_on "Create new Talk"
      expect(current_path).to eq(purchases_path)
    end

  end
end
