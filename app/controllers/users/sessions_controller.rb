class Users::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :verify_authenticity_token, if: lambda { request.format.json? }

  include Devise::Controllers::Rememberable

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?

    sign_in(resource_name, resource)
    if params[:remember_me]
      remember_me(resource)
    end

    respond_with resource do |format|
      format.html { redirect_to after_sign_in_path_for(resource) }
      format.json do
        if resource.is_a? User
          user_hash = resource.attributes
          resource.venues.reload
          series = resource.venues.collect { |v| [v.id, v.title ]}
          user_hash.merge!(series: Hash[series])
          render json: user_hash.to_json
        end
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

end
