import mx.core.FlexGlobals;
import mx.events.SliderEvent;

[Bindable]
public var gain:int = 0;

private var version:String = '3.2';
private var mic:Microphone;
private var opts:MicrophoneEnhancedOptions;
private var streamer:String;
private var shadowGain:Number = 0;
private var streamVolume:Number = 1;

private var publishStreamName:String;
private var publishNetStream:NetStream;
private var publishNetConnection:NetConnection;
private var monitorNetConnection:NetConnection;

private var netStreams:Array = new Array();
private var netConnections:Array = new Array();

private var jsImports:Object = {
  closeMethod:     null,
  errorMethod:     null,
  logMethod:       null,
  feedbackMethod:  null,
  silenceLevel:    null,
  silenceTimeout:  null,
  settingsClosed:  null,
  afterInitialize: null
};

private var jsExports:Object = {
  micCheck:           micCheck,
  publish:            publishStream,
  unpublish:          unpublishStream,
  subscribe:          subscribeStream,
  unsubscribeAll:     unsubscribeAll,
  muteMic:            muteMic,
  unmuteMic:          unmuteMic,
  setVolume:          setVolume,
  setStreamingServer: setStreamingServer
};

// --- initializer

public function initApp():void {
  log('Instanciating Blackbox...');
  try {
    var li:LoaderInfo = FlexGlobals.topLevelApplication.systemManager.stage.loaderInfo;

    // make javascript parameters available to actionscript
    for(key in jsImports) {
      jsImports[key] = li.parameters[key] || 'console.log';
    }

    // catch all uncaught exceptions
    li.uncaughtErrorEvents.addEventListener(
      UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);

    // setup up options for enhanced microphone
    opts = new MicrophoneEnhancedOptions();
    opts.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
    opts.autoGain = false;
    opts.echoPath = 128;
    opts.nonLinearProcessing = true;

    var key:String;

    // make actionscript methods accessible to javascript
    for(key in jsExports) {
      ExternalInterface.addCallback(key, jsExports[key]);
    }

    log('Instanciation of version ' + version +
        ' complete, calling ' + jsImports.afterInitialize);
    ExternalInterface.call(jsImports.afterInitialize);
  }
  catch (error:Error) {
    log("Error during instanciation...");
    ExternalInterface.call(jsImports.logMethod, error);
  }
}

// --- private methods

private function log(msg:String):void {
  ExternalInterface.call(jsImports.logMethod, "[Blackbox]: " + msg);
}

private function setupMic():void {
  var enhanced:Boolean = enhancedMicrophone.selected;

  mic = null;
  if(enhanced) {
    log('Setting up enhanced mic...')
    mic = Microphone.getEnhancedMicrophone();
    mic.enhancedOptions = opts;
  } else {
    log('Setting up regular mic...')
    mic = Microphone.getMicrophone();
  }

  mic.codec = SoundCodec.SPEEX;
  mic.encodeQuality = 10;
  mic.framesPerPacket = 1;
  mic.setUseEchoSuppression(true);
  mic.noiseSuppressionLevel = 0;
  mic.setSilenceLevel(0, 2000);

  mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);

  gain = mic.gain;

  enhancedMicrophone.enabled = true;
  monitor.enabled = true;
  volume.enabled = true;

  if(publishStreamName != null) {
    publishNetStream.attachAudio(mic);
    //publishNetConnection.close();
    //publishStream(publishStreamName);
  }
}

private function setStreamVolume(ns:NetStream, vol:Number):void {
  var st:SoundTransform = ns.soundTransform;
  st.volume = vol;
  ns.soundTransform = st;
  //ns.soundTransform.volume = vol;
}

private function updateStreamsVolume(vol:Number):void {
  for each (var ns:NetStream in netStreams) {
    setStreamVolume(ns, vol);
  }
  log("Set volume of "+netStreams.length+" streams to "+vol+".")
}

// --- private handlers

// http://stackoverflow.com/questions/101532
private function uncaughtErrorHandler(event:UncaughtErrorEvent):void {
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

private function asyncErrorHandler(event:AsyncErrorEvent):void {
  log("AsyncErrorEvent: " + event.error);
}

private function ioErrorHandler(event:IOErrorEvent):void {
  log("IOErrorEvent: " + event.text);
}

private function securityErrorHandler(event:SecurityErrorEvent):void {
  log("SecurityErrorEvent: " + event.text);
}

private function onMicData(e:SampleDataEvent):void {
  bar.setProgress(e.target.activityLevel, 100);
  debouncedFeedback(e.target.activityLevel);
}
// --- public handlers

private function clickSelectInputSource():void {
  Security.showSettings(SecurityPanel.MICROPHONE);
}

private function clickClose():void {
  ExternalInterface.call(jsImports.closeMethod);
}

private function gainHandler(e:SliderEvent):void {
  gain = e.value;
  mic.gain = gain;
}

private function localLoopbackHandler(e:MouseEvent):void {
  log('Setting local loopback to ' + e.target.selected);
  mic.setLoopBack(e.target.selected);
}

private function monitorHandler(e:MouseEvent):void {
  if(!e.target.selected) {
    log('Unsubscribe from monitor.');
    monitorNetConnection.close();
    return;
  }

  log('Subscribe to monitor.')
  var nc:NetConnection = new NetConnection();
  nc.addEventListener(NetStatusEvent.NET_STATUS,
                      netStatusHandler(receiveStream, nc, publishStreamName));
  nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
  nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
  nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
  nc.connect(streamer);
  monitorNetConnection = nc;
}

// --- exported methods

private function setStreamingServer(url:String):void {
  log('Setting streaming server to '+url);
  streamer = url;
}

private function micCheck():void {
  log('Initiate mic check...');
  if(mic == null) setupMic();

  // * [ActivityEvent type="activity" bubbles=false
  //   cancelable=false eventPhase=2 activating=true]
  // * [ActivityEvent type="activity" bubbles=false
  //   cancelable=false eventPhase=2 activating=false]
  // log('Add ActivityEventListener.');
  // mic.addEventListener(ActivityEvent.ACTIVITY,
  //                      function(event:ActivityEvent):void {
  //                        log('ActivityEvent: ' + event.activating);
  //                      });

  // * [StatusEvent type="status" bubbles=false cancelable=false
  //   eventPhase=2 code="Microphone.Unmuted" level="status"]
  // * [StatusEvent type="status" bubbles=false cancelable=false
  //   eventPhase=2 code="Microphone.Muted" level="status"]
  log('Add StatusEventListener.');
  mic.addEventListener(StatusEvent.STATUS,
                       function(event:StatusEvent):void {
                         mic.setLoopBack(false);
                         log('StatusEvent: ' + event.code);
                         switch(event.code) {
                         case 'Microphone.Unmuted':
                           log('Permission has been granted.');
                           //Security.showSettings(SecurityPanel.MICROPHONE);
                           //checkSettings(function():void {
                           //  ExternalInterface.call(jsImports.settingsClosed);
                           //});
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
  // mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);

  mic.setLoopBack(true);
  //mic.setUseEchoSuppression(true);
  log('Awaiting mic check event...');
}

private function muteMic():void {
  shadowGain = mic.gain;
  mic.gain = 0;
  log("Mute mic by setting gain to 0; shadowGain set.")
}

private function unmuteMic():void {
  mic.gain = shadowGain;
  log("Unmute mic by setting gain to shadowGain.")
}

private function setVolume(volume:Number):void {
  log("Set volume of all streams to "+volume);
  updateStreamsVolume(volume);
}

private function publishStream(stream:String):void {
  log("Publishing mic to " + stream);
  if(publishStreamName != null) {
    log("Already publishing to "+ publishStreamName);
    return;
  }
  if(mic == null) setupMic();
  publishStreamName = stream;

  var nc:NetConnection = new NetConnection();
  nc.addEventListener(NetStatusEvent.NET_STATUS,
                      netStatusHandler(sendStream, nc, stream));
  nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
  nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
  nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
  nc.connect(streamer);

  publishNetConnection = nc;
}

private function unpublishStream():void {
  log("Unpublishing mic...");
  publishStreamName = null;
  if (publishNetConnection != null) {
    publishNetConnection.close();
    log("Unpublished mic.");
  }
}

private function subscribeStream(stream:String):void {
  log("Subcribe to stream: " + stream);
  var nc:NetConnection = new NetConnection();
  nc.addEventListener(NetStatusEvent.NET_STATUS,
                      netStatusHandler(receiveStream, nc, stream));
  nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
  nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
  nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
  nc.connect(streamer);
  netConnections.push(nc);
}

private function unsubscribeAll():void {
  log("Unsubscribing all, closing "+netConnections.length+" NetConnections.");
  for each (var nc:NetConnection in netConnections) {
    nc.close();
  }
}

// --- private helpers

private function sendStream(nc:NetConnection, stream:String):void {
  var ns:NetStream = new NetStream(nc);
  ns.attachAudio(mic);
  ns.publish(stream, "live");
  // TODO check if it makes sense to push a published stream on netStreams
  netStreams.push(ns);
  publishNetStream = ns;
}

private function receiveStream(nc:NetConnection, stream:String):void {
  var ns:NetStream = new NetStream(nc);
  ns.receiveVideo(false);
  setStreamVolume(ns, streamVolume);
  ns.play(stream);
  netStreams.push(ns);
}

private function netStatusHandler(f:Function, nc:NetConnection, s:String):Function {
  return function(event:NetStatusEvent):void {
    if (event.info.code == "NetConnection.Connect.Success") f(nc, s);
    ExternalInterface.call(jsImports.errorMethod, event.info.code, s);
  }
}

// TODO use this to debounce feedback
// https://github.com/amacdougall/underscore.as/blob/master/src/com/alanmacdougall/underscore/_.as#L633-L658
private function debouncedFeedback(x:Number):void {
  ExternalInterface.call(jsImports.feedbackMethod, x);
}

// // https://code.google.com/p/wami-recorder/source/browse/src/edu/mit/csail/wami/client/FlashSettings.as
// private static var MAX_CHECKS:uint = 28800; // * 1/4sec = 2h
// private var checkSettingsIntervalID:int = 0;
// private var showedPanel:Boolean = false;
// private var checkAttempts:int = 0;
//
// private function checkSettings(success:Function):void {
//   clearInterval(checkSettingsIntervalID);
//   if (!showingPanel()) {
//     success();
//     // log("we're good.");
//     return;
//   }
//   // log('panel open, check attempts: '+ checkAttempts);
//   checkAttempts++;
//   if (checkAttempts > MAX_CHECKS) {
//     log('giving up.');
//     return;
//   }
//   checkSettingsIntervalID = setInterval(checkSettings, 250, success);
// }
//
// // Try to capture the stage: triggers a Security error when
// // the settings dialog box is open. Unfortunately, this is how
// // we have to poll the settings dialogue to know when it closes.
// private function showingPanel():Boolean {
//   var showing:Boolean = false;
//   var dummy:BitmapData = new BitmapData(1,1);
//   try { dummy.draw(this.stage); }
//   catch (error:Error) {
//     log("Still not closed, could not capture the stage: " + this.stage);
//     showing = true;
//   }
//   dummy.dispose();
//   dummy = null;
//   return showing;
// }


// LEGACY

//
//   try {
//     var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
//     options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
//     options.autoGain = false;
//     options.echoPath = 128;
//     options.nonLinearProcessing = true;
//
//     mic = Microphone.getEnhancedMicrophone();
//     // 0, 0 for continous stream
//     mic.setSilenceLevel(0, 2000);
//     //mic.setSilenceLevel(silenceLevel, silenceTimeout);
//     mic.enhancedOptions = options;
//     // SPEEX setzt frame rate selbst, vielleicht windows auf nellymoser zwingen
//     // bei nellymoser kann man die rate setzten
//     mic.codec = SoundCodec.SPEEX;
//
//     // Alternativ einen zweiten und dritte Stream senden
//     // byteArray sind Wave Daten
//
//     // http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Microphone.html#encodeQuality
//     // encodeQuality 7 == 23.8 kbit/s
//     //  * upload of 1mb takes 5.6min
//     //  * streaming one hour produces 10.7mb raw data
//     /*
//       | Quality | kb/s | min2up 1MB | MB/h raw data |
//       |---------+------+------------+---------------|
//       |       0 | 3.95 |  34.565401 |     1.7358398 |
//       |       1 | 5.75 |  23.744928 |     2.5268555 |
//       |       2 | 7.75 |  17.617204 |     3.4057617 |
//       |       3 | 9.80 |  13.931973 |     4.3066406 |
//       |       4 | 12.8 |  10.666667 |         5.625 |
//       |       5 | 16.8 |  8.1269841 |     7.3828125 |
//       |       6 | 20.6 |  6.6278317 |     9.0527344 |
//       |       7 | 23.8 |  5.7366947 |     10.458984 |
//       |       8 | 27.8 |  4.9112710 |     12.216797 |
//       |       9 | 34.2 |  3.9922027 |     15.029297 |
//       |      10 | 42.2 |  3.2353870 |     18.544922 |
//       #+TBLFM: $3=(1024*8)/$2/60::$4=60*60*$2/(1024*8)
//     */
//     mic.encodeQuality = 10;
//     mic.framesPerPacket = 1;
//     mic.setUseEchoSuppression(true);
//
//     mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);
//
//     // The amount by which the microphone boosts the signal. Valid
//     // values are 0 to 100. The default value is 50.
//     //mic.gain = 50;
//
//     // Maximum attenuation of the noise in dB (negative number) used
//     // for Speex encoder. If enabled, noise suppression is applied to
//     // sound captured from Microphone before Speex compression. Set
//     // to 0 to disable noise suppression. Noise suppression is
//     // enabled by default with maximum attenuation of -30 dB. Ignored
//     // when Nellymoser codec is selected.
//     mic.noiseSuppressionLevel = 0;
//
//     // The rate is a Nellymoser setting.
//     //
//     // The rate at which the microphone is capturing sound, in
//     // kHz. Acceptable values are 5, 8, 11, 22, and 44. The default
//     // value is 8 kHz if your sound capture device supports this
//     // value. Otherwise, the default value is the next available
//     // capture level above 8 kHz that your sound capture device
//     // supports, usually 11 kHz.
//     //
//     // Note: The actual rate differs slightly from the rate value,
//     // as noted in the following table:
//     //
//     // | rate | frquency  |
//     // |------+-----------|
//     // |   44 | 44,100 Hz |
//     // |   22 | 22,050 Hz |
//     // |   11 | 11,025 Hz |
//     // |    8 | 8,000 Hz  |
//     // |    5 | 5,512 Hz  |
//     //mic.rate = 22;
//
