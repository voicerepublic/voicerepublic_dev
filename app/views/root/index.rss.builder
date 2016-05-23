# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title')
@podcast.description = t('.podcast.description', url: root_url).chomp
@podcast.image_title = t('.podcast.title')
@podcast.author =      t('.podcast.author')
@podcast.subtitle =    t('.podcast.subtitle')

# urls
@podcast.url =         root_url
@podcast.image_link =  root_url
@podcast.image_url =   image_url 'vr_logo_1400.png'

xml << render(partial: 'shared/podcast', locals: { xml: xml })
