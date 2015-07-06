class SupportController < ApplicationController

  layout 'support'

  def api
    @api_doc = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new,
                                       fenced_code_blocks: true).
                                       render(File.open(Rails.root.join("doc/API.md"), "r").read)
  end

end
