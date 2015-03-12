require 'rails_helper'

describe Xhr::TalksController do

  describe 'logged in' do

    before do
      @current_user = FactoryGirl.create(:user)
      allow(request.env['warden']).to receive_messages :authenticate! => @current_user
      allow(controller).to receive_messages :current_user => @current_user
      @current_user.reload
      venue = FactoryGirl.create(:venue, user: @current_user)
      @talk = FactoryGirl.create(:talk, venue: venue)
    end

    describe 'unprocessables' do

      it 'returns 422 if no msg given' do
        put :update, id: @talk.id
        expect(response.status).to be(422)
      end

      it 'returns 422 if no user id given' do
        put :update, id: @talk.id, msg: { }
        expect(response.status).to be(422)
      end

      it 'returns 422 if neither event nor state given' do
        put :update, id: @talk.id, msg: { user: { id: 1 } }
        expect(response.status).to be(422)
      end

      it 'raises error when state cannot be set' do
        allow_any_instance_of(Xhr::TalksController).to receive(:validate_state).and_raise
        expect {
          put :update, id: @talk.id, msg: { state: 'WaitingForPromotion' }
        }.to raise_error
      end

    end

    # as host sending events for other user
    it 'uses the expected method' do
      other = FactoryGirl.create(:user)
      # since the given event will trigger a delayed job
      # which we can prevent it from running by activating
      # Delayed::Worker
      Delayed::Worker.delay_jobs = true # activate
      VCR.use_cassette 'talk_update_event_wfp' do
        put :update, id: @talk.id, msg: { event: 'StartTalk' }
        expect(assigns(:method)).to eq('start_talk')
      end
      Delayed::Worker.delay_jobs = false # deactivate
    end

    it 'uses the method store_state for state by default' do
      @talk.update_attribute :session, { @current_user.id => {} }
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: { state: 'WaitingForPromotion' }
        expect(assigns(:method)).to eq(:store_state)
      end
    end

    it 'should receive store_state' do
      @talk.update_attribute :session, { @current_user.id => {} }
      message = { state: 'WaitingForPromotion' }
      #controller.should_receive(:store_state)#.and_return(message)
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: message
      end
      expect(@talk.reload.session[@current_user.id][:state]).to eq(message[:state])
    end

    it 'returns on store_state' do
      @talk.update_attribute :session, { @current_user.id => {} }
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: { state: 'WaitingForPromotion' }
        expect(response.status).to be(200)
      end
    end

    it 'returns on registering' do
      VCR.use_cassette 'talk_update_state_registering' do
        put :update, id: @talk.id, msg: { state: 'Registering' }
        expect(response.status).to be(200)
      end
    end

    it 'should actually store the state' do
      @talk.update_attribute :session, { @current_user.id => {} }
      message = { state: 'WaitingForPromotion' }
      VCR.use_cassette 'talk_update_state_wfp' do
        put :update, id: @talk.id, msg: message
        expect(@talk.reload.session[@current_user.id]).not_to be_empty
      end
    end

    describe 'authorization' do

      it 'should verify host identity on events' do
        @talk.venue.update_attribute :user, FactoryGirl.create(:user)
        message = { event: 'Promotion', user: { id: @current_user.id } }
        VCR.use_cassette 'talk_update_verify_host' do
          put :update, id: @talk.id, msg: message
          expect(response.status).to be(740)
        end
      end

    end

  end

  it 'should authenticate user' do
    put :update, id: 'invalid_id'
    expect(response.status).to be(302)
  end

end
