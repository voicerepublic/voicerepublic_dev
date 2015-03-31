require 'rails_helper'

describe StaticPagesController do

  describe "GET 'pricing'" do
    it "returns http success" do
      get 'pricing'
      expect(response).to be_success
    end
  end

end
