
(function($){
    var $chatBody = $('textarea.group_chat_textarea');
    $('.group_chat_submit').on('click', function(event){
       event.preventDefault();
       $('.group_chat_submit').submit();
       $chatBody.val(''); 
    });    
  
    $chatBody.on('keydown', function(event){
      if(event.keyCode == 13) {
        event.preventDefault();
        $('.group_chat_submit').submit();
        $chatBody.val('');
      }
    });
})(jQuery);
  