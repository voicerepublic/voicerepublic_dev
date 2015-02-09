class Users::RegistrationsController < Devise::RegistrationsController

  def new
    resource = build_resource(user_params)
    respond_with resource
  end

  def create
    @guest_user = session[:guest_user_id] = nil
    super
  end

  private

  def user_params
    return {} unless params[:user] # for redirect on subscribe
    params.require(:user).permit(:firstname, :lastname, :email)
  end

  def after_sign_up_path_for(resource)
    '/onboard'
  end

end
