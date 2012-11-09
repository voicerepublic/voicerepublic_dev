require 'spec_helper'

describe Notification::MissedCall do
  
  it "has a valid factory" do
    FactoryGirl.build(:notification_missed_call).should be_valid
  end
  
  it "is invalid without supplied klu" do
    FactoryGirl.build(:notification_missed_call, :klu => nil).should_not be_valid
  end
  
end