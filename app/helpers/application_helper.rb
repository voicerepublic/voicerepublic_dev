module ApplicationHelper

  def body_classes
    list = [ controller_name,
             [controller_name, action_name] * '-' ]
    list += @body_classes unless @body_classes.nil?
    list * ' '
  end

  def default_content(locale, key)
    keys = [locale.to_s] + key.split('.')
    keys.reduce(sections) do |r, k|
      case r
      when String then r
      when nil then nil
      else r[k]
      end
    end
  end

  # TODO: refactor into controllers
  def render_footer?
    return false if controller_action == 'explore-index'
    return false if controller_action == 'users-edit'
    return false if controller_action == 'venues-show'
    return false if controller_action == 'talks-new'
    return false if controller_action == 'uploads-new'
    return false if controller_action == 'pages-publish_talk'
    true
  end

  # TODO: refactor into controllers
  def render_top_loader?
    return false if controller_action == 'talks-show'
    true
  end

  def controller_action
    [controller_name, action_name] * '-'
  end

  # s works much like t, but looks up md formatted content from the db
  # and inserts it as html
  #
  # interpolations are also options, but the only option is :format
  def section(key, interpolations={})
    if key.to_s.first == "."
      if @virtual_path
        key = @virtual_path.gsub(%r{/_?}, ".") + key.to_s
      else
        raise "Cannot use s(#{key.inspect}) shortcut because path is not available"
      end
    end
    section = Section.find_or_create_by(key: key, locale: I18n.locale)
    if section.content.nil? # nil not blank!
      section.content = default_content(locale, key)
      section.save
      section.reload
    end
    case interpolations[:format]
    when 'raw'
      section = section.content || ''
    else
      section = section.content_as_html
    end
    section = interpolations.inject(section) do |result, interpolation|
      name, value = interpolation
      result.gsub("%{#{name}}", value)
    end
    if Rails.env.development? and section.blank?
      section = [key, interpolations.inspect] * ' '
    end
    section.html_safe
  end
  alias_method :s, :section


  def blog_url(path)
    "http://blog.voicerepublic.com#{path}?lang=#{I18n.locale}"
  end


  def icon_tag(topic, opts={})
    title = opts[:title] || topic
    "<div class='svg-icon' title='#{title}'><svg><use xlink:href='#icon-#{topic}'></use></svg></div>".html_safe
  end

  def naked_icon(topic, opts={})
    "<svg><use xlink:href='#icon-#{topic}'></use></svg>".html_safe
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
      class: 'link-delete button hollow muted btn-hover-red'
    }
  end

  # limit number of words being displayed.
  #
  def limit_words(txt, num)
    arr = ( txt ? txt.split(" ") : [] )
    arr.length > num-1 ? arr[0..num-1].join(" ").concat(" ...") : txt
  end

  # TODO: move into trickery
  def release
    @release ||=
      begin
        path = Rails.env.production? ? '../repo' : '.'
        tag = %x[ (cd #{path} && git describe --tags --abbrev=0) ].chomp || 'notag'
        patchlevel = %x[ (cd #{path} && git log --oneline #{tag}.. | wc -l) ].chomp
        # date = %x[ (cd #{path} && git log -1 --format=%ai) ].chomp
        # "#{tag} p#{patchlevel} (#{date})"
        "#{tag} p#{patchlevel}"
      end
  end

  def sections
    # TODO read all yaml files from config/sections
    # TODO check if files changed and reread
    @sections = # TODO then activate caching with ||=
      YAML.load(File.read(Rails.root.join('config/sections.yml')))
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
