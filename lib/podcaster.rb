require 'tilt/builder'

# Renders and persists RSS Podcast feeds
class Podcaster
  include ActionView::Helpers::AssetUrlHelper

  def initialize
    @template = Tilt.new('app/views/shared/_podcast.rss.builder')
    # TODO: Why is `feeds` not visible within Settings in Podcaster?
    # It works for other settings.yml entries here and the feeds
    # config works within Controllers.
    # @feeds_path = Settings.feeds.path
    @feeds_path = 'public/system/feeds'
  end

  def self.url_helpers
    Rails.application.routes.url_helpers
  end

  def url_helpers
    self.class.url_helpers
  end

  def save_podcast_for(model, metadata)
    podcast_str = @template.render metadata

    # `Talk` -> `talks`
    folder_name = model.class.to_s.pluralize.downcase

    File.open(Rails.root.join(@feeds_path, folder_name, "#{model.id}.rss"), 'wb') do |f|
      f << podcast_str
    end

    Rails.logger.info "Rendered podcast feed for #{model.class} ID #{model.id}"
  end


  def render_for_talk(id)
    talk = Talk.find(id)

    metadata = OpenStruct.new(talks: [talk],

                              # TODO
                              category:    'Society & Culture',

                              # translations
                              title:       I18n.t('talks.podcast.title', title: talk.title),
                              image_title: I18n.t('talks.podcast.title', title: talk.title),

                              # misc
                              description: talk.description_as_text,
                              author:      talk.user.name,
                              subtitle:    talk.teaser,

                              # urls
                              url:         url_helpers.talk_url(talk),
                              image_link:  url_helpers.talk_url(talk),
                              rss_url:     url_helpers.talk_url(talk, format: :rss),
                              image:       talk.image)

    save_podcast_for(talk, metadata)
  end

  def render_for_series(id)
    series = Series.find(id)

    metadata = OpenStruct.new(talks: series.talks.archived.ordered,

                              # TODO
                              category:    'Society & Culture',

                              # translations
                              title:       I18n.t('series.podcast.title', title: series.title),
                              image_title: I18n.t('series.podcast.title', title: series.title),

                              # misc
                              description: series.description_as_text,
                              author:      series.user.name,
                              subtitle:    series.teaser,

                              # urls
                              url:         url_helpers.series_url(series),
                              image_link:  url_helpers.series_url(series),
                              rss_url:     url_helpers.series_url(series, format: :rss),
                              image:       series.image)

    save_podcast_for(series, metadata)
  end

  def render_for_user_published(id)
    user = User.find(id)

    metadata = OpenStruct.new(talks: user.talks.archived.order('updated_at DESC'),
                              # TODO
                              category:    'Society & Culture',

                              # translations
                              title:        I18n.t('users.podcast.title', username: user.name),
                              image_title:  I18n.t('users.podcast.title', username: user.name),
                              subtitle:     I18n.t('users.podcast.subtitle'),

                              # misc
                              description:  user.about_as_text,
                              author:       user.name,

                              # urls
                              url:          url_helpers.user_url(user),
                              image_link:   url_helpers.user_url(user),
                              image:        user.avatar)
    save_podcast_for(user, metadata)
  end

  def render_for_featured
    # TODO: DISCUSS during Code review:
    # Previously, in the RootController, `Talk.recent.limit(10)` was
    # used. However, this doesn't seem to be useful as a "Featured
    # Talks" Podcast.
    metadata = OpenStruct.new(talks: Talk.promoted,
                              # TODO
                              category:    'Society & Culture',

                              # translations
                              title:       I18n.t('root.podcast.title'),
                              description: I18n.t('root.podcast.description',
                                                  url: url_helpers.root_url).chomp,
                              image_title: I18n.t('root.podcast.title'),
                              author:      I18n.t('root.podcast.author'),
                              subtitle:    I18n.t('root.podcast.subtitle'),

                              # urls
                              url:         url_helpers.root_url,
                              image_link:  url_helpers.root_url,
                              image_url:   image_url('vr_logo_1400.png'))

    podcast_str = @template.render metadata

    File.open(Rails.root.join(@feeds_path, 'featured', 'index.rss'), 'wb') do |f|
      f << podcast_str
    end

    Rails.logger.info "Rendered podcast feed 'Featured'."
  end

  def render_for_user_pinned(user_id)
    user = User.find user_id
    metadata = OpenStruct.new(talks: Talk.remembered_by(user),

                              category:    'Society & Culture',

                              # translations
                              title:       I18n.t('reminders.index.podcast.title', username: user.name),
                              description: user.about,
                              image_title: I18n.t('reminders.index.podcast.title', username: user.name),
                              author:      user.name,
                              subtitle:    I18n.t('reminders.index.podcast.subtitle', username: user.name),

                              # urls
                              url:         url_helpers.user_url(user),
                              image_link:  url_helpers.user_url(user),
                              image:       user.avatar)

    podcast_str = @template.render metadata

    File.open(Rails.root.join(@feeds_path, 'user_pinned', "#{user.id}.rss"), 'wb') do |f|
      f << podcast_str
    end

    Rails.logger.info "Rendered podcast feed 'UsersPinned'."
  end

  def self.itunes_image_url(image)
    image.thumb('1400x1400#', format: 'png').url(name: 'image.png')
  end

  def self.unsecured_url(url)
    url.gsub(%r{https:\/\/}, 'http://')
  end

  def self.vrmedia_url(talk, fmt='mp3')
    url_helpers.root_url + 'vrmedia/' + talk.id.to_s + '.' + fmt
  end

end

# podcaster = Podcaster.new
# podcaster.render_for_user_pinned(1)
# Setting.get('feeds')

# Emitter.render_feed(:user_pinned, id: 2)

# t = Talk.find(3)
# t.update_attribute :title, '2'

# u = User.find(2)
# u.update_attribute :firstname, '8'

# Emitter.render_feed(:featured)
