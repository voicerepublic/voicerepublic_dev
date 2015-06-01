# OPTIONAL: goes to slack (in production)
#
class PurchaseMessage < BaseMessage

  include ActionView::Helpers::NumberHelper

  def slack_message(purchase)
    _user = slack_link(purchase.owner.name, url_for(purchase.owner))
    _price = number_to_currency(purchase.total/100.0,
                                unit: Purchase::CURRENCY, format: '%u %n')

    "#{_user} purchased #{purchase.product} for #{_price}"
  end

  def distribute(purchase)
    slack.send slack_message(purchase),
               user: 'Revenue Agent',
               icon: ':moneybag:',
               chan: Settings.slack.revenue_channel
  end

end
