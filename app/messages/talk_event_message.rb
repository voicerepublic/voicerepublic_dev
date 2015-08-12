# OPTIONAL: goes to faye and slack (in production)
#
class TalkEventMessage < BaseMessage

  def slack_message(talk, args)
    current_state, new_state, event = args

    intro = "Don't know how to format talk event `#{event}` for"

    intro = "Now live" if event == :start_talk

    intro = "Just archived" if event == :archive

    intro = "Has been created" if event == :prepare

    intro = "Started processing" if event == :process

    intro = "Has been ended" if event == :end_talk

    _talk  = slack_link(talk.title, talk_url(talk))
    _series = slack_link(talk.series.title, series_url(talk.series))
    _user  = slack_link(talk.series.user.name, user_url(talk.series.user))

    "#{intro} (#{talk.id}) #{_talk} in #{_series} by #{_user}"
  end

  def distribute(talk, *args)
    faye.publish_to '/event/talk', { talk: talk.attributes, args: args }

    slack.send(slack_message(talk, args))
  end

end
