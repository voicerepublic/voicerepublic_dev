// This is a manifest file that'll be compiled into application.js,
// which will include all the files listed below.
//
// Any JavaScript/Coffee file within this directory,
// lib/assets/javascripts, vendor/assets/javascripts, or
// vendor/assets/javascripts of plugins, if any, can be referenced
// here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll
// appear at the bottom of the the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE
// PROCESSED, ANY BLANK LINE SHOULD GO AFTER THE REQUIRES BELOW.
//
//
// --- BUNDLED LIBRARIES
//= require jquery
//= require jquery_ujs
//= require foundation
//= require selectize
//= require slick
//= require jquery-ui/datepicker
//= require jquery-ui/slider
//
// --- VENDORED LIBRARIES
//= require jquery.jplayer.min
//= require nprogress
//= require jquery-ui-timepicker-addon
//
// --- COMPONENTS
//= require components/ajax_filter
//= require components/infinite_scroll
//= require components/share_social
//= require components/ga-event
//= require components/tag_list
//= require components/picker
//= require components/persisted_log
//= require components/language_select
//= require components/instant_image
//= require components/on_blank_show
//
// --- VIEWS
//= require views/explore
//= require views/purchases
//
// --- MISC
//= require sencha
//= require shame
//= require cljs
//= require topbar

$(document).foundation();




// TODO resolve code duplication between this file and shame.js
//main app
//auto close the flash message:
$('.flash-msg').delay(3000).fadeOut(1000);

$('#mobile-logo').on('click', function() {
    console.log('opening the mobile nav');
    $('#mobile-nav').toggleClass('hide');
});

$('.button-play-pause').on('click', function() {
    $(this).children('span').each(function() {
        $(this).toggleClass('hide');

    });
    $('#indicator').toggleClass('metering');
});

$('.button-volume').on('click', function() {
    $(this).children('span').each(function() {
        $(this).toggleClass('hide');

    });
    $(this).toggleClass('muted');
});




//Fake volume meter:
window.setInterval(function() {
    $('.metering').css({
        "max-height": Math.random() * 20
    });
}, 100);


// change to light view on avatar click (profile page)
$('.profile-avatar').on('click', function() {
    $('html').toggleClass('profile-light');

});

var $comingUp = $('#coming-up');
var $claim = $('#claim');



$('.category-buttons .button').on('click', function() {
    $(this).siblings().removeClass('active');
    $(this).toggleClass('active');
});




$("input#user_slug").focus(function() {
    //console.log('tryign to schange slug');

    $('.slug-warning').removeClass('hide');
});

//trigger thing on search
$('.search-container button[type="submit"]').click(function() {
    $('#working').removeClass('hide');
});
$('.search-container input').keypress(function(e) {
    if (e.which == 13) { //Enter key pressed
        $('#working').removeClass('hide');
    }
});


//show talk card alerts
$('.talk-card').on('click', '.pin-btn, .unpin-btn', function(e) {
    //console.log(e);
    var flasher = $(this).parent().parent().parent().next();
    var myText = $(this).attr('data-msg');
    console.log("text: " + myText);
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
});