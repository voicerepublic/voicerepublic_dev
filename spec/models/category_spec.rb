require 'spec_helper'

describe Category do
  it "has a valid factory" do
    FactoryGirl.create(:category).should be_valid
  end
  it "is invalid without name" do
    FactoryGirl.build(:category, name: nil).should_not be_valid
  end
  it "can have a parent-category" do
    cat = FactoryGirl.create(:child_category)
    cat.parent_id.should_not be_nil
  end
end
