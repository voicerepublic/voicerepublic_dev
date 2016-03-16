class MailgunEmailInterceptor
  def self.delivering_email(message)
    message['x-mailgun-native-send'] = true if message.to ~= /^.*@voicerepublic.com$/]
  end
end

ActionMailer::Base.register_interceptor(MailgunEmailInterceptor)
