module ApplicationHelper

  def delete_params
    {
      method: :delete,
      data: { 
        confirm: I18n.t('.confirm_delete', default: 'Are you sure?')
      },
      class: 'button tiny'
    }
  end

  def destroy_participation_link(venue)
    link_to( I18n.t('helpers.venue_actions.unjoin_venue'),
             venue_participation_path(:venue_id => @venue.id),
             :method => :delete,
             :data => {
               :confirm => I18n.t('helpers.venue_actions.confirm_unjoin_venue')
             },
             :class => "btn btn-small" )
  end
  
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
  
end

# determine release once when module is loaded
ApplicationHelper::RELEASE = ApplicationHelper.determine_release
