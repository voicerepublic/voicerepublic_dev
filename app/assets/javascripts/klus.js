
(function($){

	var klus = {};

	klus.imageGallery = {
		init: function() {
			if ($('.large-klu:not(.klu-form) .kluuu-pics').length > 0) {
				var urls = this.getImageURLs();
				var descriptions = this.getImageDescription();
				if (urls.length > 1) {
					this.buildGallery(urls,descriptions);
				}
			}
		},

		getImageURLs: function() {
			return $('.kluuu-pics').data('images-urls').split(' ');
		},
		getImageDescription: function() {
		  return $('.kluuu-pics').data('images-desc').split('|');  
		},

		buildGallery: function(imagesURLs, descriptions) {

			var iPlusOne = function(array, i) {
				if (i+1 < array.length) {
					return i+1;
				}
				else {
					return 0;
				}
			};

			var iMinusOne = function(array, i) {
				if (i !== 0) {
					return i-1;
				}
				else {
					return array.length - 1;
				}
			};

			var nextPicture = function(i) {
				previous = $($eyeCatchers[i]);
				previous.animate({left: -$kluuuPicsWidth}, 'fast', function() {
					// console.log(previous);
					previous.css({left: $kluuuPicsWidth});
				});
				i = iPlusOne($eyeCatchers, i);
				$($eyeCatchers[i]).animate({left: 0}, 'fast');
				
				return i;
			};

			var previousPicture = function(i) {
				previous = $($eyeCatchers[i]);
				previous.animate({left: $kluuuPicsWidth}, 'fast', function() {
					// console.log(previous);
					previous.css({left: -$kluuuPicsWidth});
				});
				i = iMinusOne($eyeCatchers, i);
				$($eyeCatchers[i]).animate({left: 0}, 'fast');
				
				return i;
			};

			var i = 0;
			var $kluuuPics = $('.kluuu-pics');
			//var $kluuuDesc = $('.klu-image-caption');
			$kluuuPics.wrap("<div id='gallery-container' />");
			$kluuuPics.css('height', $kluuuPics.height());
			var $kluuuPicsWidth = $kluuuPics.width();
			$kluuuPics.addClass('jqueryfied');
			var $galleryContainer = $('#gallery-container').css('position', 'relative').append('<a href="#" id="gallery-last"><i class="icon-circle-arrow-left"></i></a>').append('<a href="#" id="gallery-next"><i class="icon-circle-arrow-right"></i></a>');
			var $kluEyecatcher = $('.klu-main .klu-eyecatcher').remove();
			var $kluuuDesc = $('.klu-image-caption').remove();
			var newLi, previous;
			$.each(imagesURLs, function(i){
				newLi = $kluEyecatcher.clone().appendTo($kluuuPics);
				newLi.find('img').attr('src', imagesURLs[i]);
				newLi.find('.klu-image-caption').html(descriptions[i])
			});
			var $eyeCatchers = $('.klu-main .klu-eyecatcher').css({
				left: $kluuuPicsWidth
			});

			$($eyeCatchers[0]).css('left', 0);

			$kluuuPics.on('click', function() {
				i = nextPicture(i);
			});
			$('#gallery-next').on('click', function(e){
				e.preventDefault();
				i = nextPicture(i);
				//console.log(descriptions[i])
			});
			$('#gallery-last').on('click', function(e){
				e.preventDefault();
				i = previousPicture(i);
				//console.log(descriptions[i])
			});
		}
	};

    //klus.tagInput = {
    //	init: function() {
    //		if ($('.klu-form').length > 0) {
    //			this.build();
    //		}
    //	},
    //
    //	
    //
    //	build: function() {
    //
    //		var tagList = [];
    //
    //		var isTagUsed = function(tag) {
    //			$.each(tagList, function(i){
    //				if(tagList[i] === tag) {
    //					return true;
    //				} else {
    //					return false;
    //				}
    //			});
    //		};
    //
    //		var newPill = function(tag) {
    //			var pill = $('<span />').css({
    //				display: 'inline-block',
    //				margin: '3px 2px'
    //			});
    //			pill.text(tag);
    //			pill.data('tag', tag);
    //			pill.addClass('label');
    //			pill.prependTo($workingContainer).hide().fadeIn('fast');
    //			var deleteTag = $("<span>&times;</span>").appendTo(pill);
    //			deleteTag.css({
    //				cursor: 'pointer',
    //				marginLeft: '3px'
    //			});
    //			deleteTag.on('click', function() {
    //				$.each(tagList, function(i){
    //					if (pill.data("tag") == tagList[i]) {
    //						tagList.splice(i, 1);
    //						$input.val(tagList.join(","));
    //					}
    //				});
    //				pill.fadeOut('fast', function() {
    //					pill.remove();
    //				});
    //			});
    //		};
    //
    //		var firstRun = function($input) {
    //			var previousTags = $input.val();
    //			if (previousTags !== "") {
    //				previousTags = previousTags.split(', ');
    //				$.each(previousTags, function(i) {
    //					newPill(previousTags[i]);
    //					tagList.push(previousTags[i]);
    //				});
    //			}
    //		};
    //
    //		var $input =  $('#klu_tag_list').hide();
    //		var $workingContainer = $input.parent();
    //		var $newInput = $("<input>", {'type': 'text'}).appendTo($workingContainer);
    //		$newInput.attr('placeholder', 'Add new tag by pressing enter after you typed it');
    //		firstRun($input);
    //		$newInput.on('keydown', function(event) {
    //			if(event.keyCode == 13) {
    //				event.preventDefault();
    //				event.stopPropagation();
    //			}
    //		});
    //		$newInput.on('keyup', function(event) {
    //			tag = $newInput.val();
    //			if(event.keyCode == 13 && !(isTagUsed(tag))){
    //				event.preventDefault();
    //				event.stopPropagation();
    //				newPill(tag);
    //				tagList.push(tag);
    //				$input.val(tagList.join(","));
    //				$newInput.val("");
    //			}
    //		});
    //	}
    //};

	klus.callButton = {
		init: function() {
			this.jqueryfy();
			// this.bindActions();
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
			$('.no-kluuu:not(.tiny-klu) .klu-eyecatcher.klu-title').each(function() {
				$(this).height(parseInt($(this).width(), 10) * 3/4 + "px").addClass('well well-small');
			});
		}
	};


	// document.ready
	$(function(){
		klus.callButton.init();
		klus.imageGallery.init();
		//klus.tagInput.init();
	});
})(jQuery);

