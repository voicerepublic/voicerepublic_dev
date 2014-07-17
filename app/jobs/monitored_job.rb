# expects `model`, `id`, and `method` passed in as options
class MonitoredJob < Struct.new(:opts)

  def perform
    clazz = opts[:model].to_s.camelize.constantize
    obj = clazz.find(opts[:id])
    obj.send(opts[:method])
  end

  # hooks
  def enqueue(job)
    publish job: job, signal: 'enqueue'
    slack "enqueued job #{job.inspect} with opts #{opts.inspect}"
  end

  def before(job)
    publish job: job, signal: 'before'
    slack "before job #{job.inspect} with opts #{opts.inspect}"
  end

  def after(job)
    publish job: job, signal: 'after'
    slack "after job #{job.inspect} with opts #{opts.inspect}"
  end

  def success(job)
    publish job: job, signal: 'success'
    slack "success for job #{job.inspect} with opts #{opts.inspect}"
  end

  def error(job, exception)
    publish job: job, signal: 'error', exception: exception
    slack "error #{exception.inspect} for job #{job.inspect} with opts #{opts.inspect}"
  end

  def failure(job)
    publish job: job, signal: 'failure'
    slack "failure on job #{job.inspect} with opts #{opts.inspect}"
  end

  # internal
  def publish(event)
    PrivatePub.publish_to '/dj', { opts: opts, event: event }
  end

  def slack(message)
    url = "https://voicerepublic.slack.com/services/hooks/incoming-webhook"+
          "?token=#{Settings.slack_token}"
    payload = {
      channel: '#voicerepublic_tech',
      username: 'dj',
      text: message,
      icon_emoji: ':vr:'
    }
    cmd = "curl -X POST --data-urlencode 'payload=#{JSON.unparse(payload)}' '#{url}'"
    %x[ #{cmd} ]
  end

end
