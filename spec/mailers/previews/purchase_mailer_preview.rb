# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/invoice
  def invoice
    PurchaseMailer.invoice(FactoryGirl.create(:purchase))
  end

end
