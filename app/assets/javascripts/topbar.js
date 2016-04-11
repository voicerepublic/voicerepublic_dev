$('#search-loupe a').on('click',function(){
    $('.can-hide').addClass('animated zoomOut').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(){
        $(this).removeClass('animated zoomOut').addClass('hide');
    });
    $('.search-container').removeClass('hide').addClass('animated fadeInRight').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(){
        $('.search-container').find('input').focus();
    });
    $('#mobile-nav').hide();
});

$('#search-close').on('click', function(){
    $('.search-container').addClass('animated fadeOutRight').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(){
        $(this).removeClass('animated fadeOutRight').addClass('hide');
        $('.can-hide').removeClass('hide').addClass('animated zoomIn').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',function(){
            $(this).removeClass('animated zoomIn');
        });
    });
   

});