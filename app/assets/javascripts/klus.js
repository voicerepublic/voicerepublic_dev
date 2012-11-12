
(function($){

	var klus = {};

	klus.imageGallery = {
		init: function() {
			if ($('.large-klu:not(.klu-form) .kluuu-pics').length > 0) {
				this.buildGallery();
			}
		},

		getImageURLs: function() {
			return $('.kluuu-pics').data('images-urls').split(' ');
		},

		buildGallery: function() {
			var i = 0;
			var imagesURLs = this.getImageURLs();
			$('.klu-eyecatcher').on('click', function() {
				if (i+1 < imagesURLs.length) {
					i++;
				}
				else {
					i = 0;
				}
				$('.klu-eyecatcher').find('img').attr('src', imagesURLs[i]);
			});
		}
	};

	klus.tagInput = {
		init: function() {
			if ($('.klu-form').length > 0) {
				this.build();
			}
		},

		

		build: function() {

			var tagList = [];

			var isTagUsed = function(tag) {
				$.each(tagList, function(i){
					if(tagList[i] === tag) {
						return true;
					} else {
						return false;
					}
				});
			};

			var newPill = function(tag) {
				var pill = $('<span />').css({
					display: 'inline-block',
					margin: '3px 2px'
				});
				pill.text(tag);
				pill.data('tag', tag);
				pill.addClass('label');
				pill.prependTo($workingContainer).hide().fadeIn('fast');
				var deleteTag = $("<span>&times;</span>").appendTo(pill);
				deleteTag.css({
					cursor: 'pointer',
					marginLeft: '3px'
				});
				deleteTag.on('click', function() {
					$.each(tagList, function(i){
						if (pill.data("tag") == tagList[i]) {
							tagList.splice(i, 1);
							$input.val(tagList.join(","));
						}
					});
					pill.fadeOut('fast', function() {
						pill.remove();
					});
				});
			};

			var firstRun = function($input) {
				var previousTags = $input.val();
				previousTags = previousTags.split(', ');
				$.each(previousTags, function(i) {
					newPill(previousTags[i]);
					tagList.push(previousTags[i]);
				});
			};

			var $input =  $('#klu_tag_list').hide();
			var $workingContainer = $input.parent();
			var $newInput = $("<input>", {'type': 'text'}).appendTo($workingContainer);
			$newInput.attr('placeholder', 'Add new tag with pressing enter after you typed it');
			firstRun($input);
			$newInput.on('keydown', function(event) {
				if(event.keyCode == 13) {
					event.preventDefault();
					event.stopPropagation();
				}
			});
			$newInput.on('keyup', function(event) {
				tag = $newInput.val();
				if(event.keyCode == 13 && !(isTagUsed(tag))){
					event.preventDefault();
					event.stopPropagation();
					newPill(tag);
					tagList.push(tag);
					$input.val(tagList.join(","));
					$newInput.val("");
				}
			});
		}
	};

	klus.callButton = {
		init: function() {
			this.jqueryfy();
			this.bindActions();
			this.keepAspectRatio();
			fitText('.klu-layout .klu-title:not(input)');
		},
		jqueryfy: function() {
			$('.call-btn').addClass("jqueryfied");
		},
		bindActions: function() {
			var callButton = $('.call-btn');
			var callForm = callButton.find('form');
			var callFormButton = callForm.find('button');
			var callButtonLinks = callButton.find('a').on('click', function(e){
				e.stopPropagation();
				e.preventDefault();
				document.location = this.href;
			});
			callFormButton.on('click', function(e){
				e.stopPropagation();
			});
			callButton.on('click', function(){
				callFormButton.trigger('click');
			});
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
		klus.imageGallery.init();
		klus.tagInput.init();
	});
})(jQuery);

