require "rails_helper"

RSpec.describe PurchaseMailer, type: :mailer do
  describe "invoice" do

    let(:purchase) { FactoryGirl.create(:purchase) }
    let(:mail) { PurchaseMailer.invoice(purchase) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t('purchase_mailer.invoice.subject'))
      expect(mail.to).to eq([purchase.owner.email])
      expect(mail.from).to eq(['service@voicerepublic.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Thank you")
    end
  end

end
