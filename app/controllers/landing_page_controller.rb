class LandingPageController < BaseController

  def index
    respond_to do |format|
      format.html do
        @talks_featured = Talk.featured.limit(5)
        @talks_live     = Talk.live_and_halflive.limit(5)
        @talks_recent  	= Talk.recent.limit(5)
        @talks_popular  = Talk.popular.limit(5)
        @user           = User.new
      end
      format.rss do
        @podcast = OpenStruct.new(talks: Talk.recent.limit(10))
      end
    end
  end

end
