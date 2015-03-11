require 'spec_helper'

describe EmbedTalksController do

  describe '' do
    render_views

    # login user
    before  do
      @user = FactoryGirl.create(:user)
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_user => @user
    end

    it 'renders' do
      talk = FactoryGirl.create :talk
      get :show, id: talk.id
    end

    it 'has content' do
      talk = FactoryGirl.create :talk, title: 'my title'
      get :show, id: talk.id
      expect(response.body).to match(/MY TITLE/)
    end

  end

end
