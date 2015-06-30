class Users::SessionsController < Devise::SessionsController

  JSON_OPTS = { only: %w( id firstname lastname created_at updated_at
                          sign_in_count last_sign_in_at email
                          authentication_token last_sign_in_ip
                          about_as_html website timezone summary
                          credits purchases_count ),
                methods: %w( series list_of_series ) }

  respond_to :json

  skip_before_action :verify_authenticity_token, if: ->{ request.format.json? }

  include Devise::Controllers::Rememberable

  # POST /resource/sign_in
  def create
    respond_with resource do |format|
      format.html do
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_navigational_format?

        sign_in(resource_name, resource)
        remember_me(resource) if params[:remember_me]
        redirect_to after_sign_in_path_for(resource)
      end

      format.json do
        resource = resource_from_credentials
        return invalid_login_attempt unless resource
        render json: resource.to_json(JSON_OPTS)
      end
    end
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

  protected

  def invalid_login_attempt
    warden.custom_failure!
    render json: { success: false, errors: 'Error with your login or password' }, status: 401
  end

  def resource_from_credentials
    data = { email: params[:email] }
    if res = resource_class.find_for_database_authentication(data)
      return res if res.valid_password?(params[:password])
    end
  end

end
