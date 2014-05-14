require 'spec_helper'

describe LandingPageController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns http success with format rss" do
      get 'index', format: 'rss'
      response.should be_success
    end
  end
  
end
