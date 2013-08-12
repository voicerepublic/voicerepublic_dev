require 'spec_helper'

describe Account do

  it "is not valid if no user given" do
    FactoryGirl.build(:account, user_id: nil).should_not be_valid
  end

  it "is not valid if no timezone given" do
    FactoryGirl.build(:account, timezone: nil).should_not be_valid
  end
  
  it "has a valid with prefs factory" do
    FactoryGirl.build(:account_with_prefs).should be_valid
  end
  
  it "has a valid timezone" do
    tz = FactoryGirl.create(:account).timezone
    ActiveSupport::TimeZone.all.map { |x| x.name }.include?(tz).should be_true
  end
  
  it "has an empty portrait-path if deleted" do
    a = FactoryGirl.create(:account_with_portrait)
    a.portrait.destroy
    a.save
    a.portrait_file_name.should be_nil
  end
  
end
