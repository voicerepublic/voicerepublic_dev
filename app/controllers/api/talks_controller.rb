class Api::TalksController < Api::BaseController

  JSON_CONFIG = { except: [:session, :storage] }

  before_action :authenticate_user!

  def index
    @talks = Talk.all
    @talks = @talks.limit(params[:limit]) if params[:limit]
    @talks = @talks.offset(params[:offset]) if params[:offset]
    @talks = @talks.order(params[:order]) if params[:order]

    @talks = @talks.where.not(featured_from: nil) if params[:featured_from]
    @talks = @talks.where(state: params[:state]) if params[:state]

    render json: @talks.to_json(JSON_CONFIG)
  end

end
