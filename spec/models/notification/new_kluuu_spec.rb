require 'spec_helper'

describe Notification::NewKluuu do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_kluuu).should be_valid
  end
  
  it "is created if a person i follow creates a new klu" do
    relation = FactoryGirl.create(:follow)
    receiver = relation.follower
    creator = relation.followed
    FactoryGirl.create(:published_kluuu, :user => creator)
    receiver.notifications.content_alerts.should_not be_empty
    receiver.notifications.content_alerts.first.should be_a_kind_of(Notification::NewKluuu)
  end
  
  it "points to a published kluuu" do
    relation = FactoryGirl.create(:follow)
    receiver = relation.follower
    creator = relation.followed
    FactoryGirl.create(:published_kluuu, :user => creator)
    receiver.notifications.content_alerts.first.klu.should be_a_kind_of(Klu)
  end
  
end