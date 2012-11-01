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
    case notification.class.name
    when "Notification::NewStatus"
      link_to(t('.see_more'), user_status_updates_url(:user_id => notification.other ))
    when "Notification::NewKluuu"
      link_to(t('.see_more'), klu_url(:id => notification.klu))
    when "Notification::NewBookmark"
      link_to(t('.see_more'), user_bookmarks_url(:user_id => notification.other))
    when "Notification::NewComment"
      link_to(t('.see_more'), notification.url)
    when "Notification::NewFollower"
      link_to(t('.visit_profile'), user_path(:id => notification.other ))
    when "Notification::NewRating"
      link_to(t('.see_more'), klu_url(:id => notification.klu))
    when "Notification::NewMessage"
      link_to(t('.read_more'), notification.url )
    end
  end
  
end
