require 'rails_helper'

# it renders specs
describe 'ErrorsController' do
  it 'it renders show on GET /403' do # show
    visit '/403'
    expect(page).to have_selector('.error')
  end

  it 'it renders show on GET /404' do # show
    # the 404 renders the first promoted talk,
    # so here we have to make sure there is one
    FactoryGirl.create(:talk, :archived, :featured)
    visit '/404'
    expect(page).to have_selector('.error')
  end

  it 'it renders show on GET /500' do # show
    visit '/500'
    expect(page).to have_selector('.error')
  end
end
