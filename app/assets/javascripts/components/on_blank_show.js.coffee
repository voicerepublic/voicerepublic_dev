# use with `select` tags or simple_form's `association`, e.g.
#
#   = f.association :series, collection: current_user.series,
#     include_blank: t('.create_new_series'),
#     input_html: { 'data-on-blank-show' => '#wrapper_new_series_title' }
#
# if the empty option of the select is selected it triggers the node
# to be shown which matches the selector provided as the value of the
# attribute.
#
console.log("loading on blank show.") if audit

attribute = 'data-on-blank-show'

initialize = (node, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  target = $(selector)

  $(node).change (event) ->
    return target.show() if @value == ''
    target.hide()

  target.hide() unless $(node).val() in [undefined, '']

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
