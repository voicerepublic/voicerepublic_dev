# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', title: @venue.title)
@podcast.image_title = t('.podcast.title', title: @venue.title)

# misc
@podcast.description = @venue.description
@podcast.author =      @venue.user.name
@podcast.subtitle =    @venue.teaser

# urls
@podcast.url =         venue_url(@venue)
@podcast.image_link =  venue_url(@venue)
@podcast.image_url =   @venue.image.thumb('1400x1400#').url

xml << render(partial: 'shared/podcast', locals: { xml: xml })
