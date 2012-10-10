require 'spec_helper'

describe Rating do
  it "has a valid factory" do
    FactoryGirl.create(:rating).should be_valid
  end
  it "has a valid user" do
    FactoryGirl.create(:rating).user.should be_valid
  end
  it "has a valid rateable" do
    FactoryGirl.create(:rating).rateable.should be_valid
  end
  it "has text-content" do
    FactoryGirl.create(:rating).content.should_not be_empty
  end
  it "has integer score" do
    FactoryGirl.create(:rating).score.should be_an_instance_of Fixnum
  end
  
  it "is invalid without user" do
    FactoryGirl.build(:rating, :user => nil).should_not be_valid
  end
  
  it "is invalid without a rateable" do
    FactoryGirl.build(:rating, :rateable => nil).should_not be_valid
  end
  
  it "is invalid without content" do
    FactoryGirl.build(:rating, :content => '').should_not be_valid
  end
  
  it "is invalid without rateable_type" do 
    FactoryGirl.build(:rating, :rateable_type => nil).should_not be_valid
  end
  
end
