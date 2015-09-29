class Api::BookmarksController < Api::BaseController

  skip_before_action :verify_authenticity_token, if: lambda { request.format.json? }

  # TODO create a global whitelist for all models, as yaml so wie can
  # also use it in specs
  JSON_CONFIG = {
    only: %w(
            id
            firstname
            lastname
            email
            authentication_token
            credits
          ),
    methods: %w( list_of_series )
  }

  before_action :authenticate_user!

  def show
    render json: current_user.to_json(JSON_CONFIG)
  end

end
