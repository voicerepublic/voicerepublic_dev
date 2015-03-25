class FayeSquasher < Struct.new(:rules)

  def outgoing(message, callback)

    rules.each do |channel, pattern|
      if message['channel'].match(pattern)
        message['data'] ||= {}
        message['data']['channel'] = message['channel']
        message['channel'] = channel
      end
    end

    callback.call(message)
  end

end
