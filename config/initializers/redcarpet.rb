# https://github.com/vmg/redcarpet

MD2HTML = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true))

# class Redcarpet::Render::TEXT < Redcarpet::Render::Base
#   # TODO implement the renderer
# end
#
# MD2TEXT = Redcarpet::Markdown.new(Redcarpet::Render::TEXT.new)
