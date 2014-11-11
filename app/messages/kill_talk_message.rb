# OPTIONAL: goes to slack (in production)
#
class KillTalkMessage < BaseMessage

  def slack_message(talk)
    _talk = slack_link(talks.title url_for(talk), talk.title)
    "killed talk (#{talk.id}) #{_talk}"
  end

  def distribute(talk)
    slack.send(slack_message(talk),
               user: 'dj-trigger',
               icon: Settings.slack.icon[:trigger])
  end

end
