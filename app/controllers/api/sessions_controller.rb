class Api::SessionsController < Devise::SessionsController

  JSON_OPTS = { only: %w( id firstname lastname created_at updated_at
                          sign_in_count last_sign_in_at email
                          authentication_token last_sign_in_ip
                          about_as_html website timezone summary
                          credits purchases_count ),
                          # TODO remove series here
                          methods: %w( series list_of_series ) }

  respond_to :json

  skip_before_action :verify_authenticity_token, if: ->{ request.format.json? }

  include Devise::Controllers::Rememberable

  # POST /api/sessions
  def create
    resource = resource_from_credentials
    return invalid_login_attempt unless resource
    render json: resource.to_json(JSON_OPTS)
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
