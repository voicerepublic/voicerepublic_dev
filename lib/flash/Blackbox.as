package {

  import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.events.Event;
	import flash.events.StatusEvent;
  import flash.events.NetStatusEvent;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.media.Microphone;
  import flash.media.MicrophoneEnhancedOptions;
  import flash.media.MicrophoneEnhancedMode;
  import flash.media.SoundCodec;
  import flash.display.MovieClip;
  import flash.external.ExternalInterface;

  public class Blackbox extends MovieClip {
    var mic: Microphone;
    var subscribedStreams: Array = new Array();
		var publishedStream: NetStream;
    var publishedConnection: NetConnection;
    var streamer: String;

    public function Blackbox() {
      streamer = root.loaderInfo.parameters['streamer'];

      ExternalInterface.addCallback("publish", publishStream);
			ExternalInterface.addCallback("unpublish", unpublishStream);
      ExternalInterface.addCallback("subscribe", subscribeStream);
			ExternalInterface.addCallback("mute", muteMic);
			ExternalInterface.addCallback("unmute", unmuteMic);
			ExternalInterface.addCallback("activate", activateMic);

			var callback: String = root.loaderInfo.parameters['afterInitialize'] || "flashInitialized";
			ExternalInterface.call(callback);
    }

    function muteMic() {
			mic.gain = 0;
		}

    function unmuteMic() {
			mic.gain = 50;
		}

    function activateMic() {
			mic = Microphone.getEnhancedMicrophone();

		  if (!mic) {
			  ExternalInterface.call("alert", "No microphone installed.");
			} else if (mic.muted) {
        Security.showSettings(SecurityPanel.PRIVACY);
				mic.addEventListener(StatusEvent.STATUS, micHandler, false, 0, true);
			} else {
        ExternalInterface.call("micActivated");
			}
    }

    function micHandler(event: StatusEvent) {
			if (event.code == "Microphone.Unmuted") {
        ExternalInterface.call("micActivated");
			}
		}

    function publishStream(stream: String) {
      publishedConnection = new NetConnection();
      publishedConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler(sendStream, publishedConnection, stream));
      publishedConnection.connect(streamer);
    }

    function unpublishStream() {
      if (publishedStream != null) {
        publishedStream.close();
        publishedStream = null;
      }

      if (publishedConnection != null) {
        publishedConnection.close();
        publishedConnection = null;
      }
    }

    function subscribeStream(stream: String) {
      var nc: NetConnection = new NetConnection();
      nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler(receiveStream, nc, stream));
      nc.connect(streamer);
    }

    function sendStream(nc: NetConnection, stream: String) {
      var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
      options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
      options.autoGain = false;
      options.echoPath = 128;
      options.nonLinearProcessing = true;

			if (!mic) {
        mic = Microphone.getEnhancedMicrophone();
			}

      mic.setSilenceLevel(0, 2000);
      mic.enhancedOptions = options;
      mic.codec = SoundCodec.SPEEX;
      mic.encodeQuality = 7;
      mic.framesPerPacket = 1;
      mic.gain = 50;
      mic.setUseEchoSuppression(true);

      publishedStream = new NetStream(nc);
      publishedStream.attachAudio(mic);
      publishedStream.publish(stream, "live");
    }
 
    function receiveStream(nc: NetConnection, stream: String) {
      var ns: NetStream = new NetStream(nc);
      ns.receiveVideo(false);
      ns.play(stream);
      subscribedStreams.push(ns);
    }
 
    function netStatusHandler(func: Function, nc: NetConnection, stream: String): Function {
      return function(event: NetStatusEvent) {
        if (event.info.code == "NetConnection.Connect.Success") {
          func(nc, stream);
          log("connected to " + stream);
        } else {
          log(event.info.code);
        }
      }
    }

    function log(msg) {
      ExternalInterface.call("flashLog", msg);
    }
  }
}
