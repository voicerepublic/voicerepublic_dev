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
  
end
