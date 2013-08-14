package {
  //import flash.events.MouseEvent;
  //import fl.controls.TextInput;
 
  import flash.events.Event;
  import flash.events.NetStatusEvent;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.media.Microphone;
  import flash.media.SoundCodec;
  import flash.display.MovieClip;
 
  import flash.system.Security;
  import flash.external.ExternalInterface;

  public class Blackbox extends MovieClip {
    var mic: Microphone;
    var netStreams: Array = new Array();
    var nc: NetConnection;
 
    public function Blackbox() {
      //publishBtn.addEventListener(MouseEvent.CLICK, mouseEventHandler(publishStream, publishInput));
      //playBtn2.addEventListener(MouseEvent.CLICK, mouseEventHandler(playStream, playInput2));
      //playBtn3.addEventListener(MouseEvent.CLICK, mouseEventHandler(playStream, playInput3));
      //playBtn4.addEventListener(MouseEvent.CLICK, mouseEventHandler(playStream, playInput4));
      nc = new NetConnection();
      ExternalInterface.addCallback("publishStream", publishStream);
      ExternalInterface.addCallback("playStream", playStream);
      ExternalInterface.call("flashInitialized");
    }

    //function mouseEventHandler(func: Function, input: TextInput): Function {
    //  return function (event: MouseEvent) {
    //    var stream: String = input.text;
    //    var nc: NetConnection = new NetConnection();
    //    nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler(func, nc, stream));
    //    nc.connect("rtmp://kluuu-staging.panter.ch/discussions");
    //  }
    //}
 
    function publishStream(stream: String) {
      mic = Microphone.getMicrophone();
      mic.codec = SoundCodec.SPEEX;
      mic.setUseEchoSuppression(true);
      mic.framesPerPacket = 1;
      mic.gain = 100;
      mic.setSilenceLevel(0, 2000);
 
      var ns: NetStream = new NetStream(nc);
      ns.attachAudio(mic);
      ns.publish(stream, "live");
      netStreams.push(ns);
    }
 
    function playStream(stream: String) {
      var ns: NetStream = new NetStream(nc);
      ns.receiveVideo(false);
      ns.play(stream);
      netStreams.push(ns);
    }
 
    function netStatusHandler(func: Function, stream: String): Function {
      return function (event: NetStatusEvent) {
        if (event.info.code == "NetConnection.Connect.Success") {
          func(nc, stream);
        } else {
          log(event.info.code);
          trace(event.info.code);
        }
      }
    }

    function log(msg) {
      ExternalInterface.call("flashLog", msg);
    }
  }
}
