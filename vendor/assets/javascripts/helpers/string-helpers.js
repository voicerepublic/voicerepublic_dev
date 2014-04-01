/*****************************************************************************
	STRING HELPERS

	A set of prototype modifiers for the String class that will help out with
	everyday string tasks.

	Author: 	Jocko MacGregor
	Version: 	0.1b
	Date: 		January 20, 2014
 *****************************************************************************/


/*
Left pads a string to a specific size with a specific character.

count = The number of characters in the resulting string.
pad = (optional: default=0) The character to pad the string with.
*/
String.prototype.lpad = function(count, pad) {
	pad = pad || '0';
	str = this + '';
	return str.length >= count ? str : new Array(count - str.length + 1).join(pad) + str;		
};


/*
Left pads a string to a specific size with a specific character.

count = The number of characters in the resulting string.
pad = (optional: default=0) The character to pad the string with.
*/
String.prototype.rpad = function(count, pad) {
	pad = pad || '0';
	str = this + '';
	return str.length >= count ? str : str + new Array(count - str.length + 1).join(pad);		
};