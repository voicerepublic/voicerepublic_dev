(function($){
  $(function(){
    var userInfo = $('.user-more-information').hide();
    $('#user-toggle').on('click', function() {
      userInfo.slideToggle(300);
    });
  });
})(jQuery);