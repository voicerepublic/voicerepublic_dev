class Api::TalksController < Api::BaseController

  JSON_CONFIG = { except: [:session, :storage] }

  before_action :authenticate_user!

  # TODO security: check for sql injection
  def index
    @talks = Talk.all

    # paging
    @talks = @talks.limit(params[:limit]) if params[:limit]
    @talks = @talks.offset(params[:offset]) if params[:offset]

    # sort order
    if order = params[:order]
      order = "#{order} DESC" if params[:reverse]
      @talks = @talks.order(order)
    end

    # filter
    @talks = @talks.where.not(featured_from: nil) if params[:featured_from]
    @talks = @talks.where(state: params[:state]) if params[:state]

    render json: @talks.to_json(JSON_CONFIG)
  end

end
