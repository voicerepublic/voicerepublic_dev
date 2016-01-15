require 'rails_helper'

describe 'PricingPage' do
  it 'renders' do
    visit purchases_path
    expect(page).to have_content("Talk Credit Packages")
  end
end
