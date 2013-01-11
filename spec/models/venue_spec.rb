require 'spec_helper'

describe Venue do
  
  it "has a valid factory" do
    FactoryGirl.create(:venue).should be_valid
  end
  
  it "is invalid without host-kluuu" do
    FactoryGirl.build(:venue, :host_kluuu => nil).should_not be_valid
  end
  
  it "is invalid without title" do
    FactoryGirl.build(:venue, :title => nil).should_not be_valid
  end
  
  it "is invalid without description" do
    FactoryGirl.build(:venue, :description => nil).should_not be_valid
  end
  
  it "is invalid without start_time" do
    FactoryGirl.build(:venue, :start_time => nil).should_not be_valid
  end

end
