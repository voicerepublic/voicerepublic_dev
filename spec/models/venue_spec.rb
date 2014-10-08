require 'spec_helper'

describe Venue do

  it "is invalid without title" do
    FactoryGirl.build(:venue, :title => nil).should_not be_valid
  end

end
