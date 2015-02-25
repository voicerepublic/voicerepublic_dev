class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include Devise::Controllers::Rememberable

  def facebook
    logger.debug("OmniauthCallbacks#facebook - omniauth.auth: \n" +
                 " #{request.env['omniauth.auth']}\n")
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    unless @user.valid?
      logger.warn("OmniAuthCallbacks#facebook - user invalid: #{@user.errors.inspect}")
      flash[:error] = @user.errors.full_message(:email, "is in use")
      redirect_to new_user_registration_url and return
    end

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      remember_me(@user)
      sign_in @user, :event => :authentication
      redirect_to root_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end
