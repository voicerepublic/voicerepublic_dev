package {

  import flash.events.Event;
  import flash.events.AsyncErrorEvent;
  import flash.events.IOErrorEvent;
  import flash.events.NetStatusEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.media.Microphone;
  import flash.media.MicrophoneEnhancedOptions;
  import flash.media.MicrophoneEnhancedMode;
  import flash.media.SoundCodec;
  import flash.media.SoundTransform;
  import flash.display.MovieClip;

  import flash.external.ExternalInterface;

  import flash.display.Shape;
  import flash.events.SampleDataEvent;
  // import flash.events.ActivityEvent;
  // import flash.events.StatusEvent;
  //import fl.transitions.Tween;
  //import fl.transitions.easing.*;
  import spark.effects.Scale;

  // [Frame(factoryClass='mx.preloaders.DownloadProgressBar')]

  public class Blackbox extends MovieClip {
    internal var version: String = '2.2';
    internal var mic: Microphone;
    internal var netStreams: Array = new Array();
    internal var streamer: String;
		internal var publishNetConnection: NetConnection;
    internal var logMethod: String;
    internal var errorMethod: String;
    internal var feedbackMethod: String;
    internal var volume: Number = 1;
    // internal var myCircle:Shape = new Shape();

    // constructor
    public function Blackbox() {
      // // init graphics
      // var width:int = stage.stageWidth;
      // var height:int = stage.stageHeight;
      // myCircle.graphics.beginFill(0x00CCFF);
      // // myCircle.graphics.lineStyle(20, 0xCCCC99);
      // myCircle.graphics.drawCircle(width/2, height/2, 100);
      // myCircle.graphics.endFill();
      // addChild(myCircle);

      //var myTween:Tween=new Tween(myCircle,"x",Regular.easeOut,80,470,4,true);
      //var myScale:Scale=new Scale(this);
      //myScale.scaleXBy = 2;
      //myScale.play();

      streamer = root.loaderInfo.parameters['streamer'];

      ExternalInterface.addCallback("micCheck", micCheck);
      ExternalInterface.addCallback("publish", publishStream);
			ExternalInterface.addCallback("unpublish", unpublishStream);
      ExternalInterface.addCallback("subscribe", subscribeStream);
			ExternalInterface.addCallback("muteMic", muteMic);
			ExternalInterface.addCallback("unmuteMic", unmuteMic);
			ExternalInterface.addCallback("setStreamingServer", setStreamingServer);
			ExternalInterface.addCallback("setVolume", setVolume);

      errorMethod = root.loaderInfo.parameters['errorMethod'] || "console.log";
      logMethod = root.loaderInfo.parameters['logMethod'] || "console.log";
      feedbackMethod = root.loaderInfo.parameters['feedbackMethod'] || "console.log";
			var callback: String =
          root.loaderInfo.parameters['afterInitialize'] || "flashInitialized";

      log('Instanciation of version '+version+' complete, calling ' + callback);
			ExternalInterface.call(callback);
    }

    internal function setStreamingServer(url: String): void {
      log('Setting streaming server to '+url);
      streamer = url;
    }

    internal function micCheck(): void {
      log('Initiate mic check...');
      mic = Microphone.getEnhancedMicrophone();
      // mic.addEventListener(ActivityEvent.ACTIVITY,
      //                      function(event:ActivityEvent): void {
      //                        log('ActivityEvent: ' + event);
      //                      });
      // mic.addEventListener(StatusEvent.STATUS,
      //                      function(event:StatusEvent): void {
      //                        log('StatusEvent: ' + event);
      //                      });
      mic.setLoopBack(true);
      mic.setUseEchoSuppression(true);
      mic.addEventListener(SampleDataEvent.SAMPLE_DATA,
                           function(event:SampleDataEvent): void {
                             var value:Number = mic.activityLevel;
			                       ExternalInterface.call(feedbackMethod, value);
                             //log(value.toString());
                             // myCircle.width = value;
                             // while(event.data.bytesAvailable)     {
                             //   var sample:Number = event.data.readFloat();
                             // }
                           });
      log('Initiation complete.');
    }

    internal function muteMic(): void {
      log("Mute mic by setting gain to 0.")
			mic.gain = 0;
		}

    internal function unmuteMic(): void {
      log("Unmute mic by setting gain to 50.")
			mic.gain = 50;
		}

    internal function setStreamVolume(ns:NetStream, vol:Number): void {
      var st:SoundTransform = ns.soundTransform;
      st.volume = vol;
      ns.soundTransform = st;
    }

    internal function updateStreamsVolume(vol:Number): void {
      for each (var ns:NetStream in netStreams) {
        setStreamVolume(ns, vol);
      }
      log("Set volume of "+netStreams.length+" streams to "+vol+".")
    }

    internal function setVolume(vol:Number): void {
      try {
        volume = vol;
        updateStreamsVolume(volume);
      }
      catch(e:Error) {
        log(e.toString());
      }
    }

    internal function publishStream(stream: String): void {
      log("Publishing mic to " + stream);
      publishNetConnection = new NetConnection();
      publishNetConnection.addEventListener(NetStatusEvent.NET_STATUS,
                                            netStatusHandler(sendStream,
                                                             publishNetConnection,
                                                             stream));
      // audit
      publishNetConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,
                                            asyncErrorHandler);
      publishNetConnection.addEventListener(IOErrorEvent.IO_ERROR,
                                            ioErrorHandler);
      publishNetConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                            securityErrorHandler);
      // end audit
      publishNetConnection.connect(streamer);
    }

    internal function unpublishStream(): void {
      log("Unpublishing mic.");
			if (publishNetConnection != null) {
				publishNetConnection.close();
			}
		}

    internal function subscribeStream(stream: String): void {
      log("Subcribe to stream: " + stream);
      var nc: NetConnection = new NetConnection();
      nc.addEventListener(NetStatusEvent.NET_STATUS,
                          netStatusHandler(receiveStream, nc, stream));
      // audit
      nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,
                          asyncErrorHandler);
      nc.addEventListener(IOErrorEvent.IO_ERROR,
                          ioErrorHandler);
      nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                          securityErrorHandler);
      // end audit
      nc.connect(streamer);
    }

    internal function sendStream(nc: NetConnection, stream: String): void {
      var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
      options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
      options.autoGain = false;
      options.echoPath = 128;
      options.nonLinearProcessing = true;

      mic = Microphone.getEnhancedMicrophone();
      // 0, 0 for continous stream
      //mic.setSilenceLevel(0, 2000);
      mic.setSilenceLevel(0, 0);
      mic.enhancedOptions = options;
      // SPEEX setzt frame rate selbst, vielleicht windows auf nellymoser zwingen
      // bei nellymoser kann man die rate setzten
      mic.codec = SoundCodec.SPEEX;

      // Alternativ einen zweiten und dritte Stream senden
      // byteArray sind Wave Daten
      
      // http://www.gbaptista.com/docs/as3/flash/media/Microphone.html#encodeQuality
      // encodeQuality 7 == 23.8 kbit/s
      //  * upload of 1mb takes 5.6min
      //  * streaming one hour produces 10.7mb raw data
      mic.encodeQuality = 7;
      mic.framesPerPacket = 1;
      mic.gain = 50;
      mic.setUseEchoSuppression(true);

      var ns: NetStream = new NetStream(nc);
      ns.attachAudio(mic);
      ns.publish(stream, "live");
      netStreams.push(ns);
    }

    internal function receiveStream(nc: NetConnection, stream: String): void {
      var ns: NetStream = new NetStream(nc);
      ns.receiveVideo(false);
      setStreamVolume(ns, volume);
      ns.play(stream);
      netStreams.push(ns);
    }

    internal function netStatusHandler(func: Function,
                              nc: NetConnection,
                              stream: String): Function {
      return function(event: NetStatusEvent): void {
        // see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/NetStatusEvent.html#info
        if (event.info.code == "NetConnection.Connect.Success") {
          func(nc, stream);
        }
        ExternalInterface.call(errorMethod, event.info.code, stream);
      }
    }

    // audit
    internal function asyncErrorHandler(event: AsyncErrorEvent): void {
      log("AsyncErrorEvent: " + event.error);
    }

    internal function ioErrorHandler(event: IOErrorEvent): void {
      log("IOErrorEvent: " + event.text);
    }

    internal function securityErrorHandler(event: SecurityErrorEvent): void {
      log("SecurityErrorEvent: " + event.text);
    }
    // end audit
    
    internal function log(msg: String): void {
      ExternalInterface.call(logMethod, "[Blackbox]: " + msg);
    }
  }
}
