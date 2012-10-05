require 'spec_helper'

describe Notification::Base do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_basis).should be_valid
  end
end
