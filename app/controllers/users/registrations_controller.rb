class Users::RegistrationsController < Devise::RegistrationsController
  layout 'velvet_minimal'
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
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
    '/onboard'
  end

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides reCAPTCHA
      set_minimum_password_length
      respond_with_navigational(resource) { render :new }
    end 
  end
end
