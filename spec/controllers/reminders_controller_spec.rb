require 'rails_helper'

describe RemindersController do

  before do
    @user = FactoryGirl.create(:user)
    allow(request.env['warden']).to receive_messages :authenticate! => @user
    allow(controller).to receive_messages current_user: @user
  end

  describe "POST create" do

    describe "with valid params" do

      let(:talk) { FactoryGirl.create(:talk) }

      it "creates a new Reminder for the current_user" do
        expect {
          post :create, talk_id: talk.id
        }.to change(Reminder, :count).by(1)
        expect(Reminder.last.user).to eq(@user)
      end

      it "assigns a newly created reminder as @reminder" do
        post :create, talk_id: talk.id
        expect(assigns(:reminder)).to be_a(Reminder)
        expect(assigns(:reminder)).to be_persisted
      end

      it "redirects to the created reminder" do
        post :create, talk_id: talk.id
        expect(response).to redirect_to(assigns(:reminder))
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reminder" do
      reminder = FactoryGirl.create :reminder, user_id: @user.id
      expect {
        delete :destroy, id: reminder.to_param, format: 'js'
      }.to change(Reminder, :count).by(-1)
    end

    it "authorizes destroys" do
      reminder = FactoryGirl.create(:reminder)
      expect {
        delete :destroy, id: reminder.to_param
      }.to raise_error(CanCan::AccessDenied)
    end

    it "destroy returns 200 and renders js code" do
      reminder = FactoryGirl.create :reminder, user_id: @user.id
      delete :destroy, id: reminder.to_param, format: 'js'
      expect(response.status).to eq(200)
    end
  end

end
