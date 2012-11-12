require 'safe_update_rates'

#Set default Currency in the Money Gem
Money.default_currency = Money::Currency.new("EUR")

#Set default Bank in the Money Gem and load the rates once at startup
Money.default_bank = EuCentralBank.new

SafeUpdateRates.safe_update_rates