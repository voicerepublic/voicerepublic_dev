attribute = 'data-slide-down'

enableFields = (element, selector) ->
  source = $(element)
  target = $(selector)
  source.click (e) ->
  	target.toggleClass 'slide-down-close'
  	if target.hasClass 'slide-down-close'
  		target.removeAttr('style')
  	else
    	height = target.find('.slide-down-content').outerHeight()
    	target.height height

$("*[#{attribute}]").each (index, element) ->
  value = $($(element).attr(attribute))
  enableFields element, value