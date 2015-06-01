class PlainMailer < ApplicationMailer
  layout false

  def welcome(user)
    interpolate! user
    subject = I18n.t('plain_mailer.welcome.subject', user_firstname: user.firstname)
    from = 'patrick.frank@voicerepublic.com'
    default_mail user.email_with_name, from, 'plain', subject
  end

end
