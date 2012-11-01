class Notification::Base < ActiveRecord::Base
  
  ALERTS          = %w{ Notification::NewBookmark 
                        Notification::NewComment
                        Notification::NewFollower
                        Notification::NewRating } 
  CONTENT_ALERTS  = %w{ Notification::NewKluuu Notification::NewStatus }
  
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
      set_notification_count if self.instance_of?()
      #PrivatePub.publish_to("/notifications/#{user_id}", "alert('<%= self.to_s %>');")
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
      #raise
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
  def push_notification_in_actionbar
    # $('<p>Test</p>').insertAfter('.inner');
    
    #<li class="menu-item">
    #  <%= link_to_url_for_notification_reason(notification) do %>
    #    <%= notification %>
    #  <% end %>
    #</li>
    js = "$('<li class=\'menu-item\'>').insertAfter('#notifications-#{user_id}');"
    PrivatePub.publish_to("/notifications/#{user_id}", js)
  end
  
end
