require 'spec_helper'

feature "Search validation" do
  background do
    visit root_path
  end

  scenario "it should set an error on empty search input", driver: :chrome, slow: true do
    page.fill_in 'query', with: ''
    find("#query").native.send_keys(:return)
    page.should have_css('.warning')

    page.fill_in 'query', with: 'search key'
    page.should_not have_css('.warning')
  end
end

# user agents taken from: http://www.useragentstring.com/
feature "Browser detection" do
  describe "supported browsers" do

    scenario "ie10" do
      user_agent = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"
      page.driver.browser.header('User-Agent', user_agent)
      visit root_path
      current_path.should == root_path
    end

  end

  describe "unsupported browsers" do

    scenario "ie9" do
      user_agent = "Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US))"
      page.driver.browser.header('User-Agent', user_agent)
      visit root_path
      current_path.should_not == root_path
    end

  end
end
