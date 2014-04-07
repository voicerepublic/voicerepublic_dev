validate_search_input = function(e) {
  var search_input = $('#query');
  if( !search_input.val() ) {
    $(search_input).addClass('warning');
    e.preventDefault();
    return false;
  }
}

$(function() {
  $('#query').on('blur keypress', function() {
    $(this).removeClass('warning');
  });
  $('#query').add(".navbar-search").on('keypress submit', function(e) {
    if ((e.type == "submit") || (e.which == 13)) {
      validate_search_input(e);
    }
  });
});

