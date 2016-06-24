# https://github.com/vmg/redcarpet

require 'redcarpet/render_strip'

class Redcarpet::Render::VRHTML < Redcarpet::Render::HTML

  def postprocess(doc)
    youtubify(doc)
  end

  private

  # adds iframes for youtube links
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

end

MD2HTML = Redcarpet::Markdown.new(Redcarpet::Render::VRHTML.new(filter_html: true))

class Redcarpet::Render::VRStripDown < Redcarpet::Render::StripDown

  def raw_html(str)
    return "\n" if str =~ /^<br *\/?>$/
    ""
  end

  def entity(str)
    Nokogiri::HTML.parse(str).text
  end

  def normal_text(str)
    str.gsub(/\\n/, "\n")
  end

end

MD2TEXT = Redcarpet::Markdown.new(Redcarpet::Render::VRStripDown.new)

# a more permissive renderer

options = {
  hard_wrap: true
}

extensions = {
  lax_spacing: true,
  highlight: true
}

MD2PAGES = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(options), extensions)
