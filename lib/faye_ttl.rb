# FayeTtl will cache incoming messages on selected channels
# for a given time (ttl) and annotate subscription responses
# of those channels with cached data.
#
# Options
# * channels - array of channels
# * ttl - number of seconds, defaults to 10800 (3 hours)
#
class FayeTtl < Struct.new(:opts)

  attr_accessor :history

  def added(e)
    self.history = Hash.new { |h, k| h[k] = [] }
  end

  def incoming(message, callback)
    channel = message['channel']
    if channel.start_with?(*channels)
      message['data']['timestamp'] = Time.now.to_i
      history[channel] << message['data']
    end

    callback.call(message)
  end

  def outgoing(message, callback)
    channel = message['channel']
    if channel =~ /\/meta\/subscribe/
      subscription = message['subscription']
      if subscription.start_with?(*channels)
        messages = history[subscription]
        unless messages.empty?
          messages = messages.delete_if do |m|
            (Time.now.to_i - m['timestamp']) > ttl
          end
          message['ext'] = { 'cached' => messages }
          self.history[subscription] = messages
        end
      end
    end

    callback.call(message)
  end
  
  private

  def ttl
    @ttl ||= opts[:ttl] || 14400
  end

  def channels
    return @channels unless @channels.nil?
    raise "no channels given" if opts[:channels].nil?
    @channels = opts[:channels].tap do |r|
      r.is_a?(Array) ? r : [ r ]
    end
  end
  
end
