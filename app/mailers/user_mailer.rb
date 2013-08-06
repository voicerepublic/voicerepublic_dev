class UserMailer < ActionMailer::Base
  default from: "info@kluuu.com"
  
  def friend_notification(notification)
    @notification = notification
    @user = @notification.user
    I18n.locale = @user.account.preferred_locale
    mail(:to => @user.email, :subject => t('mailers.your_friend_took_action'))
  end
  
  def content_notification(notification)
    @notification = notification
    @user = @notification.user
    I18n.locale = @user.account.preferred_locale
    mail(:to => @user.email, :subject => t('mailers.activity_around_you'))
  end
  
end
