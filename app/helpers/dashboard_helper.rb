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
  
end
