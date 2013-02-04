require 'spec_helper'

describe Notification::NewVenue do
  it "has a valid factory" do
    FactoryGirl.create(:notification_new_venue).should be_valid
  end
  
  it "is created for follower that wants information about friends activities" do
    relation = FactoryGirl.create(:follow)
    receiver = relation.follower
    creator = relation.followed
    _kluuu = FactoryGirl.create(:published_kluuu, :user => creator)
    _venue = FactoryGirl.create(:venue, :host_kluuu => _kluuu)
    receiver.notifications.content_alerts.should_not be_empty
    receiver.notifications.content_alerts.first.should be_a_kind_of(Notification::NewVenue)
  end
  
end
