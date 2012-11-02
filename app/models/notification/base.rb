require 'notification_renderer'

class Notification::Base < ActiveRecord::Base
  include ActionView::Helpers::JavaScriptHelper
  
  ALERTS          = %w{ Notification::NewBookmark 
                        Notification::NewComment
                        Notification::NewFollower
                        Notification::NewRating } 
  CONTENT_ALERTS  = %w{ Notification::NewKluuu Notification::NewStatus }
  
  attr_accessible :other_id, :video_session_id, :user_id, :anon_id, :other, :user
  
  scope :unread,          where(:read => false)
  scope :alerts,          :conditions => { :type => ALERTS }, :order => "created_at DESC"
  scope :content_alerts,  :conditions => { :type => CONTENT_ALERTS  }, :order => "created_at DESC"
  
  alias_method :reason, :to_s
  
  
  def to_s
    self.class.name
  end
  
  private
  
  def generate_push_notification
    Rails.logger.debug("#{self.class.name}#generate_push_notification - start")
    begin
      set_notification_count 
      push_notification_in_actionbar
      #PrivatePub.publish_to("/notifications/#{user_id}", "alert('<%= self.to_s %>');")
    rescue Exception => e
      Rails.logger.error("#{self.class.name}#generate_push_notification - ERROR: #{e.inspect}")
      raise
    end  
  end
  
  def generate_mail_notification
  end
  
  # sets number of notifications unread in actionbar
  #
  def set_notification_count
    js = "$('#alerts-count-#{user_id}').html('#{self.user.notifications.alerts.unread.count}');"
    Rails.logger.debug("#{self.class.name} - set_notification_count: js: '#{js}'")
    PrivatePub.publish_to("/notifications/#{user_id}", js)
  end
  
  # pushes notification into actionbar - notification-listing
  #
  # FIXME - rendered content is not inserted at given DOM-position
  def push_notification_in_actionbar
    if ALERTS.include?(self.class.name)
      Rails.logger.debug("#{self.class.name}#push_notification_in_actionbar - start ")
      n = KluuuCode::NotificationRenderer.new
      content =  escape_javascript(n.render('shared/notification_list_item', :locals => {:notification => self }))
      Rails.logger.debug("#{self.class.name}#push_notification_in_actionbar - content: #{content}")
      PrivatePub.publish_to("/notifications/#{user_id}", "$('#{content}').insertAfter('#notification-#{user_id}');")
      Rails.logger.debug("#{self.class.name}#push_notification_in_actionbar - end ")
    else
      Rails.logger.debug("#{self.class.name}#push_notification_in_actionbar - NOT IN ALERTS ")
    end
  end
  
end
