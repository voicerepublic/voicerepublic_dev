attribute = 'data-trigger-on-error'

initialize = (element, selector) ->
  source = $(element)
  target = $(selector)
  if $('.error', target).length
    source.click()

$("*[#{attribute}]").each (index, element) -> 
  value = $(element).attr(attribute)
  initialize element, value
