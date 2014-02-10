/*****************************************************************************
	DATE HELPERS

	A set of prototype modifiers for the Date class that will help out with
	everyday date tasks.

	REQUIRES: 	string-helpers.js (v0.1b)

	Author: 	Jocko MacGregor
	Version: 	0.1b
	Date: 		January 20, 2014
 *****************************************************************************/



/*
Returns the numeric representation of the day of the year.

Source: http://javascript.about.com/library/bldayyear.htm
*/
Date.prototype.getDayOfTheYear = function() {
	var onejan = new Date(this.getFullYear(),0,1);
	return Math.ceil((this - onejan) / 86400000);
}

/*
Add date formating to the Date class using a modified subset of the 'strftime' fomatting patterns
from Ruby.

Author: Jocko MacGregor

Date (Year, Month, Day):
  %Y - Year with century
  %C - year / 100 (round down.  20 in 2009)
  %y - year % 100 (00..99)

  %m - Month of the year, zero-padded (01..12)
          %_m  blank-padded ( 1..12)
          %-m  no-padded (1..12)
  %B - The full month name (``January'')
          %^B  uppercased (``JANUARY'')
  %b - The abbreviated month name (``Jan'')
          %^b  uppercased (``JAN'')

  %d - Day of the month, zero-padded (01..31)
          %-d  no-padded (1..31)
  %e - Day of the month, blank-padded ( 1..31)

  %j - Day of the year (001..366)
		  %_j  blank-padded (  1..366)
          %-j  no-padded (1..366)

Time (Hour, Minute, Second, Subsecond):
  %H - Hour of the day, 24-hour clock, zero-padded (00..23)
		 %_H - blank-padded ( 0..23)
  		 %-H - no-padded (0..23)
  %k - Hour of the day, 24-hour clock, blank-padded ( 0..23)
  %I - Hour of the day, 12-hour clock, zero-padded (01..12)
		 %_I - blank-padded ( 0..12)
		 %-I - no-padded (0..12)
  %l - Hour of the day, 12-hour clock, blank-padded ( 1..12)
  %P - Meridian indicator, lowercase (``am'' or ``pm'')
  %p - Meridian indicator, uppercase (``AM'' or ``PM'')

  %M - Minute of the hour (00..59)

  %S - Second of the minute (00..59)

Weekday:
  %A - The full weekday name (``Sunday'')
          %^A  uppercased (``SUNDAY'')
  %a - The abbreviated name (``Sun'')
          %^a  uppercased (``SUN'')
  %u - Day of the week (Monday is 1, 1..7)
  %w - Day of the week (Sunday is 0, 0..6)


*/

Date.prototype.format = function(fmt) {
	fmt = fmt || '%Y-%m-%d %H:%M:%S';
	
	var fmt_matches = fmt.match(/\%[-_^]{0,1}[YCymBbdejHkIlPpMSLNAauw]{1,1}/g);
	
	if (fmt_matches.length == 0) {
		return fmt;
	}
	
	var f_months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
	var a_months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
	var am_pm = ['am','pm'];
	var f_days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
	var a_days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
	
	fmt_matches = fmt_matches.sort();
	previous_match = "";
	
	for (i=0;i<fmt_matches.length;i++) {
		var match = fmt_matches[i];
		if (previous_match != match) {
			var val = "";
			var re = null;
			
			switch(match) {
				case '%Y':  re = /%Y/g; val = this.getFullYear(); break;
				case '%C':  re = /%C/g; val = Match.floor(this.getFullYear()/100); break;
				case '%y':  re = /%y/g; val = ('' + this.getFullYear % 100).lpad(2); break;
				case '%m':  re = /%m/g; val = ('' + (this.getMonth()+1)).lpad(2); break;
				case '%_m': re = /%\_m/g; val = ('' + (this.getMonth()+1)).lpad(2, ' '); break;
				case '%-m': re = /%\-m/g; val = ('' + (this.getMonth()+1)); break;
				case '%B':  re = /%B/g; val = f_months[this.getMonth()]; break;
				case '%^B': re = /%\^B/g; val = f_months[this.getMonth()].toUpperCase(); break;
				case '%b':  re = /%b/g; val = a_months[this.getMonth()]; break;
				case '%^b': re = /%\^b/g; val = a_months[this.getMonth()].toUpperCase(); break;
				case '%d':  re = /%d/g; val = ('' + this.getDate()).lpad(2); break;
				case '%-d': re = /%\-d/g; val = ('' + this.getDate()); break;
				case '%e':  re = /%e/g; val = ('' + this.getDate()).lpad(2, ' '); break;
				case '%j':  re = /%j/g; val = ('' + this.getDayOfTheYear()).lpad(3); break;
				case '%-j': re = /%\-j/g; val = ('' + this.getDayOfTheYear()); break;
				case '%_j': re = /%\_j/g; val = ('' + this.getDayOfTheYear()).lpad(3, ' '); break;
				case '%H':  re = /%H/g; val = ('' + this.getHours()).lpad(2); break;
				case '%-H': re = /%\-H/g; val = ('' + this.getHours()); break;
				case '%_H': re = /%\_H/g; val = ('' + this.getHours()).lpad(2, ' '); break;
				case '%k':  re = /%k/g; val = ('' + this.getHours()).lpad(2, ' '); break;
				case '%I':  re = /%I/g; val = ('' + (this.getHours() % 12 == 0 ? 12 : this.getHours() % 12)).lpad(2); break;
				case '%-I': re = /%\-I/g; val = ('' + (this.getHours() % 12 == 0 ? 12 : this.getHours() % 12)); break;
				case '%_I': re = /%\_I/g; val = ('' + (this.getHours() % 12 == 0 ? 12 : this.getHours() % 12)).lpad(2, ' '); break;
				case '%l':  re = /%l/g; val = ('' + (this.getHours() % 12 == 0 ? 12 : this.getHours() % 12)).lpad(2, ' '); break;
				case '%P':  re = /%P/g; val = am_pm[Math.floor(this.getHours()/12)]; break;
				case '%p':  re = /%p/g; val = am_pm[Math.floor(this.getHours()/12)].toUpperCase(); break;
				case '%M':  re = /%M/g; val = ('' + this.getMinutes()).lpad(2); break;
				case '%S':  re = /%S/g; val = ('' + this.getSeconds()).lpad(2); break;
				case '%A':  re = /%A/g; val = f_days[this.getDay()]; break;
				case '%^A': re = /%\^A/g; val = f_days[this.getDay()].toUpperCase; break;
				case '%a':  re = /%a/g; val = a_days[this.getDay()]; break;
				case '%^a': re = /%\^a/g; val = a_days[this.getDay()].toUpperCase; break;
				case '%w':  re = /%w/g; val = ('' + this.getDay()); break;
				case '%u':  re = /%u/g; val = '' + (this.getDay() == 0 ? 7 : this.getDay()); break;
			};

			fmt = fmt.replace(re, val);
			
			previous_match = match;
		}
	}
	
	return fmt;
};
