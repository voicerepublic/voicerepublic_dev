# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', title: @talk.title)
@podcast.image_title = t('.podcast.title', title: @talk.title)

# misc
@podcast.description = @talk.description_as_plaintext
@podcast.author =      @talk.user.name # delegate via venue
@podcast.subtitle =    @talk.teaser

# urls
@podcast.url =         talk_url(@talk)
@podcast.image_link =  talk_url(@talk)
@podcast.image_url =   @talk.image.thumb('1400x1400#').url

xml << render(partial: 'shared/podcast', locals: { xml: xml })
