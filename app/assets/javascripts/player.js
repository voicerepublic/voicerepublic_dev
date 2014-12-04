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
      keyEnabled: true
    });
  });
});
