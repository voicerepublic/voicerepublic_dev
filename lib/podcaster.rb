require 'tilt/builder'

# FIXME: `render_for_talk` renders a previous version of the talk
# XXX: It's not a DB issue. In the after_save model Talk hook, the title is
# set correcly. Also, it's immediately correct in the next line after
# `update_attribute`. Only in the Podcaster daemon, the title is stale.

# It also shouldn't be a caching issue, because:
#  1. The daemon actually does a `select * from talks where id == x`
#  2. The daemon receives stale _even if_ the daemon is restarted! The
#  object shouldn't be cached in between killing and restarting Ruby.


# TODO: Change `puts` to `Rails.logger.info`

# Renders and persists RSS Podcast feeds
class Podcaster
  def initialize
    @template = Tilt.new('app/views/shared/_podcast.rss.builder')
  end

  def render_for_talk(id)
    # talk = Talk.find(id).reload
    # talk = ActiveRecord::Base.uncached { Talk.find(id) }
    # https://apidock.com/rails/ActiveRecord/QueryCache/ClassMethods/uncached
    talk = Talk.uncached do
      Talk.find(id)
    end

    puts "Retrieved talk with title #{talk.reload.title}"

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
                              url:         Rails.application.routes.url_helpers.talk_url(talk),
                              image_link:  Rails.application.routes.url_helpers.talk_url(talk),
                              rss_url:     Rails.application.routes.url_helpers.talk_url(talk, format: :rss),
                              image:       talk.image)

    podcast_str = @template.render metadata
    File.open(Rails.root.join('public/feeds/talks', "#{id}.rss"), 'wb') do |f|
      f << podcast_str
    end
  end

  def self.itunes_image_url(image)
    image.thumb('1400x1400#', format: 'png').url(name: 'image.png')
  end

  def self.unsecured_url(url)
    url.gsub(%r{https:\/\/}, 'http://')
  end
end

# podcaster = Podcaster.new
# podcaster.render_for_talk(2)

Emitter.render_feed(:talk, id: 2)

t = Talk.find(2)
t.update_attribute :title, "1"
Talk.find(2).title
