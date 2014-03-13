showUpload = (element) ->
  target = $(element)

  source = $("#{target.attr('data-show-upload')}")
  source.change ->
    reader = new FileReader()
    reader.onload = (e) ->
      target.css 'backgroundImage', "url(#{e.target.result})" 
    reader.readAsDataURL source[0].files[0]

$('*[data-show-upload]').each (index,element) -> 
  showUpload(element)
