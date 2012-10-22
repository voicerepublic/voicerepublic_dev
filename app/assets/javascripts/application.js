// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

 function overlay(innerHTML){
  var overlayContent = $("<div />");
  overlayContent.append(innerHTML);
  overlayContent.css({
    width: "50%",
    background: "white",
    position: "absolute",
    left: "50%",
    top: "50%",
    padding: "30px",
    border: "1px black solid"
  });
  var body = $('body').css('position', 'relative');
  body.append(overlayContent);
  var overlayHeight = overlayContent.height();
  var overlayWidth = overlayContent.width();
  overlayContent.css({
    marginTop: -parseInt(overlayHeight, 10)/2,
    marginLeft: -parseInt(overlayWidth, 10)/2
  });
};