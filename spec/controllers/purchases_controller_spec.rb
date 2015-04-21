require 'rails_helper'

describe PurchasesController do

  describe 'logged in' do

    before do
      @user = FactoryGirl.create(:user)
      allow(request.env['warden']).to receive_messages :authenticate! => @user
      allow(controller).to receive_messages :current_user => @user
    end

    describe "GET 'express'" do
      it "returns http success" do
        pending unless Settings.payment_enabled
        get 'express', purchase: { product: 'B5' }
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
        pending unless Settings.payment_enabled
        post 'create', purchase: { product: 'B5', token: 'ASDF' }
        expect(response).to be_a_redirect
      end
    end

  end

end
