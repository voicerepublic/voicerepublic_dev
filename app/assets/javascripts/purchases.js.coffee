return unless $('.purchases-index')

$('.purchases-index input[type=\'radio\']').click (e) ->
  $('.purchases-index label').removeClass('selected')
  $(e.target.parentNode).addClass('selected')
