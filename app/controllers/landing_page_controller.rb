class LandingPageController < BaseController

  layout 'velvet'
  def index
    respond_to do |format|
      format.html do
        @publishers = [
          {image: 'eth', category: 'Academic', url: '/users/zentrum-geschichte-des-wissens-eth-universitat-zurich'},
          {image: 'amaze', category: 'Academic', url: ''},
          {image: 'courage', category: 'Academic',url: ''},
          {image: 'ferien', category: 'Academic'},
          {image: 'republica', category: 'Academic'},
          {image: 'things', category: 'Academic'},
          {image: 'webinale', category: 'Academic'},
          {image: 'wilpf', category: 'Academic'}
          ]       


      
        @talks_live     = Talk.publicly_live

        @talks_featured = Talk.featured.limit(6)
        @talks_recent  	= Talk.recent.limit(6)
        @talks_popular  = Talk.popular.limit(12)
      end
      format.rss do
        @podcast = OpenStruct.new(talks: Talk.recent.limit(10))
      end
      format.xml
    end
  end

end
