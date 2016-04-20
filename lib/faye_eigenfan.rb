class FayeEigenfan < Struct.new(:channels)

  def incoming(message, callback)
    channels.each do |channel|
      if message['channel'] == channel
        eigen_channel = message['data'].delete('channel')
        message['channel'] = eigen_channel
      end
    end

    callback.call(message)
  end

end
