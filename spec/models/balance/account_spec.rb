require 'spec_helper'

describe Balance::Account do
  it "has a valid factory" do
    FactoryGirl.create(:balance_account).should be_valid
  end
  
  it "is invalid without user" do
    FactoryGirl.build(:balance_account, :user => nil).should_not be_valid
  end
  
  it "is invalid without currency" do
    FactoryGirl.build(:balance_account, :currency => nil).should_not be_valid
  end
  
end
