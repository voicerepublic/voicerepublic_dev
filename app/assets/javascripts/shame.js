'use strict';

//auto close the flash message:
$('.flash-msg').delay(3000).fadeOut(1000);

$('#mobile-logo').on('click', function(){
  $('#mobile-nav').toggle().toggleClass('hide');
  hideSearchContainer()
});

$('.button-volume').on('click', function() {
  $(this).children('span').each(function() {
    $(this).toggleClass('hide');
  });
  $(this).toggleClass('muted');
});

// change to light view on avatar click (profile page)
$('.profile-avatar').on('click',function(){
  $('html').toggleClass('profile-light');
});

var $comingUp = $('#coming-up');
var $claim = $('#claim');

$('.category-buttons .button').on('click', function(){
  $(this).siblings().removeClass('active');
  $(this).toggleClass('active');
});

function changeLabelName(input) {
  var $input   = $( this ),
      $label   = $input.next( 'label' ),
      labelVal = $label.html();

  var fileName = '';

  if( $input.target.value ) fileName = e.target.value.split( '\\' ).pop();

  if( fileName )
    $label.find( 'span' ).html( fileName );
  else
    $label.html( labelVal );

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
  $('.slug-warning').removeClass('hide');
});

//trigger thing on search
$('.search-container button[type="submit"]').click(function(){
  $('#working').removeClass('hide');
});

$('.search-container input').keypress(function(e){
  if(e.which == 13){ // Enter key pressed
    $('#working').removeClass('hide');
  }
});

//show talk card alerts
$('.talk-card').on('click','.pin-btn, .unpin-btn', function(e){
  var flasher = $(this).parent().parent().parent().next();
  var myText = $(this).attr('data-msg');
  flasher.find('.flasher-text p').text(myText);
  flasher.removeClass('hide').delay(1000).queue(function(next){
    $.when($(this).fadeOut(500)).done(function() {
      $(this).addClass('hide').css({"opacity":1, "display":"table"});
    });
    next();
  });
});

var venueThumb = $('.venue-thumb');

window.fired = false;
window.onTalkPageReady = function() {
  if (fired) return;
  $('#right-sidebar').removeClass('hide');
};

window.onload = function() {
  TweenMax.staggerFrom(".driftup", 1, {top:"50px",
                                       autoAlpha: 0,
                                       ease:Power4.easeOut}, .2);
};

$(document).ready(function(){
  $('.top-bar').removeClass('transparent');
  $('#working').addClass('offscreen');
});

//venue#index help text
$('#help-text-trigger').on('click',function(){
  $('.optional-help-text').toggleClass('hide');
});

//icon cheatsheet:
var iconCounter = 1;
$('svg symbol').each(function(){
  // print icons on page:
  var iconName = $(this).attr('id').slice(5);
  $('#icon-cheatsheet').append('<div class="icon-thumb"><svg class="icon"><use xlink:href="#'+$(this).attr('id')+'" /></svg><p>'+iconCounter+'. '+iconName+'</p></div>');
  iconCounter ++;
});

//show claim btns on ready
$( document ).ready(function(){
  $('#claim-btn').removeClass('hide')
  $('#edit-btn').removeClass('hide')
  $('#naming-advice').removeClass('hide')
})

//claiming device name hack
$("#device_name").prop("readonly", true)

$("#edit-btn").on('click',function(){
  $(this).addClass('hide')
  $("#save-btn").removeClass('hide')
  $("#device_name").removeClass('read-only').prop("readonly",false).select()
});

$("#save-btn").on('click',function(){
  // $(this).html("save").removeClass('save')
  $("#device_name").addClass('read-only').prop("readonly",true)
  $(this).addClass('hide')
  $("#edit-btn").removeClass('hide')

});



$(document).foundation();

$(function() {
  if($(".devices-edit").length > 0) {
    $('#device_name').val(suggestions[organization_id]);
  }
});
