# I admit this is not the best name.
attribute = 'data-replace-with'

initialize = (element, selector) ->
  source = $(element)
  target = $(selector)
  source.click (e) ->
    target.show()
    source.hide()

$("*[#{attribute}]").each (index, element) -> 
  value = $($(element).attr(attribute))
  initialize element, value
