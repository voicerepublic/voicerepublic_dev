require 'rails_helper'

describe UsersController do

  before do
    @user = FactoryGirl.create(:user)
    allow(request.env['warden']).to receive_messages :authenticate! => @user
    allow(controller).to receive_messages :current_user => @user
  end

  describe "GET show" do
    let(:user) { FactoryGirl.create(:user) }
    it "assigns the requested user as @user" do
      get :show, {:id => user.to_param}
      expect(assigns(:user)).to eq(user)
    end

    it "returns http success with format rss" do
      get :show, id: user.to_param, format: 'rss'
      expect(response).to be_success
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        expect(@user.reload.firstname).to eq('Hugo')
      end

      it "assigns the requested user as @user" do
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to the user" do
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        expect(response).to redirect_to(user_url(id: @user))
      end
    end

    describe "with invalid params"  do
      it "assigns the user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(User).to receive(:save).and_return(false)
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        expect(assigns(:user)).to eq(@user)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(User).to receive(:save).and_return(false)
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        expect(response).to render_template("edit")
      end
    end
  end



end
