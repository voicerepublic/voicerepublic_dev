require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

puts 'Booting rails... (sigh)'
require File.expand_path(File.join(%w(.. .. .. config environment)), __FILE__)

# The ControlCenter ties all other services together.
#
#
# NOTE `venue_event_down` will be forwarded by BumpyBridge and
# modified by FayeEigenfan hence you need to provide a `channel` to
# publish eventually to.
#
class ControlCenter

  include Services::Subscriber
  include Services::Publisher

  subscribe x: 'venue_event_up'
  subscribe x: 'venue_transition'
  subscribe x: 'talk_transition'

  # messages from browsers on venues#show, e.g.
  #
  #   {"event"=>"start", "talk_id"=>4147, "channel"=>"/up/user/7/venue/124"}
  #
  def venue_event_up(*args)
    body = JSON.parse(args.shift)
    event = body['event']
    case event
    when 'start'
      talk_id = body['talk_id']
      talk = Talk.find(talk_id)
      talk.start_talk! if talk.can_start_talk?
    else
      puts "Unhandled message on venue_event_up: #{body.inspect}"
      publish x: 'unhandled_messages',
              original_x: 'venue_event_up',
              original_body: body
    end
  end

  def venue_transition(*args)
    pp body = args.shift
    #publish x: 'venue_event_down',
    #        channel: "/down/venues/#{venue.id}"
  end

  def talk_transition(*args)
    pp body = args.shift

    talk_id = body['details']['talk']['id']
    venue_id = body['details']['venue']['id']
    event = body['details']['event'].last

    publish x: 'venue_event_down',
            event: event,
            talk_id: talk_id,
            channel: "/down/venue/#{venue_id}"
  end

end

# SERVICE ControlCenter
# venue_transition ->
# venue_event_up ->
# -> venue_event_down
