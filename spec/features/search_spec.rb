require 'rails_helper'

# it-renders-specs
describe 'SearchController' do
  it 'it renders show on GET /search/:page/*query' do # show
    visit '/search/1/asdf'
    expect(page).to have_selector('.search-show')
  end
end

feature "Search", js: true do
  before do
    visit root_path
    Thread.current["PgSearch.enable_multisearch"] = true
  end

  after do
    Thread.current["PgSearch.enable_multisearch"] = false
  end

  describe "Search#show" do
    scenario "unknown search term" do
      page.fill_in 'query', with: 'unknown search term'
      find(".search-lupe").click
      expect(page).to have_content(I18n.t("search.show.no_results"))
    end
    scenario "shows number of results" do
      FactoryGirl.create :talk, title: "known search term"
      page.fill_in 'query', with: 'unknown search term'
      find(".search-lupe").click
      expect(page).to have_content("SORRY, NO RESULTS FOR")
      page.fill_in 'query', with: 'known search term'
      find(".search-lupe").click
      expect(page).to have_content("1 RESULT FOR \"known search term\"")
    end
  end

  describe "Search validation" do
    scenario "it should set an error on empty search input", driver: :chrome do
      page.fill_in 'query', with: ''
      find("#query").native.send_keys(:return)
      expect(page).to have_css('.warning')

      page.fill_in 'query', with: 'search key'
      expect(page).not_to have_css('.warning')

      page.fill_in 'query', with: ''
      find(".icon-magnifying-glass").click
      expect(page).to have_css('.warning')
    end

    scenario "it searches with magnifying glass" do
      FactoryGirl.create :talk, title: "test title talk"
      page.fill_in 'query', with: 'test talk'
      find(".search-lupe").click
      expect(page).to have_content "TEST TITLE TALK"
    end

    scenario "it searches when hitting enter", driver: :chrome  do
      FactoryGirl.create :talk, title: "test title talk"
      page.fill_in 'query', with: 'test talk'
      find("#query").native.send_keys(:return)
      expect(page).to have_content "TEST TITLE TALK"
    end
  end
end
