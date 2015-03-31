module Pricing

  BUSINESS = %w( B5 B10 B25 B50 B100 )
  NONPROFIT = %w( NP1 NP5 NP10 NP25 )

  # returns quantity, price in cents, total in cents
  PACKAGES = {
    'B5' =>   [ 'B5',     5, 3000,  15000],
    'B10' =>  [ 'B10',   10, 2500,  25000],
    'B25' =>  [ 'B25',   25, 1800,  45000],
    'B50' =>  [ 'B50',   50, 1500,  75000],
    'B100' => [ 'B100', 100, 1200, 120000],
    'NP1' =>  [ 'NP1',    1, 2500,   2500],
    'NP5' =>  [ 'NP5',    5, 1800,   9000],
    'NP10' => [ 'NP10',  10, 1500,  15000],
    'NP25' => [ 'NP25',  25, 1200,  30000]
  }

  # include Gnuplot
  # extend self

  # FIXME
  # def plot_pricing!(max=150)
  #   Tempfile.open('pricing', '/tmp') do |f|
  #     (1..max).each { |q| f.puts [q, make_deal(q)[1]/100]*" " }
  #     f.close
  #     gnuplot(f.path, 'doc/pricing.svg')
  #   end
  #   puts 'Updated doc/pricing.svg'
  # end

end
