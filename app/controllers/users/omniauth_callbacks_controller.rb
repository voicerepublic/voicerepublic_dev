class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    logger.debug("OmniauthCallbacks#facebook - omniauth.auth: \n #{request.env['omniauth.auth']}\n")
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
end