module LandingPageHelper
  include ActsAsTaggableOn::TagsHelper
  
  
  # checks if there is an upcoming venue
  #
  def partial_for_venue_and_news
    
    if Venue.upcoming
      render(:partial => 'lp_venue')
    end
    
  end
  
end
