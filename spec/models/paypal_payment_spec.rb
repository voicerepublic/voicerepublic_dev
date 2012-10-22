require 'spec_helper'

describe PaypalPayment do
  it "has a valid Factory" do
    FactoryGirl.build(:paypal_payment).should be_valid
  end
  
  it "is invalid without check_in_order" do
    FactoryGirl.build(:paypal_payment, :check_in_order => nil).should_not be_valid
  end
  
end
