# expects `model`, `id`, and `method` passed in as options
#
# Will pass a message if the subclass defines these methods:
#
#  * enqueue_message
#  * before_message
#  * success_message
#  * error_message
#  * failure_message
#
class MonitoredJob < Struct.new(:opts)

  def perform
    clazz = opts[:model].to_s.camelize.constantize
    obj = clazz.find(opts[:id])
    obj.send(opts[:method])
  end

  # hooks
  def enqueue(job)
    # newschool
    Simon.says x: 'dj_callbacks', event: 'job_enqueued',
               opts: opts, job: job.attributes
    # TODO remove oldschool
    msg = respond_to?(:enqueue_message) ? send(:enqueue_message, job) : nil
    GenericDjMessage.call(job, 'enqueue', opts, msg)
  end

  def before(job)
    # newschool
    Simon.says x: 'dj_callbacks', event: 'job_before',
               opts: opts, job: job.attributes
    # TODO remove oldschool
    msg = respond_to?(:before_message) ? send(:before_message, job) : nil
    GenericDjMessage.call(job, 'before', opts, msg)
  end

  def after(job)
    # newschool
    Simon.says x: 'dj_callbacks', event: 'job_after',
               opts: opts, job: job.attributes
    # TODO remove oldschool
    msg = respond_to?(:after_message) ? send(:after_message, job) : nil
    GenericDjMessage.call(job, 'after', opts, msg)
  end

  def success(job)
    # newschool
    Simon.says x: 'dj_callbacks', event: 'job_success',
               opts: opts, job: job.attributes
    # TODO remove oldschool
    msg = respond_to?(:success_message) ? send(:success_message, job) : nil
    GenericDjMessage.call(job, 'success', opts, msg)
  end

  def error(job, exception)
    # newschool
    Simon.says x: 'dj_callbacks', event: 'job_error',
               opts: opts, job: job.attributes
    # TODO remove oldschool
    msg = respond_to?(:error_message) ? send(:error_message, job, exception) : nil
    GenericDjMessage.call(job, 'error', opts, msg)
  end

  def failure(job)
    # newschool
    Simon.says x: 'dj_callbacks', event: 'job_failure',
               opts: opts, job: job.attributes
    # TODO remove oldschool
    msg = respond_to?(:failure_message) ? send(:failure_message, job) : nil
    GenericDjMessage.call(job, 'failure', opts, msg)
  end

end
