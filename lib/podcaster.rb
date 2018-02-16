require 'tilt'

class Podcaster
  include ApplicationHelper

  def initialize
    @template = Tilt.new('app/views/shared/_podcast.rss.builder')
  end

  def render_for_talk(id)
    talk = Talk.find(id)

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

    podcast_str = @template.render metadata
    File.open(Rails.root.join('public/feeds/talks', "#{id}.rss"), 'wb') do |file|
      file << podcast_str
    end

  end
end


# podcaster = Podcaster.new
# podcaster.render_for_talk(1)
# Emitter.render_feed(:talk, id: 1)
