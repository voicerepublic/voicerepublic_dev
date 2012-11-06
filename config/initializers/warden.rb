Warden::Manager.after_authentication do |user,auth,opts|
  user.update_attribute(:available, 'online') if user
end

Warden::Manager.before_logout do |user,auth,opts|
  user.update_attribute(:available, 'offline') if user
end