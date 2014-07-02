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

end
