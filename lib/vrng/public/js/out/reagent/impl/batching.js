// Compiled by ClojureScript 1.7.228 {:static-fns true, :optimize-constants true}
goog.provide('reagent.impl.batching');
goog.require('cljs.core');
goog.require('reagent.debug');
goog.require('reagent.interop');
goog.require('reagent.ratom');
goog.require('reagent.impl.util');
goog.require('clojure.string');
if(typeof reagent.impl.batching.mount_count !== 'undefined'){
} else {
reagent.impl.batching.mount_count = (0);
}
reagent.impl.batching.next_mount_count = (function reagent$impl$batching$next_mount_count(){
return reagent.impl.batching.mount_count = (reagent.impl.batching.mount_count + (1));
});
reagent.impl.batching.fake_raf = (function reagent$impl$batching$fake_raf(f){
return setTimeout(f,(16));
});
reagent.impl.batching.next_tick = ((cljs.core.not(reagent.impl.util.is_client))?reagent.impl.batching.fake_raf:(function (){var w = window;
var or__6153__auto__ = (w["requestAnimationFrame"]);
if(cljs.core.truth_(or__6153__auto__)){
return or__6153__auto__;
} else {
var or__6153__auto____$1 = (w["webkitRequestAnimationFrame"]);
if(cljs.core.truth_(or__6153__auto____$1)){
return or__6153__auto____$1;
} else {
var or__6153__auto____$2 = (w["mozRequestAnimationFrame"]);
if(cljs.core.truth_(or__6153__auto____$2)){
return or__6153__auto____$2;
} else {
var or__6153__auto____$3 = (w["msRequestAnimationFrame"]);
if(cljs.core.truth_(or__6153__auto____$3)){
return or__6153__auto____$3;
} else {
return reagent.impl.batching.fake_raf;
}
}
}
}
})());
reagent.impl.batching.compare_mount_order = (function reagent$impl$batching$compare_mount_order(c1,c2){
return ((c1["cljsMountOrder"]) - (c2["cljsMountOrder"]));
});
reagent.impl.batching.run_queue = (function reagent$impl$batching$run_queue(a){
a.sort(reagent.impl.batching.compare_mount_order);

var n__7056__auto__ = a.length;
var i = (0);
while(true){
if((i < n__7056__auto__)){
var c_9160 = (a[i]);
if(cljs.core.truth_((c_9160["cljsIsDirty"]))){
(c_9160["forceUpdate"])();
} else {
}

var G__9161 = (i + (1));
i = G__9161;
continue;
} else {
return null;
}
break;
}
});
reagent.impl.batching.run_funs = (function reagent$impl$batching$run_funs(a){
var n__7056__auto__ = a.length;
var i = (0);
while(true){
if((i < n__7056__auto__)){
(a[i]).call(null);

var G__9162 = (i + (1));
i = G__9162;
continue;
} else {
return null;
}
break;
}
});

/**
* @constructor
 * @implements {reagent.impl.batching.Object}
*/
reagent.impl.batching.RenderQueue = (function (queue,scheduled_QMARK_,after_render){
this.queue = queue;
this.scheduled_QMARK_ = scheduled_QMARK_;
this.after_render = after_render;
})
reagent.impl.batching.RenderQueue.prototype.queue_render = (function (c){
var self__ = this;
var this$ = this;
self__.queue.push(c);

return this$.schedule();
});

reagent.impl.batching.RenderQueue.prototype.add_after_render = (function (f){
var self__ = this;
var _ = this;
return self__.after_render.push(f);
});

reagent.impl.batching.RenderQueue.prototype.schedule = (function (){
var self__ = this;
var this$ = this;
if(cljs.core.truth_(self__.scheduled_QMARK_)){
return null;
} else {
self__.scheduled_QMARK_ = true;

var G__9163 = ((function (this$){
return (function (){
return this$.run_queue();
});})(this$))
;
return (reagent.impl.batching.next_tick.cljs$core$IFn$_invoke$arity$1 ? reagent.impl.batching.next_tick.cljs$core$IFn$_invoke$arity$1(G__9163) : reagent.impl.batching.next_tick.call(null,G__9163));
}
});

reagent.impl.batching.RenderQueue.prototype.run_queue = (function (){
var self__ = this;
var _ = this;
var q = self__.queue;
var aq = self__.after_render;
self__.queue = [];

self__.after_render = [];

self__.scheduled_QMARK_ = false;

reagent.impl.batching.run_queue(q);

return reagent.impl.batching.run_funs(aq);
});

reagent.impl.batching.RenderQueue.getBasis = (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(cljs.core.cst$sym$queue,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$mutable,true], null)),cljs.core.with_meta(cljs.core.cst$sym$scheduled_QMARK_,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$mutable,true], null)),cljs.core.with_meta(cljs.core.cst$sym$after_DASH_render,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$mutable,true], null))], null);
});

reagent.impl.batching.RenderQueue.cljs$lang$type = true;

reagent.impl.batching.RenderQueue.cljs$lang$ctorStr = "reagent.impl.batching/RenderQueue";

reagent.impl.batching.RenderQueue.cljs$lang$ctorPrWriter = (function (this__6751__auto__,writer__6752__auto__,opt__6753__auto__){
return cljs.core._write(writer__6752__auto__,"reagent.impl.batching/RenderQueue");
});

reagent.impl.batching.__GT_RenderQueue = (function reagent$impl$batching$__GT_RenderQueue(queue,scheduled_QMARK_,after_render){
return (new reagent.impl.batching.RenderQueue(queue,scheduled_QMARK_,after_render));
});

reagent.impl.batching.render_queue = (new reagent.impl.batching.RenderQueue([],false,[]));
reagent.impl.batching.flush = (function reagent$impl$batching$flush(){
return reagent.impl.batching.render_queue.run_queue();
});
reagent.impl.batching.queue_render = (function reagent$impl$batching$queue_render(c){
(c["cljsIsDirty"] = true);

return reagent.impl.batching.render_queue.queue_render(c);
});
reagent.impl.batching.mark_rendered = (function reagent$impl$batching$mark_rendered(c){
return (c["cljsIsDirty"] = false);
});
reagent.impl.batching.do_after_flush = (function reagent$impl$batching$do_after_flush(f){
return reagent.impl.batching.render_queue.add_after_render(f);
});
reagent.impl.batching.do_later = (function reagent$impl$batching$do_later(f){
reagent.impl.batching.do_after_flush(f);

return reagent.impl.batching.render_queue.schedule();
});
reagent.impl.batching.is_reagent_component = (function reagent$impl$batching$is_reagent_component(c){
var G__9165 = c;
var G__9165__$1 = (((G__9165 == null))?null:(G__9165["props"]));
if((G__9165__$1 == null)){
return null;
} else {
return (G__9165__$1["argv"]);
}
});
reagent.impl.batching.run_reactively = (function reagent$impl$batching$run_reactively(c,run){
if(cljs.core.truth_(reagent.impl.batching.is_reagent_component(c))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$is_DASH_reagent_DASH_component,cljs.core.cst$sym$c)], 0)))].join('')));
}

reagent.impl.batching.mark_rendered(c);

var rat = (c["cljsRatom"]);
if((rat == null)){
var res = reagent.ratom.capture_derefed(run,c);
var derefed = reagent.ratom.captured(c);
if(!((derefed == null))){
(c["cljsRatom"] = reagent.ratom.make_reaction.cljs$core$IFn$_invoke$arity$variadic(run,cljs.core.array_seq([cljs.core.cst$kw$auto_DASH_run,((function (res,derefed,rat){
return (function (){
return reagent.impl.batching.queue_render(c);
});})(res,derefed,rat))
,cljs.core.cst$kw$derefed,derefed], 0)));
} else {
}

return res;
} else {
return reagent.ratom.run(rat);
}
});
reagent.impl.batching.dispose = (function reagent$impl$batching$dispose(c){
var G__9167_9168 = (c["cljsRatom"]);
if((G__9167_9168 == null)){
} else {
reagent.ratom.dispose_BANG_(G__9167_9168);
}

return reagent.impl.batching.mark_rendered(c);
});
