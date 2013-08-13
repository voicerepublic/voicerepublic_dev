require 'spec_helper'

describe Event do

  it "is invalid without venue" do
    FactoryGirl.build(:event, :venue => nil).should_not be_valid
  end

  it "is invalid without start_time" do
    FactoryGirl.build(:event, :start_time => nil).should_not be_valid
  end
  
  it "is invalid without duration" do
    FactoryGirl.build(:event, :duration => nil).should_not be_valid
  end
  

  it 'should scope not_past' do
    expected = [ FactoryGirl.create(:event, :start_time => 1.day.from_now),
                 FactoryGirl.create(:event, :start_time => 30.minutes.ago, :duration => 60) ]
    FactoryGirl.create(:event, :start_time => 1.day.ago)
    Event.not_past.should == expected
  end
  
  it 'should know when to start' do
    event = FactoryGirl.create(:event, :start_time => 42.minutes.from_now)
    event.start_in_seconds.should be_within(1).of(42.minutes)
  end

end
