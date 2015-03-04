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
  has_one :transaction, class_name: 'PurchaseTransaction', as: :source

  serialize :details

  # sets `express_token` and fetches and sets `details`
  def express_token=(token)
    self[:express_token] = token
    if new_record? and token.present?
      self.details = EXPRESS_GATEWAY.details_for(token)
    end
  end

  # also sets `amount` based on deal
  def quantity=(qty)
    self[:quantity], self.amount = make_deal(qty)
  end

  def setup
    response = EXPRESS_GATEWAY.setup_purchase(amount, express_options)
    raise response.params['message'] unless response.success?
    self[:express_token] = response.token
    self # make it chainable
  end

  def redirect_url
    EXPRESS_GATEWAY.redirect_url_for(express_token)
  end

  def process
    response = EXPRESS_GATEWAY.purchase(amount,
                                        ip: ip,
                                        token: express_token,
                                        payer_id: express_payer_id,
                                        currency: CURRENCY)
    raise response.params['message'] unless response.success?
    update_attribute(:purchased_at, Time.now) if response.success?
    create_transaction.process!
    response.success?
  end

  private

  def helpers
    Rails.application.routes.url_helpers
  end

  def express_options
    {
      items: [
        { name: "#{quantity} Talk Credits",
          quantity: 1,
          description: "Package",
          amount: amount }
      ],
      allow_note: false,
      no_shipping: true,
      currency: CURRENCY,
      ip: ip,
      return_url: helpers.new_purchase_url(quantity: quantity),
      cancel_return_url: helpers.purchases_url
    }
  end

end
