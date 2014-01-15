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
    FactoryGirl.create(:event, :start_time => 1.day.ago, :end_at => 1.minute.ago)
    Event.not_past.pluck(:id).should == expected.map(&:id)
  end
  
  it 'should know when to start' do
    event = FactoryGirl.create(:event, :start_time => 42.minutes.from_now)
    event.start_in_seconds.should be_within(1).of(42.minutes)
  end

  # it 'should have scope most_recent_only' do
  #   venue = FactoryGirl.create(:venue)
  #   expected = FactoryGirl.create(:event, :venue => venue, :start_time => 1.week.ago)
  #   FactoryGirl.create(:event, :venue => venue, :start_time => 2.weeks.ago)
  #   FactoryGirl.create(:event, :venue => venue, :start_time => 3.weeks.ago)
  #   expect(Event.most_recent_only.to_sql).to eq([expected])
  # end

end
