class Users::SessionsController < Devise::SessionsController 

  include Devise::Controllers::Rememberable

  skip_before_filter :require_no_authentication
  protect_from_forgery with: :null_session

  # POST /resource/sign_in
  def create
    sign_out
    # FIXME: this writes the password in plain text to the log
    logger.debug("Users::Sessions#create - overwrite devise params: #{params.inspect}")
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    
    sign_in(resource_name, resource)
    if params[:remember_me]
      remember_me(resource)
    end
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end
  
end
