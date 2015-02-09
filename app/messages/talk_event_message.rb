# OPTIONAL: goes to faye and slack (in production)
#
class TalkEventMessage < BaseMessage

  def slack_message(talk, args)
    current_state, new_state, event = args

    intro = "Don't know how to format talk event `#{event}` for"

    intro = "Now live" if event == :start_talk

    intro = "Now live but has not started" if
      args == [:prelive, :halflive, :start_talk]

    intro = "Now started" if args == [:halflive, :live, :start_talk]

    intro = "Just archived" if event == :archived

    _talk  = slack_link(talk.title, talk_url(talk))
    _venue = slack_link(talk.venue.title, venue_url(talk.venue))
    _user  = slack_link(talk.venue.user.name, user_url(talk.venue.user))

    "#{intro} (#{talk.id}) #{_talk} in #{_venue} by #{_user}"
  end

  def distribute(talk, *args)
    faye.publish_to '/event/talk', { talk: talk.attributes, args: args }

    slack.send(slack_message(talk, args))
  end

end
