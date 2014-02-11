require 'spec_helper'

describe Api::TalksController do

  it 'returns ok' do
    talk = FactoryGirl.create(:talk)
    user = FactoryGirl.create(:user)
    put :update, id: talk.id, { msg: { state: 'Registering', user: { id: user.id } } }
    response.should be(:ok)
  end

end
