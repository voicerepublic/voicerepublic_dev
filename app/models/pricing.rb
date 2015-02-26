module Pricing

  include Gnuplot

  def make_price(quantity)
    return  10 * 10 if quantity <= 10
    return  25 *  9 if quantity <= 25
    return  50 *  8 if quantity <= 50
    return 100 *  6 if quantity <= 100
    quantity * 6

    # return quantity * 6 if quantity <= 250
    # 250 * 6 + (quantity - 250) * 4
  end

  def plot_pricing!(max=150)
    Tempfile.open('pricing', '/tmp') do |f|
      (1..max).each { |q| f.puts [q, make_price(q)]*" " }
      f.close
      gnuplot(f.path, 'doc/pricing.svg')
    end
    puts 'Updated doc/pricing.svg'
  end

end
