require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :publish
      expect(response).to have_http_status(:success)
    end
  end

end
