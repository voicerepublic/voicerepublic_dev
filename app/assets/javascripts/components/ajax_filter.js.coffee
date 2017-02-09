console.log("loading ajax filter.") if insider

attribute = 'data-ajax-filters'

initialize = (node, target) ->

  inputs = $('select, input', node)
  console.log inputs
  nodes = $(inputs)

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
