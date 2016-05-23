# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', title: @series.title)
@podcast.image_title = t('.podcast.title', title: @series.title)

# misc
@podcast.description = @series.description
@podcast.description_as_text = @series.description_as_text
@podcast.author =      @series.user.name
@podcast.subtitle =    @series.teaser

# urls
@podcast.url =         series_url(@series)
@podcast.image_link =  series_url(@series)
@podcast.image =       @series.image

xml << render(partial: 'shared/podcast', locals: { xml: xml })
