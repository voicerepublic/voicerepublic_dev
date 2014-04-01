attribute = 'data-show-upload'

initialize = (element, selector) ->
  target = $(element)
  source = $(selector)
  source.change ->
    reader = new FileReader()
    reader.onload = (e) ->
      target.css 'backgroundImage', "url(#{e.target.result})" 
    reader.readAsDataURL source[0].files[0]

$("*[#{attribute}]").each (index, element) -> 
  value = $(element).attr(attribute)
  initialize element, value
