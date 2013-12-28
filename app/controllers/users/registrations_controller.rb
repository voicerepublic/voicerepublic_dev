class Users::RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource(params[:user])
    respond_with resource
  end
end
