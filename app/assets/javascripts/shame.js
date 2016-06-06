'use strict';

//auto close the flash message:
$('.flash-msg').delay(2000).fadeOut(500);




// $("#user_avatar, #series_image").change(function(){
//     console.log('should change the image');
//     readURL(this);
//     // changeLabelName($('.inputfile'));
// });



window.fired = false;
window.onTalkPageReady = function() {
    if (fired) {
        return;
    }
    $('#right-sidebar').removeClass('hide')
};


$(document).foundation();






$('#mobile-logo').on('click', function() {
    //console.log('opening the mobile nav');
    $('#mobile-nav').toggleClass('hide');
});






$("input#user_slug").focus(function() {
    $('.slug-warning').removeClass('hide');
});

//trigger thing on search
$('.search-container button[type="submit"]').click(function() {
    $('#working').removeClass('offscreen');
});
$('.search-container input').keypress(function(e) {
    if (e.which == 13) { //Enter key pressed
        $('#working').removeClass('offscreen');
    }
});


//show talk card alerts
$('.talk-card').on('click', '.pin-btn, .unpin-btn', function(e) {
    //console.log(e);
    var flasher = $(this).parent().next();
    var myText = $(this).attr('data-msg');
    //console.log("text: " + myText);
    flasher.find('.flasher-text p').text(myText);
    flasher.removeClass('hide').delay(1000).queue(function(next) {
        $.when($(this).fadeOut(500)).done(function() {
            $(this).addClass('hide').css({
                "opacity": 1,
                "display": "table"
            });
        });
        next();
    });
});

//TOPBAR:
$('#search-loupe a').on('click', function() {
    $('.can-hide').addClass('animated zoomOut').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
        $(this).removeClass('animated zoomOut').addClass('hide');
    });
    $('.search-container').removeClass('hide').addClass('animated fadeInRight').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
        $('.search-container').find('input').focus();
    });
    $('#mobile-nav').hide();
});

$('#search-close').on('click', function() {
    $('.search-container').addClass('animated fadeOutRight').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
        $(this).removeClass('animated fadeOutRight').addClass('hide');
        $('.can-hide').removeClass('hide').addClass('animated zoomIn').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
            $(this).removeClass('animated zoomIn');
        });
    });


});


$(document).ready(function(){
    $('.top-bar').removeClass('transparent')
    $('#working').addClass('offscreen')
});