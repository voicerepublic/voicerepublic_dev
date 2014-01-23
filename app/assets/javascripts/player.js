$(function () {
  $(".kluuu.jp-jplayer").each(function (i, el) {
    var player = $(el)

    player.jPlayer({
      ready: function (event) {
        $(this).jPlayer("setMedia", {
          m4a: player.data('recording')
        });
      },
  
      volume: 1,
      cssSelectorAncestor: player.data('selector'),
      swfPath: "/flash",
      supplied: "m4a",
      wmode: "window",
      smoothPlayBar: true,
      keyEnabled: true
    });
  });
});
