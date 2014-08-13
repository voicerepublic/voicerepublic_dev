module PodcastHelper

  def link_to_podcast(entity)
    # Different systems require a different protocol:
    #   Macs: ITPC
    #   iPhone & iPad: FEED
    #   TODO Linux: Unknown (Test Amarok && Rhythmbox). Using HTTP to fall back
    #   to browser capabilities.
    #   TODO Windows: Unknown (Test scenarios need to be defined)
    #
    # default
    protocol = 'feed'
    # mac
    protocol = (browser.mac? && !(browser.mobile? || browser.tablet?)) ? 'itpc' : protocol
    # linux
    protocol = browser.linux? ? 'http' : protocol

    link_to content_tag('span', '', class: 'icon-podcast') + t('.subscribe_to_podcast'),
      url_for(controller: entity.class.to_s.pluralize.downcase,
              action: 'show',
              format: :rss,
              only_path: false,
              protocol: protocol),
      class: 'button-podcast'

  end

end
