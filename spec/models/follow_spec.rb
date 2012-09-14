require 'spec_helper'

describe Follow do
  it "has a valid factory" do
    FactoryGirl.create(:follow).should be_valid
  end
  
  it "is invalid without a follower user" do
    FactoryGirl.build(:follow, :follower_id => nil).should_not be_valid
  end
  it "is invalid withoug a followed user" do
    FactoryGirl.build(:follow, :followed_id => nil).should_not be_valid
  end
  
  it "is destroyed if follower user is destroyed" do
    _follower = FactoryGirl.create(:user)
    _follow = FactoryGirl.create(:follow, :follower => _follower)
    _follow.should be_valid
    
    _follower.destroy
    expect {
      Follow.find(_follow.id)
    }.to raise_error
  end
  
  it "is destroyed if followed user is destroyed" do
    _followed = FactoryGirl.create(:user)
    _follow = FactoryGirl.create(:follow, :followed => _followed)
    _follow.should be_valid
    
    _followed.destroy
    expect {
      Follow.find(_follow.id)
    }.to raise_error
  end
  
  
end
