# AudioProcessor inherits from Fidelity::ChainRunner to overwrite its
# callbacks.
#
# It will send messages to Faye using two namespaces:
#
# * `talk.public_channel` - to announce any state changes publicly
#
class AudioProcessor < Fidelity::ChainRunner

  # TODO oldschool: a lot to cleanup here
  # TODO maybe cover uploads in their own channel

  attr_accessor :talk

  private

  def before_chain
    # TODO oldschool: remove (should by covered by talk_transitions)
    LiveServerMessage.call talk.public_channel, { event: 'Process' }
    @t0 = Time.now.to_i

    # uploading might take a while, so we'll take the time
    t2 = Time.now.to_i
    talk.send(:upload_flvs!)
    delta_t2 = Time.now.to_i - t2
  end

  def before_strategy(index, name)
    attrs = { id: talk.id, run: name,
              index: index, total: chain.size }
    Simon.says x: 'audio_progress', event: 'start_processing', details: attrs
    ProgressMessage.call(talk.public_channel, event: 'StartProcessing', talk: attrs)

    @t1 = Time.now.to_i
  end

  def after_strategy(index, name)
    delta_t1 = Time.now.to_i - @t1
    attrs = { id: talk.id, run: name,
              index: index, total: chain.size,
              elapsed: delta_t1 }
    Simon.says x: 'audio_progress', event: 'finished_processing', details: attrs
    ProgressMessage.call(talk.public_channel, event: 'FinishProcessing', talk: attrs)
  end

  def after_chain
    # uploading might take a while, so we'll take the time
    t2 = Time.now.to_i
    talk.send(:upload_results!)
    delta_t2 = Time.now.to_i - t2

    delta_t0 = Time.now.to_i - @t0
    # TODO oldschool: remove (should by covered by talk_transitions)
    LiveServerMessage.call(talk.public_channel, { event: 'Archive',
                                                  links: talk.media_links })
  end

end
