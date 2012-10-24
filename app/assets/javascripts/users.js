(function($){
  $(function(){
    var userShowMore = $('<a href=\"#\" id=\"user-toggle\" class=\"user-show-more\">Show more</a><');
    $('.user-information').append(userShowMore);
    var userInfoShownLines = 7.5;
    var animationDuration = 300;
    var userInfo = $('.user-information-more');
    var userInfoOriginalHeight = userInfo.height(); 
    /* Dirty IE Hack, beacuse Jquery doesn't provide line-height in units, if it was uniteless defined in css */
    var userInfoLineHeight = userInfo.css("line-height");
    var NotIEPattern = /px/;
    if (!NotIEPattern.test(userInfoLineHeight)) {
      var userInfoHiddenHeight = userInfoLineHeight * parseInt(userInfo.css("font-size"), 10) * userInfoShownLines;  
    } else {
      var userInfoHiddenHeight = parseInt(userInfoLineHeight, 10) * userInfoShownLines;
    };
    /* End of Hack */
    userInfo.addClass("jqueryfied gradient");
    var userInfoHiddenToggle  = true; 
    userInfo.height(userInfoHiddenHeight + "px");
    $('#user-toggle').on('click', function() {
      if (userInfoHiddenToggle) {
        userInfo.animate({height: userInfoOriginalHeight}, animationDuration);
        userInfoHiddenToggle = !userInfoHiddenToggle;
        userShowMore.text("Show less");
        userInfo.removeClass("gradient");
      } else {
        userInfo.animate({height: userInfoHiddenHeight + "px"}, animationDuration);
        userInfoHiddenToggle = !userInfoHiddenToggle;
        userShowMore.text("Show more");
        userInfo.addClass("gradient");
      };
    });
  });
})(jQuery);