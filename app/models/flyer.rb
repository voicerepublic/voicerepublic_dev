class Flyer < Struct.new(:talk)

  # colors according to ci style guide
  COLORS = %w( #182847 #2c46b0 #54c6c6 #a339cd )

  # check if the fyler file exists
  def exist?
    File.exist?(path(true))
  end

  # remove the flyer file
  def disintegrate!
    File.unlink(path(true)) if exist?
  end

  # returns either the web path (default)
  #
  #     e.g. /system/flyer/42.png
  #
  # or, if `fs` is true, the absolute file system path
  #
  #     e.g. /home/app/app/shared/public/system/flyer/42.png
  #
  def path(fs=false)
    name = "#{talk.id}.png" # TODO use friendly id
    return Settings.flyer.location + '/' + name unless fs

    path = File.expand_path(Settings.flyer.path, Rails.root)
    FileUtils.mkdir_p(path)
    File.join(path, name)
  end

  # Generates a svg flyer and converts it to png via Inkscape.
  #
  # This can be run in bulk to regenerate all flyers:
  # FIXME
  #
  #     FileUtils.rm(Dir.glob('app/shared/public/system/flyer/*.png'))
  #     Talk.find_each { |t| t.send(:generate_flyer) }
  #
  def generate!
    a_svg_file = svg_file
    cmd = "inkscape -f %s -e %s 2>&1 >/dev/null"
    ActiveSupport::Notifications.instrument "flyer.inkscape.vr", cmd: cmd do
      system cmd % [ a_svg_file.path, path(true) ]
    end
    a_svg_file.unlink
  end

  def svg_file
    svg_data = File.read(svg_template)
    interpolations.each do |key, value|
      svg_data.sub! "[-#{key}-]", Nokogiri::HTML.fragment(value).to_s
    end

    file = Tempfile.new('svg')
    file.write svg_data
    file.close
    file
  end

  def svg_template
    File.expand_path(File.join(%w(doc design flyer.svg)), Rails.root)
  end

  def interpolations
    {
      color:    COLORS[rand(COLORS.size)],
      host:     tlak.speakers || talk.user.name,
      title:    talk.title,
      day:      I18n.l(talk.starts_at, format: :flyer_day),
      datetime: I18n.l(talk.starts_at, format: :flyer_datetime)
    }
  end

end
