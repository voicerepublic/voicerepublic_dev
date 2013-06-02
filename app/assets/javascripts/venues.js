
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

    //Disable KluuU Links
    var disableKluLinks = {};
    disableKluLinks = function() {
      if ($('.label-chat').text().length > 0){
        $('.medium-klu a').css('cursor','default');
        $('.medium-klu a').click(function(e){
          e.preventDefault();
        });
        
      }
    };

    var datetimePicker = function() {
      /** 
       $('#datepicker').datetimepicker({
        language: '<%= I18n.locale.to_s %>',
        pickDate: true,
        pickTime: true
      });
      $('#timepicker').datetimepicker({
        language: '<%= I18n.locale.to_s %>',
        pickDate: false
      });
      **/
       $('#datetimepicker').datetimepicker({
        language: '<%= I18n.locale.to_s %>',
        pickDate: true,
        pickTime: true
      });
    };

    disableKluLinks();
    datetimePicker();

})(jQuery);
  