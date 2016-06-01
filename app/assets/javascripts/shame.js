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

//$('.button-play-pause').on('click', function() {
//    $(this).children('span').each(function() {
//        $(this).toggleClass('hide');
//
//    });
//    $('#indicator').toggleClass('metering');
//});

$('.button-volume').on('click', function() {
    $(this).children('span').each(function() {
        $(this).toggleClass('hide');

    });
    $(this).toggleClass('muted');
});




////Fake colume meter:
//window.setInterval(function() {
//    $('.metering').css({
//        "max-height": Math.random() * 20
//    });
//}, 100);


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
$('.talk-card').on('click','.pin-btn, .unpin-btn', function(e){
    //console.log(e);
    var flasher = $(this).parent().parent().parent().next();
    var myText = $(this).attr('data-msg');
    console.log("text: " + myText);
    flasher.find('.flasher-text p').text(myText);
    flasher.removeClass('hide').delay(1000).queue(function(next){
    $.when($(this).fadeOut(500)).done(function() {
    $(this).addClass('hide').css({"opacity":1, "display":"table"});
});
    next();
});
});

window.fired = false;
window.onTalkPageReady = function() {
    if (fired) {
        return;
    }
    $('#right-sidebar').removeClass('hide')
};

$(document).ready(function(){
    $('.top-bar').removeClass('transparent')
    $('#working').addClass('offscreen')
});

// Particles
particlesJS("particles",
{
  "particles": {
    "number": {
      "value": 30
      ,
      "density": {
        "enable": true,
        "value_area": 800
      }
    },
    "color": {
      "value": ["#a339cd","#374da1","#f82847"]
    },
    "shape": {
      "type": "triangle",
      "stroke": {
        "width": 0
      },
      "polygon": {
        "nb_sides": 5
      },
      "image": {
        "src": "img/github.svg",
        "width": 100,
        "height": 100
      }
    },
    "opacity": {
      "value": 1,
      "random": false,
      "anim": {
        "enable": false,
        "speed": 1,
        "opacity_min": 0.1,
        "sync": false
      }
    },
    "size": {
      "value": 300,
      "random": true,
      "anim": {
        "enable": false,
        "speed": 40,
        "size_min": 0.1,
        "sync": false
      }
    },
    "line_linked": {
      "enable": false,
      "distance": 150,
      "color": "#374da1",
      "opacity": .4,
      "width": 1
    },
    "move": {
      "enable": true,
      "speed": .5,
      "direction": "bottom",
      "random": false,
      "straight": false,
      "out_mode": "out",
      "bounce": false,
      "attract": {
        "enable": false,
        "rotateX": 600,
        "rotateY": 641.3648243462092
      }
    }
  },
  "interactivity": {
    "detect_on": "canvas",
    "events": {
      "onhover": {
        "enable": true,
        "mode": "bubble"
      },
      "onclick": {
        "enable": true,
        "mode": "push"
      },
      "resize": true
    },
    "modes": {
      "grab": {
        "distance": 400,
        "line_linked": {
          "opacity": 1
        }
      },
      "bubble": {
        "distance": 231.44200550588337,
        "size": 8.120772123013452,
        "duration": 2,
        "opacity": 0.4953670995038205,
        "speed": 3
      },
      "repulse": {
        "distance": 200,
        "duration": 0.4
      },
      "push": {
        "particles_nb": 4
      },
      "remove": {
        "particles_nb": 2
      }
    }
  },
  "retina_detect": true
});

// var canvas = document.querySelector('canvas')
// var canvasContext = canvas.getContext("2d");
// var drawBlur = function() {
//   // Store the width and height of the canvas for below
//   var w = canvas.width;
//   var h = canvas.height;
//   // This draws the image we just loaded to our canvas
//   canvasContext.drawImage(canvasBackground, 0, 0, w, h);
//   // This blurs the contents of the entire canvas
//   stackBlurCanvasRGBA("heroCanvas", 0, 0, w, h, 20);
// }
// canvasBackground.onload = function() {
//   drawBlur();
// }

// var targetCanvas = document.querySelector('canvas')
// StackBlur.canvasRGB(targetCanvas, 0, 0, 2000, 500, 100);
