# makes the selected upload image appear on the page even before it
# was actually uploaded to the backend
#
attribute = 'data-show-upload'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  target = $(element)
  source = $(selector)

  source.change ->
    reader = new FileReader()
    reader.onload = (e) ->
      target.css 'backgroundImage', "url(#{e.target.result})"
    reader.readAsDataURL source[0].files[0]

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
