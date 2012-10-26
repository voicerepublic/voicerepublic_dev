require 'spec_helper'

describe Notification::NewComment do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_comment).should be_valid
  end
  
  it "is created when my status_messages get a comment"  do
    status_update = FactoryGirl.create(:status_update)
    status_update.comments << FactoryGirl.create(:comment, :commentable => status_update)
    status_update.user.notifications.alerts.should_not be_empty
    status_update.user.notifications.alerts.first.should be_a_kind_of(Notification::NewComment)
  end
  
  it "points to a status_message" do
    status_update = FactoryGirl.create(:status_update)
    status_update.comments << FactoryGirl.create(:comment, :commentable => status_update)
    status_update.user.notifications.alerts.first.url.should_not be_empty
  end

end