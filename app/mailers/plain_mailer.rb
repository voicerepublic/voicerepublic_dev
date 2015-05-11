class PlainMailer < ApplicationMailer
  layout false

  def welcome(user)
    interpolate! user
    default_mail user.email_with_name, 'patrick.frank@voicerepublic.com', 'plain'
  end

end
