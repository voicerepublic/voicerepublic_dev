class Slack < Struct.new(:chan, :user, :icon)

  def send(message, opts={})

    _chan = opts[:chan] || chan
    _user = opts[:user] || user
    _icon = opts[:icon] || icon

    url = "https://voicerepublic.slack.com/services/hooks/incoming-webhook"+
          "?token=#{Settings.slack.token}"
    # message = "#{Settings.slack.tag} #{message}" if Settings.slack.tag

    payload = {
      channel:    _chan,
      username:   _user,
      text:       message,
      icon_emoji: _icon
    }

    json = JSON.unparse(payload)
    cmd = "curl -X POST --data-urlencode 'payload=#{json}' '#{url}' 2>&1"
    %x[ #{cmd} ]
  end

end
