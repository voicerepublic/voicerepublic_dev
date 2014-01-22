require 'spec_helper'

describe CommentsController do
  
  describe 'with user logged in' do
  
    before do
      @user = FactoryGirl.create(:user)
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_or_guest_user => @user 
    end

    describe 'POST create' do
      describe 'with valid attributes' do
        it 'creates a comment' do
          @article = FactoryGirl.create(:article)
          params = {
            article_id: @article.id,
            comment: FactoryGirl.attributes_for(:comment)
          }
          expect { post :create, params }.to change(Comment, :count).by(1)
        end
      end
    end

  end

end
