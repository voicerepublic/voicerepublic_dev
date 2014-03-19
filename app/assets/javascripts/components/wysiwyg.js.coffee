attribute = 'data-wysiwyg'

initialize = (node, selector) ->

  # HACK: fix position of toolbar
  $(node).before($(selector))

  editor = new wysihtml5.Editor node.id,
    toolbar:     $(selector).attr('id')
    parserRules: wysihtml5ParserRules
    stylesheets: [ '/assets/wysihtml5.css' ]

$.each $("*[#{attribute}]"), (index, node) ->
  initialize node, $(node).attr(attribute)
