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
  target = $(element)
  now = new Date

  if scope == 'date'
    target.datepicker
      minDate: 0
      dateFormat: "yy-mm-dd"
    target.datepicker "setDate", now
      
  if scope == 'time'
    target.timepicker
      timeFormat: 'HH:mm'
      hourGrid: 3
      minuteGrid: 10
    target.datepicker "setDate", now

$("*[#{attribute}]").each (index, element) -> 
  value = $(element).attr(attribute)
  initialize element, value
