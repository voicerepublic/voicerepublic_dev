// http://stackoverflow.com/questions/9847580
var browser = function() {
  var result = 'other';

  // Opera 8.0+
  if ((!!window.opr && !!opr.addons) ||
      !!window.opera ||
      navigator.userAgent.indexOf(' OPR/') >= 0)
    result = 'opera';

  // Firefox 1.0+
  if (typeof InstallTrigger !== 'undefined')
    result = 'firefox';

  // At least Safari 3+: "[object HTMLElementConstructor]"
  if (Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0)
    result = 'safari';

  // Internet Explorer 6-11
  if (/*@cc_on!@*/false || !!document.documentMode)
    result = 'ie';

  // Edge 20+
  if ((result != 'ie') && !!window.StyleMedia)
    result = 'edge';

  // Chrome 1+
  if (!!window.chrome && !!window.chrome.webstore)
    result = 'chrome';

  // Blink engine detection
  //if ((result == 'chrome' || result == 'opera') && !!window.CSS)
  //  result = 'blink';

  return result;
};
