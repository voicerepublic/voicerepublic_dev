# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title',    username: @user.name)
@podcast.image_title = t('.podcast.title',    username: @user.name)
@podcast.subtitle =    t('.podcast.subtitle', username: @user.name)
@podcast.author =      t('.podcast.author',   username: @user.name)

# misc
@podcast.description = @user.about

# urls
@podcast.url =         user_url(@user)
@podcast.image_link =  user_url(@user)
@podcast.image_url =   image_url 'vr_logo_1400.png'

xml << render(partial: 'shared/podcast', locals: { xml: xml })
