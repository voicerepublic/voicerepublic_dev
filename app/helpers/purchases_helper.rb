module PurchasesHelper

  include Pricing

  def paypal_button
    image_tag 'https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif'
  end

end
