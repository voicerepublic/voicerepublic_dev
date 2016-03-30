class PagesController < ApplicationController

  skip_before_filter :check_browser

  layout 'velvet'

  def api
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new,
                                       fenced_code_blocks: true)
    @api_doc = renderer.render(File.read(Rails.root.join("doc/API.md")))
  end

  def error
    raise 'Hello Errbit!'
  end

end
