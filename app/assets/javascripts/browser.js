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

  // iOS 11+ userAgent:
  // "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A356 Safari/604.1"
  if (navigator.userAgent.match(/Mozilla.*OS 1\d.*Safari/) != null)
    result = 'ios11+';

  // Blink engine detection
  //if ((result == 'chrome' || result == 'opera') && !!window.CSS)
  //  result = 'blink';

  return result;
};
