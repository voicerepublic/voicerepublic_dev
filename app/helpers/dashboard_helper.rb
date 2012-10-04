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
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'NewMessage'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'NewComment'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'NewFollower'
      render(:partial => 'shared/notify_new_follower', :locals => {:notification => notification})
    when 'NewRating'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    when 'NewKluuu'
      render(:partial => 'shared/notification', :locals => {:notification => notification})
    end
    
  end
  
end
