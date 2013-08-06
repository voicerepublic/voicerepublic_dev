module ApplicationHelper
  
  # limit number of words beeing displayed.
  #
  def limit_words(txt, num)
    arr = ( txt ? txt.split(" ") : [] )
    arr.length > num-1 ? arr[0..num-1].join(" ").concat(" ...") : txt
  end
  
  def simple_links(txt)
    p txt
    txt.gsub(/(https?:\/\/\S*)/, "<a href='\\1' target='_blank'>\\1</a>")
  end
  
  # simple_format, but with simple links target blanks preserved
  def sophisticated_format(txt)
    simple_format(simple_links(sanitize(txt)), {}, :sanitize => false)
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
