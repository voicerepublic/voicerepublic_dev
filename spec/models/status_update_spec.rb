require 'spec_helper'

describe StatusUpdate do
  it "has a valid factory" do
    FactoryGirl.create(:status_update).should be_valid
  end
  it "has a valid user" do
    FactoryGirl.build(:status_update).user.should_not be_nil
  end
  it "has some content" do
    FactoryGirl.build(:status_update).content.should_not be_empty
  end
  it "is invalid without a user" do
    FactoryGirl.build(:status_update, user: nil ).should_not be_valid
  end
  it "is invalid without content" do
    FactoryGirl.build(:status_update, content: nil).should_not be_valid
  end
  it "will have no comments after creation" do
    FactoryGirl.create(:status_update).comments.should be_empty
  end
end
