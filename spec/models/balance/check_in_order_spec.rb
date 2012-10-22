require 'spec_helper'

describe Balance::CheckInOrder do
  it "has a valid factory" do
    FactoryGirl.create(:balance_check_in_order).should be_valid
  end
  
  it "is invalid without currency" do
    FactoryGirl.build(:balance_check_in_order, :currency => nil).should_not be_valid
  end
  
  it "is invalid without balance_account" do
    FactoryGirl.build(:balance_check_in_order, :balance_account => nil).should_not be_valid
  end
  
  it "is invalid if amount_cents is less or equal 0" do
    FactoryGirl.build(:balance_check_in_order, :amount_cents => 0).should_not be_valid
    FactoryGirl.build(:balance_check_in_order, :amount_cents => -5).should_not be_valid
  end
  
end
