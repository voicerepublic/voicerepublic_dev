require 'spec_helper'

describe User do
  
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end
  it "is invalid without an email" do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end
  it "is invalid without firstname" do
    FactoryGirl.build(:user, firstname: nil).should_not be_valid
  end
  it "is invalid without lastname" do
    FactoryGirl.build(:user, lastname: nil).should_not be_valid
  end
  it "has a profile_setting after creation" do
    FactoryGirl.create(:user).profile_setting.should_not be_nil
  end
  
end
