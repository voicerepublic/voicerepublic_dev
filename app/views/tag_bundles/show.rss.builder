# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', title: @tag_bundle.title_en)
@podcast.image_title = t('.podcast.title', title: @tag_bundle.title_en)

# misc
@podcast.description = @tag_bundle.description_en
@podcast.author =      t('.podcast.author')
@podcast.subtitle =    t('.podcast.teaser')

# urls
@podcast.url =         root_url
@podcast.image_link =  root_url
@podcast.image_url =   '' # no idea

xml << render(partial: 'shared/podcast', locals: { xml: xml })
