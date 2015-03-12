require 'rails_helper'

describe Participation do

  it 'validates presence of venue' do
    expect(FactoryGirl.build(:participation, venue: nil)).not_to be_valid
  end

  it 'validates presence of user' do
    expect(FactoryGirl.build(:participation, user: nil)).not_to be_valid
  end

  it 'validates uniqueness of venue in scope user' do
    p0 = FactoryGirl.create(:participation)
    p1 = FactoryGirl.build(:participation, venue: p0.venue, user: p0.user)
    expect(p0.venue_id).to eq(p1.venue_id)
    expect(p0.user_id).to eq(p1.user_id)
    expect(p1).to_not be_valid
  end

end
