require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      page = FactoryGirl.create(:page)
      get :show, id: page.to_param
      expect(response).to have_http_status(:success)
    end
  end

end
