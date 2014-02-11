require 'spec_helper'

describe Api::TalksController do

  let(:talk) { FactoryGirl.create(:talk) }
  let(:user) { FactoryGirl.create(:user) }

  it 'returns 422 if no msg given' do
    put :update, id: talk.id
    response.status.should be(422)
  end

  it 'returns 422 if no user id given' do
    put :update, id: talk.id, msg: { }
    response.status.should be(422)
  end

  it 'returns 422 if neither event nor state given' do
    put :update, id: talk.id, msg: { user: { id: 1 } }
    response.status.should be(422)
  end


  it 'uses the expected method' do
    VCR.use_cassette 'talk_update_state_wfp' do
      put :update, id: talk.id, msg:
        { event: 'WaitingForPromotion', user: { id: user.id } }
      assigns(:method).should eq('waiting_for_promotion')
    end
  end

  it 'uses the method store_state for state by default' do
    talk.update_attribute :session, { user.id.to_s => {} }
    VCR.use_cassette 'talk_update_state_wfp' do
      put :update, id: talk.id, msg:
        { state: 'WaitingForPromotion', user: { id: user.id } }
      assigns(:method).should eq(:store_state)
    end
  end

  it 'should receive store_state' do
    talk.update_attribute :session, { user.id.to_s => {} }
    message = { state: 'WaitingForPromotion', user: { id: user.id } }
    controller.should_receive(:store_state).and_return(message)
    VCR.use_cassette 'talk_update_state_wfp' do
      put :update, id: talk.id, msg: message
    end
  end

  it 'returns on store_state' do
    talk.update_attribute :session, { user.id.to_s => {} }
    VCR.use_cassette 'talk_update_state_wfp' do
      put :update, id: talk.id, msg:
        { state: 'WaitingForPromotion', user: { id: user.id } }
      response.status.should be(200)
    end
  end

  it 'returns on registering' do
    VCR.use_cassette 'talk_update_state_registering' do
      put :update, id: talk.id, msg:
        { state: 'Registering', user: { id: user.id } }
      response.status.should be(200)
    end
  end

  it 'should actually store the state' do
    talk.update_attribute :session, { user.id.to_s => {} }
    message = { state: 'WaitingForPromotion', user: { id: user.id } }
    VCR.use_cassette 'talk_update_state_wfp' do
      put :update, id: talk.id, msg: message
      talk.reload.session[user.id.to_s].should_not be_empty
    end
  end

end
