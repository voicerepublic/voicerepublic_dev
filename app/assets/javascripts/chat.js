var chat = {};

chat.build = function(htmlstring) {

  function buildDOM(htmlstring) {
    var chatContainer = $('#chat-container');
    var newChatInstance = $(htmlstring);
    var newChatID = newChatInstance.attr('id');
    if (chatContainer.length === 0) {
      chatContainer = $('<div />').attr({'id': 'chat-container'}).appendTo('body');
    }
    chatContainer.append(htmlstring);
    console.log(newChatID);
  }

  function registerClose() {
    $('.chat-close').on('click', function(){
      overlay.close();
    });
  }
  
  function registerCleanOnClick() {
    var $chatBody = $('textarea.chat_textarea');
    $('.chat_submit').on('click', function(){
       $('.chat_submit').submit();
       $chatBody.val(''); 
    });    
  }

  function registerSubmitOnEnter() {
    var $chatBody = $('textarea.chat_textarea');
    $chatBody.on('keydown', function(event){
      if(event.keyCode == 13) {
        event.preventDefault();
        $('.chat_submit').submit();
        $chatBody.val('');
      }
    });
  }

  overlay.build(htmlstring, true);
  registerClose();
  registerCleanOnClick();
  registerSubmitOnEnter();
};