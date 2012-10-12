require 'spec_helper'

describe Notification::IncomingCall do
  it "has a valid registered factory do" do
    FactoryGirl.create(:notification_registered_incoming_call).should be_valid
  end
  it "is invalid without other_id" do
    FactoryGirl.build(:notification_registered_incoming_call, other_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_registered_incoming_call, video_session_id: nil).should_not be_valid
  end 
  it "is invalid without user_id" do
    FactoryGirl.build(:notification_registered_incoming_call, user_id: nil).should_not be_valid
  end
  it "has a valid anonymous factory do" do
    FactoryGirl.create(:notification_anonymous_incoming_call).should be_valid
  end
  it "is invalid without anon_id" do
    FactoryGirl.build(:notification_anonymous_incoming_call, anon_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_anonymous_incoming_call, video_session_id: nil).should_not be_valid
  end 
  it "is invalid without user_id" do
    FactoryGirl.build(:notification_anonymous_incoming_call, user_id: nil).should_not be_valid
  end
end