# goes to faye and slack (in production)
#
class TalkEventMessage < BaseMessage

  def slack_message(talk, event)
    _talk  = slack_link(talk.title, talk_url(talk))
    _venue = slack_link(talk.venue.title, venue_url(talk.venue))
    _user  = slack_link(talk.venue.user.name, user_url(talk.venue.user))

    case event
    when :start_talk
      "NOW LIVE (#{talk.id}) #{_talk} in #{_venue} by #{_user}"
    when :archived
      "JUST ARCHIVED (#{talk.id}) #{_talk} in #{_venue} by #{_user}"
    else
      "Don't know how to format talk event `#{event}` for talk #{talk.id}"
    end
  end

  def distribute(talk, *args)
    event = args.last

    faye.publish_to '/event/talk', { talk: talk.attributes, args: args }

    slack.send(slack_message(talk, event))
  end

end
