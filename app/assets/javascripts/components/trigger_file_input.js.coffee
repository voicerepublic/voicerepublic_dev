triggerFileInput = (element) ->
	source = $(element)
	target = $("##{source.attr('data-trigger-file-input')}")
	source.click -> 
  	target.click()

$('*[data-trigger-file-input]').each (index,element) -> 
  triggerFileInput(element)