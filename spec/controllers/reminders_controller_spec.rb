require 'spec_helper'

describe RemindersController do

  before do
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => @user
    controller.stub current_user: @user
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
        expect(response).to redirect_to(talk)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reminder" do
      reminder = FactoryGirl.create :reminder, user_id: @user.id
      expect {
        delete :destroy, {:id => reminder.to_param}
      }.to change(Reminder, :count).by(-1)
    end

    it "authorizes destroys" do
      reminder = FactoryGirl.create(:reminder)
      expect {
        delete :destroy, {:id => reminder.to_param}
      }.to raise_error(CanCan::AccessDenied)
    end

    it "redirects to the users reminders list" do
      reminder = FactoryGirl.create :reminder, user_id: @user.id
      delete :destroy, {:id => reminder.to_param}
      expect(response).to redirect_to(controller.current_user)
    end
  end

end
