# https://github.com/taylorbrooks/closeio
#
# Example response from CloseIO
#
#   * doc/clarion.yml
#
# Incoming Message Example
#
#     {
#       "action": "followup",
#       "email": "max@example.com",
#       "name": "Max Mustermann"
#       "text": "Follow up. Customer Max Mustermann (max@example.com) dropped under 3 credits."
#     }
#
require 'closeio'

class CloseioGate

  include Services::Subscriber
  include Services::LocalConfig

  subscribe x: 'customer_relation'

  def customer_relation(*args)
    body = args.first
    action = body['action']
    if respond_to?(action)
      send(action, body)
    else
      warn "Unknown action #{action}"
    end
  end

  private

  def followup(data)
    leads = []

    email = data['email']
    text = data['text']

    response = closeio.list_leads("email:#{email}")
    leads = response.total_results ? response.data : [create_lead(data)]

    leads.each do |lead|
      create_task(
        'lead' => lead.id,
        'text' => text
      )
    end
  end

  def create_lead(data)
    closeio.create_lead(
      name: data['name'],
      contacts: [{
                   name: data['name'],
                   emails: [{type: "office", email: data['email']}]
                 }]
    )
  end

  def create_task(data)
    closeio.create_task(
      _type: 'lead',
      lead_id: data['lead'],
      assigned_to: config.closio.recipient,
      text: data['text'],
      date: today,
      is_complete: false
    )
  end

  def closeio
    @closeio ||= Closeio::Client.new(config.closio.apikey)
  end

  def today
    Time.now.strftime('%Y-%m-%d')
  end

end
