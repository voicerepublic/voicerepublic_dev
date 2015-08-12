require 'rails_helper'

describe Participation do

  it 'validates presence of series' do
    expect(FactoryGirl.build(:participation, series: nil)).not_to be_valid
  end

  it 'validates presence of user' do
    expect(FactoryGirl.build(:participation, user: nil)).not_to be_valid
  end

  it 'validates uniqueness of series in scope user' do
    p0 = FactoryGirl.create(:participation)
    p1 = FactoryGirl.build(:participation, series: p0.series, user: p0.user)
    expect(p0.series_id).to eq(p1.series_id)
    expect(p0.user_id).to eq(p1.user_id)
    expect(p1).to_not be_valid
  end

end
