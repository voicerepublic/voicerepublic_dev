'use strict';

//auto close the flash message:
$('.flash-msg').delay(3000).fadeOut(1000);




// Smooth scrolll
// $(function() {
//     $('a[href*=#]:not([href=#])').click(function() {
//         if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname) {
//             var target = $(this.hash);
//             target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
//             if (target.length) {
//                 $('html,body').animate({
//                     scrollTop: target.offset().top
//                 }, 1000);
//                 return false;
//             }
//         }
//     });
// });



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




//Fake colume meter:
window.setInterval(function() {
    $('.metering').css({
        "max-height": Math.random() * 20
    });
}, 100);


// change to light view on avatar click (profile page)
$('.profile-avatar').on('click',function(){
    $('html').toggleClass('profile-light');

});

var $comingUp = $('#coming-up');
var $claim = $('#claim');

$(window).scroll(function() {
    if ( $comingUp.is( ':in-viewport' ) ) {
  $('.down-arrow').addClass('hide');
}

if ($claim.is (':in-viewport')){

    $('.top-bar').removeClass('with-background');
} else {
    $('.top-bar').addClass('with-background');
}
});

$('.category-buttons .button').on('click', function(){
    $(this).siblings().removeClass('active');
    $(this).toggleClass('active');
});


$(document).foundation();
