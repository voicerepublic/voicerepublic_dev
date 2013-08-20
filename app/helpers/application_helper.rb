module ApplicationHelper
  
  # limit number of words beeing displayed.
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
    template = "\n\n<iframe width='307' height='188' " +
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
  
end
