require 'spec_helper'

describe Api::TalksController do

  describe 'logged in' do

    before do
      @current_user = FactoryGirl.create(:user)
      request.env['warden'].stub :authenticate! => @current_user
      controller.stub :current_or_guest_user => @current_user
      @current_user.reload
      venue = FactoryGirl.create(:venue, user: @current_user)
      @talk = FactoryGirl.create(:talk, venue: venue)
    end

    describe 'unprocessables' do

      it 'returns 422 if no msg given' do
        put :update, id: @talk.id
        response.status.should be(422)
      end

      it 'returns 422 if no user id given' do
        put :update, id: @talk.id, msg: { }
        response.status.should be(422)
      end

      it 'returns 422 if neither event nor state given' do
        put :update, id: @talk.id, msg: { user: { id: 1 } }
        response.status.should be(422)
      end

    end

    # as host sending events for other user
    it 'uses the expected method' do
      other = FactoryGirl.create(:user)
      VCR.use_cassette 'talk_update_event_wfp' do
        put :update, id: @talk.id, msg: { event: 'StartTalk' }
        assigns(:method).should eq('start_talk')
      end
    end

    it 'uses the method store_state for state by default' do
      @talk.update_attribute :session, { @current_user.id => {} }
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: { state: 'WaitingForPromotion' }
        assigns(:method).should eq(:store_state)
      end
    end

    it 'should receive store_state' do
      @talk.update_attribute :session, { @current_user.id => {} }
      message = { state: 'WaitingForPromotion' }
      controller.should_receive(:store_state).and_return(message)
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: message
      end
    end

    it 'returns on store_state' do
      @talk.update_attribute :session, { @current_user.id => {} }
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: { state: 'WaitingForPromotion' }
        response.status.should be(200)
      end
    end

    it 'returns on registering' do
      VCR.use_cassette 'talk_update_state_registering' do
        put :update, id: @talk.id, msg: { state: 'Registering' }
        response.status.should be(200)
      end
    end

    it 'should actually store the state' do
      @talk.update_attribute :session, { @current_user.id => {} }
      message = { state: 'WaitingForPromotion' }
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: message
        @talk.reload.session[@current_user.id].should_not be_empty
      end
    end

    describe 'authorization' do

      it 'should verify host identity on events' do
        @talk.venue.update_attribute :user, FactoryGirl.create(:user)
        message = { event: 'Promotion', user: { id: @current_user.id } }
        VCR.use_cassette 'talk_update_verify_host' do
          put :update, id: @talk.id, msg: message
          response.status.should be(740)
        end
      end

    end

  end

  it 'should authenticate user' do
    put :update, id: 1
    response.status.should be(302)
  end

end
