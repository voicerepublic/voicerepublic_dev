function flashInitialized() {
  console.log('hello');
}


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
    $('.tagList').select2(
      { width: 'element',
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

  var initVenue = function() {
    // http://stackoverflow.com/questions/7235417
    // http://stackoverflow.com/questions/952732
    var isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
    window.Venue.blackbox = isInternetExplorer ? document.all.Blackbox : document.Blackbox;

    // window.Venue is initially defined in venues/_venue_show_live
    // so here we'll have to merge here
    window.Venue = $.extend({}, window.Venue, {
      subscriptions: [],
      sender: false,
      promote: function() {
        window.Venue.blackbox.publish(window.Venue.streamId);
        window.Venue.sender = true;
        window.Venue.subscribe();
      },
      demote: function() {
        window.Venue.blackbox.unpublish();
        window.Venue.sender = false;
      },
      // onRegister is triggered by new participants
      // all senders (the host and all guests) should
      // respond with triggering a subscribe
      onRegister: function(streamId) {
        log('received onRegister of '+streamId+', '+window.Venue.streamId+', '+window.Venue.sender);
        if(streamId == window.Venue.streamId) return; // ignore self
        if(!window.Venue.sender) return; // skip unless sender
        window.Venue.subscribe();
      },
      // onSubscribe is triggered by senders upon receiving a onRegister
      onSubscribe: function(streamId) {
        log('received onSubscribe to '+streamId);
        if(streamId == window.Venue.streamId) return; // ignore self
        if($.inArray(streamId, window.Venue.subscriptions) != -1) return; // skip known
        window.Venue.blackbox.subscribe(streamId);
        window.Venue.subscriptions.push(streamId);
      },
      // tiggers onRegister on other side
      register: function() {
        log('sending register of '+window.Venue.streamId);
        window.Venue.publish("window.Venue.onRegister('"+window.Venue.streamId+"');");
      },
      // tiggers onSubscribe on other side
      subscribe: function() {
        log('sending subscribe to '+window.Venue.streamId);
        window.Venue.publish("window.Venue.onSubscribe('"+window.Venue.streamId+"');");
      },
      // publishes data via /fayeproxy to private_pub
      publish: function(data) {
        log('publish: '+data);
        var channel = window.Venue.channel;
        $.ajax('/fayeproxy', { type: 'POST', data: { channel: channel, data: data } });
      }
    });

    // 'register' is called to announce a new client
    window.Venue.register();
  };

  window.initBlackbox = function() {
    var flashvars = { streamer: 'rtmp://kluuu-staging.panter.ch/discussions' };
    var params = {};
    var attributes = { id: "Blackbox", name: "Blackbox" };
    swfobject.embedSWF("/flash/Blackbox.swf", "flashcontent", "215", "140",
                       "10.3.181.22", null, flashvars, params, attributes);
  };

  var log = function(msg) {
    if(console==undefined) return;
    console.log(msg);
  };

  // for now, this is in global namespace
  // later we'll pass it to initBlackbox
  window.flashInitialized = function() {
    log('flash initialized');
    initVenue();
  };

  //initBlackbox();

})(jQuery);
