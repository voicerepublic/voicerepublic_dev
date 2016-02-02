class Users::RegistrationsController < Devise::RegistrationsController

  def new
    resource = build_resource(user_params)

    affiliate = [ request.env['affiliate.tag'],
                  request.env['affiliate.time'],
                  request.env['affiliate.from'] ].compact * '|'
    affiliate = nil if affiliate.blank?
    resource.referrer = affiliate

    respond_with resource
  end

  private

  def user_params
    return {} unless params[:user] # for redirect on subscribe
    params.require(:user).permit(:firstname, :lastname, :email)
  end

  def after_sign_up_path_for(resource)
    # newschool
    Simon.says x: 'user_registrations',
               event: 'user_registered',
               details: {
                 user: {
                   name: user.name,
                   email: user.email
                 }
               }

    # TODO oldschool remove
    Simon.comprehend(resource, :registered)

    '/onboard'
  end

end
