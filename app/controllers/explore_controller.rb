class ExploreController < ApplicationController

  def index
    @talks_live     = Talk.live.limit(5)
    @talks_featured = Talk.featured.limit(5)
    @talks_recent   = Talk.recent.limit(5)
    @talks_popular  = Talk.popular.limit(5)
  end

  # GET /explore/featured
  def featured
    @talks = Talk.prelive.featured.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /explore/upcoming
  def upcoming
    @talks = Talk.prelive.ordered.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /explore/popular
  def popular
    @talks = Talk.popular.paginate(page: params[:page], per_page: 25)
    respond_to do |format|
      format.html do
        render :index
      end
      # hack to provide dibran with an easy interface, TODO move to api
      format.json do
        render json: @talks.to_json(only: %w(id slug state title
                                             teaser starts_at ends_at))
      end
    end
  end

  # GET /explore/live
  def live
    @talks = Talk.live.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /explore/recent
  def recent
    @talks = Talk.recent.paginate(page: params[:page], per_page: 25)
    render :index
  end

end
