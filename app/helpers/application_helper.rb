module ApplicationHelper

  # s works much like t, but looks up md formatted content from the db
  # and inserts it as html
  def section(key)
    if key.to_s.first == "."
      if @virtual_path
        key = @virtual_path.gsub(%r{/_?}, ".") + key.to_s
      else
        raise "Cannot use s(#{key.inspect}) shortcut because path is not available"
      end
    end
    Section.find_or_create_by(key: key, locale: I18n.locale).content_as_html.html_safe
  end
  alias_method :s, :section


  def blog_url(path)
    "http://blog.voicerepublic.com#{path}?lang=#{I18n.locale}"
  end


  def icon_tag(topic)
    "<div class='svg-icon'><svg><use xlink:href='#icon-#{topic}'></use></svg></div>".html_safe
  end


  def test_talk_path
    new_talk_path talk: { dryrun: true }
  end

  def vrmedia_url(talk, fmt='mp3')
    root_url + 'vrmedia/' + talk.id.to_s + '.' + fmt
  end

  def rss_link_tag(title, url=nil)
    url ||= url_for(format: 'rss')
    tag :link, rel: "alternate",
        type: "application/rss+xml",
        title: title,
        href: url
  end

  # abstract delete params, valid for all resources
  def delete_params
    {
      method: :delete,
      data: {
        confirm: I18n.t('.confirm_delete', default: 'Are you sure?')
      },
      class: 'link-delete'
    }
  end

  # limit number of words being displayed.
  #
  def limit_words(txt, num)
    arr = ( txt ? txt.split(" ") : [] )
    arr.length > num-1 ? arr[0..num-1].join(" ").concat(" ...") : txt
  end

  # TODO: move into trickery
  class << self
    def determine_release
      path = Rails.env.production? ? '../repo' : '.'
      tag = %x[ (cd #{path} && git describe --tags --abbrev=0) ].chomp || 'notag'
      patchlevel = %x[ (cd #{path} && git log --oneline #{tag}.. | wc -l) ].chomp
      # date = %x[ (cd #{path} && git log -1 --format=%ai) ].chomp
      # "#{tag} p#{patchlevel} (#{date})"
      "#{tag} p#{patchlevel}"
    end
  end

  def release
    RELEASE
  end

  def strip_html(str)
    document = Nokogiri::HTML.parse(str)
    document.css("br").each { |node| node.replace("\n") }
    document.text
  end

  def render_social_meta_tags(opts)
    render partial: 'shared/social_meta_tags', locals: opts
  end

end

# determine release once when module is loaded
ApplicationHelper::RELEASE = ApplicationHelper.determine_release
