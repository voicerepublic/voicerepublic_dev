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
      before { @series = FactoryGirl.create(:series) }
      it 'leads actual users back to where they came from' do
        post :create, { series_id: @series.id, participation: valid_attributes }
        expect(response).to redirect_to(@series)
      end
      it 'creates a new Participation' do
        @series = FactoryGirl.create(:series)
        expect {
          post :create, { series_id: @series.id, participation: valid_attributes }
        }.to change(Participation, :count).by(1)
      end
    end

    describe 'DELETE destroy' do
      describe 'with valid parameters' do
        it 'destroys an existing Participation' do
          @participation = FactoryGirl.create(:participation, user: @user)
          params = {
            series_id: @participation.series_id,
            id: @participation.id
          }
          expect { delete :destroy, params }.to change(Participation, :count).by(-1)
        end
      end
    end

  end

end
