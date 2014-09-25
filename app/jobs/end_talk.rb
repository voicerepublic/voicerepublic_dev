class EndTalk < MonitoredJob

  include Rails.application.routes.url_helpers

  def perform
    talk = Talk.find_by(id: opts[:id])
    # fail silently if talk doesn't exist
    return if talk.nil?
    # fail silently if talk is past state live
    return if talk.archived? or talk.processing?
    # otherwise fire event end_talk
    talk.end_talk!

    slack.send "killed talk (#{talk.id}) <#{url_for(talk)}|#{talk.title}>",
               user: "dj-trigger", icon: Settings.slack.icon[:trigger]
  end

end
