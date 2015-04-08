require File.expand_path('../../../spec/support/paypal_bogus_gateway', __FILE__)

ActiveMerchant::Billing::Base.mode = Settings.activemerchant.billing_mode.to_sym

case Settings.activemerchant.gateway.to_sym

when :paypal_express
  options = Settings.paypal.to_hash
  Settings.express_gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(options)

when :bogus
  # does not come with activemerchant, find it in spec/support/paypal_bogus_gateway
  Settings.express_gateway = ActiveMerchant::Billing::PaypalBogusGateway.new

else
  raise "Unknown Gateway: #{Settings.activemerchant.gateway}"
end
