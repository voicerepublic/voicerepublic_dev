/*
 * CREATE NOTICE
 */

(function($){

	var help_notices = {};
	var help_cookie = [];

	help_notices.init = function(){


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

		var $notice = $(".help-text-overlay"); /* alle help-notices auf view */

		if(getCookie("kluuu-help-notices") === undefined){ /* wenn noch kein cookie vorhanden */
			
		} else {
			help_cookie = getCookie("kluuu-help-notices").split("|");
		}

		var register_close = function(){
			$notice.find(".close-icon").on("click", function(){
				$(this).parent().fadeOut();

				var $notice_name = $(this).parent().attr("data-help-notice");
				help_cookie[$notice_name] = 1; /* 1 = off */

				set_cookie("kluuu-help-notices", help_cookie.join("|")); /* hier braucht es noch key */
			});
		};

		register_close();
		
	};



	// document.ready
	$(function(){
		help_notices.init();
	});
})(jQuery);