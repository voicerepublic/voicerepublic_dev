require 'spec_helper'

describe PurchasesController do

  describe "GET 'express'" do
    it "returns http success" do
      pending unless Settings.payment_enabled
      get 'express'
      response.should be_redirect
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      pending unless Settings.payment_enabled
      get 'new'
      response.should be_success
    end
  end

  # TODO
  describe "GET 'create'" do
    pending "returns http success" do
      post 'create', purchase: { quantity: 1, token: 'ASDF' }
      response.should be_success
    end
  end

end
