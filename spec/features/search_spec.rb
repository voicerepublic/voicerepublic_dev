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
    #visit root_path # sometimes fails here on CI
    Thread.current["PgSearch.enable_multisearch"] = true
  end

  after do
    Thread.current["PgSearch.enable_multisearch"] = false
  end

  describe "Search#show" do
    scenario "unknown search term" do
      skip "FIXME with nick or alain"
      find("#search-loupe").click
      page.fill_in 'search-field', with: 'unknown search term'
      expect(page).to have_content(I18n.t("search.show.no_results"))
    end
    scenario "shows number of results" do
      skip "FIXME with nick or alain"
      FactoryGirl.create :talk, title: "known search term"

      find("#search-loupe").click
      page.fill_in 'search-field', with: 'unknown search term'
      puts find("#search-field")
      puts find("#search-field").native
      find("#search-field").native.send_keys(:return)

      expect(page).to have_content("SORRY, NO RESULTS FOR")
      find("#search-loupe").click
      page.fill_in 'search-field', with: 'known search term'
      expect(page).to have_content("1 RESULT FOR \"known search term\"")
    end
  end

  describe "Search validation" do
    scenario "it should set an error on empty search input", driver: :chrome do
      skip "FIXME with nick or alain"
      page.fill_in 'search-field', with: ''
      find("#search-field").native.send_keys(:return)
      expect(page).to have_css('.warning')

      page.fill_in 'search-field', with: 'search key'
      expect(page).not_to have_css('.warning')

      page.fill_in 'search-field', with: ''
      find(".icon-magnifying-glass").click
      expect(page).to have_css('.warning')
    end

    scenario "it searches with magnifying glass" do
      skip "FIXME with nick or alain"
      FactoryGirl.create :talk, title: "test title talk"
      page.fill_in 'search-field', with: 'test talk'
      find(".search-loupe").click
      expect(page).to have_content "TEST TITLE TALK"
    end

    scenario "it searches when hitting enter", driver: :chrome  do
      skip "FIXME with nick or alain"
      FactoryGirl.create :talk, title: "test title talk"
      page.fill_in 'search-field', with: 'test talk'
      find("#search-field").native.send_keys(:return)
      expect(page).to have_content "TEST TITLE TALK"
    end
  end
end
