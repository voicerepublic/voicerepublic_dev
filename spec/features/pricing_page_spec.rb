require 'spec_helper'

describe 'PrisingPage' do
  it 'renders' do
  	visit root_path
  	within 'footer' do
  		click_on 'Pricing'
  	end
    expect(page).to have_content ("Conferences")
  end
end

