$(function () {
  $(".vr-player.jp-jplayer").each(function (i, el) {
    var player = $(el)
    player.jPlayer({
      ready: function (event) {
        $(this).jPlayer("setMedia", {
          m4a: player.data('m4a'),
          mp3: player.data('mp3'),
          ogg: player.data('ogg')
        })
      },
      volume: 1,
      cssSelectorAncestor: player.data('selector'),
      swfPath: "/flash",
      supplied: "m4a, mp3, ogg",
      wmode: "window",
      smoothPlayBar: true,
      keyEnabled: true
    })
  })
})

// TODO: Use Angular instead of jQuery
$(document).ready(function() {
  $("body").on("click", ".embed_player span", function() {
    share_iframe = $(this).parent().find(".share_iframe")
    if (share_iframe.hasClass("hide")) {
      share_iframe.slideDown("slow").removeClass("hide");
    } else {
      share_iframe.slideUp("slow").addClass("hide");
    }
  });
})
