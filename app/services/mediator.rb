require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

require File.expand_path(File.join(%w(.. mediator dj_callback)), __FILE__)
require File.expand_path(File.join(%w(.. mediator talk_transition)), __FILE__)
require File.expand_path(File.join(%w(.. mediator transaction_transition)), __FILE__)

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
  include Services::AutoPublish # publishes the return value of handlers

  subscribe x: 'dj_callback', handler: DjCallback
  subscribe x: 'talk_transition', handler: TalkTransition
  subscribe x: 'user_registration'

  subscribe x: 'transaction_transition', handler: TransactionTransition


  def user_registration(info, prop, body, opts)
    name = body['details']['user']['name']
    email = body['details']['user']['email']
    message = "%s just registered with %s." % [name, email]

    { x: 'notification', text: message }
  end


  def run
    notify text: 'Mediator started.'
    super
  end

end
