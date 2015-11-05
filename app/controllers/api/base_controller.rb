class Api::BaseController < ApplicationController

  respond_to :json

  # TODO do we need the condition here?
  skip_before_action :verify_authenticity_token, if: ->{ request.format.json? }

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!

end
