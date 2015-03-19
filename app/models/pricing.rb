module Pricing

  include Gnuplot

  # returns quantity and price in cents
  def make_deal(qty)
    qty = qty.to_i

    qty =  10 if qty <= 10
    qty =  25 if qty > 10 and qty <= 25
    qty =  50 if qty > 25 and qty <= 50
    qty = 100 if qty > 50 and qty <= 100

    price =  10 * 1000 if qty == 10
    price =  25 *  900 if qty == 25
    price =  50 *  800 if qty == 50
    price = qty *  700 if qty >= 100

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
