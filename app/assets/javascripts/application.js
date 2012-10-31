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

overlay = {

  build: function(innerHTML) {

    var calculateOverlay = function() {
      var windowHeight = $(window).height();
      var bodyHeight = $('body').height();
      var overlayHeight = overlayContent.height();
      var overlayWidth = overlayContent.width();
      var minMarginTop = 30;

      function calculateBG() {
        if (bodyHeight < windowHeight && overlayHeight < windowHeight) {
          overlayBackground.height(windowHeight);
        } else if (overlayHeight > windowHeight) {
          overlayBackground.height((overlayHeight + minMarginTop) * 1.05);
          overlayContent.css({
            marginTop: 0,
            top: minMarginTop
          });
        }
      }
      overlayContent.css({
        marginTop: -overlayHeight/2,
        marginLeft: -overlayWidth/2,
        maxWidth: overlayContent.width()
      });
      calculateBG();
    };
    var overlayBackground = $("<div />", {"class": "overlay-background"});
    var overlayContent = $("<div />", {"class": "overlay-content"}).appendTo(overlayBackground);
    overlayContent.html(innerHTML);
    overlayContent.find("button[data-function=closeOverlay], input[data-function=closeOverlay], a[data-function=closeOverlay]").on("click", function(e) {
      overlay.close(overlayBackground);
    });
    var body = $('body').css({
        position: 'relative'
      }).append(overlayBackground);
    calculateOverlay();
  },

  close: function(target) {
    target = target || ".overlay-background";
    if (typeof target == 'string' || typeof target == 'object') {
      $(target).fadeOut("fast", function() {
        $(this).remove();
      });
    }
  }
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
      //console.log("targetWidth: " + targetWidth)
      var inner = $("<div />").css({
        display: "inline-block",
        lineHeight: 1.5
      });
      text.wrapInner(inner);
      inner = text.find("div");
      var currentFontSize = parseInt(text.css("font-size"));
      //console.log(inner.text());
      while (inner.height() < targetHeight) {
          currentFontSize++;
          text.css("font-size", currentFontSize + "px");
          //console.log("font-size: " + text.css("font-size") + " height: " + inner.height() + " width: " + inner.width());
      };
      while (inner.height() > targetHeight || inner.width() > targetWidth) {
        currentFontSize--;
        text.css("font-size", currentFontSize + "px");
        //console.log("font-size: " + text.css("font-size") + " height: " + inner.height() + " width: " + inner.width());
      };
      inner.css("padding-top", (targetHeight - inner.height())/2 + "px");
    });
  };
  calculateSize();
  setTimeout(calculateSize, 150);
  setTimeout(calculateSize, 500);
  setTimeout(calculateSize, 1000);
};