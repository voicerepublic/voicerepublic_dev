selector = '.languageSelect'

initialize = (node) ->

  $(node).select2
    width: 'element'

# init if present
$.each $(selector), (index, node) -> initialize(node)
    
