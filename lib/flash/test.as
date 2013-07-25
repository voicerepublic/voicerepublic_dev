package {

  //import flash.system.System;
  import flash.system.Security;
  import flash.display.MovieClip;
  import flash.external.ExternalInterface;
  
  public class Main extends MovieClip {

    function Main() {
      //System.security.allowDomain("*");
      //Security.allowDomain("*");
      //Security.allowInsecureDomain("*");

      ExternalInterface.addCallback("toggle_mute", toggle_mute);
      //ExternalInterface.addCallback("add", null, add);

      ExternalInterface.call("flashInitialized");
    }

    function toggle_mute() {
      log('success, but toggle_mute is not yet implemented');
    }

    function log(msg) {
      ExternalInterface.call("flashLog", msg);
    }

  }
}



