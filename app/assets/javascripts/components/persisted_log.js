// if `window.console.off` is set, all calls to `console.log` will be
// swallowed. To activate the console run `window.console.off = false`

// use an immediate function to wrap `console.log` in another function
// which is assigned to `console.log` overwriting the original, which
// is captured within the closure of the wrapping function as `_super`

//console.log = function(_super) {
//  return function() {
//    if(window.console.off) return;
//    _super.apply(this, arguments);
//  };
//}(console.log);

// // use the same move to store messages in some storage
// console.log = function(_super, _storage) {
//   var slice = Array.prototype.slice,
//       store = function(str) {
//         var log = JSON.parse(_storage.getItem('log'));
//         if(log == null) log = [];
//         log.push([new Date(), str]);
//         _storage.setItem('log', JSON.stringify(log));
//       };
//   return function() {
//     var args = slice.apply(arguments);
//     store(JSON.stringify(args));
//     _super.apply(this, args);
//   };
// }(console.log, sessionStorage);
