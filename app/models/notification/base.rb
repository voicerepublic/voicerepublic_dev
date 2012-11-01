class Notification::Base < ActiveRecord::Base
  
  scope :unread, where(:read => false)
  
  scope :alerts, :conditions => { :type => %w{ Notification::NewBookmark 
                                               Notification::NewComment
                                               Notification::NewFollower
                                               Notification::NewRating
                                              } 
                                 }, :order => "created_at DESC"
                                 
  scope :content_alerts, 
                :conditions => { :type => %w{ Notification::NewKluuu Notification::NewStatus }  }, :order => "created_at DESC"
  
  alias_method :reason, :to_s
  
  
  def to_s
    self.class.name
  end
  
  private
  
  def generate_push_notification
    Rails.logger.debug("#{self.class.name}#generate_push_notification - start")
    begin
      set_notification_count
      #PrivatePub.publish_to("/notifications/#{user_id}", "alert('<%= self.to_s %>');")
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
      #raise
    end  
  end
  
  def generate_mail_notification
  end
  
  def set_notification_count
    js = "$('#alerts-count-#{user_id}').html('#{self.user.notifications.alerts.unread.count}');"
    Rails.logger.debug("#{self.class.name} - set_notification_count: js: '#{js}'")
    PrivatePub.publish_to("/notifications/#{user_id}", js)
  end
  
end
