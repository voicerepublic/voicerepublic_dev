// Compiled by ClojureScript 1.7.228 {}
goog.provide('vrng.core');
goog.require('cljs.core');
goog.require('vrng.talk');
goog.require('vrng.venue');
vrng.core.mount_roots = (function vrng$core$mount_roots(){
vrng.talk.mount_root.call(null);

return vrng.venue.mount_root.call(null);
});
vrng.core.init_BANG_ = (function vrng$core$init_BANG_(){
return vrng.core.mount_roots.call(null);
});

//# sourceMappingURL=core.js.map