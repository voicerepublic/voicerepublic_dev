class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_last_request 
  
  
  private
  
  def set_last_request
    #logger.debug("########### current_user: #{current_user.inspect}")
    if current_user 
      current_user.update_attribute(:last_request_at, Time.now) if ( current_user.last_request_at.nil? ) || ( current_user.last_request_at < Time.now - 1.minute )  
    end
  end
end
