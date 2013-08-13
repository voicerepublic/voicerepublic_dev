require 'spec_helper'

describe Comment do
  
  it "is invalid without content" do
    FactoryGirl.build(:comment, content: nil).should_not be_valid
  end
  it "is invalid without a commentable" do
    FactoryGirl.build(:comment, commentable: nil).should_not be_valid
  end
  it "is invalid without a commentable_type" do
    FactoryGirl.build(:comment, commentable_type: nil).should_not be_valid
  end 
  it "is invalid without a user" do
    FactoryGirl.build(:comment, user: nil).should_not be_valid
  end
  
  it "will be destroyed if related status_update is destroyed" do
    _cmt = FactoryGirl.create(:comment)
    _cmt.commentable.should be_a_kind_of(StatusUpdate)
    _cmt.commentable.destroy
    expect { Comment.find(_cmt.id) }.to raise_error
  end
  
end
