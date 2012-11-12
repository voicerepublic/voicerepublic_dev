/*
 * CREATE NOTICE
 */

(function($){

	var help_notices = {};

	help_notices.init = function(){

		var $notice = $(".help-text-overlay");

		var register_close = function(){
			$notice.find(".help-text-overlay, .close-icon").on("click", function(){
				$notice.fadeOut();
			});
		};

		register_close();

		var set_cookie = function (c_name,value){
			document.cookie=c_name + "=" + value;
		};

		var getCookie = function (c_name){

			var i,x,y,ARRcookies=document.cookie.split(";");
			for (i=0;i<ARRcookies.length;i++)
			{
			  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
			  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
			  x=x.replace(/^\s+|\s+$/g,"");
			  if (x==c_name)
			    {
			    return unescape(y);
			    }
			  }
			};
		
		};



	// document.ready
	$(function(){
		help_notices.init();
	});
})(jQuery);