Warden::Manager.after_authentication do |user,auth,opts|
  user.update_attribute(:available, :online)
end

Warden::Manager.before_logout do |user,auth,opts|
  user.update_attribute(:available, :offline)
end