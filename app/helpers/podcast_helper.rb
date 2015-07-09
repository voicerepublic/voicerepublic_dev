module PodcastHelper

  # Different systems require a different protocol:
  #   Macs: ITPC
  #   iPhone & iPad: FEED
  #   TODO Linux: Unknown (Test Amarok && Rhythmbox). Using HTTP to fall back
  #   to browser capabilities.
  #   TODO Windows: Unknown (Test scenarios need to be defined)
  #
  def podcast_url(entity)
    # default
    protocol = 'feed'
    # mac
    protocol = 'itpc' if (browser.mac? && !(browser.mobile? || browser.tablet?))
    # linux
    protocol = 'http' if browser.linux?

    url_for controller: entity.class.model_name.plural,
            action: 'show',
            id: entity.to_param,
            format: :rss,
            only_path: false,
            protocol: protocol
  end

  def link_to_podcast(entity)
    attrs = {
      class: 'button-podcast',
      'data-ga-event' => "click talk podcast talk:#{entity.id}"
    }
    attrs['data-reveal-id'] = "modal-login-signup" unless current_user

    link_to podcast_url(entity), attrs do
      content_tag('span', '', class: 'icon-podcast') +
        t('.subscribe_to_podcast')
    end
  end

end
