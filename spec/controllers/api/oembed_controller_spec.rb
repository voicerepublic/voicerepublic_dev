require 'rails_helper'

RSpec.describe Api::OembedController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      talk = FactoryGirl.create(:talk)
      get :show, format: 'json', url: 'http://test.host/talks/' + talk.slug
      expect(response).to have_http_status(:success)
    end

    it "returns http failure" do
      talk = FactoryGirl.create(:talk)
      get :show, format: 'json', url: 'http://test.host/talk/' + talk.slug
      expect(response).to have_http_status(501)
    end

    it "returns http failure" do
      get :show, format: 'json', url: 'http://test.host/talks/123'
      expect(response).to have_http_status(:not_found)
    end

    it "returns http failure" do
      talk = FactoryGirl.create(:talk)
      get :show, format: 'xml', url: 'http://test.host/talks/' + talk.slug
      expect(response).to have_http_status(501)
    end
end

end
