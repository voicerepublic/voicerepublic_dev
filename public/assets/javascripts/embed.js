// http://jplayer.org/latest/developer-guide/

$(function () {
  $(".vr-player.jp-jplayer").each(function (i, el) {
    var player = $(el)
    player.jPlayer({
      ready: function (event) {
        $(this).jPlayer("setMedia", {
          m4a: player.data('m4a'),
          mp3: player.data('mp3'),
          ogg: player.data('ogg')
        });
      },
      volume: 1,
      cssSelectorAncestor: player.data('selector'),
      swfPath: '/flash/Jplayer.swf',
      supplied: "m4a, mp3, ogg",
      wmode: "window",
      smoothPlayBar: true,
      keyEnabled: true,
      verticalVolume: true
    });
  });

  var embedWidth;
  var player = $('.embed-player');

  function whatWidth(){
    embedWidth = $('.embed-player').outerWidth();
    $('.my-width').html(embedWidth)
    
    if (embedWidth < 480) {
      player.removeClass('medium')
      player.removeClass('large')
      player.removeClass('small')
      player.addClass('xs')
      $('.sm-up').hide();
      $('.md-up').hide();

    } else if (embedWidth > 479 && embedWidth < 640) {
      player.removeClass('medium')
      player.removeClass('large')
      player.removeClass('xs')
      player.addClass('small')
      $('.sm-up').show();
      $('.md-up').hide();
    } else if (embedWidth > 639 && embedWidth < 1024) {
      player.removeClass('small')
      player.removeClass('large')
      player.removeClass('xs')
      player.addClass('medium')
      $('.md-up').show();
    } else {
      player.removeClass('medium')
      player.removeClass('small')
      player.removeClass('xs')
      player.addClass('large')
      $('.sm-up').show();
      $('.md-up').show();
    }
  }
  
  whatWidth();
  $(window).resize(whatWidth)

});
