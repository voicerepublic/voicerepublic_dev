# jQuery-UI Datepicker
#
#     http://api.jqueryui.com/datepicker/
#
# jQuery-UI Timepicker Addon (3rd party)
#
#     https://github.com/trentrichardson/jQuery-Timepicker-Addon
#
attribute = 'data-picker'

initialize = (element, scope) ->
  console.log "initialize: #{attribute} (#{scope})"

  target = $(element)

  if scope == 'date'
    target.datepicker
      dateFormat: "yy-mm-dd"
      prevText: ''
      nextText: ''

  if scope == 'time'
    target.timepicker
      timeFormat: 'HH:mm'
      hourGrid: 3
      minuteGrid: 10

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
