require 'pp'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  
  def facebook
    logger.debug("OmniauthCallbacks#facebook - omniauth.auth: \n #{request.env['omniauth.auth']}\n")
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], guest_or_current_user)

    unless @user.valid?
      logger.warn("OmniAuthCallbacks#facebook - user invalid: @user.inspect")
      flash[:error] = @user.errors.full_message(:email, "is in use")
      redirect_to new_user_registration_url and return
    end
    
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      @user.update_attribute(:available, 'online')
      remember_me(@user)
      sign_in @user, :event => :authentication
      redirect_to venues_url
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    logger.debug("OmniauthCallbacks#google_oauth2 - omniauth.auth: \n #{pp request.env['omniauth.auth']}\n")
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], guest_or_current_user)
    unless @user.valid?
      logger.warn("OmniAuthCallbacks#google_oath2- user invalid: @user.inspect")
      flash[:error] = @user.errors.full_message(:email, "is in use")
      redirect_to new_user_registration_url and return
    end
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      @user.update_attribute(:available, 'online')
      remember_me(@user)
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  #def twitter
  #  pp request.env['omniauth.auth']
  #  logger.debug("OmniauthCallbacks#twitter - omniauth.auth: \n #{request.env['omniauth.auth']}\n")
  #  @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], guest_or_current_user)
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