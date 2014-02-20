guestList = ->
  
  users = $('.guestList').val().split(',')
  
  $('.guestList').select2
    width: 'element'
    multiple: true
    tokenSeparators: [",", " "]
    ajax:
      url: "/api/users"
      data: (term, page) ->
        q = term
        limit = 10
        { q, page, limit }
      results: (data, page) ->
        # whether or not there are more results available
        more = (page * 10) < data.total
        # notice we return the value of more so Select2
        # knows if more results can be loaded
        results = data.users
        { results, more }
    # we want to return the lastnames not the ids
    id: (e) -> e.lastname
    createSearchChoice: (term) ->
      id = $.trim term
      name = id
      { id, name }
    # select2 assumes 'text', but in our case it's 'lastname'
    formatResult: (result, container, query, escapeMarkup) ->
      markup = []
      Select2.util.markMatch(result.lastname, query.term, markup, escapeMarkup)
      markup.join ''
    formatSelection: (data, container, escapeMarkup) ->
      if data then escapeMarkup(data.lastname) else undefined
  
  # workaround to populate select2 with existing data
  formatted = []
  $.each users, (i, lastname) ->
    if lastname != ''
      id = Math.floor(Math.random() * 1000)
      formatted.push { id, lastname }
  if users.length > 0
    $('.guestList').select2 'data', formatted                   

# init if present
guestList() if $('.guestList').length
