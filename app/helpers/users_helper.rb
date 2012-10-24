module UsersHelper
  
  def css_class_for_available(available)
    case available
    when 'online'
      'success'
    when 'offline'
      'important'
    when 'busy'
      'warning'
    end
  end
  
end
