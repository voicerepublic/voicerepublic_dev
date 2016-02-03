class MonitoredJob < Struct.new(:opts)

  def perform
    clazz = opts[:model].to_s.camelize.constantize
    obj = clazz.find(opts[:id])
    obj.send(opts[:method])
  end

  # hooks
  def enqueue(job)
    Emitter.dj_callback('enqueue', opts, job)
  end

  def before(job)
    Emitter.dj_callback('before', opts, job)
  end

  def after(job)
    Emitter.dj_callback('after', opts, job)
  end

  def success(job)
    Emitter.dj_callback('success', opts, job)
  end

  def error(job, exception)
    Emitter.dj_callback('error', opts, job)
  end

  def failure(job)
    Emitter.dj_callback('failure', opts, job)
  end

end
