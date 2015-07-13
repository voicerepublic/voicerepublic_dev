require 'rails_helper'

describe 'Support' do
  it 'renders the api page' do
    visit '/support/api'
    expect(page).to have_content('REST')
    expect(page).to have_content('endpoint')
    expect(page).to have_content('example')
    expect(page).to have_content('response')
  end
end
