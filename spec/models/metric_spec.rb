require 'rails_helper'

describe Metric do

  it 'aggregates metrics for Series created by Users' do
    Metric.snapshot!
    expect(Series.count).to be(0)
    expect(Metric.where(key: "series_nondefault_total").last.value).to eq(0)

    # Users have a default series
    user = FactoryGirl.create :user
    expect(Series.count).to be(1)
    # That isn't counted
    Metric.snapshot!
    expect(Metric.where(key: "series_nondefault_total").last.value).to eq(0)

    # If the user creates a Series, however, it is counted
    FactoryGirl.create :series, user: user
    expect(Series.count).to be(2)
    Metric.snapshot!
    expect(Metric.where(key: "series_nondefault_total").last.value).to eq(1)
  end

end
