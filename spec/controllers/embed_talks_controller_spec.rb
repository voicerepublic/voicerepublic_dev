require 'spec_helper'

describe EmbedTalksController do

  describe '' do
    render_views

    # login user
    before  do
      @user = FactoryGirl.create(:user)
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_or_guest_user => @user
    end

    it 'renders' do
      event = FactoryGirl.create :event
      get :show, id: event.id
    end

    it 'has content' do
      event = FactoryGirl.create :event, title: 'my title'
      get :show, id: event.id
      response.body.should =~ /my title/
    end

  end

end
