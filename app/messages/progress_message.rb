# MANDATORY: goes to faye
#
class ProgressMessage < BaseMessage

  def distribute(channel, message)
    puts message
    faye.publish_to(channel, message)
  end

  def condition
    true
  end

end
