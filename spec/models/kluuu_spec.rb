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
  
  it "is invalid without tag_list" do
    FactoryGirl.build(:kluuu, tag_list: nil).should_not be_valid
  end
  
  it "has many images" do
    _pk = FactoryGirl.create(:kluuu_with_image)
    _pk.klu_images.should_not be_empty
  end
  
  it "has many comments" do
    k = FactoryGirl.create(:published_kluuu)
    user = FactoryGirl.create(:user)
    c = k.comments.create(:content => "ein kommentar", :user => user )
    c.should be_valid
  end
  
  it "will be destroyed if owning user is destroyed" do
    _k = FactoryGirl.create(:published_kluuu)
    _k.user.should be_valid
    _k.user.destroy
    expect { Kluuu.find(_k.id) }.to raise_error 
  end
  
  it "has comments that will be destroyed after deletion of commentable klu" do
    _klu = FactoryGirl.create(:published_kluuu)
    _user = FactoryGirl.create(:user)
    _comment = _klu.comments.create(:content => "ein comment", :user => _user)
    expect {
      _klu.destroy
    }.to change { Comment.count }.by(-1)
  end
  
end
