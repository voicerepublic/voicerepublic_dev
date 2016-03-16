// http://jplayer.org/latest/developer-guide/

$(function () {
  $(".vr-player.jp-jplayer").each(function (i, el) {
    var player = $(el)
    var volumeIndicator = player.next().find('.jp-volume-bar-value');
    var dancingIndicator = player.next().find('.jp-volume-bar-value-dancing');
    var interval = null;
    var state = "started";

    var start_volume_meter = function() {
      if (state == "playing") {
        var currentVolumeHeight = volumeIndicator.css("height")
        interval = setInterval(dancingVolume, 100, currentVolumeHeight, dancingIndicator);
      } else {
        dancingIndicator.css("height", volumeIndicator.height());
      }
    }

    player.jPlayer({
      ready: function (event) {
        $(this).jPlayer("setMedia", {
          m4a: player.data('m4a'),
          mp3: player.data('mp3'),
          ogg: player.data('ogg')
        });
        // dancingVolume(currentVolumeHeight, dancingIndicator);
      },

      playing: function (event) {
        var currentVolumeHeight = volumeIndicator.css("height")
        //dancingVolume(currentVolumeHeight,dancingIndicator);
        state = "playing";
        start_volume_meter();
      }, 

      pause: function (event) {
       console.log('now paused');
       state = "paused";
       clearInterval(interval);
      },

      volumechange: function(event) {
        console.log('vol changed')
        clearInterval(interval);
 
        //if ($(this).jPlayer.status.paused !== true) {
        //dancingVolume(currentVolumeHeight,dancingIndicator);


        
        start_volume_meter();
        //}
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

  function dancingVolume(j,v) {
      var rando = Math.random() * .5;
      var height = parseInt(j, 10);
      var origHeight = height + "px";
      var newHeight = height - (rando * height)  + "px";
      console.log(newHeight);
    if ($('.jp-audio').hasClass('jp-state-playing')) {
     

      $('.jp-state-playing').find(v).css("height",newHeight)
    } else {
      $('.jp-state-playing').find(v).css("height",origHeight)
    }
    

    
  }



  // Make the player responsive by checking the width of the element rather than of the browser window (since it's in an iframe)
  var embedWidth;
  var playerHolder = $('.embed-player');

  function whatWidth(){
    embedWidth = $('.embed-player').outerWidth();
    $('.my-width').html(embedWidth)
    
    if (embedWidth < 480) {
      playerHolder.removeClass('medium')
      playerHolder.removeClass('large')
      playerHolder.removeClass('small')
      playerHolder.addClass('xs')
      $('.sm-up').hide();
      $('.md-up').hide();

    } else if (embedWidth > 479 && embedWidth < 640) {
      playerHolder.removeClass('medium')
      playerHolder.removeClass('large')
      playerHolder.removeClass('xs')
      playerHolder.addClass('small')
      $('.sm-up').show();
      $('.md-up').hide();
    } else if (embedWidth > 639 && embedWidth < 1024) {
      playerHolder.removeClass('small')
      playerHolder.removeClass('large')
      playerHolder.removeClass('xs')
      playerHolder.addClass('medium')
      $('.md-up').show();
    } else {
      playerHolder.removeClass('medium')
      playerHolder.removeClass('small')
      playerHolder.removeClass('xs')
      playerHolder.addClass('large')
      $('.sm-up').show();
      $('.md-up').show();
    }
  }
  
  whatWidth();
  $(window).resize(whatWidth)




});


