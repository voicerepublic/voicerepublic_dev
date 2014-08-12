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

      it "creates a new Reminder" do
        expect {
          post :create, talk_id: talk.id
        }.to change(Reminder, :count).by(1)
      end
    
      it "assigns a newly created reminder as @reminder" do
        post :create, talk_id: talk.id
        assigns(:reminder).should be_a(Reminder)
        assigns(:reminder).should be_persisted
      end
    
      it "redirects to the created reminder" do
        post :create, talk_id: talk.id
        response.should redirect_to(talk)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reminder" do
      reminder = FactoryGirl.create(:reminder)
      expect {
        delete :destroy, {:id => reminder.to_param}
      }.to change(Reminder, :count).by(-1)
    end

    it "redirects to the users reminders list" do
      reminder = FactoryGirl.create(:reminder)
      delete :destroy, {:id => reminder.to_param}
      response.should redirect_to(controller.current_user)
    end
  end

end
