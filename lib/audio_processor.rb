# AudioProcessor inherits from Fidelity::ChainRunner to overwrite its
# callbacks.
#
# It will send messages to Faye using two namespaces:
#
# * `talk.public_channel` - to announce any state changes publicly
# * `'/monitoring'` - to propagate more detailed information to the
#   backoffice dashboard
#
class AudioProcessor < Fidelity::ChainRunner

  attr_accessor :talk

  private

  def before_chain
    announce event: 'Process'
    monitor event: 'Process', talk: talk.attributes
    @t0 = Time.now.to_i
  end

  def before_strategy(index, name)
    attrs = { id: talk.id, run: name, index: index, total: chain.size }
    monitor event: 'StartProcessing', talk: attrs
    @t1 = Time.now.to_i
  end

  def after_strategy(index, name)
    delta_t1 = Time.now.to_i - @t1
    attrs = { id: talk.id, run: name, index: index, total: chain.size }
    monitor event: 'FinishProcessing', talk: attrs, elapsed: delta_t1
  end

  def after_chain
    # uploading might take a while, so we'll take the time
    t2 = Time.now.to_i
    monitor event: 'StartUpload', talk: talk.attributes
    talk.send(:upload!)
    delta_t2 = Time.now.to_i - t2
    monitor event: 'FinishUpload', talk: talk.attributes, elapsed: delta_t2

    # this will be pretty quick
    talk.send(:cleanup!)

    delta_t0 = Time.now.to_i - @t0
    announce event: 'Archive', links: talk.media_links
    monitor event: 'Archive', talk: talk.attributes, elapsed: delta_t0
  end

  # publicly announce a state change
  def announce(payload)
    PrivatePub.publish_to(talk.public_channel, payload)
  end

  # propagate to monitoring namespace
  def monitor(payload)
    PrivatePub.publish_to('/monitoring', payload)
  end

end
