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
  end

  def before(job)
    publish job: job, signal: 'before'
  end

  def after(job)
    publish job: job, signal: 'after'
  end

  def success(job)
    publish job: job, signal: 'success'
  end

  def error(job, exception)
    publish job: job, signal: 'error', exception: exception
  end

  def failure(job)
    publish job: job, signal: 'failure'
  end

  # internal
  def publish(event)
    PrivatePub.publish_to '/dj', { opts: opts, event: event }
  end
  
end
