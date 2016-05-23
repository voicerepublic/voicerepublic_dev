# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', title: @talk.title)
@podcast.image_title = t('.podcast.title', title: @talk.title)

# misc
@podcast.description = @talk.description
@podcast.description_as_text = @ talk.description_as_text
@podcast.author =      @talk.user.name # delegate via series
@podcast.subtitle =    @talk.teaser

# urls
@podcast.url =         talk_url(@talk)
@podcast.image_link =  talk_url(@talk)
@podcast.image =       @talk.image

xml << render(partial: 'shared/podcast', locals: { xml: xml })
