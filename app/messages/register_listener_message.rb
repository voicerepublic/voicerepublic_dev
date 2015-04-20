# MANDATORY: goes to faye (in all envs)
#
class RegisterListenerMessage < BaseMessage

  def distribute(talk_channel, session_id)
    message = { talk: talk_channel, session: session_id }
    faye.publish_to('/register/listener', message)
  end

  def condition
    true # always
  end

end
