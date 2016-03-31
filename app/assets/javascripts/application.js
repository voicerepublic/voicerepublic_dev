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
//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.jplayer.min
//= require select2
//= require slick
//
//= require player.js
//= require validate_search
//= require jquery-ui/datepicker
//= require jquery-ui/slider
//= require jquery-ui-timepicker-addon
//= require slider.js
//= require nprogress
//
//= require sencha
//= require purchases
//= require_tree ./components

// run `proof` on the console to get a proof background-image on body
window.proof = function(name) {
    if (name == undefined) name = 'default';
    var value = 'papayaWhip url(/images/proof/' + name + '.png) no-repeat center top';
    $('body').css({
        background: value
    });
};

$(document).foundation();

// deep linking for foundation tabs
// https://github.com/zurb/foundation/issues/3692
if (window.location.hash) {
    $('dl.tabs dd a').each(function() {
        var hash = '#' + $(this).attr('href').split('#')[1];
        if (hash == window.location.hash) {
            $(this).click();
        };
    });
}

$(function() {
    $(document).foundation();
});

//main app
//auto close the flash message:
$('.flash-msg').delay(3000).fadeOut(1000);

$('#mobile-logo').on('click', function() {
    console.log('opening the mobile nav');
    $('#mobile-nav').toggle();
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

//$( '.inputfile' ).each( function()

function changeLabelName(input) {
    var $input = $(this),
        $label = $input.next('label'),
        labelVal = $label.html();

    //console.log('should change label name')

    // $input.on( 'change', function( e )
    // {
    var fileName = '';

    // if( this.files && this.files.length > 1 )
    //     fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
    if ($input.target.value)
        fileName = e.target.value.split('\\').pop();

    if (fileName)
        $label.find('span').html(fileName);
    else
        $label.html(labelVal);
    // });

    // Firefox bug fix
    $input
        .on('focus', function() {
            $input.addClass('has-focus');
        })
        .on('blur', function() {
            $input.removeClass('has-focus');
        });
}

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();


        reader.onload = function(e) {
            var fileName = $('input[type=file]').val().split('\\').pop();
            $('.preview-img').css('background-image', 'url(' + e.target.result) + ')';
            console.log('filename:' + fileName);
            $('.preview-img').next().find('span').html(fileName);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$("#user_avatar, #series_image").change(function() {
    console.log('should change the image');
    readURL(this);
    // changeLabelName($('.inputfile'));
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