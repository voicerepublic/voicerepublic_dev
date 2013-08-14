package {
 
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
 
    public function Blackbox() {
      ExternalInterface.addCallback("publish", publishStream);
      ExternalInterface.addCallback("subscribe", subscribeStream);
      ExternalInterface.call("flashInitialized");
    }

    function publishStream(stream: String) {
      var nc: NetConnection = new NetConnection();
      nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler(sendStream, nc, stream));
      nc.connect("rtmp://kluuu-staging.panter.ch/discussions");
    }

    function subscribeStream(stream: String) {
      var nc: NetConnection = new NetConnection();
      nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler(receiveStream, nc, stream));
      nc.connect("rtmp://kluuu-staging.panter.ch/discussions");
    }

    function sendStream(nc: NetConnection, stream: String) {
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
 
    function receiveStream(nc: NetConnection, stream: String) {
      var ns: NetStream = new NetStream(nc);
      ns.receiveVideo(false);
      ns.play(stream);
      netStreams.push(ns);
    }
 
    function netStatusHandler(func: Function, nc: NetConnection, stream: String): Function {
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
