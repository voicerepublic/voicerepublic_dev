require 'spec_helper'

describe Notification::NewStatus do
  it "has a valid factory" do
    FactoryGirl.build(:notification_new_status).should be_valid
  end
  
  it "is created if a follower wants infos about friends content" do
    relation = FactoryGirl.create(:follow)
    receiver = relation.follower
    creator = relation.followed
    FactoryGirl.create(:status_update, :user => creator)
    receiver.notifications.content_alerts.should_not be_empty
    receiver.notifications.content_alerts.first.should be_a_kind_of(Notification::NewStatus)
  end
  
  it "is not created if a follower configured inform_of_friends false" do
    relation = FactoryGirl.create(:follow)
    receiver = relation.follower
    receiver.account.prefs.inform_of_friends = "0"
    receiver.account.save
    
    creator = relation.followed
    FactoryGirl.create(:status_update, :user => creator)
    receiver.notifications.content_alerts.should be_empty
  end
end
