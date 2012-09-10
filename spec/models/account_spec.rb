require 'spec_helper'

describe Account do
  it "has a valid factory" do
    FactoryGirl.create(:account).should be_valid
  end
  it "is not valid if no user given" do
    FactoryGirl.build(:account, user_id: nil).should_not be_valid
  end
  it "is not valid if no timezone given" do
    FactoryGirl.build(:account, timezone: nil).should_not be_valid
  end
  
  it "has a valid timezone" do
    tz = FactoryGirl.create(:account).timezone
    ActiveSupport::TimeZone.all.map { |x| x.name }.include?(tz).should be_true
  end
  
end
