# This is the general template for podcast feeds. It is being used in
# several contexts:
#
#  * app/views/landing_page/index.rss.builder
#  * app/views/users/show.rss.builder
#  * app/views/series/show.rss.builder
#
# All channel level data is passed via the `podcast` object.
#
# Some best practices adopted from here
#
#  * http://www.rssboard.org/rss-profile
#  * https://github.com/gpodder/podcast-feed-best-practice/blob/master/podcast-feed-best-practice.md
#
# and these well established podcasts:
#
#  * http://feeds.twit.tv/twit.xml
#  * http://feed.nashownotes.com/rss.xml
#
#
# FIXME: itunes category hardcoded - where to get ahold of it?
#
namespaces = {
  'xmlns:atom'            => "http://www.w3.org/2005/Atom",
  'xmlns:media'           => "http://search.yahoo.com/mrss/",
  'xmlns:itunes'          => "http://www.itunes.com/dtds/podcast-1.0.dtd",
  'xmlns:creativeCommons' => "http://backend.userland.com/creativeCommonsRssModule",
  'xmlns:sy'              => "http://purl.org/rss/1.0/modules/syndication/",
  # see http://web.resource.org/rss/1.0/modules/dc/
  'xmlns:dc'              => "http://purl.org/dc/elements/1.1/"
}

xml.instruct!
xml.rss namespaces.merge(version: '2.0') do
  xml.channel do

    # title
    xml.title { xml.cdata! @podcast.title }
    xml.dc(:title) { xml.cdata! @podcast.title }

    xml.description do
      xml.cdata! @podcast.description + I18n.t(:podcast_branding)
    end
    xml.link @podcast.url
    langs = @podcast.talks.map(&:language).compact
    langs = %w(en) if langs.empty?
    main_lang = langs.inject(Hash.new { |h, k| h[k] = 0 }) { |h, l| h[l]+=1; h }.to_a.sort_by { |e| e.last }.last.first
    xml.language main_lang
    xml.image do
      xml.url @podcast.image_url || itunes_image_url(@podcast.image)
      xml.title do
        xml.cdata! @podcast.image_title
      end
      xml.link @podcast.image_link
    end

    # http://validator.w3.org/feed/docs/warning/MissingAtomSelfLink.html
    xml.tag! 'atom:link', rel: 'self',
             type: 'application/rss+xml',
             href: request.url

    xml.itunes :image, href: @podcast.image_url || itunes_image_url(@podcast.image)
    xml.itunes :category, text: @podcast.category
    xml.itunes :subtitle, @podcast.subtitle
    xml.itunes :summary do
      xml.cdata! @podcast.description_as_text + I18n.t(:podcast_branding)
    end
    xml.itunes :explicit, 'no'

    # author
    xml.itunes :author, @podcast.author
    xml.dc :creator, @podcast.author

    xml.itunes :owner do
      xml.itunes :name, 'VoiceRepublic Service'
      xml.itunes :email, 'service@voicerepublic.com'
    end

    talks = @podcast.talks || []
    talks.each do |talk|
      # skip talks where media is missing for whatever reason
      next unless talk.podcast_file

      xml.item do
        xml.title h talk.title

        # description
        xml.description do
          xml.cdata! talk.description + I18n.t(:podcast_branding)
        end
        xml.itunes :summary do
          xml.cdata! talk.description_as_text + I18n.t(:podcast_branding)
        end

        xml.itunes :subtitle, talk.teaser
        # TODO: Maybe we want to show the speakers here?
        xml.itunes :author, talk.series.user.name
        xml.itunes :duration, talk.podcast_file[:duration]
        xml.itunes :explicit, 'no'
        xml.itunes :image, href: itunes_image_url(talk.image)
        xml.pubDate talk.processed_at.try(:to_s, :rfc822)
        xml.link talk_url(talk)
        xml.guid talk_url(talk), isPermaLink: true
        xml.enclosure url: vrmedia_url(talk),
                      type: "audio/mpeg",
                      length: talk.podcast_file[:size]
      end
    end
  end
end
