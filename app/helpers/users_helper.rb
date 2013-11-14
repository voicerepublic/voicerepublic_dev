module UsersHelper

  def css_class_for_available(available)
    case available
    when 'online'
      'success'
    when 'busy'
      'important'
    when 'offline'
      'attention'
    end
  end

  def badge_for_count(count)
    if count > 0
      return "badge-important"
    else
      #return "badge-info"
      ""
    end
  end

  def notification_count
    current_or_guest_user.notifications.alerts.unread.count
  end

  def unread_messages_count
    current_or_guest_user.received_messages.receiver_unread.count
  end

end
