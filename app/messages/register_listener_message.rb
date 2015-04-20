# MANDATORY: goes to faye (in all envs)
#
class RegisterListenerMessage < BaseMessage

  def distribute(talk, session)
    message = { talk_id: talk.id, session: session }
    faye.publish_to('/register/listener', message)
  end

  def condition
    # this prevents the need for lots VCRs in specs
    !Rails.env.test?
  end

end
