# OPTIONAL: goes to slack & faye (in production)
#
class GenericDjMessage < BaseMessage

  def distribute(job, signal, opts, message)
    faye.publish_to '/dj', job: job, signal: signal

    return if message.nil?
    slack.send(message,
               icon: Settings.slack.icon[job.queue],
               user:"dj-#{job.queue}")
  end

end
