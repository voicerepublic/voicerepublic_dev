# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', username: @user.name)
@podcast.image_title = t('.podcast.title', username: @user.name)
@podcast.subtitle =    t('.podcast.subtitle')

# misc
@podcast.description = @user.about
@podcast.author =      @user.name

# urls
@podcast.url =         user_url(@user)
@podcast.image_link =  user_url(@user)
@podcast.image_url =   @user.avatar.thumb('1400x1400#').url

xml << render(partial: 'shared/podcast', locals: { xml: xml })
