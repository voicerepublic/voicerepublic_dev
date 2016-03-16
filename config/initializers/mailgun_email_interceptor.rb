# We need to add the header 'x-mailgun-native-send' to mails that go to voicerepublic.com addresses,
# otherwise it will fail atmails sender verification.

class MailgunEmailInterceptor
  def self.delivering_email(message)
     message.mailgun_headers = {'x-mailgun-native-send' => 'true'} if message.to.first =~ /@voicerepublic.com$/
  end
end

ActionMailer::Base.register_interceptor(MailgunEmailInterceptor)
