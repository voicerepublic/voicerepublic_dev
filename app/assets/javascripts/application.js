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
//= require foundation.alert
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
//
//= require sencha
//= require purchases
//= require_tree ./components

// run `proof` on the console to get a proof background-image on body
window.proof = function(name) {
  if(name==undefined) name = 'default';
  var value = 'papayaWhip url(/images/proof/'+name+'.png) no-repeat center top';
  $('body').css({background: value});
};

$(document).foundation();

// deep linking for foundation tabs
// https://github.com/zurb/foundation/issues/3692
if(window.location.hash) {
  $('dl.tabs dd a').each(function(){
    var hash = '#' + $(this).attr('href').split('#')[1];
    if(hash == window.location.hash) {
      $(this).click();
    };
  });
}
