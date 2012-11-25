xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.config{
      xml.localeversion("0.8", :suppressWarning => "true") 
      xml.version("0004-2012-18-05")
      xml.help(:url => "http://www.kluuu.com/")
      xml.porttest(:host => @video_server_address, :application => "video")
      xml.application(:uri => "rtmp://#{@video_server_address}/bigbluebutton", :host => "http://#{@video_server_address}/bigbluebutton/api/enter")
      xml.language(:userSelectionEnabled => "false")
      xml.skinning(:enabled => "true", :url => "/kluuu/bbb/branding/css/kluuu.css.swf?v=4")
      xml.layout(:showDebugWindow => "true", :showLogButton => "true", :showVideoLayout => "false", :showResetLayout => "false", :showToolbar => "true", :showHelpButton => "true", :showLogoutWindow => "true")
      
      xml.modules{
      
      	xml.module(:name => "ChatModule", :url => "/kluuu/bbb/ChatModule.swf?v=4", 
			:uri => "rtmp://#{@video_server_address}/bigbluebutton", 
			:dependsOn => "ViewersModule",	
			:translationOn => "true",
			:translationEnabled => "true",	
			:privateEnabled => "false",
			:start => "true")
		
		xml.module(:name => "PresentModule", :url => "/kluuu/bbb/PresentModule.swf?v=4", 
			:uri => "rtmp://#{@video_server_address}/bigbluebutton", 
			:host => "http://#{@video_server_address}", 
			:showPresentWindow => "true",
			:dependsOn => "ViewersModule",
			:start => "true")
		      
      	xml.module(:name => "ViewersModule", :url => "/kluuu/bbb/ViewersModule.swf?v=4", 
			:uri => "rtmp://#{@video_server_address}/bigbluebutton", 
			:host => "http://#{@video_server_address}/bigbluebutton/api/enter",
			:allowKickUser => "true",
			:windowVisible => "false",
			:start => "true")		

		xml.module(:name => "VideoconfModule11", :url => "/kluuu/bbb/VideoconfModule11.swf?v=4", 
			:uri => "rtmp://#{@video_server_address}/video",
			:dependsOn => "ViewersModule",
			:videoQuality => "70",
			:presenterShareOnly => "false",
			:resolutions => "320x240,640x480",
			:autoStart => "true",
			:showButton => "true",
			:publishWindowVisible => "true",
			:viewerWindowMaxed => "false",
			:viewerWindowLocation => "top",
			:camKeyFrameInterval => "5",
			:camModeFps => "15",
			:camQualityBandwidth => "45000",
			:camQualityPicture => "80",
			:h264Level => "1.2",
			:h264Profile => "main",
			:start => "true",
			:silenceLevel => "0",
			:autoGain => "false",
			:showButton => "true",
			:samplingRate => "8",
			:echoCancelation => "true",
			:setLoopBack => "false",
			:echoPath => "128",
			:encodeQuality => "5",
			:framesPerPacket => "3")
		
		xml.module(:name => "VideoconfModule103", :url => "/kluuu/bbb/VideoconfModule103.swf?v=4", 
			:uri => "rtmp://#{@video_server_address}/video",
			:dependsOn => "ViewersModule",
			:videoQuality => "80",
			:presenterShareOnly => "false",
			:resolutions => "320x240,640x480",
			:autoStart => "true",
			:showButton => "false",
			:publishWindowVisible => "true",
			:viewerWindowMaxed => "false",
			:viewerWindowLocation => "top",
			:camKeyFrameInterval => "5",
			:camModeFps => "15",
			:camQualityBandwidth => "25000",
			:camQualityPicture => "80",
			:start => "true",
			:silenceLevel => "0",
			:autoGain => "false",
			:showButton => "true",
			:samplingRate => "8",
			:echoCancelation => "true",
			:setLoopBack => "false",
			:echoPath => "128",
			:encodeQuality => "5",
			:framesPerPacket => "3")
		      
      	xml.module(:name => "PaymentModule", :url => "/kluuu/bbb/PaymentModule.swf?v=4", 
			:credit => @credit,
			:ttp => @time_to_pay)
					
	}
	
		
}