require 'pp'

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

  def google_oauth2
    logger.debug("OmniauthCallbacks#google_oauth2 - omniauth.auth: \n #{request.env['omniauth.auth']}\n")
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  #def twitter
  #  pp request.env['omniauth.auth']
  #  logger.debug("OmniauthCallbacks#twitter - omniauth.auth: \n #{request.env['omniauth.auth']}\n")
  #  @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
  #
  #  if @user.persisted?
  #    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
  #    sign_in_and_redirect @user, :event => :authentication
  #  else
  #    session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
  #    redirect_to new_user_registration_url
  #  end
  #end

end