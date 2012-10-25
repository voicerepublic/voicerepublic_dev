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

function fitText(jquerySelector) {
  var text = $(jquerySelector);
  var calculateSize = function() {
    var text = $(jquerySelector);
    $.each(text, function(){
      var text = $(this).css({
        lineHeight: 0,
        fontSize: 0
      });
      var targetHeight = text.height();
      var targetWidth = text.width();
      console.log("targetWidth: " + targetWidth)
      var inner = $("<div />").css({
        display: "inline-block",
        lineHeight: 1.5
      });
      text.wrapInner(inner);
      inner = text.find("div");
      var currentFontSize = parseInt(text.css("font-size"));
      console.log(inner.text());
      while (inner.height() < targetHeight) {
          currentFontSize++;
          text.css("font-size", currentFontSize + "px");
          console.log("font-size: " + text.css("font-size") + " height: " + inner.height() + " width: " + inner.width());
      };
      while (inner.height() > targetHeight || inner.width() > targetWidth) {
        currentFontSize--;
        text.css("font-size", currentFontSize + "px");
        console.log("font-size: " + text.css("font-size") + " height: " + inner.height() + " width: " + inner.width());
      };
      inner.css("padding-top", (targetHeight - inner.height())/2 + "px");
    });
  };
  calculateSize();
  setTimeout(calculateSize, 150);
  setTimeout(calculateSize, 500);
  setTimeout(calculateSize, 1000);
};