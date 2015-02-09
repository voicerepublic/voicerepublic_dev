# OPTIONAL: goes to slack (in production)
#
class KillTalkMessage < BaseMessage

  def slack_message(talk)
    _talk = slack_link(talk.title, url_for(talk))
    "forced to stop (#{talk.id}) #{_talk}"
  end

  def distribute(talk)
    slack.send(slack_message(talk),
               user: 'dj-trigger',
               icon: Settings.slack.icon[:trigger])
  end

end
