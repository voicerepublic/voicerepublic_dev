/*
 * CREATE NOTICE
 */

(function($){


	var helpNotices = {};

  helpNotices.build = function() {
    helpNotices.onPage = $('.help-text');

    function closeBox() {
        var closeIt = $('<div />').addClass('alert alert-help-layer').html('<h3>Hilfe</h3><a href="/de/dashboard/settings/edit">Hilfe in Einstellungen ausschalten</a>');
        closeIt.appendTo('#flash_messages');
      
      // closeIt.children('a').on('click', function(e){
        $('.help-text-close, .alert-help-layer').on('click', function(e){
        helpNotices.onPage.fadeOut('fast', function() {
          helpNotices.onPage.remove();
        });
        closeIt.fadeOut('fast', function() {
          closeIt.remove();
        });
      });
    }

    var parent;
    $.each(helpNotices.onPage, function() {
      parent = $(this).parent();
      if (parent.css("position") === "static") {
        parent.css("position", "relative");
      }
    });
    closeBox();
  };

  helpNotices.init = function() {
    helpNotices.onPage = $('.help-text');
    if (helpNotices.onPage.length > 0){
      helpNotices.build();
    }
  };

	// document.ready
	$(function(){

		helpNotices.init();
	});
})(jQuery);