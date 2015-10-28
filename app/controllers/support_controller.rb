class SupportController < ApplicationController

  layout 'support'

  def foo_bar
    render partial: "test_foo"
  end

  def api
    @api_doc = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new,
                                       fenced_code_blocks: true).
                                       render(File.read(Rails.root.join("doc/API.md")))
  end

end
