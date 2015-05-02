# This is modeled after DHHs post on "Put chubby models on a diet with
# concerns":
# https://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns
# It extracts a slice of the user model that doesn’t seem part of its essence

require 'active_support/concern'

# Send Welcome Instructions and Personal Welcome Mail
module Welcomed
  extend ActiveSupport::Concern
  included do
    #after_create  :send_welcome_instructions_mail
    after_create  :send_personal_welcome_mail
  end


  private
  def send_welcome_instructions_mail
    raise 'TODO: send_welcome_instructions_mail'
  end

  def send_personal_welcome_mail
    PlainMailer.delay(queue: 'mail',
                      run_at: 32.minutes.from_now)
               .welcome(self)
  end
end
