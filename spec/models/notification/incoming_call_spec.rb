require 'spec_helper'

describe Notification::IncomingCall do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_incoming_call).should be_valid
  end
  it "is invalid without other id" do
    FactoryGirl.build(:notification_incoming_call, other_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_incoming_call, video_session_id: nil).should_not be_valid
  end
  
  it "is invalid without user" do
    FactoryGirl.build(:notification_incoming_call, user_id: nil).should_not be_valid
  end
end