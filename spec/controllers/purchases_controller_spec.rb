require 'rails_helper'

describe PurchasesController do

  describe "GET 'express'" do
    it "returns http success" do
      pending unless Settings.payment_enabled
      get 'express'
      expect(response).to be_redirect
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      pending unless Settings.payment_enabled
      get 'new'
      expect(response).to be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      post 'create', purchase: { quantity: 1, token: 'ASDF' }
      expect(response).to be_success
    end
  end

end
