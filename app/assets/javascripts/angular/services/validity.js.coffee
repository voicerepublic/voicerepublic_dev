validityFunc = ($log) ->

  counter = 0
  elements = {}

  register = (initial_state) ->
    counter += 1
    setter = (state) ->
      # $log.debug "validity: set #{counter} to #{state}"
      elements[counter] = state
    setter(initial_state)
    setter

  valid = ->
    values = (value for key, value of elements)
    values.reduce (r, v) -> r and v

  {
    register
    valid
  }

# annotate with dependencies to inject
validityFunc.$inject = ['$log']
window.sencha.factory "validity", validityFunc
