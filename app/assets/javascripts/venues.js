
(function($){

    $('.info-link-onair, .venue-desc-onair .close-icon').click(function(){

      $('.venue-desc-onair').toggleClass('show');
    });

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

     var tagList = function() {
         $('.tagList').select2({ width: 'element',
                                 tags: [],
                                 tokenSeparators: [",", " "],
                                 ajax: {
                                     url: "/venues/tags.json",
                                     data: function (term, page) {
                                         return {
                                             q: term, // search term
                                             page: page,
                                             limit: 10
                                         };
                                     },
                                     results: function (data, page) {
                                         // whether or not there are more results available
                                         var more = (page * 10) < data.total;
                                         // notice we return the value of more so Select2
                                         // knows if more results can be loaded
                                         return { results: data.tags, more: more };
                                     }
                                 },
                                 // we want to return the names not the ids
                                 id: function (e) { return e.name; },
                                 createSearchChoice: function (term) {
                                   return {id: $.trim(term), name: $.trim(term)};
                                 },
                                 // select2 assumes 'text', but in our case it's 'name'
                                 formatResult: function(result, container, query, escapeMarkup) {
                                     var markup=[];
                                     Select2.util.markMatch(result.name, query.term,
                                                            markup, escapeMarkup);
                                     return markup.join("");
                                 },
                                 formatSelection: function (data, container, escapeMarkup) {
                                   return data ? escapeMarkup(data.name) : undefined;
                                 }
                               });
     };
     
     disableKluLinks();
     datetimePicker();
     tagList();

})(jQuery);
