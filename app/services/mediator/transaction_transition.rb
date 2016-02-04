class Mediator
  module TransactionTransition

    extend self
    include Services::LocalConfig

    TEMPLATES = {
      :deduct => "Admin #{admin} deducted #{quantity} credits from #{name} with comment: #{comment}",
      :undo   => "Admin #{admin} undid a booking for #{name}, by deducting #{quantity} credits " +
                 "and giving EUR #{payment} back with comment: #{comment}",
      :donate => "Admin #{admin} donated #{quantity} credits to #{name} with comment: #{comment}",
      :sale   => "Admin #{admin} sold #{amount} credits for EUR #{payment} to #{name} with comment: #{comment}",
      :track  => "Admin #{admin} tracked a sale of EUR #{payment} to #{name}, " +
                 "restrospectively with comment: #{comment}",
      :noop   => "Admin #{admin} contemplated about the meaning of life with comment: #{comment}",
      :weird  => "Admin #{admin} and #{name} seem to be in cahoots. Alert the authorities, " +
                 "fishy transaction going on with comment: #{comment}"
    }


    def call(*args)
      body = args.shift
      details = body['details']
      event = details['event']
      type = details['type']

      message = { x: 'notification'}

      case event
      when %w(processing closed close)
        case type
        when 'PurchaseTransaction'
          # TODO
          user = 'Someone'
          product = 'something'
          price = 'some amount'
          message.merge channel: config.slack.revenue_channel,
                        text: '%s purchased %s for %s.' %
                        [user, product, price]

        when 'ManualTransaction'
          admin    = details['admin']
          quantity = details['quantity'].to_i
          payment  = details['payment'].to_i
          name     = details['username']
          comment  = details['comment']

          movement = :unknown
          movement = :deduct if quantity < 0  and payment == 0
          movement = :undo   if quantity < 0  and payment < 0
          movement = :donate if quantity > 0  and payment == 0
          movement = :sale   if quantity > 0  and payment > 0
          movement = :track  if quantity == 0 and payment > 0
          movement = :noop   if quantity == 0 and payment == 0
          movement = :weird  if quantity < 0  and payment > 0
          movement = :weird  if quantity >= 0 and payment < 0

          template = TEMPLATES[movement]
          template ||= "Unknown movement #{movement}"
          message.merge text: eval('"' + template + '"')

        else
          message.merge text: "Unknown type #{type}"
        end
      else
        message.merge text: "Unknown transition #{event}"
      end

      message
    end

  end
end
  # NOTE trouble to refactor this into a submodule, since it needs
  # access to `config` and `publish`
