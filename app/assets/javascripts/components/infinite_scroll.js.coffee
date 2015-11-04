attribute = 'data-infinite-scroll'

initialize = (node, value) ->

  [ spy, target, pager ] = value.split('|')

  progress = false # use to debounce

  $(window).scroll ->

    return if progress

    top = $(window).scrollTop()
    bottom = top + $(window).height()

    pos = $(spy).offset().top

    if pos <= bottom && pos >= top
      progress = true
      page = parseInt($(pager).val())
      $(pager).val(page + 1)
      query = $(node).serialize()
      url = window.location.pathname+'?'+query
      NProgress.start()
      $.ajax url,
        success: (data) ->
          $(target).append(data)
          NProgress.done()
          progress = false
          # if data is empty remove spy

$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
