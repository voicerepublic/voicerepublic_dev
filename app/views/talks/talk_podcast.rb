require 'tilt'

class Podcaster
  include ApplicationHelper

  def initialize
    @template = Tilt.new('app/views/shared/_podcast.rss.builder')
  end

  def render(model, id)
    talk = model.find(id)

    metadata = OpenStruct.new({talks: [talk],

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
                               url:         Rails.application.routes.url_helpers.talk_url(talk),
                               image_link:  Rails.application.routes.url_helpers.talk_url(talk),
                               rss_url:     Rails.application.routes.url_helpers.talk_url(talk, format: :rss),
                               image:       talk.image})

    @template.render metadata
  end


end

podcaster = Podcaster.new
podcaster.render(Talk, 1)
