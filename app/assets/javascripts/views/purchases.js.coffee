console.log("loading purchases") if insider

return unless $('.purchases-index')

$('.purchases-index input[type=\'radio\']').click (e) ->
  $('.purchases-index label').removeClass('selected')
  console.log(e.target)
  $(e.target).parents("label").addClass('selected')
