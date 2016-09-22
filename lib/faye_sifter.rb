class FayeSifter

  def initialize
    @last = Hash.new { |h, k| h[k] = 0 }
  end

  def incoming(message, callback)
    channel = message['channel']
    now = message['data'] && message['data']['now']

    if now # the message has a timestamp
      if @last[channel] >= now # but the message is too old
        puts 'SIFT %s %s <= %s' % [channel, now, @last[channel]]
        return callback.call(nil)
      else
        @last[channel] = now
      end
    end

    callback.call(message)
  end

end
