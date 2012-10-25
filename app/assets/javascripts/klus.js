
/*
 * CREATE CALL-BUTTON
 */

(function($){

	var klus = {};

	klus.callButton = {
		init: function() {
			this.jqueryfy();
			this.keepAspectRatio();
			fitText('.klu-title:not(input)');
		},
		jqueryfy: function() {
			$('.call-btn').addClass("jqueryfied")
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
		},
		keepAspectRatio: function() {
			$('.no-kluuu .klu-eyecatcher.klu-title').each(function() {
				$(this).height(parseInt($(this).width(), 10) * 3/4 + "px").addClass('well well-small');
			});
		}
	};


	// document.ready
	$(function(){
		klus.callButton.init();
	});
})(jQuery);

