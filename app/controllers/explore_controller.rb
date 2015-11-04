class ExploreController < ApplicationController

  def index
    @talks_live     = Talk.publicly_live.limit(5)
    @talks_featured = Talk.featured.limit(5)
    @talks_recent   = Talk.recent.limit(5)
    @talks_popular  = Talk.popular.limit(5)

    @talks = Talk.popular.limit(24)
    if filter = params[:filter]
      unless (language = filter[:language]).blank?
        @talks = @talks.where(language: language)
      end
      unless (publisher_type = filter[:publisher_type]).blank?
        @talks = @talks.joins(series: :users).
                 where('users.publisher_type' => publisher_type)
      end
    end

    return render partial: 'shared/talk_medium_box', collection: @talks if request.xhr?
  end

  # GET /explore/featured
  def featured
    @talks = Talk.featured.prelive.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /explore/upcoming
  def upcoming
    @talks = Talk.publicly_prelive.ordered.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /explore/popular
  def popular
    @talks = Talk.popular.paginate(page: params[:page], per_page: 25)
    respond_to do |format|
      format.html do
        render :index
      end
      # TODO check with dibran if this is needed anymore
      # hack to provide mobile with an easy interface, TODO move to api
      format.json do
        render json: @talks.to_json(only: %w(id slug state title
                                             teaser starts_at ends_at))
      end
    end
  end

  # GET /explore/live
  def live
    @talks = Talk.publicly_live.paginate(page: params[:page], per_page: 25)
    render :index
  end

  # GET /explore/recent
  def recent
    @talks = Talk.recent.paginate(page: params[:page], per_page: 25)
    render :index
  end

end
