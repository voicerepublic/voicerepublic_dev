console.log("loading pinboard.") if audit

pinMap = [] unless pinMap?

selector = '.pinboard'

csrfToken = $('*[name=csrf-token]').attr('content')

initialize = (node) ->

  talkId = $(node).attr('data-pin')
  reminderId = -> pinMap[talkId]

  setState = (pinned) ->
    if pinned
      $('.unpin-btn', node).show()
      $('.pin-btn', node).hide()
    else
      $('.pin-btn', node).show()
      $('.unpin-btn', node).hide()

  setState(reminderId())

  $('.unpin-btn', node).click (event) ->
    event.preventDefault()
    $.ajax
      headers: { 'X-CSRF-Token': csrfToken }
      url: "/reminders/#{reminderId()}"
      type: 'DELETE'
      success: (result) ->
        setState(false)

  $('.pin-btn', node).click (event) ->
    event.preventDefault()
    $.ajax
      headers: { 'X-CSRF-Token': csrfToken }
      url: "/talks/#{talkId}/reminders"
      type: 'POST'
      success: (result) ->
        pinMap[talkId] = result.reminder_id
        setState(true)

# init if present
$(selector).each (index, node) ->
  initialize node
