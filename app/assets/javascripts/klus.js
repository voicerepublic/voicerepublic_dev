
/*
 * CREATE CALL-BUTTON
 */

(function($){

	var klus = {};

	klus.callButton = {
		init: function() {
			this.jqueryfy();
			this.placeUserImage();
			this.bindActions();
		},
		jqueryfy: function() {
			$('.call-btn').addClass("jqueryfied")
		},
		placeUserImage: function() {
			var img = $('.klu-layout .call-btn img');
			var imgHeight = parseInt(img.height(), 10);
			var imgPadding = parseInt(img.css('padding-top'), 10);
			img.css({'margin-top': -(imgHeight/2 + imgPadding)});
		},
		bindActions: function() {
			var callButton = $('.call-btn');
			var callForm = callButton.find('form');
			var callFormButtion = callForm.find('button');
			var callButtonLinks = callButton.find('a').on('click', function(e){
				e.stopPropagation();
				e.preventDefault();
				document.location = this.href;
			});
			/** TODO: @Timo: Bind Button-Action **/
		}
	};


	// document.ready
	$(function(){
		klus.callButton.init();
	});
})(jQuery);

