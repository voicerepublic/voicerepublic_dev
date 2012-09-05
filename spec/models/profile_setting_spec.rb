require 'spec_helper'

describe ProfileSetting do
  it "has a valid factory" do
    FactoryGirl.create(:profile_setting).should be_valid
  end
  it "is not valid if no user given" do
    FactoryGirl.build(:profile_setting, user_id: nil).should_not be_valid
  end
  it "is not valid if no timezone given" do
    FactoryGirl.build(:profile_setting, timezone: nil).should_not be_valid
  end
  
  it "has a valid timezone" do
    tz = FactoryGirl.create(:profile_setting).timezone
    ActiveSupport::TimeZone.all.map { |x| x.name }.include?(tz).should be_true
  end
  
end
