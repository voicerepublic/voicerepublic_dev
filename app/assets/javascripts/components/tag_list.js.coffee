selector = '.tagList'

initialize = (node) ->
  #console.log "initialize: #{selector}"

  tags = $(node).data('pre').split(',')

  $(node).select2
    width: 'element'
    multiple: true
    tokenSeparators: [",", " "]
    ajax:
      url: "/xhr/tags"
      data: (term, page) ->
        q = term
        limit = 10
        { q, page, limit }
      results: (data, page) ->
        # whether or not there are more results available
        more = (page * 10) < data.total
        # notice we return the value of more so Select2
        # knows if more results can be loaded
        results = data.tags
        { results, more }
    # we want to return the names not the ids
    id: (e) -> e.name
    createSearchChoice: (term) ->
      id = $.trim term
      name = id
      { id, name }
    # select2 assumes 'text', but in our case it's 'name'
    formatResult: (result, container, query, escapeMarkup) ->
      markup = []
      Select2.util.markMatch(result.name, query.term, markup, escapeMarkup)
      markup.join ''
    formatSelection: (data, container, escapeMarkup) ->
      if data then escapeMarkup(data.name) else undefined

  # workaround to populate select2 with existing data
  formatted = []
  $.each tags, (i, name) ->
    if name != ''
      id = Math.floor(Math.random() * 1000)
      formatted.push { id, name }
  if tags.length > 0
    $(node).select2 'data', formatted

# init if present
$.each $(selector), (index, node) -> initialize(node)
