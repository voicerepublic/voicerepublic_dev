class PurchaseMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.purchase_mailer.invoice.subject
  #
  def invoice(purchase)
    @purchase = purchase
    mail to: purchase.owner.email
  end
end
