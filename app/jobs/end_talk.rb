class EndTalk < MonitoredJob
  def perform
    talk = Talk.find(opts[:id])
    # fail silently if talk is past state live
    return if talk.archived? or talk.processing?
    # otherwise fires event end_talk     
    talk.end_talk!
  end
end
