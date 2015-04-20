require 'rails_helper'

describe KillTalkMessage do

  it 'has the proper link' do
    talk = FactoryGirl.create(:talk)
    text = KillTalkMessage.instance.slack_message(talk)
    expect(text).to include('http')
    expect(text).to include(talk.to_param)
  end

end
