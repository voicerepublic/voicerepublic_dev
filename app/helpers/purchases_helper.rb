module PurchasesHelper

  include Pricing

  def paypal_button_url
    'https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif'
  end

  def paypal_button
    image_tag paypal_button_url
  end

end
