class Admin::BaseController < ApplicationController
  
  layout "admin"
  
  before_filter :admin_check
  
  private
  
  def admin_check
    unless current_user && current_user.is_admin?
      redirect_to root_path, alert: "access prohibited" and return
    end
  end
  
end