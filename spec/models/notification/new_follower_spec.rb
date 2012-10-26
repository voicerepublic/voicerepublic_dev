require 'spec_helper'

describe Notification::NewFollower do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_follower).should be_valid
  end

  it "is invalid without other-user" do
    FactoryGirl.build(:notification_new_follower, other: nil).should_not be_valid
  end
  
  it "will be created if there is a new follower for user" do
    me = FactoryGirl.create(:user)
    num_notifications = me.notifications.count 
    other = FactoryGirl.create(:user)
    f = FactoryGirl.create(:follow, follower: other, followed: me)
    me.notifications.count.should eq(num_notifications + 1)
    me.notifications.alerts.first.should be_a_kind_of(Notification::NewFollower)
  end

end