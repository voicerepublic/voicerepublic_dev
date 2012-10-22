(function($){
  $(function(){
    var userShowMore = $('<li class=\"user-show-more\"><a href=\"#\" id=\"user-toggle\">Show more</a></li>');
    var userShowMoreLink = userShowMore.find("a");
    $('.user-nav').append(userShowMore);
    var userAboutShownLines = 2;
    var animationDuration = 300;
    var userInfo = $('.user-more-information').hide();
    var userAbout = $('.user-about');
    var userAboutOriginalHeight = userAbout.height();
    var userAboutHiddenHeight = parseInt(userAbout.css("line-height"), 10) * userAboutShownLines;
    var userAboutHiddenToggle  = true; 
    userAbout.height(userAboutHiddenHeight + "px");
    $('#user-toggle').on('click', function() {
      if (userAboutHiddenToggle) {
        userAbout.animate({height: userAboutOriginalHeight}, animationDuration);
        userAboutHiddenToggle = !userAboutHiddenToggle;
        userShowMoreLink.text("Show less");
      } else {
        userAbout.animate({height: userAboutHiddenHeight + "px"}, animationDuration);
        userAboutHiddenToggle = !userAboutHiddenToggle;
        userShowMoreLink.text("Show more");
      };
      userInfo.slideToggle(animationDuration);
    });
  });
})(jQuery);