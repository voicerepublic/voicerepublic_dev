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
      return "badge-info"
    end
  end
  
end
