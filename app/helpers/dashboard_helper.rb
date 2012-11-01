module DashboardHelper
  
  def partial_for_notification(notification)
    
    case notification.class.name.split("::")[-1]
    when 'CallAccepted'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'CallRejected'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'IncomingCall'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'MissedCall'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'NewBookmark'
      render(:partial => 'notifies/my_content', :locals => {:notification => notification})
    when 'NewMessage'
      render(:partial => 'notifies/my_content', :locals => {:notification => notification})
    when 'NewComment'
      render(:partial => 'notifies/my_content', :locals => {:notification => notification})
    when 'NewFollower'
      render(:partial => 'notifies/my_content', :locals => {:notification => notification})
    when 'NewRating'
      render(:partial => 'notifies/my_content', :locals => {:notification => notification})
    when 'NewKluuu'
      render(:partial => 'notifies/new_content', :locals => {:notification => notification})
    when 'NewStatus'
      render(:partial => 'notifies/new_content', :locals => { :notification => notification })
    end
    
  end
  
  def link_to_url_for_notification_reason(notification)
    url = case notification.class.name
          when "Notification::NewStatus"
            user_status_updates_url(:user_id => notification.other )
          when "Notification::NewKluuu"
            klu_url(:id => notification.klu)
          when "Notification::NewBookmark"
            user_bookmarks_url(:user_id => notification.other)
          when "Notification::NewComment"
            notification.url
          when "Notification::NewFollower"
            user_path(:id => notification.other )
          when "Notification::NewRating"
            klu_url(:id => notification.klu)
          when "Notification::NewMessage"
            notification.url
          end
    if block_given?
      return link_to(url) { yield }
    else
      return link_to(raw('&rarr;'), url)
    end
  end
  
end
