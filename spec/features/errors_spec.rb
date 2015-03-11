require 'spec_helper'

# it renders specs
describe 'ErrorsController' do
  it 'it renders show on GET /403' do # show
    visit '/403'
    expect(page).to have_selector('.errors-show')
    expect(page).to have_content(I18n.t('exceptions.403_header'))
  end

  it 'it renders show on GET /404' do # show
    visit '/404'
    expect(page).to have_selector('.errors-show')
    expect(page).to have_content(I18n.t('exceptions.404_header'))
  end

  it 'it renders show on GET /500' do # show
    visit '/500'
    expect(page).to have_selector('.errors-show')
    expect(page).to have_content(I18n.t('exceptions.500_header'))
  end
end

