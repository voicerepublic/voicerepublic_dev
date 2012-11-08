class Notification::Base < ActiveRecord::Base
  include ActionView::Helpers::JavaScriptHelper
  include Rails.application.routes.url_helpers

  ALERTS          = %w{ Notification::NewBookmark
                        Notification::NewComment
                        Notification::NewFollower
                        Notification::NewRating
                        Notification::MissedCall }
                        
  CONTENT_ALERTS  = %w{ Notification::NewKluuu 
                        Notification::NewStatus }
                        
  CALL_ALERTS     = %w{ Notification::CallEnded 
                        Notification::CallAccepted
                        Notification::CallRejected }

  NEWS            =     [ALERTS,CONTENT_ALERTS].flatten
  
  attr_accessible :other_id, :video_session_id, :user_id, :anon_id, :other, :user

  scope :unread,          where(:read => false)
  scope :alerts,          :conditions => { :type => ALERTS }, :order => "created_at DESC"
  scope :content_alerts,  :conditions => { :type => CONTENT_ALERTS  }, :order => "created_at DESC"
  scope :news_alerts,     :conditions => { :type => NEWS  }, :order => "created_at DESC"
  scope :call_alerts,      :conditions => { :type => CALL_ALERTS  }, :order => "created_at DESC"

  
  def to_s
    self.class.name
  end

  alias_method :reason, :to_s

  def path_for_notify
    case self.class.name.split("::")[-1]
    when 'NewStatus'
      user_status_updates_url(:user_id => other )
    when 'NewKluuu'
      klu_url(:id => klu)
    when "NewBookmark"
      user_bookmarks_url(:user_id => other)
    when "NewComment"
      url
    when "NewFollower"
      user_path(:id => other )
    when "NewRating"
      klu_url(:id => klu_id)
    when "NewMessage"
      url
    end
  end
  
  def url_for_notify
    path_for_notify
  end

  #alias_method :url_for_notify, :path_for_notify  
  
  private

  def generate_push_notification
    Rails.logger.debug("#{self.class.name}#generate_push_notification - start")
    begin
      set_notification_count
      push_notification_in_actionbar
    rescue Exception => e
      Rails.logger.error("#{self.class.name}#generate_push_notification - ERROR: #{e.inspect}")
    end
  end

  def generate_mail_notification
    if ALERTS.include?(self.class.name) && self.user.account.prefs.email_concerning_me == "1" 
      Rails.logger.debug("#{self.class.name}#generate_mail_notification - generating mail for alert-type notification")
      UserMailer.content_notification(self).deliver
    end
    if CONTENT_ALERTS.include?(self.class.name) && ( self.user.account.prefs.inform_of_friends == "1" && self.user.account.prefs.email_concerning_other == "1" )
      Rails.logger.debug("#{self.class.name}#generate_mail_notification - generating mail for content_alert-type notification")
      UserMailer.friend_notification(self).deliver
    end
  end

  # sets number of notifications unread in actionbar
  #
  def set_notification_count
    if ALERTS.include?(self.class.name)
      js = "$('#alerts-count-#{user_id}').html('#{self.user.notifications.alerts.unread.count}');"
      ret = PrivatePub.publish_to("/notifications/#{user_id}", js)
      Rails.logger.debug("#{self.class.name} - set_notification_count: js: '#{js}' with return: #{ret}")
    else
      Rails.logger.debug("#{self.class.name}#set_notification_count - created notification NOT IN ALERTS - ignoring")
    end
  end

  # pushes notification into actionbar - notification-listing
  #
  def push_notification_in_actionbar
    if ALERTS.include?(self.class.name)
      renderer = KluuuCode::NotificationRenderer.new
      content =  renderer.render('shared/notification_list_item', :locals => {:notification => self })
      js = "$('#actionbar-notifications-#{user_id}').prepend('#{escape_javascript(content)}');"
      ret = PrivatePub.publish_to("/notifications/#{user_id}", js)
      Rails.logger.debug("#{self.class.name}#push_notification_in_actionbar - end \nret: #{ret.inspect}\n")
    else
      Rails.logger.debug("#{self.class.name}#push_notification_in_actionbar - created notification NOT IN ALERTS - ignoring")
    end
  end

end
