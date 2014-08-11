class Api::BaseController < ApplicationController

  acts_as_token_authentication_handler_for User

  def generate_guest_user?
    false
  end

end
