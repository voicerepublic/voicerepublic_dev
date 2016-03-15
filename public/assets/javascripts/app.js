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

$('#mobile-logo').on('click', function(){
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

// $(window).scroll(function() {
//     if ( $comingUp.is( ':in-viewport' ) ) {
//   $('.down-arrow').addClass('hide');
// }

// if ($claim.is (':in-viewport')){

//     $('.top-bar').removeClass('with-background');
// } else {
//     $('.top-bar').addClass('with-background');
// }
// });

$('.category-buttons .button').on('click', function(){
    $(this).siblings().removeClass('active');
    $(this).toggleClass('active');
});

//$( '.inputfile' ).each( function()

function changeLabelName(input)
{
    var $input   = $( this ),
        $label   = $input.next( 'label' ),
        labelVal = $label.html();

        //console.log('should change label name')

    // $input.on( 'change', function( e )
    // {
        var fileName = '';

        // if( this.files && this.files.length > 1 )
        //     fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
         if( $input.target.value )
            fileName = e.target.value.split( '\\' ).pop();

        if( fileName )
            $label.find( 'span' ).html( fileName );
        else
            $label.html( labelVal );
    // });

    // Firefox bug fix
    $input
    .on( 'focus', function(){ $input.addClass( 'has-focus' ); })
    .on( 'blur', function(){ $input.removeClass( 'has-focus' ); });
}

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        
        reader.onload = function (e) {
            var fileName = $('input[type=file]').val().split('\\').pop();
            $('.preview-img').css('background-image', 'url(' + e.target.result) + ')';
            console.log('filename:' + fileName);
            $('.preview-img').next().find('span').html(fileName);
        }
        
        reader.readAsDataURL(input.files[0]);
    }
}

$("#user_avatar, #series_image").change(function(){
    console.log('should change the image');
    readURL(this);
    // changeLabelName($('.inputfile'));
});

$("input#user_slug").focus(function(){  
    //console.log('tryign to schange slug');

    $('.slug-warning').removeClass('hide');
});

//trigger thing on search 
$('.search-container button[type="submit"]').click(function(){
       $('#working').removeClass('hide');
    });
$('.search-container input').keypress(function(e){
        if(e.which == 13){//Enter key pressed
$('#working').removeClass('hide');        }
});


//show talk card alerts
$('.pin-btn, .unpin-btn').on('click', function(){
    //$(this).parent().parent().parent().next().removeClass('hide');
    $(this).parent().parent().parent().next().removeClass('hide').delay(1000).queue(function(next){
    // $(this).fadeOut().done(function() {
    //     $(this).addClass('hide');
    // });
    $.when($(this).fadeOut(500)).done(function() {
    $(this).addClass('hide');
});
    next();
});
    //console.log('class: ' + $(this).parent().parent().parent().next().attr('class'))
});
// $("#myElem").show().delay(5000).fadeOut();

$(document).foundation();
