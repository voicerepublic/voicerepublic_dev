require 'spec_helper'

describe Purchase do

  it 'fetches details on setting token' do
    expect(Purchase.new(express_token: 'ASDF').details).to be_present
  end

  it 'calculates the amount when setting the quantity' do
    expect(Purchase.new(quantity: 1).amount).to be_present
  end

end
