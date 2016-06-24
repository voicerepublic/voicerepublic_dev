# TODO
@podcast.category =    'Society & Culture'

# translations
@podcast.title =       t('.podcast.title', username: @user.name)
@podcast.image_title = t('.podcast.title', username: @user.name)
@podcast.subtitle =    t('.podcast.subtitle')

# misc
@podcast.description = @user.about_as_text
@podcast.author =      @user.name

# urls
@podcast.url =         user_url(@user)
@podcast.image_link =  user_url(@user)
@podcast.image =       @user.avatar

xml << render(partial: 'shared/podcast', locals: { xml: xml })
