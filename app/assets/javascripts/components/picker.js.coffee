attribute = 'data-picker'

initialize = (element, scope) ->
  target = $(element)

  if scope == 'date'
    target.datepicker
      minDate: 0
      dateFormat: "yy-mm-dd"
      
  if scope == 'time'
    target.timepicker
      timeFormat: 'HH:mm'
      hourGrid: 3
      minuteGrid: 10

$("*[#{attribute}]").each (index, element) -> 
  value = $(element).attr(attribute)
  initialize element, value
