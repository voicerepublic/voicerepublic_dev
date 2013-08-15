
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
  

  var initBlackbox = function() {
    var flashvars = {};
    var params = {};
    var attributes = { id: "Blackbox", name: "Blackbox" };
    swfobject.embedSWF("/flash/Blackbox.swf", "flashcontent", "215", "140",
                       "10.3.181.22", null, flashvars, params, attributes);
    // for now, this in global namespace
    window.flashInitialized = function() {
      // http://stackoverflow.com/questions/7235417
      // http://stackoverflow.com/questions/952732
      var isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
      window.blackbox = isInternetExplorer ? document.all.Blackbox : document.Blackbox;
    };
  };
  
  disableKluLinks();
  datetimePicker();
  tagList();
  initBlackbox();
  
  // window.Venue is initially defined in venues/_venue_show_live
  // so here we'll have to merge
  window.Venue = $.extend({}, window.Venue, {
    // publishes data via /fayeproxy to private_pub
    publish: function(channel, data) {
      $.ajax('/fayeproxy', {
        type: 'POST', data: { channel: channel, data: data }
      });
    },
    // reigster is triggered by new participants
    // all senders (the host and all guests) should
    // respond with triggering a subscribe
    register: function(streamId) {
      if(streamId == Venue.streamId) return;
      console.log('hello from '+streamId);
      // TODO trigger subscribe
    },
    // subscribe is triggered by senders upon
    // receiving a register
    subscribe: function(streamId) {
      // TODO subscribe to streamId
    }
  });
  
  // 'register' is being send to announce a new client
  $( window.Venue.publish(Venue.channel, "Venue.register('"+Venue.streamId+"');") );

})(jQuery);
