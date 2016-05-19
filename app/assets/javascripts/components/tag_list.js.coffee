selector = '.tagList'

initialize = (node) ->
  #console.log "initialize: #{selector}"

  # TODO fix paging & sorting
  page = 1
  limit = 10

  $(node).selectize
    create: true
    delimiter: ','
    valueField: 'name'
    labelField: 'name'
    searchField: 'name'

    load: (q, callback) ->
      return callback() unless q.length
      $.ajax
        url: '/xhr/tags'
        data: { q, page, limit }
        success: (res) ->
          callback res.tags


# init if present
$(selector).each (index, node) ->
  initialize(node)
