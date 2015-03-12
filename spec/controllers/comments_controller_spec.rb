require 'spec_helper'

describe CommentsController do
  
  describe 'with user logged in' do
  
    before do
      @user = FactoryGirl.create(:user)
      allow(request.env['warden']).to receive_messages :authenticate! => @user
      allow(controller).to receive_messages :current_user => @user 
    end

    describe 'POST create' do
      describe 'with valid attributes' do
        it 'creates a comment' do
          venue = FactoryGirl.create(:venue)
          params = {
            venue_id: venue.id,
            comment: FactoryGirl.attributes_for(:comment)
          }
          expect { post :create, params }.to change(Comment, :count).by(1)
        end
      end
    end

  end

end
