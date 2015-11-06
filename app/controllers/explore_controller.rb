class ExploreController < ApplicationController

  LIMIT = 12

  layout 'velvet'

  def index
    page = params[:page] || 1
    @talks = Talk.popular.paginate(page: page, per_page: LIMIT)
    if filter = params[:filter]
      unless (language = filter[:language]).blank?
        @talks = @talks.where(language: language)
      end
      unless (publisher_type = filter[:publisher_type]).blank?
        @talks = @talks.joins(series: :users).
                 where('users.publisher_type' => publisher_type)
      end
      unless (category = filter[:category]).blank?
        @talks = @talks.tagged_with(category)
      end
    end

    if request.xhr?
      if page == 1
        # these get replaced by ajax filters
        return render partial: 'results'
      else
        # these get appended by infinite scroll
        return render partial: 'velvet/talk', collection: @talks
      end
    end
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
    render :index
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
