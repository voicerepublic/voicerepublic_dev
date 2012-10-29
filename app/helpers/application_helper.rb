module ApplicationHelper
  
  # limit number of words beeing displayed.
  #
  def limit_words(txt, num)
    arr = ( txt ? txt.split(" ") : [] )
    arr.length > num-1 ? arr[0..num-1].join(" ").concat(" ...") : txt
  end
  
  def app_mode
    Rails.env
  end

  def git_revision
    gi = KluuuCode::GitInfo.new(Rails.root)
    gi.latest
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
    end
  end
  
end
