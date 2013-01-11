require 'spec_helper'

describe VenueKlu do
  it "has a valid factory" do
    FactoryGirl.create(:venue_klu).should be_valid
  end
  
  it "has a valid factory with no_kluuu" do
    FactoryGirl.create(:venue_no_kluuu).should be_valid
  end
  
  it "has a valid factory with kluuu" do
    FactoryGirl.create(:venue_kluuu).should be_valid
  end
  
  it "is invalid without venue" do
    FactoryGirl.build(:venue_klu, :venue => nil).should_not be_valid
  end
  
  it "is invalid without klu" do
    FactoryGirl.build(:venue_klu, :klu => nil).should_not be_valid
  end
  
end
