require 'spec_helper'

describe Participation do

  it 'validates presence of venue' do
    FactoryGirl.build(:participation, venue: nil).should_not be_valid
  end

  it 'validates presence of user' do
    FactoryGirl.build(:participation, user: nil).should_not be_valid
  end

  it 'validates uniqueness of venue in scope user' do
    pending "@munen: shouldn't that work?"
    p0 = FactoryGirl.build(:participation)
    p1 = FactoryGirl.build(:participation, venue: p0.venue, user: p0.user)
    expect(p0.venue_id).to eq(p1.venue_id)
    expect(p0.user_id).to eq(p1.user_id)
    expect(p1).to_not be_valid
  end

end
