# expects `model`, `id`, and `method` passed in as options
#
# Will publish ALL events via PrivatePub.
#
# Will notify slack if the subclass defines these methods:
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
    publish job: job, signal: 'enqueue'

    if respond_to?(:enqueue_message) && msg = send(:enqueue_message, job)
      slack.send msg, icon: Settings.slack.icon[job.queue], user:"dj-#{job.queue}"
    end
  end

  def before(job)
    publish job: job, signal: 'before'

    if respond_to?(:before_message) && msg = send(:before_message, job)
      slack.send msg, icon: Settings.slack.icon[job.queue], user:"dj-#{job.queue}"
    end
  end

  def after(job)
    publish job: job, signal: 'after'

    if respond_to?(:after_message) && msg = send(:after_message, job)
      slack.send msg, icon: Settings.slack.icon[job.queue], user:"dj-#{job.queue}"
    end
  end

  def success(job)
    publish job: job, signal: 'success'

    if  respond_to?(:success_message) && msg = send(:success_message, job)
      slack.send msg, icon: Settings.slack.icon[job.queue], user:"dj-#{job.queue}"
    end
  end

  def error(job, exception)
    publish job: job, signal: 'error', exception: exception

    if respond_to?(:error_message) && msg = send(:error_message, job, exception)
      slack.send msg, icon: Settings.slack.icon[job.queue], user:"dj-#{job.queue}"
    end
  end

  def failure(job)
    publish job: job, signal: 'failure'

    if respond_to?(:failure_message) && msg = send(:failure_message, job)
      slack.send msg, icon: Settings.slack.icon[job.queue], user: "dj-#{job.queue}"
    end
  end

  # internal
  def publish(event)
    PrivatePub.publish_to '/dj', { opts: opts, event: event }
  end

  def slack
    @slack ||= Slack.new("#vr_sys_#{Settings.slack.tag || 'default'}", 'dj',
                         Settings.slack.icon[:default])
  end

end
