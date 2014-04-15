class SearchController < ApplicationController

  PER_PAGE = 10

  # POST /search
  def create
    redirect_to "/search/1/" + u(params[:query])
  end

  # GET  /search/1/:query
  def show
    @query = params[:query]

    @results = PgSearch.multisearch(@query).
      paginate(page: params[:page], per_page: PER_PAGE)
    @best_hit = @results.shift.searchable if params[:page] == '1'
    @talks = @results.select { |s| s.searchable.is_a?(Talk) }.map(&:searchable)
    @venues = @results.select { |s| s.searchable.is_a?(Venue) }.map(&:searchable)
    @users = @results.select { |s| s.searchable.is_a?(User) }.map(&:searchable)

    @talks_featured = Talk.featured.limit(5)
    @talks_live     = Talk.live.limit(5)
  end

  private

  def u(str)
    ERB::Util.url_encode(str)
  end

end
