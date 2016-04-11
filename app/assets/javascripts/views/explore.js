$(".category-buttons input[type='radio']").on('click', function(){
    $('.category-buttons label').removeClass('selected');
    $(this).parent().addClass('selected');
});

$(".category-buttons input[type='radio']").focus(function(){     
    $('.category-buttons label').removeClass('selected');
    $(this).parent().addClass('selected');
});