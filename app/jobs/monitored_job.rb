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
    cmd = job.handler.match(/struct:(.*)/).to_a[1]
    msg = "#{job.queue}: enqueued #{cmd} #{opts[:id]}"
    slack msg, job.queue
  end

  def before(job)
    publish job: job, signal: 'before'
    cmd = job.handler.match(/struct:(.*)/).to_a[1]
    msg = "#{job.queue}: starting #{cmd} #{opts[:id]}"
    slack msg, job.queue
  end

  # if we have success and failure below, we might not need the after
  # callback as well
  # def after(job)
  #   publish job: job, signal: 'after'
  #   cmd = job.handler.match(/struct:(.*)/).to_a[1]
  #   msg = "#{job.queue}: finished #{cmd} #{opts[:id]}"
  #   slack msg, job.queue
  # end

  def success(job)
    publish job: job, signal: 'success'
    cmd = job.handler.match(/struct:(.*)/).to_a[1]
    msg = "#{job.queue}: succeeded with #{cmd} #{opts[:id]}"
    slack msg, job.queue
  end

  def error(job, exception)
    publish job: job, signal: 'error', exception: exception
    cmd = job.handler.match(/struct:(.*)/).to_a[1]
    msg = "#{job.queue}: error during #{cmd} #{opts[:id]} with #{exception.inspect}"
    slack msg, job.queue
  end

  def failure(job)
    publish job: job, signal: 'failure'
    cmd = job.handler.match(/struct:(.*)/).to_a[1]
    msg = "#{job.queue}: failed on #{cmd} #{opts[:id]}"
    slack msg, job.queue
  end

  # internal
  def publish(event)
    PrivatePub.publish_to '/dj', { opts: opts, event: event }
  end

  def slack(message, queue='default')
    return unless Settings.slack.dj
    url = "https://voicerepublic.slack.com/services/hooks/incoming-webhook"+
          "?token=#{Settings.slack.token}"
    message = "#{Settings.slack.tag} message" if Settings.slack.tag
    payload = {
      channel: '#voicerepublic_tech',
      username: 'dj',
      text: message,
      icon_emoji: Settings.slack.icon[queue]
    }
    cmd = "curl -X POST --data-urlencode 'payload=#{JSON.unparse(payload)}' '#{url}' 2>&1"
    %x[ #{cmd} ]
  end

end
