attribute = 'data-ajax-filters'

initialize = (node, target) ->

  selects = $('select', node)
  nodes = $(selects)

  nodes.change (event) ->
    query = $(node).serialize()
    url = window.location.pathname+'?'+query
    NProgress.start()
    $.ajax url,
      success: (data) ->
        $(target).html(data)
        NProgress.done()

$("*[#{attribute}]").each (index, element) ->
  value = $($(element).attr(attribute))
  initialize element, value
