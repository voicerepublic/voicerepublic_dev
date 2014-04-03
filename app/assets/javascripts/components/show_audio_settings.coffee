attribute = 'data-show-audio-settings'

initialize = (element, selector) ->
  source = $(element)
  target = $(selector)
  source.click (e) ->
    target.toggleClass('flash-box-open')

$("*[#{attribute}]").each (index, element) -> 
  value = $($(element).attr(attribute))
  initialize element, value