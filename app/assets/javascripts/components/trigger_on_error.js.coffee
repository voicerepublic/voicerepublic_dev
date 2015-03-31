# TODO describe
#
attribute = 'data-trigger-on-error'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  $(element).click() if $('.error', $(selector)).length

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
