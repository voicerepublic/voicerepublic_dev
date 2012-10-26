class Notification::Base < ActiveRecord::Base
  
  scope :unread, where(:read => false)
  
  scope :alerts, :conditions => { :type => %w{ Notification::NewBookmark 
                                               Notification::NewComment
                                               Notification::NewFollower
                                               Notification::NewRating
                                              } 
                                 }, :order => "created_at DESC"
  scope :content_alerts, :conditions => { :type => %w{ Notification::NewKluuu
                                                      } 
                                 }, :order => "created_at DESC"
  
  alias_method :reason, :to_s
  
  
  def to_s
    self.class.name
  end
  
  private
  
  def generate_push_notification
    begin
      PrivatePub.publish_to("/notifications/#{user_id}", "alert(<%= self.to_s %>);")
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
  def generate_mail_notification
    
  end
  
end
