class LandingPageController < BaseController

  def index
    respond_to do |format|
      format.html do
        @talks_live     = Talk.live_and_halflive

        @talks_featured = Talk.featured.limit(6)
        @talks_recent  	= Talk.recent.limit(6)
        @talks_popular  = Talk.popular.limit(6)
      end
      format.rss do
        @podcast = OpenStruct.new(talks: Talk.recent.limit(10))
      end
      format.xml
    end
  end

end
