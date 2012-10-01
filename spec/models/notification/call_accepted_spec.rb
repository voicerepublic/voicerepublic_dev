require 'spec_helper'

describe Notification::CallAccepted do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_call_accepted).should be_valid
  end
  it "is invalid without other" do
    FactoryGirl.build(:notification_call_accepted, other_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_call_accepted, video_session_id: nil).should_not be_valid
  end
  it "is invalid without user id" do
    FactoryGirl.build(:notification_call_accepted, user_id: nil).should_not be_valid
  end
end