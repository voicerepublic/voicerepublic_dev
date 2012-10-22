module PaypalPaymentsHelper
  
  # simple function to put locale in paypals localized image-url
  # used in partial standard_paypal_form
  #
  def locale_paypal
    arg = nil
    case I18n.locale
    when :en
      arg = "en_US"
    when :de
      arg = "de_DE"
    end
    arg ? arg : "en_US"
  end
  
end
