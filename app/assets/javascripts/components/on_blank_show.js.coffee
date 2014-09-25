# use with `select` tags or simple_form's `association`
attribute = 'data-on-blank-show'

initialize = (node, selector) ->

  target = $(selector)

  $(node).change (event) ->
    if @value == ''
      target.show()
    else
      target.hide()

  $(selector).hide()

$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
