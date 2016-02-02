class EndTalk < MonitoredJob

  def perform
    talk = Talk.find_by(id: opts[:id])
    # fail silently if talk doesn't exist
    return if talk.nil?
    # fail silently if talk is past state live
    return if talk.archived? or talk.processing?
    # otherwise fire event end_talk
    talk.end_talk!

    # TODO remove oldschool (covered by MonitoredJob)
    KillTalkMessage.call(talk)
  end

end
