class UserMailer < ActionMailer::Base
  default from: "noreply@kluuu.com"
  
  def friend_notification(notification)
    @notification = notification
    @user = @notification.user
    I18n.locale = @user.account.preferred_locale
    mail(:to => @user.email, :subject => 'changeme')
  end
  
  def content_notification(notification)
    @notification = notification
    @user = @notification.user
    I18n.locale = @user.account.preferred_locale
    mail(:to => @user.email, :subject => 'changeme')
  end
  
end
