module DashboardHelper
  
  def partial_for_notification(notification)
    
    partial = case notification.class.name.split("::")[-1]
              when 'CallAccepted'
                  'shared/notification'
              when 'CallRejected'
                'shared/notification'
              when 'IncomingCall'
                'shared/notification'
              when 'MissedCall'
                'shared/notification'
              when 'NewBookmark'
                'notifies/my_content'
              when 'NewMessage'
                'notifies/my_content'
              when 'NewComment'
                'notifies/my_content'
              when 'NewFollower'
                'notifies/my_content'
              when 'NewRating'
                'notifies/my_content'
              when 'NewKluuu'
                'notifies/new_content'
              when 'NewStatus'
                'notifies/new_content'
              end
              
    partial ||= 'shared/notification'  # if no partial fits - render debug-partial
    render(:partial => partial, :locals => { :notification => notification } )
  end
  
  
  def link_to_url_for_notification_reason(notification)
    url = case notification.class.name.split("::")[-1]
          when "NewStatus"
            user_status_updates_url(:user_id => notification.other )
          when "NewKluuu"
            klu_url(:id => notification.klu)
          when "NewBookmark"
            user_bookmarks_url(:user_id => notification.other)
          when "NewComment"
            notification.url
          when "NewFollower"
            user_path(:id => notification.other )
          when "NewRating"
            klu_url(:id => notification.klu)
          when "NewMessage"
            notification.url
          end
    if block_given? 
      return link_to(url) { yield }
    else
      return link_to( content_tag(:i, ' ', :class => "icon-eye-open"), url, :class => "news-view")
    end
  end
  
end
