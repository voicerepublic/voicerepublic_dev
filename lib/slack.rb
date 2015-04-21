class Slack < Struct.new(:chan, :user, :icon)

  URL = "https://voicerepublic.slack.com" +
        "/services/hooks/incoming-webhook" +
        "?token=#{Settings.slack.token}"

  def send(message, opts={})
    _chan = opts.delete(:chan) || chan
    _user = opts.delete(:user) || user
    _icon = opts.delete(:icon) || icon

    payload = opts.merge({
      channel:    _chan,
      username:   _user,
      text:       message,
      icon_emoji: _icon
    })

    faraday.post URL, payload: JSON.unparse(payload)
  end

  private

  def faraday
    @faraday ||= Faraday.new(url: URL) do |f|
      f.request  :url_encoded             # form-encode POST params
      f.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

end
