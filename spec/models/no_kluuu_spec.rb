require 'spec_helper'

describe NoKluuu do
  
 
  it "has a valid factory" do
    FactoryGirl.create(:no_kluuu).should be_valid
  end
  
  it "has an user as owner" do
    FactoryGirl.create(:no_kluuu).user.should be_valid
  end
  
  it "is invalid without owner" do
    FactoryGirl.build(:no_kluuu, user:  nil).should_not be_valid
  end
  
  it "is invalid without title" do
    FactoryGirl.build(:no_kluuu, title: nil).should_not be_valid
  end
  
  it "is valid without a category" do
    FactoryGirl.build(:no_kluuu, category:  nil).should be_valid
  end
  
  it "is valid without description" do
    FactoryGirl.build(:no_kluuu, description: nil).should be_valid
  end
  
  it "is invalid without tag_list" do
    FactoryGirl.build(:no_kluuu, tag_list: nil).should_not be_valid
  end
  
  
end
