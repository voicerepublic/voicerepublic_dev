module LandingPageHelper
  include ActsAsTaggableOn::TagsHelper
  
  
  # checks if there is an upcoming venue
  # additionally checks for available Kblog::Articles
  #
  def partial_for_venue_and_news
    
    if Venue.upcoming
      if Kblog::Article.first.nil?
        render(:partial => 'lp_venue')
      else 
        render(:partial => 'lp_venue_news')
      end
    end
    
  end
  
end
