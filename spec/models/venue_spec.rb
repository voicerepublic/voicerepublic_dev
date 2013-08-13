require 'spec_helper'

describe Venue do
  
  it "is invalid without title" do
    FactoryGirl.build(:venue, :title => nil).should_not be_valid
  end
  
  it "is invalid without summary" do
    FactoryGirl.build(:venue, :summary => nil).should_not be_valid
  end

  it "is invalid without description" do
    FactoryGirl.build(:venue, :description => nil).should_not be_valid
  end


  it 'should scope featured' do
    expected = [ FactoryGirl.create(:venue, :featured_from => 1.day.ago),
                 FactoryGirl.create(:venue, :featured_from => 1.week.ago) ]
    unexpected = FactoryGirl.create(:venue, :featured_from => 1.day.from_now)
    featured = Venue.featured
    expect(featured).to include(expected[0])
    expect(featured).to include(expected[1])
    expect(featured).not_to include(unexpected)
  end
   
  it 'should know when to start (by delegation)' do
    venue = FactoryGirl.create(:venue)
    FactoryGirl.create(:event, venue: venue, :start_time => 42.minutes.from_now)
    venue.start_in_seconds.should be_within(1).of(42.minutes)
  end

  it "should have a not_past scope" do
    expected = FactoryGirl.create(:venue)
    FactoryGirl.create(:event, venue: expected, start_time: 1.week.from_now)
    FactoryGirl.create(:venue)
    expect(expected).to have(1).event
    expect(Venue.not_past).to eq([expected])
  end

  it "should have a next event" do
    venue = FactoryGirl.create(:venue)
    expected = FactoryGirl.create(:event, venue: venue, start_time: 1.week.from_now)
    FactoryGirl.create(:event, venue: venue, start_time: 2.weeks.from_now)
    expect(venue).to have(2).events
    expect(venue.next_event).to eq expected
  end

end
