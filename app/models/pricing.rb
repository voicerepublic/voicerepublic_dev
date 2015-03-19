module Pricing

  include Gnuplot

  extend self

  # returns quantity and price in cents
  def make_deal(qty)
    qty = qty.to_i

    qty =   5 if qty <= 5
    qty =  10 if qty >  5 and qty <= 10
    qty =  25 if qty > 10 and qty <= 25
    qty =  50 if qty > 25 and qty <= 50
    qty = 100 if qty > 50 and qty <= 100

    price =   5 * 3000 if qty == 5
    price =  10 * 2500 if qty == 10
    price =  25 * 1800 if qty == 25
    price =  50 * 1500 if qty == 50
    price = qty * 1200 if qty >= 100

    [qty, price]
  end

  def plot_pricing!(max=150)
    Tempfile.open('pricing', '/tmp') do |f|
      (1..max).each { |q| f.puts [q, make_deal(q)[1]/100]*" " }
      f.close
      gnuplot(f.path, 'doc/pricing.svg')
    end
    puts 'Updated doc/pricing.svg'
  end

end
