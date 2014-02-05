require 'spec_helper'

describe Venue do

  it "is invalid without title" do
    FactoryGirl.build(:venue, :title => nil).should_not be_valid
  end

  it "is invalid without teaser" do
    FactoryGirl.build(:venue, :teaser => nil).should_not be_valid
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

end
