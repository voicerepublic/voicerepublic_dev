import mx.collections.ArrayCollection;
import mx.events.DropdownEvent;
import flash.media.Microphone;
import flash.media.MicrophoneEnhancedOptions;
import mx.events.SliderEvent;
import flash.events.MouseEvent;
import flash.events.SampleDataEvent;
import flash.events.ActivityEvent;

[Bindable]
public var devices:ArrayCollection = new ArrayCollection([]);
[Bindable]
public var mic:Microphone = Microphone.getEnhancedMicrophone();
[Bindable]
public var opts:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
[Bindable]
public var gain:int = mic.gain;
[Bindable]
public var activity:int = 0;
[Bindable]
public var autoGain:Boolean = opts.autoGain;

public function initApp():void {
  refreshDeviceList();
  mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);
  opts.autoGain = true;
  mic.enhancedOptions = opts;
  mic.setLoopBack(true);
}

private function refreshDeviceList():void {
  devices = new ArrayCollection(Microphone.names);
}

private function changeDeviceHandler(e:DropdownEvent):void {
  mic = Microphone.getEnhancedMicrophone(e.target.selectedIndex);
}

private function gainHandler(e:SliderEvent):void {
  gain = e.value;
  mic.gain = gain;
}

private function autoGainHandler(e:MouseEvent):void {
  opts.autoGain = e.target.selected;
  mic.enhancedOptions = opts;
}

private function loopBackHandler(e:MouseEvent):void {
  mic.setLoopBack(e.target.selected);
}

private function onMicData(e:SampleDataEvent):void {
  activity = e.target.activityLevel;
  bar.setProgress(e.target.activityLevel, 100);
  gain = mic.gain;
}
