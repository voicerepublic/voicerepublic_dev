require 'spec_helper'

describe Bookmark do
  it "has a valid factory" do
    FactoryGirl.create(:kluuu_bookmark).should be_valid
  end
  
  it "is invalid without klu_id" do
    FactoryGirl.build(:kluuu_bookmark, klu_id: nil).should_not be_valid
  end
  
  it "is invalid without an user" do 
    FactoryGirl.build(:kluuu_bookmark, user_id: nil).should_not be_valid
  end
  
  it "will have a NoKluuu if kind of no_kluuu_bookmark" do
    _bm = FactoryGirl.create(:no_kluuu_bookmark)
    _bm.no_kluuu.should be_valid
    _bm.no_kluuu.should_not be_nil
  end
  
  it "will have a Kluuu if kind of kluuu_bookmark" do
    _bm = FactoryGirl.create(:kluuu_bookmark)
    _bm.kluuu.should be_valid
    _bm.kluuu.should_not be_nil
  end
  
  it "will be destroyed if owner is destroyed" do
    _bm = FactoryGirl.create(:kluuu_bookmark)
    _bm.user.destroy
    expect {
      Bookmark.find(_bm.id) 
    }.to raise_error
  end
  
  it "will be destroyed if associated kluuu is destroyed" do
    _bm = FactoryGirl.create(:kluuu_bookmark)
    _bm.kluuu.destroy
    expect {
      Bookmark.find(_bm.id)
    }.to raise_error
  end
end
