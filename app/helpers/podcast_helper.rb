module PodcastHelper

  # TODO fix this and maybe ge rif to the browser gem on the way
  def podcast_url(entity)
    # Different systems require a different protocol:
    #   Macs: ITPC
    #   iPhone & iPad: FEED
    #   TODO Linux: Unknown (Test Amarok && Rhythmbox). Using HTTP to fall back
    #   to browser capabilities.
    #   TODO Windows: Unknown (Test scenarios need to be defined)
    #
    # default
    #protocol = 'feed'
    # mac
    #protocol = (browser.mac? && !(browser.mobile? || browser.tablet?)) ? 'itpc' : protocol
    # linux
    #protocol = browser.linux? ? 'http' : protocol

    if browser.firefox?
      podcast_url_new entity
    elsif browser.mac? && !browser.ios?
      itunes_url entity
    else # browser.ios? || browser.android? || browser.chrome? || browser.ie? || browser.edge
      feed_url entity
    end

  end

  def itunes_url(entity)
    podcast_url_for_protocol(entity, 'itpc')
  end

  def podcast_url_new(entity)
    podcast_url_for_protocol(entity)
  end

  def feed_url(entity)
    podcast_url_for_protocol(entity, 'feed')
  end

  def podcast_url_for_protocol(entity, protocol = nil)
    options = { controller: entity.class.model_name.plural,
                action: 'show',
                id: entity.to_param,
                format: :rss,
                only_path: false }
    options[:protocol] = protocol if protocol
    url_for options
  end

  def link_to_podcast(entity)
    url = podcast_url(entity)
    link_to url, class: 'button-podcast', 'data-ga-event' => "click talk podcast talk:#{entity.id}" do
      content_tag('span', '', class: 'icon-podcast') +
        t('.subscribe_to_podcast')
    end

  end

end
