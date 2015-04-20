require 'rails_helper'

describe 'CoreExtensions' do

  it 'provides %o for ordinals on Time#strftime' do
    expect(Time.parse('2006-12-31').strftime('%o')).to eq('st')
    expect(Time.parse('2007-01-02').strftime('%o')).to eq('nd')
    expect(Time.parse('2007-01-03').strftime('%o')).to eq('rd')
    expect(Time.parse('2007-01-04').strftime('%o')).to eq('th')
  end

end
