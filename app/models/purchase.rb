# Attributes:
# * id [integer, primary, not null] - primary key
# * amount [integer] - TODO: document me
# * created_at [datetime] - creation time
# * details [text] - TODO: document me
# * express_payer_id [string] - TODO: document me
# * express_token [string] - TODO: document me
# * ip [string] - TODO: document me
# * owner_id [integer] - belongs to :owner
# * purchased_at [datetime] - TODO: document me
# * quantity [integer, default=1] - TODO: document me
# * updated_at [datetime] - last update time
class Purchase < ActiveRecord::Base

  include Pricing

  CURRENCY = 'EUR'

  belongs_to :owner, class_name: 'User', counter_cache: true
  has_one :purchase_transaction, as: :source

  serialize :details

  # sets `express_token` and fetches and sets `details`
  def express_token=(token)
    self[:express_token] = token
    if new_record? and token.present?
      self.details = Settings.express_gateway.details_for(token)
      self.country = details.params['payer_country']
    end
  end

  def product=(product)
    self[:product], self.quantity, self.amount, self.total = PACKAGES[product]
  end

  def setup
    response = Settings.express_gateway.setup_purchase(total, express_options)
    raise response.params['message'] unless response.success?
    self[:express_token] = response.token
    self # make it chainable
  end

  def redirect_url
    Settings.express_gateway.redirect_url_for(express_token)
  end

  def process
    response = Settings.express_gateway.purchase(total,
                                        ip: ip,
                                        token: express_token,
                                        payer_id: express_payer_id,
                                        currency: CURRENCY)
    raise response.params['message'] unless response.success?
    update_attribute(:purchased_at, Time.now) if response.success?
    create_purchase_transaction.process!
    PurchaseMailer.invoice(self).deliver_now
    response.success?
  end

  def indicate_vat?
    country == 'CH'
  end

  private

  def helpers
    Rails.application.routes.url_helpers
  end

  def express_options
    {
      items: [
        { name: "VR Talk Credit",
          quantity: quantity,
          description: "Bundle #{product}",
          amount: amount }
      ],
      allow_note: false,
      no_shipping: true,
      currency: CURRENCY,
      ip: ip,
      return_url: helpers.new_purchase_url(product: product),
      cancel_return_url: helpers.purchases_url
    }
  end

end
