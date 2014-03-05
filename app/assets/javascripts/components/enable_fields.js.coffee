attribute = 'data-enable-fields'

enableFields = (element, selector) ->
  source = $(element)
  target = $(selector)
  source.click (e) ->
    target.removeAttr 'disabled'

$("*[#{attribute}]").each (index, element) -> 
  value = $($(element).attr(attribute))
  enableFields element, value
