require 'faraday'

require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class Slacker

  include Services::Subscriber  # provides `subscribe`
  include Services::LocalConfig # provides `config`

  subscribe x: 'notification'

  def notification(info, prop, body, opts)
    slack(body)
  end

  private

  def slack(message={})
    return if message['text'].nil? # nothing to say

    defaults = {
      'channel' => config.slack.channel,
      'username' => config.slack.username || 'Simon',
      'icon_emoji' => config.slack.icon_emoji || ':squirrel:'
    }
    payload = defaults.merge(message)

    puts '%s %s -> %s: %s' % [ Time.now.strftime('%H:%M'),
                               payload['username'],
                               payload['channel'],
                               payload['text'] ]

    return unless config.slack.channel

    faraday.post slack_url, payload: JSON.unparse(payload)
  end

  def faraday
    @faraday ||= Faraday.new(url: slack_url) do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end
  end

  def slack_url
    @slack_url ||=
      "https://voicerepublic.slack.com" +
      "/services/hooks/incoming-webhook" +
      "?token=" + config.slack.token
  end

end
