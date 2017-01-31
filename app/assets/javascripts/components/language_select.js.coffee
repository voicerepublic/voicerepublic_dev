console.log("loading lang select.") if insider

# activates `select2` on dropdowns with class `languageSelect`
selector = '.languageSelect'

initialize = (node) ->
  #console.log "intialize: #{selector}"

  $(node).select2
    width: 'element'

# init if present
$.each $(selector), (index, node) -> initialize(node)
