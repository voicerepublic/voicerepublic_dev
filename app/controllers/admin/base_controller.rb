class Admin::BaseController < ApplicationController
  
  layout "admin"
  
  before_filter :admin_check
  
  private
  
  def admin_check
    unless guest_or_current_user && guest_or_current_user.is_admin?
      logger.debug("#{self.class.name}#admin_check - user is not admin: #{guest_or_current_user.inspect}")
      redirect_to root_path, alert: "access prohibited" and return
    end
  end
  
end