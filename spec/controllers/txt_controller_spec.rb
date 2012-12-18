require 'spec_helper'

describe TxtController do

  describe "GET 'agb'" do
    it "returns http success" do
      get 'agb'
      response.should be_success
    end
  end

  describe "GET 'tou'" do
    it "returns http success" do
      get 'tou'
      response.should be_success
    end
  end

end
