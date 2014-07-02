require 'spec_helper'

# it renders specs
describe 'ErrorsController' do
  it 'it renders show on GET /403' do # show
    visit '/403'
    page.should have_selector('.errors-show')
    page.should have_content(I18n.t('exceptions.403_header'))
  end

  it 'it renders show on GET /404' do # show
    visit '/404'
    page.should have_selector('.errors-show')
    page.should have_content(I18n.t('exceptions.404_header'))
  end

  it 'it renders show on GET /500' do # show
    visit '/500'
    page.should have_selector('.errors-show')
    page.should have_content(I18n.t('exceptions.500_header'))
  end
end

