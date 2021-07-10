# https://github.com/vmg/redcarpet

require 'redcarpet/render_strip'

class Redcarpet::Render::VRHTML < Redcarpet::Render::HTML

  def preprocess(doc)
    detect_youtube_link(doc)
  end

  def postprocess(doc)
    render_youtube_embed(doc)
  end

  private

  def detect_youtube_link(doc)
    patterns = [ /https?:\/\/www\.youtube\.com\/watch\?v=([^'"< ]+)/,
                 /https?:\/\/youtu\.be\/([^'"< ]+)/ ]

    patterns.map do |pattern|
      if md = doc.match(pattern)
        md.to_a[1..-1].each do |key|
          @youtube_keys ||= []
          @youtube_keys << key
        end
      end
    end
  end

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
  def render_youtube_embed(txt)
    return txt if @youtube_keys.nil?

    template = "\n\n<iframe width='640' height='480' " +
               "src='//www.youtube.com/embed/%s' " +
               "frameborder='0' allowfullscreen></iframe>"

   result = @youtube_keys.reduce(txt) { |doc, key| doc + (template % key) }
   @youtube_keys = nil
   result
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
  hard_wrap: true,
  filter_html: false
}

extensions = {
  lax_spacing: true,
  highlight: true
}

MD2PAGES = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(options), extensions)
