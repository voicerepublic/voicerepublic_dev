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
  
  it "has many images" do
    _pk = FactoryGirl.create(:published_kluuu)
    _pk.klu_images.should_not be_empty
  end
  
  it "will be destroyed if owning user is destroyed" do
    _k = FactoryGirl.create(:published_kluuu)
    _k.user.should be_valid
    _k.user.destroy
    expect { Kluuu.find(_k.id) }.to raise_error 
  end
  
end
