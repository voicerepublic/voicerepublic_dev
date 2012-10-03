require 'spec_helper'

describe Notification::FollowerAction do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_follower_action).should be_valid
  end
  
  it "is created when a person i follow triggers an action"
  

end