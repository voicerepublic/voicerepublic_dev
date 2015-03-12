require 'rails_helper'

describe ParticipationsController do

  describe 'with user logged in' do

    # login user
    before  do
      @user = FactoryGirl.create(:user)
      allow(request.env['warden']).to receive_messages :authenticate! => @user
      allow(controller).to receive_messages :current_user => @user
    end

    def valid_attributes
      {}
    end

    describe 'POST create' do
      before { @venue = FactoryGirl.create(:venue) }
      describe 'guests' do
        it 'leads guests to the signup form' do
          @user.update_attribute :guest, true
          allow(request.env['warden']).to receive_messages :authenticate! => @user
          allow(controller).to receive_messages :current_user => @user
          expect(Participation.count).to eq(0)
          post :create, { venue_id: @venue.id, participation: valid_attributes }
          expect(response).to redirect_to(new_user_registration_path)
          expect(Participation.count).to eq(0)
        end

        it 'leads actual users back to where they came from' do
          post :create, { venue_id: @venue.id, participation: valid_attributes }
          expect(response).to redirect_to(@venue)
        end
      end
      describe 'with valid parameters' do
        it 'creates a new Participation' do
          @venue = FactoryGirl.create(:venue)
          expect {
            post :create, { venue_id: @venue.id, participation: valid_attributes }
          }.to change(Participation, :count).by(1)
        end
      end
    end

    describe 'DELETE destroy' do
      describe 'with valid parameters' do
        it 'destroys an existing Participation' do
          @participation = FactoryGirl.create(:participation, user: @user)
          params = {
            venue_id: @participation.venue_id,
            id: @participation.id
          }
          expect { delete :destroy, params }.to change(Participation, :count).by(-1)
        end
      end
    end

  end

end
