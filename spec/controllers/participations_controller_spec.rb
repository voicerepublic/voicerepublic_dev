require 'spec_helper'

describe ParticipationsController do

  # def valid_attributes
  #   { :venue_id => FactoryGirl.create(:venue).id }
  # end
  # 
  # # TODO log in user
  # def valid_session
  #   {} 
  # end
  # 
  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Participation" do
  #       expect {
  #         post :create, {:participation => valid_attributes}, valid_session
  #       }.to change(Participation, :count).by(1)
  #     end
  # 
  #     it "assigns a newly created participation as @participation" do
  #       post :create, {:participation => valid_attributes}, valid_session
  #       assigns(:participation).should be_a(Participation)
  #       assigns(:participation).should be_persisted
  #     end
  # 
  #     it "redirects to the created participation" do
  #       post :create, {:participation => valid_attributes}, valid_session
  #       response.should redirect_to(Participation.last)
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved participation as @participation" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Participation.any_instance.stub(:save).and_return(false)
  #       post :create, {:participation => {  }}, valid_session
  #       assigns(:participation).should be_a_new(Participation)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Participation.any_instance.stub(:save).and_return(false)
  #       post :create, {:participation => {  }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested participation" do
  #     participation = Participation.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => participation.to_param}, valid_session
  #     }.to change(Participation, :count).by(-1)
  #   end
  # 
  #   it "redirects to the participations list" do
  #     participation = Participation.create! valid_attributes
  #     delete :destroy, {:id => participation.to_param}, valid_session
  #     response.should redirect_to(participations_url)
  #   end
  # end

end
