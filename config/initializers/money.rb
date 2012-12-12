# encoding : utf-8

MoneyRails.configure do |config|

# To set the default currency
#
  config.default_currency = :eur

  # Set default bank object
  #
  config.default_bank = EuCentralBank.new
end

module ExchangeRates
  def self.update(i=0)
    unless i < 4
      begin
        Money.default_bank.update_rates
        Money.default_bank.save_rates(File.join(Rails.root,'log',"exchange_rates_#{Time.now.to_i}.xml"))
      rescue Exception => e
        Rails.logger.error("Money - initializer: #{e.to_s}")
        sleep 1
        ExchangeRates.update(i += 1)
      end
    else
      Rails.logger.warn("Money - initializer: could not fetch exchange_rates  - ignoring!")
      latest_xml = Dir.glob(File.join(Rails.root,"tmp","exchange_rates_*"))[-1]
      if latest_xml && File.readable?(latest_xml)
        Money.default_bank.update_rates(latest_xml)
        return true
      else
        return false
      end
    end

  end

end

ExchangeRates.update

