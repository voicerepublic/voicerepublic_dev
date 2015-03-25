module ApplicationHelper

  def test_talk_path
    new_talk_path(talk: {
                    dryrun: true,
                    title: Faker::Commerce.product_name,
                    tag_list: Faker::Commerce.department,
                    teaser: Faker::Company.catch_phrase,
                    starts_at_date: Date.today,
                    starts_at_time: 1.minute.from_now.strftime('%H:%M'),
                    description: Faker::Lorem.paragraph(3)
                  })
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

  def simple_links(txt)
    txt.gsub(/(https?:\/\/\S*)/, "<a href='\\1' target='_blank'>\\1</a>")
  end

  # adds iframes for typical youtube links
  #
  # e.g.
  #   http://www.youtube.com/watch?v=F0G0YNHINwY
  #   or
  #   http://youtu.be/F0G0YNHINwY
  #
  # will be added as
  #   <iframe width="560" height="315" frameborder="0" allowfullscreen
  #     src="//www.youtube.com/embed/F0G0YNHINwY"></iframe>
  #
  def youtubify(txt)
    template = "\n\n<iframe width='640' height='480' " +
      "src='//www.youtube.com/embed/%s' " +
      "frameborder='0' allowfullscreen></iframe>"

    patterns = [ /https?:\/\/www\.youtube\.com\/watch\?v=(\S+)/,
                 /https?:\/\/youtu\.be\/(\S+)/ ]

    patterns.map do |pattern|
      if md = txt.match(pattern)
        md.to_a[1..-1].each do |key|
          txt += template % key
        end
      end
    end

    txt
  end

  # simple_format, but with simple links target blanks preserved
  # TODO replace with somethink like https://github.com/jch/html-pipeline
  def sophisticated_format(txt)
    simple_format(youtubify(simple_links(sanitize(txt))), {}, :sanitize => false)
  end

  def app_mode
    Rails.env
  end

  def git_revision
    gi = KluuuCode::GitInfo.new(Rails.root)
    gi.latest
  end

  def klu_type_string(klu)
    klu.instance_of?(Kluuu) ? t('helper.application.kluuu_string') : t('helper.application.no_kluuu_string')
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
    render partial: 'shared/social_meta_tags',
      locals: { **opts }
  end

end

# determine release once when module is loaded
ApplicationHelper::RELEASE = ApplicationHelper.determine_release
