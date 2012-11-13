/*
 * CREATE NOTICE
 */

(function($){

	var helpNotices = {};

  helpNotices.init = function() {
    var parent;
    helpNotices.onPage = $('.help-text');
    var closeIt = $('<div />').addClass('alert').html('<a href="#">Hilfe schließen</a>');

    closeIt.appendTo('#flash_messages');

    closeIt.children('a').on('click', function(e){
      e.preventDefault();
      helpNotices.onPage.fadeOut('fast', function() {
        helpNotices.onPage.remove();
      });
      closeIt.fadeOut('fast', function() {
        closeIt.remove();
      });
    });

    

    $.each(helpNotices.onPage, function() {
      parent = $(this).parent();
      if (parent.css("position") === "static") {
        parent.css("position", "relative");
      }
    });
  };

	

	// document.ready
	$(function(){
		helpNotices.init();
	});
})(jQuery);