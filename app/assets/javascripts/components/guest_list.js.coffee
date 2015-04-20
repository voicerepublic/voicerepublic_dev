# initializes the guest list(s) with select2
#
selector = '.guestList'

initialize = (node) ->
  #console.log "initialize: #{selector}"

  guests = JSON.parse($(node).val())
  $(node).select2
    width: 'element'
    multiple: true
    tokenSeparators: [",", " "]
    ajax:
      url: "/xhr/users"
      data: (q, page) ->
        limit = 10
        { q, page, limit }
      results: (data, page) ->
        # whether or not there are more results available
        more = (page * 10) < data.total
        # notice we return the value of more so Select2
        # knows if more results can be loaded
        results = data.users
        { results, more }
    # formats the options
    formatResult: (obj, container, query) ->
      "<img src='#{obj.img}'> #{obj.text}"
    # formats the entries
    formatSelection: (obj, container) ->
      "<img src='#{obj.img}'><br/> #{obj.text}"

  # workaround to populate select2 with existing data
  if guests.length > 0
    $(node).select2 'data', guests

# init if present
$.each $(selector), (index, node) -> initialize(node)
