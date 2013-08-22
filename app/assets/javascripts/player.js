$(function () {
  var player = $("#jquery_jplayer_1")
  player.jPlayer({
    ready: function (event) {
      console.log("init");
      $(this).jPlayer("setMedia", {
        m4a: player.data('recording')
      });
    },
    swfPath: "/flash",
    supplied: "m4a",
    wmode: "window",
    smoothPlayBar: true,
    keyEnabled: true
  })
})
