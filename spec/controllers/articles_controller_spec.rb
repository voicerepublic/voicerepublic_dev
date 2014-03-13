require 'spec_helper'

describe ArticlesController do

  describe 'with user logged in' do

    # login user
    before  do
      @user = FactoryGirl.create(:user)
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_user => @user
    end

    def valid_attributes
      FactoryGirl.attributes_for(:article)
    end

    describe 'POST create' do
      describe 'with valid parameters' do
        it 'creates a new Article' do
          @venue = FactoryGirl.create(:venue)
          # set referrer for 'redirect_to :back'
          request.env["HTTP_REFERER"] = venue_path(@venue)
          expect {
            post :create, { venue_id: @venue.id, article: valid_attributes }
          }.to change(Article, :count).by(1)
        end
      end
      describe 'with invalid parameters' do
        it "re-renders the 'new' template" do
          pending "CREATING AN ARTICLE FROM A VENUE IS NOT YET REALLY IMPLEMENTED, SO IT IS UNKNOWN WHAT THE BEHAVIOUR SHOULD BE"
          @venue = FactoryGirl.create(:venue)
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          post :create, { venue_id: @venue.id, article: {} }
          response.should be_redirect
        end
      end
    end

  end

  # describe "POST create" do
  #   describe "with valid params" do
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
