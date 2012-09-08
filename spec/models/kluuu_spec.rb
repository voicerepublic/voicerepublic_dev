require 'spec_helper'

describe Kluuu do
  it "has a valid factory" do
    FactoryGirl.create(:kluuu).should be_valid
  end
  
  it "has an user as owner" do
    FactoryGirl.create(:kluuu).user.should be_valid
  end
  
  it "is invalid without owner" do
    FactoryGirl.build(:kluuu, user:  nil).should_not be_valid
  end
  
  it "is invalid without title" do
    FactoryGirl.build(:kluuu, title: nil).should_not be_valid
  end
  
  it "is invalid without a category" do
    FactoryGirl.build(:kluuu, category:  nil).should_not be_valid
  end
  
  it "is invalid without description" do
    FactoryGirl.build(:kluuu, description: nil).should_not be_valid
  end
  
  it "has many images"
  
end
