require 'rails_helper'

describe Pricing do

  let(:object) { Object.new.tap{ |o| o.extend(Pricing) } }

  # it 'has continuity' do
  #   prev_price = 0
  #   (1..1000).each do |qty|
  #     price = object.make_deal(qty)[1]
  #     expect(price).to be >= prev_price
  #     prev_price = price
  #   end
  # end

  # it 'nicely plots' do
  #   expect { object.plot_pricing! }.not_to raise_exception
  # end

end
