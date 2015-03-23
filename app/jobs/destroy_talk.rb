class DestroyTalk < MonitoredJob

  def perform
    talk = Talk.find_by(id: opts[:id])
    # fail silently if talk doesn't exist
    return if talk.nil?
    # otherwise fire event end_talk
    talk.destroy!
  end

end
