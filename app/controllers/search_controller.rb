class SearchController < BaseController

  PER_PAGE = 10

  before_action :set_query

  # POST /search
  def create
    redirect_to "/search/1/" + u(@query)
  end

  # GET  /search/1/:query
  def show
    @results = PgSearch.multisearch(@query).
      paginate(page: params[:page], per_page: PER_PAGE)

    @rest = @results.to_a
    @best_hit = nil
    @best_hit = @rest.shift.searchable if @rest.present? and params[:page] == '1'

    @talks  = @rest.select { |s| s.searchable.is_a?(Talk) }.map(&:searchable)
    @series = @rest.select { |s| s.searchable.is_a?(Series) }.map(&:searchable)
    @users  = @rest.select { |s| s.searchable.is_a?(User) }.map(&:searchable)

    @talks_featured = Talk.featured.limit(5)
    @talks_live     = Talk.live.limit(5)
  end

  private

  def u(str)
    ERB::Util.url_encode(str)
  end

  def set_query
    params.permit(:query)
    @query = params[:query]
  end

end
