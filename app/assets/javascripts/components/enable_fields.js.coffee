# when clicked removes the attribute disabled on the element specified
# by selector
#
attribute = 'data-enable-fields'

initialize = (element, selector) ->
  console.log "initialize: #{attribute} (#{selector})"

  $(element).click (e) ->
    $(selector).removeAttr 'disabled'

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
