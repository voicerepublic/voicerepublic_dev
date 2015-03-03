require 'spec_helper'

describe UsersController do

  before do
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
  end

  describe "GET show" do
    let(:user) { FactoryGirl.create(:user) }
    it "assigns the requested user as @user" do
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
    end

    it "returns http success with format rss" do
      get :show, id: user.to_param, format: 'rss'
      response.should be_success
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
        assigns(:user).should eq(@user)
      end

      it "redirects to the user" do
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        response.should redirect_to(user_url(id: @user))
      end
    end

    describe "with invalid params"  do
      it "assigns the user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        assigns(:user).should eq(@user)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, id: @user.to_param, user: { firstname: 'Hugo' }
        response.should render_template("edit")
      end
    end
  end



end
