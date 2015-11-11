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

  # FIXME fix those after redesign of explore page
  # describe "visiting talks#index" do
  #   it 'displays talks overview' do
  #     visit talks_path
  #     expect(page).to have_selector('.see-all-link')
  #     expect(page).to have_content('Explore')
  #   end
  #
  #   it 'has "more" and displays 25 talks a time on recent' do
  #     FactoryGirl.create_list(:talk, 26, :archived, :featured)
  #     visit talks_path
  #     within(".recent") do
  #       click_on "MORE"
  #     end
  #     expect(current_path).to match(/explore\/recent/)
  #     expect(page).to have_selector('.talk-medium-box', count: 25)
  #     expect(page).to have_selector('.pagination')
  #     within(".pagination") do
  #       expect(page).to have_link('2')
  #       expect(page).not_to have_link('3')
  #     end
  #   end
  # end

end
