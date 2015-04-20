# MANDATORY: goes to faye (in all envs)
#
class RegisterListenerMessage < BaseMessage

  def distribute(talk, session)
    message = { talk_id: talk.id, session: session }
    faye.publish_to('/register/listener', message)
  end

  def condition
    true # always
  end

end
