# when clicked hide the element and show the element identified by
# selector instead
#
attribute = 'data-replace-with'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  source = $(element)

  source.click (e) ->
    $(selector).show()
    source.hide()

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $($(element).attr(attribute))
  initialize element, value
