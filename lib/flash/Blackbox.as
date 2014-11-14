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
  import flash.display.BitmapData;
  import flash.external.ExternalInterface;
  import flash.events.SampleDataEvent;
  import flash.events.ActivityEvent;
  import flash.events.StatusEvent;
  import flash.events.UncaughtErrorEvent;
  import flash.events.ErrorEvent;
  import flash.system.Security;
  import flash.system.SecurityPanel;
  import flash.utils.*;

  import flash.text.TextField;
  import flash.text.TextFormat;

  import flash.display.Graphics;
  import flash.display.Shape;
  import flash.display.GradientType;

  // [Frame(factoryClass='mx.preloaders.DownloadProgressBar')]

  public class Blackbox extends MovieClip {
    internal var version: String = '2.3';
    internal var mic: Microphone;
    internal var netStreams: Array = new Array();
    internal var streamer: String;
    internal var publishNetConnection: NetConnection;
    internal var logMethod: String;
    internal var errorMethod: String;
    internal var feedbackMethod: String;
    internal var volume: Number = 1;
    internal var silenceLevel: Number;
    internal var silenceTimeout: Number;
    internal var settingsClosed: String;
    internal var traceFormat:TextFormat;
    internal var traceField:TextField;
    internal var bar:Shape;

    // constructor
    public function Blackbox() {

      setupRectangularShape();
      setupTextField();

      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);

      streamer = root.loaderInfo.parameters['streamer'];

      ExternalInterface.addCallback("micCheck", micCheck);
      ExternalInterface.addCallback("publish", publishStream);
      ExternalInterface.addCallback("unpublish", unpublishStream);
      ExternalInterface.addCallback("subscribe", subscribeStream);
      ExternalInterface.addCallback("muteMic", muteMic);
      ExternalInterface.addCallback("unmuteMic", unmuteMic);
      ExternalInterface.addCallback("setStreamingServer", setStreamingServer);
      ExternalInterface.addCallback("setVolume", setVolume);

      errorMethod    = root.loaderInfo.parameters['errorMethod'] || "console.log";
      logMethod      = root.loaderInfo.parameters['logMethod'] || "console.log";
      feedbackMethod = root.loaderInfo.parameters['feedbackMethod'] || "console.log";
      silenceLevel   = root.loaderInfo.parameters['silence_level'];
      silenceTimeout = root.loaderInfo.parameters['silence_timeout'];
      settingsClosed = root.loaderInfo.parameters['settings_closed'];

      var callback: String =
          root.loaderInfo.parameters['afterInitialize'] || "flashInitialized";

      log('Instanciation of version '+version+' complete, calling ' + callback);
      ExternalInterface.call(callback);
    }

    internal function setupRectangularShape():void {
      var child:Shape = new Shape();
      child.graphics.lineStyle(1, 0x000000);
      child.graphics.drawRect(0, 30, stage.stageWidth, 30);
      addChild(child);
      bar = child;
    }

    internal function updateBar(value:int):void {
      bar.graphics.beginFill(0xffffff);
      bar.graphics.drawRect(0, 30, stage.stageWidth, 30);
      bar.graphics.endFill();
      bar.graphics.beginGradientFill(GradientType.LINEAR,
                                     [0x00ff00, 0xff0000],
                                     [1,1],
                                     [127,255]);
      bar.graphics.drawRect(0, 30, (stage.stageWidth / 100) * value, 30);
      bar.graphics.endFill();
    }

    internal function setupTextField():void {
      traceFormat = new TextFormat();
      traceFormat.bold = true;
      traceFormat.font = "_sans";
      traceFormat.size = 32;
      traceFormat.align = "left";
      traceFormat.color = 0x333333;
      traceField = new TextField();
      traceField.defaultTextFormat = traceFormat;
      traceField.selectable = false;
      traceField.mouseEnabled = false;
      traceField.width = stage.stageWidth;
      traceField.height = stage.stageHeight;
      addChild(traceField);
    }

    internal function setStreamingServer(url: String): void {
      log('Setting streaming server to '+url);
      streamer = url;
    }

    internal function micCheck(): void {
      log('Initiate mic check...');
      mic = Microphone.getEnhancedMicrophone();
      mic.setSilenceLevel(0, 2000);

      // * [ActivityEvent type="activity" bubbles=false
      //   cancelable=false eventPhase=2 activating=true]
      // * [ActivityEvent type="activity" bubbles=false
      //   cancelable=false eventPhase=2 activating=false]
      // log('Add ActivityEventListener.');
      // mic.addEventListener(ActivityEvent.ACTIVITY,
      //                      function(event:ActivityEvent): void {
      //                        log('ActivityEvent: ' + event.activating);
      //                      });

      // * [StatusEvent type="status" bubbles=false cancelable=false
      //   eventPhase=2 code="Microphone.Unmuted" level="status"]
      // * [StatusEvent type="status" bubbles=false cancelable=false
      //   eventPhase=2 code="Microphone.Muted" level="status"]
      log('Add StatusEventListener.');
      mic.addEventListener(StatusEvent.STATUS,
                           function(event:StatusEvent): void {
                             mic.setLoopBack(false);
                             log('StatusEvent: ' + event.code);
                             switch(event.code) {
                             case 'Microphone.Unmuted':
                               log('Permission has been granted.');
                               Security.showSettings(SecurityPanel.MICROPHONE);
                               checkSettings(function():void {
                                 ExternalInterface.call(settingsClosed);
                               });
                               break;
                             case 'Microphone.Muted':
                               log('Permission has been declined.');
                               break;
                             default:
                               log('Something else happened');
                             }
                           });

      // * [SampleDataEvent type="sampleData" bubbles=false
      //   cancelable=false eventPhase=2 position=88320 data=...]
      mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);

      mic.setLoopBack(true);
      //mic.setUseEchoSuppression(true);
      log('Awaiting mic check event...');
    }

    internal function onMicData(e:SampleDataEvent):void {
      traceField.text = "\n\n";
      traceField.appendText("Activity Level: " +
                            e.target.activityLevel + "\n");
      traceField.appendText("Codec: " + e.target.codec + "\n");
      traceField.appendText("Gain: " + e.target.gain + "\n");
      //updateBar(e.target.activityLevel);
      // traceField.appendText("bytesAvailable: " +
      //                       e.data.bytesAvailable + "\n");
      // traceField.appendText("length: " + e.data.length + "\n");
      // traceField.appendText("position: " + e.data.position + "\n");
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
      try {
        var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
        options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
        options.autoGain = false;
        options.echoPath = 128;
        options.nonLinearProcessing = true;

        mic = Microphone.getEnhancedMicrophone();
        // 0, 0 for continous stream
        mic.setSilenceLevel(0, 2000);
        //mic.setSilenceLevel(silenceLevel, silenceTimeout);
        mic.enhancedOptions = options;
        // SPEEX setzt frame rate selbst, vielleicht windows auf nellymoser zwingen
        // bei nellymoser kann man die rate setzten
        mic.codec = SoundCodec.SPEEX;

        // Alternativ einen zweiten und dritte Stream senden
        // byteArray sind Wave Daten

        // http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Microphone.html#encodeQuality
        // encodeQuality 7 == 23.8 kbit/s
        //  * upload of 1mb takes 5.6min
        //  * streaming one hour produces 10.7mb raw data
        /*
          | Quality | kb/s | min2up 1MB | MB/h raw data |
          |---------+------+------------+---------------|
          |       0 | 3.95 |  34.565401 |     1.7358398 |
          |       1 | 5.75 |  23.744928 |     2.5268555 |
          |       2 | 7.75 |  17.617204 |     3.4057617 |
          |       3 | 9.80 |  13.931973 |     4.3066406 |
          |       4 | 12.8 |  10.666667 |         5.625 |
          |       5 | 16.8 |  8.1269841 |     7.3828125 |
          |       6 | 20.6 |  6.6278317 |     9.0527344 |
          |       7 | 23.8 |  5.7366947 |     10.458984 |
          |       8 | 27.8 |  4.9112710 |     12.216797 |
          |       9 | 34.2 |  3.9922027 |     15.029297 |
          |      10 | 42.2 |  3.2353870 |     18.544922 |
          #+TBLFM: $3=(1024*8)/$2/60::$4=60*60*$2/(1024*8)
        */
        mic.encodeQuality = 10;
        mic.framesPerPacket = 1;
        mic.gain = 50;
        mic.setUseEchoSuppression(true);

        mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);

        var ns: NetStream = new NetStream(nc);
        ns.attachAudio(mic);
        ns.publish(stream, "live");
        netStreams.push(ns);
      }
      catch(e:Error) {
        log(e.toString());
      }
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

    // https://code.google.com/p/wami-recorder/source/browse/src/edu/mit/csail/wami/client/FlashSettings.as
    private static var MAX_CHECKS:uint = 28800; // * 1/4sec = 2h
    private var checkSettingsIntervalID:int = 0;
    private var showedPanel:Boolean = false;
    private var checkAttempts:int = 0;

    internal function checkSettings(success:Function):void {
      clearInterval(checkSettingsIntervalID);
      if (!showingPanel()) {
        success();
        // log("we're good.");
        return;
      }
      // log('panel open, check attempts: '+ checkAttempts);
      checkAttempts++;
      if (checkAttempts > MAX_CHECKS) {
        log('giving up.');
        return;
      }
      checkSettingsIntervalID = setInterval(checkSettings, 250, success);
    }

    // Try to capture the stage: triggers a Security error when
    // the settings dialog box is open. Unfortunately, this is how
    // we have to poll the settings dialogue to know when it closes.
    private function showingPanel():Boolean {
      var showing:Boolean = false;
      var dummy:BitmapData = new BitmapData(1,1);
      try { dummy.draw(this.stage); }
      catch (error:Error) {
        log("Still not closed, could not capture the stage: " + this.stage);
        showing = true;
      }
      dummy.dispose();
      dummy = null;
      return showing;
    }

    // http://stackoverflow.com/questions/101532
    internal function uncaughtErrorHandler(event:UncaughtErrorEvent):void {
      if (event.error is Error) {
        var error:Error = event.error as Error;
        // do something with the error
        log("Uncaught Error: " + error);
      } else if (event.error is ErrorEvent) {
        var errorEvent:ErrorEvent = event.error as ErrorEvent;
        // do something with the error
        log("Uncaught ErrorEvent: " + errorEvent);
      } else {
        // a non-Error, non-ErrorEvent type was thrown and uncaught
        log("Uncaught Something: " + event);
      }
    }

  }
}
