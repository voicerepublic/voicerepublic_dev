# goes to faye (in all environments)
#
class LiveClientMessage < BaseMessage

  def distribute(channel, message)
    faye.publish_to(channel, message)
  end

  def condition
    true # always
  end

end
