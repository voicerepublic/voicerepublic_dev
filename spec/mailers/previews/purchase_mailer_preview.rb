# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
#
# This is executed in environment `development`!
#
class PurchaseMailerPreview < ActionMailer::Preview

  def invoice
    PurchaseMailer.invoice(Purchase.last)
  end

end
