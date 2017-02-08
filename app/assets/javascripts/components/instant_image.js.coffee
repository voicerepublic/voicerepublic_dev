console.log("loading instant image.") if insider

attribute = 'data-instant-image'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  source = $(element)
  [imageSelector, spanSelector] = selector.split('|')
  targetImage = $(imageSelector)
  targetSpan = $(spanSelector)
  #console.log source, targetImage, targetSpan

  source.change ->
    #console.log 'changed'
    return unless source.prop('files') and source.prop('files')[0]
    reader = new FileReader
    reader.onload = (event) ->
      #console.log event
      fileName = source.val().split('\\').pop()
      targetImage.css 'background-image', "url(#{event.target.result})"
      targetSpan.html(fileName)
    #console.log source.prop('files')[0]
    reader.readAsDataURL(source.prop('files')[0])


# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
