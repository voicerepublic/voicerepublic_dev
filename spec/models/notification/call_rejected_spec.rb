require 'spec_helper'

describe Notification::CallRejected do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_call_rejected).should be_valid
  end
  it "is invalid without other" do
    FactoryGirl.build(:notification_call_rejected, other_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_call_rejected, video_session_id: nil).should_not be_valid
  end
  it "is invalid without user id" do
    FactoryGirl.build(:notification_call_rejected, user_id: nil).should_not be_valid
  end
end