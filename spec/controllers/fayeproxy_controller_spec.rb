require 'spec_helper'

describe FayeproxyController do

  describe "GET 'publish'" do
    it "returns http success" do
      get 'publish'
      response.should be_success
    end
  end

end
