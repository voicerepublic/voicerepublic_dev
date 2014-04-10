class Users::RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource(params[:user])
    respond_with resource
  end

  def create
    @guest_user = session[:guest_user_id] = nil
    super
  end
end
