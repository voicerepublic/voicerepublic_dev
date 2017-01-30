// --- BUNDLED LIBRARIES
//= require jquery
//= require jquery_ujs
//
// --- VENDORED LIBRARIES
//= require jquery.jplayer.min
//
// --- COMPONENTS
//= require components/ga-event
//= require components/pinboard

// http://jplayer.org/latest/developer-guide/
//
// TODO move init of player out of here into a more generic place (component)

if (insider) {
    console.log("loading embed.");
}

function doThatThing() {
    $(".share-panel .share-btn a").click(function(e) {
  var social_network;
  var element = $(e.target).parent();
  social_network = $(element).attr("class").split(" ").filter(function(data) {
    return ["facebook", "twitter", "mail"].indexOf(data) != -1 ? data : undefined
  });
  social_network = social_network[0];
  return $.post("/xhr/social_shares", {
    social_share: {
      shareable_id: $(element).attr("data-shareable-id"),
      shareable_type: $(element).attr("data-shareable-type"),
      social_network: social_network
    }
  }).always(function(data) {
    var social_url;
    if (social_network !== 'mail') {
      social_url = {
        facebook: "https://www.facebook.com/sharer/sharer.php?u=",
        twitter: "https://twitter.com/intent/tweet?source=webclient&text="
      }[social_network];
      social_url += encodeURI(window.location);
      window.open(social_url, "_blank").focus();
    }
  });
});
}

$(function() {


    doThatThing();


    $(".vr-player.jp-jplayer").each(function(i, el) {
        var player = $(el)
        var volumeIndicator = player.next().find('.jp-volume-bar-value');
        var dancingIndicator = player.next().find('.jp-volume-bar-value-dancing');
        var interval = null;
        var state = "started";
        var teaserVisible = false;
        var teaserMsg;

        var start_volume_meter = function() {
            if (state == "playing") {
                var currentVolumeHeight = volumeIndicator.css("height")
                interval = setInterval(dancingVolume, 100, currentVolumeHeight, dancingIndicator);
            } else {
                dancingIndicator.css("height", volumeIndicator.height());
            }
        }

        player.jPlayer({
            ready: function(event) {
                $(this).jPlayer("setMedia", {
                    m4a: player.data('m4a'),
                    mp3: player.data('mp3'),
                    ogg: player.data('ogg')
                });
            },

            //canplay: function(){

              // $('.jp-controls').removeClass('hide');
              // $('.jp-time-holder').removeClass('hide');
              // $('.loading-indicator').addClass('hide');

            //},

            playing: function(event) {
                var currentVolumeHeight = volumeIndicator.css("height")
                state = "playing";
                start_volume_meter();
            },

            pause: function(event) {
                state = "paused";
                clearInterval(interval);
                toggleTeaser();
            },

            play: function() {
                if (!$('.teaser-msg').hasClass('hide')) {
                    toggleTeaser();
                }
            },

            volumechange: function(event) {
                clearInterval(interval);
                start_volume_meter();
            },

            ended: function() {
                console.log("it's over")
                //toggleTeaser();
                _gaq.push("_trackEvent", "click", "play", "player", "ended", "talk: " + talk_id)
            },

            volume: .8,
            cssSelectorAncestor: player.data('selector'),
            swfPath: '/flash/Jplayer.swf',
            supplied: "m4a, mp3, ogg",
            wmode: "window",
            smoothPlayBar: true,
            keyEnabled: true,
            verticalVolume: true

        });
    });

    function toggleTeaser() {
        console.log('teaser has been toggled')
        $('.teaser-msg a.teaser-link p span').html(teaserMsg);
        $('.jp-progress').toggleClass('hide');
        $('.teaser-msg').toggleClass('hide');
        if(!$('.embed-msg').hasClass('hide')){
            $('.embed-msg').addClass('hide');
            $('.jp-progress').toggleClass('hide');
            $('.action-panel').toggleClass('hide')
        }
    }



    function dancingVolume(j, v) {
        var rando = Math.random() * .5;
        var height = parseInt(j, 10);
        var origHeight = height + "px";
        var newHeight = height - (rando * height) + "px";
        if ($('.jp-audio').hasClass('jp-state-playing')) {
            $('.jp-state-playing').find(v).css("height", newHeight)
        } else {
            $('.jp-state-playing').find(v).css("height", origHeight)
        }
    }


    //Share and action btns functionality:
    $('.action-share').on('click', function() {
        $('.share-panel').toggleClass('hide');
        $('.action-panel').toggleClass('hide');
        $('.jp-time-holder').addClass('sharing');
    });


    $('.close-share').on('click', function() {
        $('.share-panel').toggleClass('hide');
        $('.action-panel').toggleClass('hide');
        $('.jp-time-holder').removeClass('sharing');
    });

    $('.close-msg').on('click', function() {
        $('.embed-msg').toggleClass('hide');
        $('.action-panel').toggleClass('hide');
        $('.jp-progress').toggleClass('hide');

    });


    $('.action-btn.pin-btn').on('click', function() {
        $('.embed-msg').removeClass('hide');
        $('.action-panel').addClass('hide');
        $('.jp-progress').addClass('hide');
        if(!$('.teaser-msg').hasClass('hide')) {
            $('.teaser-msg').addClass('hide')
        }

    });

    //easter egg to make the player unbranded:
    $('.image-box').on('click', function() {
        $('.embed-player').toggleClass('unbranded');
    });

    // Make the player responsive by checking the width of the element rather than of the browser window (since it's in an iframe)
    var embedWidth;
    var embedClass = "";
    var playerHolder = $('.embed-player');

    function showEmbedClass() {
        $('.my-class').text("my-class: " + embedClass);
    }

    //breakpoints:
    var token = 150;
    var tiny = 320;
    var xs = 480;
    var small = 640;
    var medium = 1024;

    var breakpoints = [
        "token",
        "tiny",
        "xs",
        "small",
        "medium",
        "large"
    ];

    var hideForTiny = [
        $('.slides-btn'),
        $('.chat-btn'),
        $('.action-share'),
    ];

    var addBreakpointClass = function(c) {
        jQuery.each(breakpoints, function(index, item) {
            playerHolder.removeClass(item)
        });

        if (c == "tiny" || c== "token"){

        jQuery.each(hideForTiny, function() {
            $(this).addClass('hide')
        });
        } else {
                  jQuery.each(hideForTiny, function() {
            $(this).removeClass('hide')
        });
        }

        playerHolder.addClass(c)
        $('.mySize').text(c)

    };

    function calcWidth() {
        embedWidth = $('.embed-player').outerWidth();
        $('.my-width').html(embedWidth)
        if (embedWidth <= token) {
            embedClass = String(breakpoints[0])
            //teaserMsg = msg_token;
        } else if (embedWidth > token && embedWidth <= tiny) {
            embedClass = String(breakpoints[1])
            $('.sm-up').hide();
            $('.md-up').hide();
            teaserMsg = msg_tiny;
        } else if (embedWidth > tiny && embedWidth < xs) {
            embedClass = String(breakpoints[2])
            $('.sm-up').hide();
            $('.md-up').hide();
            teaserMsg = msg_xs;
        } else if (embedWidth > xs && embedWidth < small) {
            embedClass = String(breakpoints[3])
            $('.sm-up').show();
            $('.md-up').hide();
            teaserMsg = msg_small;
        } else if (embedWidth > small && embedWidth < medium) {
            embedClass = String(breakpoints[4])
            $('.md-up').show();
            teaserMsg = msg_medium;
        } else {
            embedClass = String(breakpoints[5])
            $('.sm-up').show();
            $('.md-up').show();
            teaserMsg = msg_large;
        }
        addBreakpointClass(embedClass);
    }
    calcWidth();
    $(window).resize(calcWidth)




});