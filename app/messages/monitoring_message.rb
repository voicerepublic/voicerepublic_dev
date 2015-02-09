# OPTIONAL: goes to faye (in dev & production)
#
class MonitoringMessage < BaseMessage

  def distribute(message)
    faye.publish_to('/monitoring', message)
  end

  def condition
    !Rails.env.test?
  end

end
