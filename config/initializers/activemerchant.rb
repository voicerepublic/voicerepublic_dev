ActiveMerchant::Billing::Base.mode = Settings.activemerchant.billing_mode.to_sym

case Settings.activemerchant.gateway.to_sym

when :paypal_express
  options = Settings.paypal.to_hash
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(options)

when :bogus
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::BogusGateway.new

else
  raise "Unknown Gateway: #{Settings.activemerchant.gateway}"
end
