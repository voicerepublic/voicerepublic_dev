require 'rails_helper'

# it renders specs
describe 'ExploreController' do
  describe 'renders' do
    it 'index on GET /explore' do # index
      visit '/explore'
      expect(page).to have_selector(".explore-index")
    end
    it 'index on GET /explore/featured' do # featured
      visit '/explore/featured'
      expect(page).to have_selector(".explore-featured")
    end
    it 'index on GET /explore/popular' do # popular
      visit '/explore/popular'
      expect(page).to have_selector(".explore-popular")
    end
    it 'index on GET /explore/upcoming' do # upcoming
      visit '/explore/upcoming'
      expect(page).to have_selector(".explore-upcoming")
    end
    it 'index on GET /explore/live' do # live
      visit '/explore/live'
      expect(page).to have_selector(".explore-live")
    end
    it 'index on GET /explore/recent' do # recent
      visit '/explore/recent'
      expect(page).to have_selector(".explore-recent")
    end
  end
end
