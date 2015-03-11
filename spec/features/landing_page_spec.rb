require 'spec_helper'

describe 'LandingPageController' do
  describe 'renders' do
    it 'index on GET /' do # index
      visit root_path
      expect(page).to have_selector(".landing_page-index")
    end
    it 'new on GET /talks/new' do # new
      expect { visit '/landing_page/new' }.to raise_error(ActionController::RoutingError)
    end
  end
end

