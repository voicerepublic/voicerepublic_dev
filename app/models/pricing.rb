module Pricing

  BUSINESS = %w( B5 B10 B25 B50 B100 )
  NONPROFIT = %w( NP5 NP10 NP25 )

  # returns quantity, price in cents, total in cents
  PACKAGES = {
    'B5' =>   [ 'B5',     5, 3000,  15000],
    'B10' =>  [ 'B10',   10, 2500,  25000],
    'B25' =>  [ 'B25',   25, 1800,  45000],
    'B50' =>  [ 'B50',   50, 1500,  75000],
    'B100' => [ 'B100', 100, 1200, 120000],

    'NP5' =>  [ 'NP5',    5, 1400,   7000],
    'NP10' => [ 'NP10',  10, 1200,  12000],
    'NP25' => [ 'NP25',  25,  800,  20000]
  }

end
