require 'rails_helper'

describe LandingPageController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it "returns http success with format rss" do
      get 'index', format: 'rss'
      expect(response).to be_success
    end
  end
  
end
