require 'rails_helper'

describe 'PricingPage' do
  it 'renders' do
  	visit root_path
  	within 'footer' do
  		click_on 'Pricing'
  	end
    expect(page).to have_content ("Enterprise")
  end
end
