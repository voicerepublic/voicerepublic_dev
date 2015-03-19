require 'spec_helper'

describe Purchase do

  it 'fetches details on setting token' do
    expect(Purchase.new(express_token: 'ASDF').details).to be_present
  end

  it 'calculates the amount when setting the quantity' do
    expect(Purchase.new(quantity: 1).amount).to be_present
  end

  it 'works with parallel transactions' do
    user = FactoryGirl.create(:user)
    user_credits = user.credits
    purchase0 = FactoryGirl.create(:purchase, owner: user)
    purchase1 = FactoryGirl.create(:purchase, owner: user)
    t0 = Thread.new { purchase0.process }
    t1 = Thread.new { purchase1.process }
    t0.join
    t1.join
    expected_result = user_credits+purchase0.quantity+purchase1.quantity
    expect(user.reload.credits).to eq(expected_result)
  end

end
