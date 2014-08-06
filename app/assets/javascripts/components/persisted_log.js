// use an immediate function to wrap `console.log` in another function
// which is assigned to `console.log` overwriting the original, which
// is captured within the closure of the wrapping function as `_super`
console.log = function(_super, _storage, _bubble) {
  var slice = Array.prototype.slice,
      store = function(str) {
        var log = JSON.parse(_storage.getItem('log'));
        if(log == null) log = [];
        log.push([new Date(), str]);
        _storage.setItem('log', JSON.stringify(log));
      };
  return function() {
    var args = slice.apply(arguments);
    store(JSON.stringify(args));
    if(_bubble) _super.apply(this, args);
  };
}(console.log, sessionStorage, true);

// TODO while this is as generic as it gets, for vr we need it to
// bubble only if in development or the logged in user is an
// insider, otherwise it should not bubble. And we only really need
// this on the live page, so we might need to move the code to a less
// generic location, i.e. the initialization process of the angular
// app. Leaving it here for now for review. It shouldn't hurt.
