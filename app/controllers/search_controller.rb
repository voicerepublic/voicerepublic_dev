class SearchController < BaseController

  layout 'velvet'

  PER_PAGE = 10

  before_action :set_query

  # POST /search
  def create
    redirect_to "/search/1/" + u(@query)
  end

  # GET  /search/1/:query
  def show
    @talks = Talk.search(@query).
      paginate(page: params[:page], per_page: PER_PAGE)
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
