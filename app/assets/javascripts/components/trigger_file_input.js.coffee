# when clicking on the given element, trigger a click on the file
# upload selection button
#
attribute = 'data-trigger-file-input'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"
  $(element).click -> $(selector).click()

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
