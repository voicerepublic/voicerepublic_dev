class ApplicationMailer < ActionMailer::Base
  default from: Settings.devise.from_address
  layout 'mailer'
end
