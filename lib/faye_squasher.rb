class FayeSquasher < Struct.new(:rules)

  def incoming(message, callback)
    rules.each do |channel, pattern|
      if message['channel'].match(pattern)
        # puts "SQUASH #{message['channel']} => #{channel}"
        message['data'] ||= {}
        message['data']['channel'] = message['channel']
        message['channel'] = channel
      end
    end

    callback.call(message)
  end

end
