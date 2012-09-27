require 'spec_helper'

describe Notification::NewMessage do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_message).should be_valid
  end

  it "is invalid without other-user" do
    FactoryGirl.build(:notification_new_message, other: nil).should_not be_valid
  end
  
  it "will be created if there is a new message for user"

end