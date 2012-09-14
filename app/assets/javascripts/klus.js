
/*
 * CREATE CALL-BUTTON
 */

(function($){

	var klus = {};

	klus.callButton = {
		init: function() {

		},
		placeUserImage: function() {
			var img = $('.kluuu .call-btn img');
			var imgHeight = parseInt(img.height(), 10);
			var imgPadding = parseInt(img.css('padding-top'), 10);
			img.css({'margin-top': -(imgHeight/2 + imgPadding)});
		},
		bindActions: function() {
			alert('r');
			var callButton = $('.call-btn');
			var callForm = callButton.find('form');
			var callFormButtion = callForm.find('button');
			var callButtonLinks = callButton.find('a').css({'border': '1px red solid'});
		}
	};


	// document.ready
	$(function(){
		klus.callButton.bindActions();
	});
})(jQuery);

