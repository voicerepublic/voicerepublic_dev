attribute = 'data-slide-down'
scroll = 'data-slide-down-scroll'
action = 'data-slide-down-action'

enableFields = (element, selector, scrollTo, actionF, targetState, targetStateOld) ->
  source = $(element)
  target = $(selector)

  source.click (e) ->
    targetStateOld = if target.hasClass 'slide-down-close' then false else true
    # alert actionF.text
    # unless actionF.length
    #   targetState = !targetStateOld
    #   alert targetState
    # else if actionF == 'open'
    #   targetState = true
    # else if actionF == 'close'
    #   targetState = false

    if targetStateOld
      closeContent target
    else
      openContent target, scrollTo



  openContent = (target,scrollTo) ->
    height = target.find('.slide-down-content').outerHeight()
    target.removeClass 'slide-down-close'
    target.height height
    if scrollTo
      $('html,body').animate
        scrollTop: target.offset().top, 500
  closeContent = (target) ->
    target.removeAttr('style')
    target.addClass('slide-down-close')

$("*[#{attribute}]").each (index, element) ->
  value    = $($(element).attr(attribute))
  scrollTo = $($(element).attr(scroll))
  actionF   = $($(element).attr(action))
  enableFields element, value, scrollTo, actionF