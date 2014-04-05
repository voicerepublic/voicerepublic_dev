require 'spec_helper'

feature "General feature specs" do
  describe "Search validation" do
    background do
      visit root_path
    end

    scenario "it should set an error on empty search input", driver: :chrome, slow: true do
      page.fill_in 'query', with: ''
      find("#query").native.send_keys(:return)
      page.should have_css('.warning')

      page.fill_in 'query', with: 'search key'
      page.should_not have_css('.warning')

      page.fill_in 'query', with: ''
      find(".icon-magnifying-glass").click
      page.should have_css('.warning')
    end
  end
end
