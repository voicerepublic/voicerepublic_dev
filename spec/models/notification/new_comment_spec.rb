require 'spec_helper'

describe Notification::NewComment do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_comment).should be_valid
  end
  
  it "is created when my status_messages get a comment"
  it "points to a status_message"

end