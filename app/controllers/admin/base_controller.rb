class Admin::BaseController < ApplicationController
  
  layout "admin"
  
  before_filter :admin_check
  
  private
  
  def admin_check
    unless current_or_guest_user && current_or_guest_user.is_admin?
      logger.debug("#{self.class.name}#admin_check - user is not admin: #{current_or_guest_user.inspect}")
      redirect_to root_path, alert: "access prohibited" and return
    end
  end
  
end