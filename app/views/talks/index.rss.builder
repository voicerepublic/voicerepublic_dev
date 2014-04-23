# FIXME: itunes category hardcoded - where to get ahold of it?
# FIXME: file length should be computed
# FIXME: xml.lang is hardcoded

xml.instruct! 
xml.rss version: '2.0', "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title h @venue.title
    xml.description h @venue.description
    xml.link venue_url(@venue)
    xml.language 'DE'
    xml.image do
      xml.url itunes_image_url(@venue.image)
      xml.title @venue.title
      xml.link venue_url(@venue)
    end
    #xml.tag! 'atom:link', rel: 'self', 
    #                      type: 'application/rss+xml', 
    #                      href: venue_talks_url(@venue, format: :rss)

    xml.itunes :image, href: itunes_image_url(@venue.image)
    xml.itunes :author, @venue.user.name
    xml.itunes :category, text: "Society & Culture" 
    xml.itunes :subtitle, @venue.teaser
    xml.itunes :summary, @venue.description
    xml.itunes :explicit, 'no'
    xml.itunes :owner do 
      xml.itunes :email, @venue.user.email
    end
    @venue.talks.archived.each do |talk|
      xml.item do
        xml.title h talk.title
        xml.description h talk.description
        xml.itunes :subtitle, talk.teaser
        xml.itunes :summary, talk.description
        xml.itunes :author, @venue.user.name
        xml.itunes :duration, itunes_duration_format(talk.duration)
        xml.itunes :explicit, 'no'
        xml.itunes :image, href: itunes_image_url(talk.image)
        xml.pubDate talk.processed_at.to_s(:rfc822)
        xml.link venue_talk_url(@venue, talk)
        xml.guid venue_talk_url(@venue, talk)
        xml.enclosure url: itunes_enclosure_url(talk),
                      type: "audio/mpeg",
                      length: 0
      end
    end
  end
end
