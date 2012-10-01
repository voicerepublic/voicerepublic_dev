require 'spec_helper'

describe Notification::Base do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_basis).should be_valid
  end

  it "is invalid without user" do
    FactoryGirl.build(:notification_basis, user: nil).should_not be_valid
  end

end
