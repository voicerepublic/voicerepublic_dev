# Attributes:
# * id [integer, primary, not null] - primary key
# * amount [integer] - TODO: document me
# * created_at [datetime] - creation time
# * details [text] - TODO: document me
# * express_payer_id [string] - TODO: document me
# * express_token [string] - TODO: document me
# * ip [string] - TODO: document me
# * purchased_at [datetime] - TODO: document me
# * quantity [integer, default=1] - TODO: document me
# * updated_at [datetime] - last update time
class Purchase < ActiveRecord::Base

  include Pricing

  CURRENCY = 'EUR'

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

  def process
    response = EXPRESS_GATEWAY.purchase(amount,
                                        ip: ip,
                                        token: express_token,
                                        payer_id: express_payer_id,
                                        currency: CURRENCY)
    raise response.params['message'] unless response.success?
    update_attribute(:purchased_at, Time.now) if response.success?
    # TODO increase credits, create transaction
    response.success?
  end

end
