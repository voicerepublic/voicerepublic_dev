require 'spec_helper'

describe FayeproxyController do

  describe "GET 'publish'" do
    it "returns http success" do
      VCR.use_cassette "faye_connectivity_test" do
        get 'publish'
        response.should be_success
      end
    end
  end

end
