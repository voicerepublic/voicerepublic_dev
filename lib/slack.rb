class Slack < Struct.new(:chan, :user, :icon)

  def send(message, opts={})

    _chan = opts.delete(:chan) || chan
    _user = opts.delete(:user) || user
    _icon = opts.delete(:icon) || icon

    url = "https://voicerepublic.slack.com/services/hooks/incoming-webhook"+
          "?token=#{Settings.slack.token}"
    # message = "#{Settings.slack.tag} #{message}" if Settings.slack.tag

    payload = opts.merge({
      channel:    _chan,
      username:   _user,
      text:       message,
      icon_emoji: _icon
    })

    # OLDSCHOOL
    json = JSON.unparse(payload)
    cmd = "curl -X POST --data-urlencode 'payload=#{json}' '#{url}' 2>&1"
    %x[ #{cmd} ]

    # NEWSCHOOL
    # file = Tempfile.new(['slack', '.json'])
    # json = JSON.unparse(payload)
    # #payload = 'payload=' + json
    # #p payload
    # #file.write payload
    # file.write json
    # file.close
    # cmd = "curl -X POST --data-urlencode payload=@#{file.path} '#{url}'"# 2>&1"
    # p cmd
    # %x[ #{cmd} ]
    # #file.unlink
  end

end
