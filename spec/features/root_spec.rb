require 'rails_helper'

describe 'RootController' do
  describe 'renders' do
    it 'index on GET /' do # index
      visit root_path
      expect(page).to have_selector(".root")
      expect(page).to have_selector(".root-index")
    end
    it 'GET /root/new' do # new
      expect { visit '/root/new' }.to raise_error(ActionController::RoutingError)
    end
  end
end
