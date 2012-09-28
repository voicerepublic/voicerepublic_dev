require 'spec_helper'

describe CreditAccount do
  it "has a valid factory" do
    FactoryGirl.create(:credit_account).should be_valid
  end
  it "is invalid without an initialized prepaid_amount" do
    FactoryGirl.build(:credit_account, prepaid_amount: nil).should_not be_valid
  end
  it "is invalid without an initialized revenue_amount" do
    FactoryGirl.build(:credit_account, revenue_amount: nil).should_not be_valid
  end
  it "is invalid without an initialized currency" do
    FactoryGirl.build(:credit_account, currency: nil).should_not be_valid
  end
end
