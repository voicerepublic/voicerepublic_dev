class LandingPageController < BaseController

  layout 'velvet'
  def index
    respond_to do |format|
      format.html do
        @publishers = [
          {image: 'eth', category: 'Academic', url: '/users/zentrum-geschichte-des-wissens-eth-universitat-zurich'},
          {image: 'amaze', category: 'Conference', url: '/users/a-maze'},
          {image: 'courage', category: 'Foundation',url: '/users/courage-foundation'},
          {image: 'ferien', category: 'Conference',url: '/users/internationale-ferienkurse'},
          {image: 'republica', category: 'Conference',url: '/users/re-publica'},
          {image: 'things', category: 'Conference',url: '/users/internet-of-things-conference'},
          {image: 'webinale', category: 'Conference',url: '/users/webinale-conference'},
          {image: 'wilpf', category: 'Foundation',url: '/users/emma-burgisser'}
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
