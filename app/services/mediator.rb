require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

# The Mediator's responsibility is to subscribe to relevant channels
# and transform events into human readable notifications and forward
# those to a notification channel.
#
# Messages in the `notifications` channel will be picked up an
# forwarded to some communication channel like Slack, IRC or Text
# Messages. Best practice is to use different channels for regocnized
# and yet unrecognized (generic/unformatted) messages.
#
class Mediator

  include Services::Subscriber  # provides `subscribe`
  include Services::Publisher   # provides `publish`
  include Services::LocalConfig # provides `config`

  subscribe x: 'dj_callbacks', handler: :dj_callback
  subscribe x: 'purchase_events', handler: :pruchase_event
  subscribe x: 'talk_transitions', handler: :talk_transition

  # TODO decide on alternative signature
  # subscribe :dj_callback, x: 'dj_callbacks', autopub: { x: 'notifications' }

  def dj_callback(info, prop, body)
    # TODO notify ...
  end

  def purchase_event(info, prop, body)
    # TODO notify ...
  end

  def talk_transition(info, prop, body)
    # TODO notify ...
  end

  private

  def notify(msg)
    publish exchange: 'notifications', message: msg
  end

end
