class Forward < MonitoredJob

  def perform
    talk = Talk.find(opts[:id])
    # TODO check if forward_url is valid (head request?)
    LiveServerMessage.call talk.public_channel,
                           event: 'Forward',
                           forward_url: talk.forward_url
  end

end
