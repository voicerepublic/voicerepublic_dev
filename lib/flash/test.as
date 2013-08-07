package {

  //import flash.system.System;
  import flash.system.Security;
  import flash.display.MovieClip;
  import flash.external.ExternalInterface;

  import flash.net.NetConnection;
  
  public class Main extends MovieClip {

    private var connection:NetConnection;

    function Main() {
      //System.security.allowDomain("*");
      //Security.allowDomain("*");
      //Security.allowInsecureDomain("*");
      connection = new NetConnection();
//             connection.connect(null);                                                                  

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


// package {
//     import flash.display.Sprite;
//     import flash.events.NetStatusEvent;
//     import flash.events.SecurityErrorEvent;
//     import flash.media.Video;
//     import flash.net.NetConnection;
//     import flash.net.NetStream;
//     import flash.events.Event;
// 
//     public class NetConnectionExample extends Sprite {
//         private var videoURL:String = "http://www.helpexamples.com/flash/video/cuepoints.flv";
//         private var connection:NetConnection;
//         private var stream:NetStream;
//         private var video:Video = new Video();        
// 
//         public function NetConnectionExample() {
//             connection = new NetConnection();
//             connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
//             connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
//             connection.connect(null);
//         }
// 
//         private function netStatusHandler(event:NetStatusEvent):void {
//             switch (event.info.code) {
//                 case "NetConnection.Connect.Success":
//                     connectStream();
//                     break;
//                 case "NetStream.Play.StreamNotFound":
//                     trace("Stream not found: " + videoURL);
//                     break;
//             }
//         }
// 
//         private function securityErrorHandler(event:SecurityErrorEvent):void {
//             trace("securityErrorHandler: " + event);
//         }
// 
//         private function connectStream():void {
//             addChild(video);
//             var stream:NetStream = new NetStream(connection);
//             stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
//             stream.client = new CustomClient();
//             video.attachNetStream(stream);
//             stream.play(videoURL);
//         }
//     }
// }
// 
// class CustomClient {
//     public function onMetaData(info:Object):void {
//         trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
//     }
//     public function onCuePoint(info:Object):void {
//         trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
//     }
// }
// 
// package {
//     import flash.display.Sprite;
//     import flash.events.*;
//     import flash.media.Sound;
//     import flash.media.SoundChannel;
//     import flash.net.URLRequest;
// 
//     public class SoundExample extends Sprite {
//         private var url:String = "MySound.mp3";
//         private var song:SoundChannel;
// 
//         public function SoundExample() {
//             var request:URLRequest = new URLRequest(url);
//             var soundFactory:Sound = new Sound();
//             soundFactory.addEventListener(Event.COMPLETE, completeHandler);
//             soundFactory.addEventListener(Event.ID3, id3Handler);
//             soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
//             soundFactory.addEventListener(ProgressEvent.PROGRESS, progressHandler);
//             soundFactory.load(request);
//             song = soundFactory.play();
//         }
// 
//         private function completeHandler(event:Event):void {
//             trace("completeHandler: " + event);
//         }
// 
//         private function id3Handler(event:Event):void {
//             trace("id3Handler: " + event);
//         }
// 
//         private function ioErrorHandler(event:Event):void {
//             trace("ioErrorHandler: " + event);
//         }
// 
//         private function progressHandler(event:ProgressEvent):void {
//             trace("progressHandler: " + event);
//         }
//     }
// }
