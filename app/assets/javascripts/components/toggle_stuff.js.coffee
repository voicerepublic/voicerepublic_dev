# TODO rename to something intelligible
#
# toggles class hide-stuff when clicked
#
attribute = 'data-toggle-stuff'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  $(element).click (e) ->
    $(selector).toggleClass 'hide-stuff'

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
