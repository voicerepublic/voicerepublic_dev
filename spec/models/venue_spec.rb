require 'spec_helper'

describe Venue do
  
  it "has a valid factory" do
    FactoryGirl.create(:venue).should be_valid
  end
  
  it "is invalid without host-kluuu" do
    FactoryGirl.build(:venue, :host_kluuu => nil).should_not be_valid
  end
  
  it "is invalid without title" do
    FactoryGirl.build(:venue, :title => nil).should_not be_valid
  end
  
  it "is invalid without summary" do
    FactoryGirl.build(:venue, :summary => nil).should_not be_valid
  end

  it "is invalid without description" do
    FactoryGirl.build(:venue, :description => nil).should_not be_valid
  end
  
  it "is invalid without start_time" do
    FactoryGirl.build(:venue, :start_time => nil).should_not be_valid
  end
  
  it "is invalid without duration" do
    FactoryGirl.build(:venue, :duration => nil).should_not be_valid
  end

  it 'should scope not_past' do
    expected = [ FactoryGirl.create(:venue, :start_time => 1.day.from_now),
                 FactoryGirl.create(:venue, :start_time => 30.minutes.ago, :duration => 60) ]
    FactoryGirl.create(:venue, :start_time => 1.day.ago)
    Venue.not_past.should == expected
  end

  it 'scope scope featured' do
    expected = [ FactoryGirl.create(:venue, :featured_from => 1.day.ago),
                 FactoryGirl.create(:venue, :featured_from => 1.week.ago) ]
    FactoryGirl.create(:venue, :featured_from => 1.day.from_now)
    Venue.featured.should == expected
  end
  
  it 'should know when to start' do
    venue = create :venue, :start_time => 42.minutes.from_now
    venue.start_in_seconds.should be_close(42.minutes, 1)
  end

end
