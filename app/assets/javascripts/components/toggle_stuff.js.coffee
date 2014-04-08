attribute = 'data-toggle-stuff'

enableFields = (element, selector) ->
  source = $(element)
  target = $(selector)
  source.click (e) ->
    target.toggleClass 'hide'

$("*[#{attribute}]").each (index, element) ->
  value = $($(element).attr(attribute))
  enableFields element, value
