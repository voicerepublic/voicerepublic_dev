// Compiled by ClojureScript 1.7.228 {}
goog.provide('cljs.core.async');
goog.require('cljs.core');
goog.require('cljs.core.async.impl.channels');
goog.require('cljs.core.async.impl.dispatch');
goog.require('cljs.core.async.impl.ioc_helpers');
goog.require('cljs.core.async.impl.protocols');
goog.require('cljs.core.async.impl.buffers');
goog.require('cljs.core.async.impl.timers');
cljs.core.async.fn_handler = (function cljs$core$async$fn_handler(var_args){
var args21083 = [];
var len__19428__auto___21089 = arguments.length;
var i__19429__auto___21090 = (0);
while(true){
if((i__19429__auto___21090 < len__19428__auto___21089)){
args21083.push((arguments[i__19429__auto___21090]));

var G__21091 = (i__19429__auto___21090 + (1));
i__19429__auto___21090 = G__21091;
continue;
} else {
}
break;
}

var G__21085 = args21083.length;
switch (G__21085) {
case 1:
return cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21083.length)].join('')));

}
});

cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$1 = (function (f){
return cljs.core.async.fn_handler.call(null,f,true);
});

cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$2 = (function (f,blockable){
if(typeof cljs.core.async.t_cljs$core$async21086 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21086 = (function (f,blockable,meta21087){
this.f = f;
this.blockable = blockable;
this.meta21087 = meta21087;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21086.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_21088,meta21087__$1){
var self__ = this;
var _21088__$1 = this;
return (new cljs.core.async.t_cljs$core$async21086(self__.f,self__.blockable,meta21087__$1));
});

cljs.core.async.t_cljs$core$async21086.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_21088){
var self__ = this;
var _21088__$1 = this;
return self__.meta21087;
});

cljs.core.async.t_cljs$core$async21086.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21086.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return true;
});

cljs.core.async.t_cljs$core$async21086.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return self__.blockable;
});

cljs.core.async.t_cljs$core$async21086.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return self__.f;
});

cljs.core.async.t_cljs$core$async21086.getBasis = (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"blockable","blockable",-28395259,null),new cljs.core.Symbol(null,"meta21087","meta21087",-2092503263,null)], null);
});

cljs.core.async.t_cljs$core$async21086.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21086.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21086";

cljs.core.async.t_cljs$core$async21086.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21086");
});

cljs.core.async.__GT_t_cljs$core$async21086 = (function cljs$core$async$__GT_t_cljs$core$async21086(f__$1,blockable__$1,meta21087){
return (new cljs.core.async.t_cljs$core$async21086(f__$1,blockable__$1,meta21087));
});

}

return (new cljs.core.async.t_cljs$core$async21086(f,blockable,cljs.core.PersistentArrayMap.EMPTY));
});

cljs.core.async.fn_handler.cljs$lang$maxFixedArity = 2;
/**
 * Returns a fixed buffer of size n. When full, puts will block/park.
 */
cljs.core.async.buffer = (function cljs$core$async$buffer(n){
return cljs.core.async.impl.buffers.fixed_buffer.call(null,n);
});
/**
 * Returns a buffer of size n. When full, puts will complete but
 *   val will be dropped (no transfer).
 */
cljs.core.async.dropping_buffer = (function cljs$core$async$dropping_buffer(n){
return cljs.core.async.impl.buffers.dropping_buffer.call(null,n);
});
/**
 * Returns a buffer of size n. When full, puts will complete, and be
 *   buffered, but oldest elements in buffer will be dropped (not
 *   transferred).
 */
cljs.core.async.sliding_buffer = (function cljs$core$async$sliding_buffer(n){
return cljs.core.async.impl.buffers.sliding_buffer.call(null,n);
});
/**
 * Returns true if a channel created with buff will never block. That is to say,
 * puts into this buffer will never cause the buffer to be full. 
 */
cljs.core.async.unblocking_buffer_QMARK_ = (function cljs$core$async$unblocking_buffer_QMARK_(buff){
if(!((buff == null))){
if((false) || (buff.cljs$core$async$impl$protocols$UnblockingBuffer$)){
return true;
} else {
if((!buff.cljs$lang$protocol_mask$partition$)){
return cljs.core.native_satisfies_QMARK_.call(null,cljs.core.async.impl.protocols.UnblockingBuffer,buff);
} else {
return false;
}
}
} else {
return cljs.core.native_satisfies_QMARK_.call(null,cljs.core.async.impl.protocols.UnblockingBuffer,buff);
}
});
/**
 * Creates a channel with an optional buffer, an optional transducer (like (map f),
 *   (filter p) etc or a composition thereof), and an optional exception handler.
 *   If buf-or-n is a number, will create and use a fixed buffer of that size. If a
 *   transducer is supplied a buffer must be specified. ex-handler must be a
 *   fn of one argument - if an exception occurs during transformation it will be called
 *   with the thrown value as an argument, and any non-nil return value will be placed
 *   in the channel.
 */
cljs.core.async.chan = (function cljs$core$async$chan(var_args){
var args21095 = [];
var len__19428__auto___21098 = arguments.length;
var i__19429__auto___21099 = (0);
while(true){
if((i__19429__auto___21099 < len__19428__auto___21098)){
args21095.push((arguments[i__19429__auto___21099]));

var G__21100 = (i__19429__auto___21099 + (1));
i__19429__auto___21099 = G__21100;
continue;
} else {
}
break;
}

var G__21097 = args21095.length;
switch (G__21097) {
case 0:
return cljs.core.async.chan.cljs$core$IFn$_invoke$arity$0();

break;
case 1:
return cljs.core.async.chan.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.chan.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.chan.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21095.length)].join('')));

}
});

cljs.core.async.chan.cljs$core$IFn$_invoke$arity$0 = (function (){
return cljs.core.async.chan.call(null,null);
});

cljs.core.async.chan.cljs$core$IFn$_invoke$arity$1 = (function (buf_or_n){
return cljs.core.async.chan.call(null,buf_or_n,null,null);
});

cljs.core.async.chan.cljs$core$IFn$_invoke$arity$2 = (function (buf_or_n,xform){
return cljs.core.async.chan.call(null,buf_or_n,xform,null);
});

cljs.core.async.chan.cljs$core$IFn$_invoke$arity$3 = (function (buf_or_n,xform,ex_handler){
var buf_or_n__$1 = ((cljs.core._EQ_.call(null,buf_or_n,(0)))?null:buf_or_n);
if(cljs.core.truth_(xform)){
if(cljs.core.truth_(buf_or_n__$1)){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str("buffer must be supplied when transducer is"),cljs.core.str("\n"),cljs.core.str(cljs.core.pr_str.call(null,new cljs.core.Symbol(null,"buf-or-n","buf-or-n",-1646815050,null)))].join('')));
}
} else {
}

return cljs.core.async.impl.channels.chan.call(null,((typeof buf_or_n__$1 === 'number')?cljs.core.async.buffer.call(null,buf_or_n__$1):buf_or_n__$1),xform,ex_handler);
});

cljs.core.async.chan.cljs$lang$maxFixedArity = 3;
/**
 * Creates a promise channel with an optional transducer, and an optional
 *   exception-handler. A promise channel can take exactly one value that consumers
 *   will receive. Once full, puts complete but val is dropped (no transfer).
 *   Consumers will block until either a value is placed in the channel or the
 *   channel is closed. See chan for the semantics of xform and ex-handler.
 */
cljs.core.async.promise_chan = (function cljs$core$async$promise_chan(var_args){
var args21102 = [];
var len__19428__auto___21105 = arguments.length;
var i__19429__auto___21106 = (0);
while(true){
if((i__19429__auto___21106 < len__19428__auto___21105)){
args21102.push((arguments[i__19429__auto___21106]));

var G__21107 = (i__19429__auto___21106 + (1));
i__19429__auto___21106 = G__21107;
continue;
} else {
}
break;
}

var G__21104 = args21102.length;
switch (G__21104) {
case 0:
return cljs.core.async.promise_chan.cljs$core$IFn$_invoke$arity$0();

break;
case 1:
return cljs.core.async.promise_chan.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.promise_chan.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21102.length)].join('')));

}
});

cljs.core.async.promise_chan.cljs$core$IFn$_invoke$arity$0 = (function (){
return cljs.core.async.promise_chan.call(null,null);
});

cljs.core.async.promise_chan.cljs$core$IFn$_invoke$arity$1 = (function (xform){
return cljs.core.async.promise_chan.call(null,xform,null);
});

cljs.core.async.promise_chan.cljs$core$IFn$_invoke$arity$2 = (function (xform,ex_handler){
return cljs.core.async.chan.call(null,cljs.core.async.impl.buffers.promise_buffer.call(null),xform,ex_handler);
});

cljs.core.async.promise_chan.cljs$lang$maxFixedArity = 2;
/**
 * Returns a channel that will close after msecs
 */
cljs.core.async.timeout = (function cljs$core$async$timeout(msecs){
return cljs.core.async.impl.timers.timeout.call(null,msecs);
});
/**
 * takes a val from port. Must be called inside a (go ...) block. Will
 *   return nil if closed. Will park if nothing is available.
 *   Returns true unless port is already closed
 */
cljs.core.async._LT__BANG_ = (function cljs$core$async$_LT__BANG_(port){
throw (new Error("<! used not in (go ...) block"));
});
/**
 * Asynchronously takes a val from port, passing to fn1. Will pass nil
 * if closed. If on-caller? (default true) is true, and value is
 * immediately available, will call fn1 on calling thread.
 * Returns nil.
 */
cljs.core.async.take_BANG_ = (function cljs$core$async$take_BANG_(var_args){
var args21109 = [];
var len__19428__auto___21112 = arguments.length;
var i__19429__auto___21113 = (0);
while(true){
if((i__19429__auto___21113 < len__19428__auto___21112)){
args21109.push((arguments[i__19429__auto___21113]));

var G__21114 = (i__19429__auto___21113 + (1));
i__19429__auto___21113 = G__21114;
continue;
} else {
}
break;
}

var G__21111 = args21109.length;
switch (G__21111) {
case 2:
return cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21109.length)].join('')));

}
});

cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$2 = (function (port,fn1){
return cljs.core.async.take_BANG_.call(null,port,fn1,true);
});

cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$3 = (function (port,fn1,on_caller_QMARK_){
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.fn_handler.call(null,fn1));
if(cljs.core.truth_(ret)){
var val_21116 = cljs.core.deref.call(null,ret);
if(cljs.core.truth_(on_caller_QMARK_)){
fn1.call(null,val_21116);
} else {
cljs.core.async.impl.dispatch.run.call(null,((function (val_21116,ret){
return (function (){
return fn1.call(null,val_21116);
});})(val_21116,ret))
);
}
} else {
}

return null;
});

cljs.core.async.take_BANG_.cljs$lang$maxFixedArity = 3;
cljs.core.async.nop = (function cljs$core$async$nop(_){
return null;
});
cljs.core.async.fhnop = cljs.core.async.fn_handler.call(null,cljs.core.async.nop);
/**
 * puts a val into port. nil values are not allowed. Must be called
 *   inside a (go ...) block. Will park if no buffer space is available.
 *   Returns true unless port is already closed.
 */
cljs.core.async._GT__BANG_ = (function cljs$core$async$_GT__BANG_(port,val){
throw (new Error(">! used not in (go ...) block"));
});
/**
 * Asynchronously puts a val into port, calling fn0 (if supplied) when
 * complete. nil values are not allowed. Will throw if closed. If
 * on-caller? (default true) is true, and the put is immediately
 * accepted, will call fn0 on calling thread.  Returns nil.
 */
cljs.core.async.put_BANG_ = (function cljs$core$async$put_BANG_(var_args){
var args21117 = [];
var len__19428__auto___21120 = arguments.length;
var i__19429__auto___21121 = (0);
while(true){
if((i__19429__auto___21121 < len__19428__auto___21120)){
args21117.push((arguments[i__19429__auto___21121]));

var G__21122 = (i__19429__auto___21121 + (1));
i__19429__auto___21121 = G__21122;
continue;
} else {
}
break;
}

var G__21119 = args21117.length;
switch (G__21119) {
case 2:
return cljs.core.async.put_BANG_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.put_BANG_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
case 4:
return cljs.core.async.put_BANG_.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21117.length)].join('')));

}
});

cljs.core.async.put_BANG_.cljs$core$IFn$_invoke$arity$2 = (function (port,val){
var temp__4655__auto__ = cljs.core.async.impl.protocols.put_BANG_.call(null,port,val,cljs.core.async.fhnop);
if(cljs.core.truth_(temp__4655__auto__)){
var ret = temp__4655__auto__;
return cljs.core.deref.call(null,ret);
} else {
return true;
}
});

cljs.core.async.put_BANG_.cljs$core$IFn$_invoke$arity$3 = (function (port,val,fn1){
return cljs.core.async.put_BANG_.call(null,port,val,fn1,true);
});

cljs.core.async.put_BANG_.cljs$core$IFn$_invoke$arity$4 = (function (port,val,fn1,on_caller_QMARK_){
var temp__4655__auto__ = cljs.core.async.impl.protocols.put_BANG_.call(null,port,val,cljs.core.async.fn_handler.call(null,fn1));
if(cljs.core.truth_(temp__4655__auto__)){
var retb = temp__4655__auto__;
var ret = cljs.core.deref.call(null,retb);
if(cljs.core.truth_(on_caller_QMARK_)){
fn1.call(null,ret);
} else {
cljs.core.async.impl.dispatch.run.call(null,((function (ret,retb,temp__4655__auto__){
return (function (){
return fn1.call(null,ret);
});})(ret,retb,temp__4655__auto__))
);
}

return ret;
} else {
return true;
}
});

cljs.core.async.put_BANG_.cljs$lang$maxFixedArity = 4;
cljs.core.async.close_BANG_ = (function cljs$core$async$close_BANG_(port){
return cljs.core.async.impl.protocols.close_BANG_.call(null,port);
});
cljs.core.async.random_array = (function cljs$core$async$random_array(n){
var a = (new Array(n));
var n__19273__auto___21124 = n;
var x_21125 = (0);
while(true){
if((x_21125 < n__19273__auto___21124)){
(a[x_21125] = (0));

var G__21126 = (x_21125 + (1));
x_21125 = G__21126;
continue;
} else {
}
break;
}

var i = (1);
while(true){
if(cljs.core._EQ_.call(null,i,n)){
return a;
} else {
var j = cljs.core.rand_int.call(null,i);
(a[i] = (a[j]));

(a[j] = i);

var G__21127 = (i + (1));
i = G__21127;
continue;
}
break;
}
});
cljs.core.async.alt_flag = (function cljs$core$async$alt_flag(){
var flag = cljs.core.atom.call(null,true);
if(typeof cljs.core.async.t_cljs$core$async21131 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21131 = (function (alt_flag,flag,meta21132){
this.alt_flag = alt_flag;
this.flag = flag;
this.meta21132 = meta21132;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21131.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (flag){
return (function (_21133,meta21132__$1){
var self__ = this;
var _21133__$1 = this;
return (new cljs.core.async.t_cljs$core$async21131(self__.alt_flag,self__.flag,meta21132__$1));
});})(flag))
;

cljs.core.async.t_cljs$core$async21131.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (flag){
return (function (_21133){
var self__ = this;
var _21133__$1 = this;
return self__.meta21132;
});})(flag))
;

cljs.core.async.t_cljs$core$async21131.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21131.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.deref.call(null,self__.flag);
});})(flag))
;

cljs.core.async.t_cljs$core$async21131.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
return true;
});})(flag))
;

cljs.core.async.t_cljs$core$async21131.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.flag,null);

return true;
});})(flag))
;

cljs.core.async.t_cljs$core$async21131.getBasis = ((function (flag){
return (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"alt-flag","alt-flag",-1794972754,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"private","private",-558947994),true,new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(cljs.core.PersistentVector.EMPTY))], null)),new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"meta21132","meta21132",-1616558890,null)], null);
});})(flag))
;

cljs.core.async.t_cljs$core$async21131.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21131.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21131";

cljs.core.async.t_cljs$core$async21131.cljs$lang$ctorPrWriter = ((function (flag){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21131");
});})(flag))
;

cljs.core.async.__GT_t_cljs$core$async21131 = ((function (flag){
return (function cljs$core$async$alt_flag_$___GT_t_cljs$core$async21131(alt_flag__$1,flag__$1,meta21132){
return (new cljs.core.async.t_cljs$core$async21131(alt_flag__$1,flag__$1,meta21132));
});})(flag))
;

}

return (new cljs.core.async.t_cljs$core$async21131(cljs$core$async$alt_flag,flag,cljs.core.PersistentArrayMap.EMPTY));
});
cljs.core.async.alt_handler = (function cljs$core$async$alt_handler(flag,cb){
if(typeof cljs.core.async.t_cljs$core$async21137 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21137 = (function (alt_handler,flag,cb,meta21138){
this.alt_handler = alt_handler;
this.flag = flag;
this.cb = cb;
this.meta21138 = meta21138;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21137.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_21139,meta21138__$1){
var self__ = this;
var _21139__$1 = this;
return (new cljs.core.async.t_cljs$core$async21137(self__.alt_handler,self__.flag,self__.cb,meta21138__$1));
});

cljs.core.async.t_cljs$core$async21137.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_21139){
var self__ = this;
var _21139__$1 = this;
return self__.meta21138;
});

cljs.core.async.t_cljs$core$async21137.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21137.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.active_QMARK_.call(null,self__.flag);
});

cljs.core.async.t_cljs$core$async21137.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return true;
});

cljs.core.async.t_cljs$core$async21137.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.async.impl.protocols.commit.call(null,self__.flag);

return self__.cb;
});

cljs.core.async.t_cljs$core$async21137.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"alt-handler","alt-handler",963786170,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"private","private",-558947994),true,new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"cb","cb",-2064487928,null)], null)))], null)),new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"cb","cb",-2064487928,null),new cljs.core.Symbol(null,"meta21138","meta21138",-856621022,null)], null);
});

cljs.core.async.t_cljs$core$async21137.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21137.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21137";

cljs.core.async.t_cljs$core$async21137.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21137");
});

cljs.core.async.__GT_t_cljs$core$async21137 = (function cljs$core$async$alt_handler_$___GT_t_cljs$core$async21137(alt_handler__$1,flag__$1,cb__$1,meta21138){
return (new cljs.core.async.t_cljs$core$async21137(alt_handler__$1,flag__$1,cb__$1,meta21138));
});

}

return (new cljs.core.async.t_cljs$core$async21137(cljs$core$async$alt_handler,flag,cb,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * returns derefable [val port] if immediate, nil if enqueued
 */
cljs.core.async.do_alts = (function cljs$core$async$do_alts(fret,ports,opts){
var flag = cljs.core.async.alt_flag.call(null);
var n = cljs.core.count.call(null,ports);
var idxs = cljs.core.async.random_array.call(null,n);
var priority = new cljs.core.Keyword(null,"priority","priority",1431093715).cljs$core$IFn$_invoke$arity$1(opts);
var ret = (function (){var i = (0);
while(true){
if((i < n)){
var idx = (cljs.core.truth_(priority)?i:(idxs[i]));
var port = cljs.core.nth.call(null,ports,idx);
var wport = ((cljs.core.vector_QMARK_.call(null,port))?port.call(null,(0)):null);
var vbox = (cljs.core.truth_(wport)?(function (){var val = port.call(null,(1));
return cljs.core.async.impl.protocols.put_BANG_.call(null,wport,val,cljs.core.async.alt_handler.call(null,flag,((function (i,val,idx,port,wport,flag,n,idxs,priority){
return (function (p1__21140_SHARP_){
return fret.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [p1__21140_SHARP_,wport], null));
});})(i,val,idx,port,wport,flag,n,idxs,priority))
));
})():cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.alt_handler.call(null,flag,((function (i,idx,port,wport,flag,n,idxs,priority){
return (function (p1__21141_SHARP_){
return fret.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [p1__21141_SHARP_,port], null));
});})(i,idx,port,wport,flag,n,idxs,priority))
)));
if(cljs.core.truth_(vbox)){
return cljs.core.async.impl.channels.box.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.deref.call(null,vbox),(function (){var or__18370__auto__ = wport;
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return port;
}
})()], null));
} else {
var G__21142 = (i + (1));
i = G__21142;
continue;
}
} else {
return null;
}
break;
}
})();
var or__18370__auto__ = ret;
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
if(cljs.core.contains_QMARK_.call(null,opts,new cljs.core.Keyword(null,"default","default",-1987822328))){
var temp__4657__auto__ = (function (){var and__18358__auto__ = cljs.core.async.impl.protocols.active_QMARK_.call(null,flag);
if(cljs.core.truth_(and__18358__auto__)){
return cljs.core.async.impl.protocols.commit.call(null,flag);
} else {
return and__18358__auto__;
}
})();
if(cljs.core.truth_(temp__4657__auto__)){
var got = temp__4657__auto__;
return cljs.core.async.impl.channels.box.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"default","default",-1987822328).cljs$core$IFn$_invoke$arity$1(opts),new cljs.core.Keyword(null,"default","default",-1987822328)], null));
} else {
return null;
}
} else {
return null;
}
}
});
/**
 * Completes at most one of several channel operations. Must be called
 * inside a (go ...) block. ports is a vector of channel endpoints,
 * which can be either a channel to take from or a vector of
 *   [channel-to-put-to val-to-put], in any combination. Takes will be
 *   made as if by <!, and puts will be made as if by >!. Unless
 *   the :priority option is true, if more than one port operation is
 *   ready a non-deterministic choice will be made. If no operation is
 *   ready and a :default value is supplied, [default-val :default] will
 *   be returned, otherwise alts! will park until the first operation to
 *   become ready completes. Returns [val port] of the completed
 *   operation, where val is the value taken for takes, and a
 *   boolean (true unless already closed, as per put!) for puts.
 * 
 *   opts are passed as :key val ... Supported options:
 * 
 *   :default val - the value to use if none of the operations are immediately ready
 *   :priority true - (default nil) when true, the operations will be tried in order.
 * 
 *   Note: there is no guarantee that the port exps or val exprs will be
 *   used, nor in what order should they be, so they should not be
 *   depended upon for side effects.
 */
cljs.core.async.alts_BANG_ = (function cljs$core$async$alts_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___21148 = arguments.length;
var i__19429__auto___21149 = (0);
while(true){
if((i__19429__auto___21149 < len__19428__auto___21148)){
args__19435__auto__.push((arguments[i__19429__auto___21149]));

var G__21150 = (i__19429__auto___21149 + (1));
i__19429__auto___21149 = G__21150;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ports,p__21145){
var map__21146 = p__21145;
var map__21146__$1 = ((((!((map__21146 == null)))?((((map__21146.cljs$lang$protocol_mask$partition0$ & (64))) || (map__21146.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__21146):map__21146);
var opts = map__21146__$1;
throw (new Error("alts! used not in (go ...) block"));
});

cljs.core.async.alts_BANG_.cljs$lang$maxFixedArity = (1);

cljs.core.async.alts_BANG_.cljs$lang$applyTo = (function (seq21143){
var G__21144 = cljs.core.first.call(null,seq21143);
var seq21143__$1 = cljs.core.next.call(null,seq21143);
return cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__21144,seq21143__$1);
});
/**
 * Puts a val into port if it's possible to do so immediately.
 *   nil values are not allowed. Never blocks. Returns true if offer succeeds.
 */
cljs.core.async.offer_BANG_ = (function cljs$core$async$offer_BANG_(port,val){
var ret = cljs.core.async.impl.protocols.put_BANG_.call(null,port,val,cljs.core.async.fn_handler.call(null,cljs.core.async.nop,false));
if(cljs.core.truth_(ret)){
return cljs.core.deref.call(null,ret);
} else {
return null;
}
});
/**
 * Takes a val from port if it's possible to do so immediately.
 *   Never blocks. Returns value if successful, nil otherwise.
 */
cljs.core.async.poll_BANG_ = (function cljs$core$async$poll_BANG_(port){
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.fn_handler.call(null,cljs.core.async.nop,false));
if(cljs.core.truth_(ret)){
return cljs.core.deref.call(null,ret);
} else {
return null;
}
});
/**
 * Takes elements from the from channel and supplies them to the to
 * channel. By default, the to channel will be closed when the from
 * channel closes, but can be determined by the close?  parameter. Will
 * stop consuming the from channel if the to channel closes
 */
cljs.core.async.pipe = (function cljs$core$async$pipe(var_args){
var args21151 = [];
var len__19428__auto___21201 = arguments.length;
var i__19429__auto___21202 = (0);
while(true){
if((i__19429__auto___21202 < len__19428__auto___21201)){
args21151.push((arguments[i__19429__auto___21202]));

var G__21203 = (i__19429__auto___21202 + (1));
i__19429__auto___21202 = G__21203;
continue;
} else {
}
break;
}

var G__21153 = args21151.length;
switch (G__21153) {
case 2:
return cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21151.length)].join('')));

}
});

cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$2 = (function (from,to){
return cljs.core.async.pipe.call(null,from,to,true);
});

cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$3 = (function (from,to,close_QMARK_){
var c__21038__auto___21205 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___21205){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___21205){
return (function (state_21177){
var state_val_21178 = (state_21177[(1)]);
if((state_val_21178 === (7))){
var inst_21173 = (state_21177[(2)]);
var state_21177__$1 = state_21177;
var statearr_21179_21206 = state_21177__$1;
(statearr_21179_21206[(2)] = inst_21173);

(statearr_21179_21206[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (1))){
var state_21177__$1 = state_21177;
var statearr_21180_21207 = state_21177__$1;
(statearr_21180_21207[(2)] = null);

(statearr_21180_21207[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (4))){
var inst_21156 = (state_21177[(7)]);
var inst_21156__$1 = (state_21177[(2)]);
var inst_21157 = (inst_21156__$1 == null);
var state_21177__$1 = (function (){var statearr_21181 = state_21177;
(statearr_21181[(7)] = inst_21156__$1);

return statearr_21181;
})();
if(cljs.core.truth_(inst_21157)){
var statearr_21182_21208 = state_21177__$1;
(statearr_21182_21208[(1)] = (5));

} else {
var statearr_21183_21209 = state_21177__$1;
(statearr_21183_21209[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (13))){
var state_21177__$1 = state_21177;
var statearr_21184_21210 = state_21177__$1;
(statearr_21184_21210[(2)] = null);

(statearr_21184_21210[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (6))){
var inst_21156 = (state_21177[(7)]);
var state_21177__$1 = state_21177;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21177__$1,(11),to,inst_21156);
} else {
if((state_val_21178 === (3))){
var inst_21175 = (state_21177[(2)]);
var state_21177__$1 = state_21177;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21177__$1,inst_21175);
} else {
if((state_val_21178 === (12))){
var state_21177__$1 = state_21177;
var statearr_21185_21211 = state_21177__$1;
(statearr_21185_21211[(2)] = null);

(statearr_21185_21211[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (2))){
var state_21177__$1 = state_21177;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21177__$1,(4),from);
} else {
if((state_val_21178 === (11))){
var inst_21166 = (state_21177[(2)]);
var state_21177__$1 = state_21177;
if(cljs.core.truth_(inst_21166)){
var statearr_21186_21212 = state_21177__$1;
(statearr_21186_21212[(1)] = (12));

} else {
var statearr_21187_21213 = state_21177__$1;
(statearr_21187_21213[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (9))){
var state_21177__$1 = state_21177;
var statearr_21188_21214 = state_21177__$1;
(statearr_21188_21214[(2)] = null);

(statearr_21188_21214[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (5))){
var state_21177__$1 = state_21177;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21189_21215 = state_21177__$1;
(statearr_21189_21215[(1)] = (8));

} else {
var statearr_21190_21216 = state_21177__$1;
(statearr_21190_21216[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (14))){
var inst_21171 = (state_21177[(2)]);
var state_21177__$1 = state_21177;
var statearr_21191_21217 = state_21177__$1;
(statearr_21191_21217[(2)] = inst_21171);

(statearr_21191_21217[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (10))){
var inst_21163 = (state_21177[(2)]);
var state_21177__$1 = state_21177;
var statearr_21192_21218 = state_21177__$1;
(statearr_21192_21218[(2)] = inst_21163);

(statearr_21192_21218[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21178 === (8))){
var inst_21160 = cljs.core.async.close_BANG_.call(null,to);
var state_21177__$1 = state_21177;
var statearr_21193_21219 = state_21177__$1;
(statearr_21193_21219[(2)] = inst_21160);

(statearr_21193_21219[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___21205))
;
return ((function (switch__20926__auto__,c__21038__auto___21205){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_21197 = [null,null,null,null,null,null,null,null];
(statearr_21197[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_21197[(1)] = (1));

return statearr_21197;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_21177){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21177);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21198){if((e21198 instanceof Object)){
var ex__20930__auto__ = e21198;
var statearr_21199_21220 = state_21177;
(statearr_21199_21220[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21177);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21198;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21221 = state_21177;
state_21177 = G__21221;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_21177){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_21177);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___21205))
})();
var state__21040__auto__ = (function (){var statearr_21200 = f__21039__auto__.call(null);
(statearr_21200[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___21205);

return statearr_21200;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___21205))
);


return to;
});

cljs.core.async.pipe.cljs$lang$maxFixedArity = 3;
cljs.core.async.pipeline_STAR_ = (function cljs$core$async$pipeline_STAR_(n,to,xf,from,close_QMARK_,ex_handler,type){
if((n > (0))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.call(null,cljs.core.list(new cljs.core.Symbol(null,"pos?","pos?",-244377722,null),new cljs.core.Symbol(null,"n","n",-2092305744,null))))].join('')));
}

var jobs = cljs.core.async.chan.call(null,n);
var results = cljs.core.async.chan.call(null,n);
var process = ((function (jobs,results){
return (function (p__21405){
var vec__21406 = p__21405;
var v = cljs.core.nth.call(null,vec__21406,(0),null);
var p = cljs.core.nth.call(null,vec__21406,(1),null);
var job = vec__21406;
if((job == null)){
cljs.core.async.close_BANG_.call(null,results);

return null;
} else {
var res = cljs.core.async.chan.call(null,(1),xf,ex_handler);
var c__21038__auto___21588 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___21588,res,vec__21406,v,p,job,jobs,results){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___21588,res,vec__21406,v,p,job,jobs,results){
return (function (state_21411){
var state_val_21412 = (state_21411[(1)]);
if((state_val_21412 === (1))){
var state_21411__$1 = state_21411;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21411__$1,(2),res,v);
} else {
if((state_val_21412 === (2))){
var inst_21408 = (state_21411[(2)]);
var inst_21409 = cljs.core.async.close_BANG_.call(null,res);
var state_21411__$1 = (function (){var statearr_21413 = state_21411;
(statearr_21413[(7)] = inst_21408);

return statearr_21413;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21411__$1,inst_21409);
} else {
return null;
}
}
});})(c__21038__auto___21588,res,vec__21406,v,p,job,jobs,results))
;
return ((function (switch__20926__auto__,c__21038__auto___21588,res,vec__21406,v,p,job,jobs,results){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0 = (function (){
var statearr_21417 = [null,null,null,null,null,null,null,null];
(statearr_21417[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__);

(statearr_21417[(1)] = (1));

return statearr_21417;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1 = (function (state_21411){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21411);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21418){if((e21418 instanceof Object)){
var ex__20930__auto__ = e21418;
var statearr_21419_21589 = state_21411;
(statearr_21419_21589[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21411);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21418;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21590 = state_21411;
state_21411 = G__21590;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = function(state_21411){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1.call(this,state_21411);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___21588,res,vec__21406,v,p,job,jobs,results))
})();
var state__21040__auto__ = (function (){var statearr_21420 = f__21039__auto__.call(null);
(statearr_21420[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___21588);

return statearr_21420;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___21588,res,vec__21406,v,p,job,jobs,results))
);


cljs.core.async.put_BANG_.call(null,p,res);

return true;
}
});})(jobs,results))
;
var async = ((function (jobs,results,process){
return (function (p__21421){
var vec__21422 = p__21421;
var v = cljs.core.nth.call(null,vec__21422,(0),null);
var p = cljs.core.nth.call(null,vec__21422,(1),null);
var job = vec__21422;
if((job == null)){
cljs.core.async.close_BANG_.call(null,results);

return null;
} else {
var res = cljs.core.async.chan.call(null,(1));
xf.call(null,v,res);

cljs.core.async.put_BANG_.call(null,p,res);

return true;
}
});})(jobs,results,process))
;
var n__19273__auto___21591 = n;
var __21592 = (0);
while(true){
if((__21592 < n__19273__auto___21591)){
var G__21423_21593 = (((type instanceof cljs.core.Keyword))?type.fqn:null);
switch (G__21423_21593) {
case "compute":
var c__21038__auto___21595 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (__21592,c__21038__auto___21595,G__21423_21593,n__19273__auto___21591,jobs,results,process,async){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (__21592,c__21038__auto___21595,G__21423_21593,n__19273__auto___21591,jobs,results,process,async){
return (function (state_21436){
var state_val_21437 = (state_21436[(1)]);
if((state_val_21437 === (1))){
var state_21436__$1 = state_21436;
var statearr_21438_21596 = state_21436__$1;
(statearr_21438_21596[(2)] = null);

(statearr_21438_21596[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21437 === (2))){
var state_21436__$1 = state_21436;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21436__$1,(4),jobs);
} else {
if((state_val_21437 === (3))){
var inst_21434 = (state_21436[(2)]);
var state_21436__$1 = state_21436;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21436__$1,inst_21434);
} else {
if((state_val_21437 === (4))){
var inst_21426 = (state_21436[(2)]);
var inst_21427 = process.call(null,inst_21426);
var state_21436__$1 = state_21436;
if(cljs.core.truth_(inst_21427)){
var statearr_21439_21597 = state_21436__$1;
(statearr_21439_21597[(1)] = (5));

} else {
var statearr_21440_21598 = state_21436__$1;
(statearr_21440_21598[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21437 === (5))){
var state_21436__$1 = state_21436;
var statearr_21441_21599 = state_21436__$1;
(statearr_21441_21599[(2)] = null);

(statearr_21441_21599[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21437 === (6))){
var state_21436__$1 = state_21436;
var statearr_21442_21600 = state_21436__$1;
(statearr_21442_21600[(2)] = null);

(statearr_21442_21600[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21437 === (7))){
var inst_21432 = (state_21436[(2)]);
var state_21436__$1 = state_21436;
var statearr_21443_21601 = state_21436__$1;
(statearr_21443_21601[(2)] = inst_21432);

(statearr_21443_21601[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
});})(__21592,c__21038__auto___21595,G__21423_21593,n__19273__auto___21591,jobs,results,process,async))
;
return ((function (__21592,switch__20926__auto__,c__21038__auto___21595,G__21423_21593,n__19273__auto___21591,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0 = (function (){
var statearr_21447 = [null,null,null,null,null,null,null];
(statearr_21447[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__);

(statearr_21447[(1)] = (1));

return statearr_21447;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1 = (function (state_21436){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21436);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21448){if((e21448 instanceof Object)){
var ex__20930__auto__ = e21448;
var statearr_21449_21602 = state_21436;
(statearr_21449_21602[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21436);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21448;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21603 = state_21436;
state_21436 = G__21603;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = function(state_21436){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1.call(this,state_21436);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__;
})()
;})(__21592,switch__20926__auto__,c__21038__auto___21595,G__21423_21593,n__19273__auto___21591,jobs,results,process,async))
})();
var state__21040__auto__ = (function (){var statearr_21450 = f__21039__auto__.call(null);
(statearr_21450[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___21595);

return statearr_21450;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(__21592,c__21038__auto___21595,G__21423_21593,n__19273__auto___21591,jobs,results,process,async))
);


break;
case "async":
var c__21038__auto___21604 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (__21592,c__21038__auto___21604,G__21423_21593,n__19273__auto___21591,jobs,results,process,async){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (__21592,c__21038__auto___21604,G__21423_21593,n__19273__auto___21591,jobs,results,process,async){
return (function (state_21463){
var state_val_21464 = (state_21463[(1)]);
if((state_val_21464 === (1))){
var state_21463__$1 = state_21463;
var statearr_21465_21605 = state_21463__$1;
(statearr_21465_21605[(2)] = null);

(statearr_21465_21605[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21464 === (2))){
var state_21463__$1 = state_21463;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21463__$1,(4),jobs);
} else {
if((state_val_21464 === (3))){
var inst_21461 = (state_21463[(2)]);
var state_21463__$1 = state_21463;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21463__$1,inst_21461);
} else {
if((state_val_21464 === (4))){
var inst_21453 = (state_21463[(2)]);
var inst_21454 = async.call(null,inst_21453);
var state_21463__$1 = state_21463;
if(cljs.core.truth_(inst_21454)){
var statearr_21466_21606 = state_21463__$1;
(statearr_21466_21606[(1)] = (5));

} else {
var statearr_21467_21607 = state_21463__$1;
(statearr_21467_21607[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21464 === (5))){
var state_21463__$1 = state_21463;
var statearr_21468_21608 = state_21463__$1;
(statearr_21468_21608[(2)] = null);

(statearr_21468_21608[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21464 === (6))){
var state_21463__$1 = state_21463;
var statearr_21469_21609 = state_21463__$1;
(statearr_21469_21609[(2)] = null);

(statearr_21469_21609[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21464 === (7))){
var inst_21459 = (state_21463[(2)]);
var state_21463__$1 = state_21463;
var statearr_21470_21610 = state_21463__$1;
(statearr_21470_21610[(2)] = inst_21459);

(statearr_21470_21610[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
});})(__21592,c__21038__auto___21604,G__21423_21593,n__19273__auto___21591,jobs,results,process,async))
;
return ((function (__21592,switch__20926__auto__,c__21038__auto___21604,G__21423_21593,n__19273__auto___21591,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0 = (function (){
var statearr_21474 = [null,null,null,null,null,null,null];
(statearr_21474[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__);

(statearr_21474[(1)] = (1));

return statearr_21474;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1 = (function (state_21463){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21463);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21475){if((e21475 instanceof Object)){
var ex__20930__auto__ = e21475;
var statearr_21476_21611 = state_21463;
(statearr_21476_21611[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21463);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21475;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21612 = state_21463;
state_21463 = G__21612;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = function(state_21463){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1.call(this,state_21463);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__;
})()
;})(__21592,switch__20926__auto__,c__21038__auto___21604,G__21423_21593,n__19273__auto___21591,jobs,results,process,async))
})();
var state__21040__auto__ = (function (){var statearr_21477 = f__21039__auto__.call(null);
(statearr_21477[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___21604);

return statearr_21477;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(__21592,c__21038__auto___21604,G__21423_21593,n__19273__auto___21591,jobs,results,process,async))
);


break;
default:
throw (new Error([cljs.core.str("No matching clause: "),cljs.core.str(type)].join('')));

}

var G__21613 = (__21592 + (1));
__21592 = G__21613;
continue;
} else {
}
break;
}

var c__21038__auto___21614 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___21614,jobs,results,process,async){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___21614,jobs,results,process,async){
return (function (state_21499){
var state_val_21500 = (state_21499[(1)]);
if((state_val_21500 === (1))){
var state_21499__$1 = state_21499;
var statearr_21501_21615 = state_21499__$1;
(statearr_21501_21615[(2)] = null);

(statearr_21501_21615[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21500 === (2))){
var state_21499__$1 = state_21499;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21499__$1,(4),from);
} else {
if((state_val_21500 === (3))){
var inst_21497 = (state_21499[(2)]);
var state_21499__$1 = state_21499;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21499__$1,inst_21497);
} else {
if((state_val_21500 === (4))){
var inst_21480 = (state_21499[(7)]);
var inst_21480__$1 = (state_21499[(2)]);
var inst_21481 = (inst_21480__$1 == null);
var state_21499__$1 = (function (){var statearr_21502 = state_21499;
(statearr_21502[(7)] = inst_21480__$1);

return statearr_21502;
})();
if(cljs.core.truth_(inst_21481)){
var statearr_21503_21616 = state_21499__$1;
(statearr_21503_21616[(1)] = (5));

} else {
var statearr_21504_21617 = state_21499__$1;
(statearr_21504_21617[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21500 === (5))){
var inst_21483 = cljs.core.async.close_BANG_.call(null,jobs);
var state_21499__$1 = state_21499;
var statearr_21505_21618 = state_21499__$1;
(statearr_21505_21618[(2)] = inst_21483);

(statearr_21505_21618[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21500 === (6))){
var inst_21480 = (state_21499[(7)]);
var inst_21485 = (state_21499[(8)]);
var inst_21485__$1 = cljs.core.async.chan.call(null,(1));
var inst_21486 = cljs.core.PersistentVector.EMPTY_NODE;
var inst_21487 = [inst_21480,inst_21485__$1];
var inst_21488 = (new cljs.core.PersistentVector(null,2,(5),inst_21486,inst_21487,null));
var state_21499__$1 = (function (){var statearr_21506 = state_21499;
(statearr_21506[(8)] = inst_21485__$1);

return statearr_21506;
})();
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21499__$1,(8),jobs,inst_21488);
} else {
if((state_val_21500 === (7))){
var inst_21495 = (state_21499[(2)]);
var state_21499__$1 = state_21499;
var statearr_21507_21619 = state_21499__$1;
(statearr_21507_21619[(2)] = inst_21495);

(statearr_21507_21619[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21500 === (8))){
var inst_21485 = (state_21499[(8)]);
var inst_21490 = (state_21499[(2)]);
var state_21499__$1 = (function (){var statearr_21508 = state_21499;
(statearr_21508[(9)] = inst_21490);

return statearr_21508;
})();
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21499__$1,(9),results,inst_21485);
} else {
if((state_val_21500 === (9))){
var inst_21492 = (state_21499[(2)]);
var state_21499__$1 = (function (){var statearr_21509 = state_21499;
(statearr_21509[(10)] = inst_21492);

return statearr_21509;
})();
var statearr_21510_21620 = state_21499__$1;
(statearr_21510_21620[(2)] = null);

(statearr_21510_21620[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___21614,jobs,results,process,async))
;
return ((function (switch__20926__auto__,c__21038__auto___21614,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0 = (function (){
var statearr_21514 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_21514[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__);

(statearr_21514[(1)] = (1));

return statearr_21514;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1 = (function (state_21499){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21499);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21515){if((e21515 instanceof Object)){
var ex__20930__auto__ = e21515;
var statearr_21516_21621 = state_21499;
(statearr_21516_21621[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21499);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21515;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21622 = state_21499;
state_21499 = G__21622;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = function(state_21499){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1.call(this,state_21499);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___21614,jobs,results,process,async))
})();
var state__21040__auto__ = (function (){var statearr_21517 = f__21039__auto__.call(null);
(statearr_21517[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___21614);

return statearr_21517;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___21614,jobs,results,process,async))
);


var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__,jobs,results,process,async){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__,jobs,results,process,async){
return (function (state_21555){
var state_val_21556 = (state_21555[(1)]);
if((state_val_21556 === (7))){
var inst_21551 = (state_21555[(2)]);
var state_21555__$1 = state_21555;
var statearr_21557_21623 = state_21555__$1;
(statearr_21557_21623[(2)] = inst_21551);

(statearr_21557_21623[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (20))){
var state_21555__$1 = state_21555;
var statearr_21558_21624 = state_21555__$1;
(statearr_21558_21624[(2)] = null);

(statearr_21558_21624[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (1))){
var state_21555__$1 = state_21555;
var statearr_21559_21625 = state_21555__$1;
(statearr_21559_21625[(2)] = null);

(statearr_21559_21625[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (4))){
var inst_21520 = (state_21555[(7)]);
var inst_21520__$1 = (state_21555[(2)]);
var inst_21521 = (inst_21520__$1 == null);
var state_21555__$1 = (function (){var statearr_21560 = state_21555;
(statearr_21560[(7)] = inst_21520__$1);

return statearr_21560;
})();
if(cljs.core.truth_(inst_21521)){
var statearr_21561_21626 = state_21555__$1;
(statearr_21561_21626[(1)] = (5));

} else {
var statearr_21562_21627 = state_21555__$1;
(statearr_21562_21627[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (15))){
var inst_21533 = (state_21555[(8)]);
var state_21555__$1 = state_21555;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21555__$1,(18),to,inst_21533);
} else {
if((state_val_21556 === (21))){
var inst_21546 = (state_21555[(2)]);
var state_21555__$1 = state_21555;
var statearr_21563_21628 = state_21555__$1;
(statearr_21563_21628[(2)] = inst_21546);

(statearr_21563_21628[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (13))){
var inst_21548 = (state_21555[(2)]);
var state_21555__$1 = (function (){var statearr_21564 = state_21555;
(statearr_21564[(9)] = inst_21548);

return statearr_21564;
})();
var statearr_21565_21629 = state_21555__$1;
(statearr_21565_21629[(2)] = null);

(statearr_21565_21629[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (6))){
var inst_21520 = (state_21555[(7)]);
var state_21555__$1 = state_21555;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21555__$1,(11),inst_21520);
} else {
if((state_val_21556 === (17))){
var inst_21541 = (state_21555[(2)]);
var state_21555__$1 = state_21555;
if(cljs.core.truth_(inst_21541)){
var statearr_21566_21630 = state_21555__$1;
(statearr_21566_21630[(1)] = (19));

} else {
var statearr_21567_21631 = state_21555__$1;
(statearr_21567_21631[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (3))){
var inst_21553 = (state_21555[(2)]);
var state_21555__$1 = state_21555;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21555__$1,inst_21553);
} else {
if((state_val_21556 === (12))){
var inst_21530 = (state_21555[(10)]);
var state_21555__$1 = state_21555;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21555__$1,(14),inst_21530);
} else {
if((state_val_21556 === (2))){
var state_21555__$1 = state_21555;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21555__$1,(4),results);
} else {
if((state_val_21556 === (19))){
var state_21555__$1 = state_21555;
var statearr_21568_21632 = state_21555__$1;
(statearr_21568_21632[(2)] = null);

(statearr_21568_21632[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (11))){
var inst_21530 = (state_21555[(2)]);
var state_21555__$1 = (function (){var statearr_21569 = state_21555;
(statearr_21569[(10)] = inst_21530);

return statearr_21569;
})();
var statearr_21570_21633 = state_21555__$1;
(statearr_21570_21633[(2)] = null);

(statearr_21570_21633[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (9))){
var state_21555__$1 = state_21555;
var statearr_21571_21634 = state_21555__$1;
(statearr_21571_21634[(2)] = null);

(statearr_21571_21634[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (5))){
var state_21555__$1 = state_21555;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21572_21635 = state_21555__$1;
(statearr_21572_21635[(1)] = (8));

} else {
var statearr_21573_21636 = state_21555__$1;
(statearr_21573_21636[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (14))){
var inst_21533 = (state_21555[(8)]);
var inst_21535 = (state_21555[(11)]);
var inst_21533__$1 = (state_21555[(2)]);
var inst_21534 = (inst_21533__$1 == null);
var inst_21535__$1 = cljs.core.not.call(null,inst_21534);
var state_21555__$1 = (function (){var statearr_21574 = state_21555;
(statearr_21574[(8)] = inst_21533__$1);

(statearr_21574[(11)] = inst_21535__$1);

return statearr_21574;
})();
if(inst_21535__$1){
var statearr_21575_21637 = state_21555__$1;
(statearr_21575_21637[(1)] = (15));

} else {
var statearr_21576_21638 = state_21555__$1;
(statearr_21576_21638[(1)] = (16));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (16))){
var inst_21535 = (state_21555[(11)]);
var state_21555__$1 = state_21555;
var statearr_21577_21639 = state_21555__$1;
(statearr_21577_21639[(2)] = inst_21535);

(statearr_21577_21639[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (10))){
var inst_21527 = (state_21555[(2)]);
var state_21555__$1 = state_21555;
var statearr_21578_21640 = state_21555__$1;
(statearr_21578_21640[(2)] = inst_21527);

(statearr_21578_21640[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (18))){
var inst_21538 = (state_21555[(2)]);
var state_21555__$1 = state_21555;
var statearr_21579_21641 = state_21555__$1;
(statearr_21579_21641[(2)] = inst_21538);

(statearr_21579_21641[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21556 === (8))){
var inst_21524 = cljs.core.async.close_BANG_.call(null,to);
var state_21555__$1 = state_21555;
var statearr_21580_21642 = state_21555__$1;
(statearr_21580_21642[(2)] = inst_21524);

(statearr_21580_21642[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto__,jobs,results,process,async))
;
return ((function (switch__20926__auto__,c__21038__auto__,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0 = (function (){
var statearr_21584 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_21584[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__);

(statearr_21584[(1)] = (1));

return statearr_21584;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1 = (function (state_21555){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21555);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21585){if((e21585 instanceof Object)){
var ex__20930__auto__ = e21585;
var statearr_21586_21643 = state_21555;
(statearr_21586_21643[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21555);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21585;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21644 = state_21555;
state_21555 = G__21644;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__ = function(state_21555){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1.call(this,state_21555);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20927__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__,jobs,results,process,async))
})();
var state__21040__auto__ = (function (){var statearr_21587 = f__21039__auto__.call(null);
(statearr_21587[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_21587;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__,jobs,results,process,async))
);

return c__21038__auto__;
});
/**
 * Takes elements from the from channel and supplies them to the to
 *   channel, subject to the async function af, with parallelism n. af
 *   must be a function of two arguments, the first an input value and
 *   the second a channel on which to place the result(s). af must close!
 *   the channel before returning.  The presumption is that af will
 *   return immediately, having launched some asynchronous operation
 *   whose completion/callback will manipulate the result channel. Outputs
 *   will be returned in order relative to  the inputs. By default, the to
 *   channel will be closed when the from channel closes, but can be
 *   determined by the close?  parameter. Will stop consuming the from
 *   channel if the to channel closes.
 */
cljs.core.async.pipeline_async = (function cljs$core$async$pipeline_async(var_args){
var args21645 = [];
var len__19428__auto___21648 = arguments.length;
var i__19429__auto___21649 = (0);
while(true){
if((i__19429__auto___21649 < len__19428__auto___21648)){
args21645.push((arguments[i__19429__auto___21649]));

var G__21650 = (i__19429__auto___21649 + (1));
i__19429__auto___21649 = G__21650;
continue;
} else {
}
break;
}

var G__21647 = args21645.length;
switch (G__21647) {
case 4:
return cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
case 5:
return cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$5((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]),(arguments[(4)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21645.length)].join('')));

}
});

cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$4 = (function (n,to,af,from){
return cljs.core.async.pipeline_async.call(null,n,to,af,from,true);
});

cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$5 = (function (n,to,af,from,close_QMARK_){
return cljs.core.async.pipeline_STAR_.call(null,n,to,af,from,close_QMARK_,null,new cljs.core.Keyword(null,"async","async",1050769601));
});

cljs.core.async.pipeline_async.cljs$lang$maxFixedArity = 5;
/**
 * Takes elements from the from channel and supplies them to the to
 *   channel, subject to the transducer xf, with parallelism n. Because
 *   it is parallel, the transducer will be applied independently to each
 *   element, not across elements, and may produce zero or more outputs
 *   per input.  Outputs will be returned in order relative to the
 *   inputs. By default, the to channel will be closed when the from
 *   channel closes, but can be determined by the close?  parameter. Will
 *   stop consuming the from channel if the to channel closes.
 * 
 *   Note this is supplied for API compatibility with the Clojure version.
 *   Values of N > 1 will not result in actual concurrency in a
 *   single-threaded runtime.
 */
cljs.core.async.pipeline = (function cljs$core$async$pipeline(var_args){
var args21652 = [];
var len__19428__auto___21655 = arguments.length;
var i__19429__auto___21656 = (0);
while(true){
if((i__19429__auto___21656 < len__19428__auto___21655)){
args21652.push((arguments[i__19429__auto___21656]));

var G__21657 = (i__19429__auto___21656 + (1));
i__19429__auto___21656 = G__21657;
continue;
} else {
}
break;
}

var G__21654 = args21652.length;
switch (G__21654) {
case 4:
return cljs.core.async.pipeline.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
case 5:
return cljs.core.async.pipeline.cljs$core$IFn$_invoke$arity$5((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]),(arguments[(4)]));

break;
case 6:
return cljs.core.async.pipeline.cljs$core$IFn$_invoke$arity$6((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]),(arguments[(4)]),(arguments[(5)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21652.length)].join('')));

}
});

cljs.core.async.pipeline.cljs$core$IFn$_invoke$arity$4 = (function (n,to,xf,from){
return cljs.core.async.pipeline.call(null,n,to,xf,from,true);
});

cljs.core.async.pipeline.cljs$core$IFn$_invoke$arity$5 = (function (n,to,xf,from,close_QMARK_){
return cljs.core.async.pipeline.call(null,n,to,xf,from,close_QMARK_,null);
});

cljs.core.async.pipeline.cljs$core$IFn$_invoke$arity$6 = (function (n,to,xf,from,close_QMARK_,ex_handler){
return cljs.core.async.pipeline_STAR_.call(null,n,to,xf,from,close_QMARK_,ex_handler,new cljs.core.Keyword(null,"compute","compute",1555393130));
});

cljs.core.async.pipeline.cljs$lang$maxFixedArity = 6;
/**
 * Takes a predicate and a source channel and returns a vector of two
 *   channels, the first of which will contain the values for which the
 *   predicate returned true, the second those for which it returned
 *   false.
 * 
 *   The out channels will be unbuffered by default, or two buf-or-ns can
 *   be supplied. The channels will close after the source channel has
 *   closed.
 */
cljs.core.async.split = (function cljs$core$async$split(var_args){
var args21659 = [];
var len__19428__auto___21712 = arguments.length;
var i__19429__auto___21713 = (0);
while(true){
if((i__19429__auto___21713 < len__19428__auto___21712)){
args21659.push((arguments[i__19429__auto___21713]));

var G__21714 = (i__19429__auto___21713 + (1));
i__19429__auto___21713 = G__21714;
continue;
} else {
}
break;
}

var G__21661 = args21659.length;
switch (G__21661) {
case 2:
return cljs.core.async.split.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 4:
return cljs.core.async.split.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21659.length)].join('')));

}
});

cljs.core.async.split.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.split.call(null,p,ch,null,null);
});

cljs.core.async.split.cljs$core$IFn$_invoke$arity$4 = (function (p,ch,t_buf_or_n,f_buf_or_n){
var tc = cljs.core.async.chan.call(null,t_buf_or_n);
var fc = cljs.core.async.chan.call(null,f_buf_or_n);
var c__21038__auto___21716 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___21716,tc,fc){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___21716,tc,fc){
return (function (state_21687){
var state_val_21688 = (state_21687[(1)]);
if((state_val_21688 === (7))){
var inst_21683 = (state_21687[(2)]);
var state_21687__$1 = state_21687;
var statearr_21689_21717 = state_21687__$1;
(statearr_21689_21717[(2)] = inst_21683);

(statearr_21689_21717[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (1))){
var state_21687__$1 = state_21687;
var statearr_21690_21718 = state_21687__$1;
(statearr_21690_21718[(2)] = null);

(statearr_21690_21718[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (4))){
var inst_21664 = (state_21687[(7)]);
var inst_21664__$1 = (state_21687[(2)]);
var inst_21665 = (inst_21664__$1 == null);
var state_21687__$1 = (function (){var statearr_21691 = state_21687;
(statearr_21691[(7)] = inst_21664__$1);

return statearr_21691;
})();
if(cljs.core.truth_(inst_21665)){
var statearr_21692_21719 = state_21687__$1;
(statearr_21692_21719[(1)] = (5));

} else {
var statearr_21693_21720 = state_21687__$1;
(statearr_21693_21720[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (13))){
var state_21687__$1 = state_21687;
var statearr_21694_21721 = state_21687__$1;
(statearr_21694_21721[(2)] = null);

(statearr_21694_21721[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (6))){
var inst_21664 = (state_21687[(7)]);
var inst_21670 = p.call(null,inst_21664);
var state_21687__$1 = state_21687;
if(cljs.core.truth_(inst_21670)){
var statearr_21695_21722 = state_21687__$1;
(statearr_21695_21722[(1)] = (9));

} else {
var statearr_21696_21723 = state_21687__$1;
(statearr_21696_21723[(1)] = (10));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (3))){
var inst_21685 = (state_21687[(2)]);
var state_21687__$1 = state_21687;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21687__$1,inst_21685);
} else {
if((state_val_21688 === (12))){
var state_21687__$1 = state_21687;
var statearr_21697_21724 = state_21687__$1;
(statearr_21697_21724[(2)] = null);

(statearr_21697_21724[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (2))){
var state_21687__$1 = state_21687;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21687__$1,(4),ch);
} else {
if((state_val_21688 === (11))){
var inst_21664 = (state_21687[(7)]);
var inst_21674 = (state_21687[(2)]);
var state_21687__$1 = state_21687;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21687__$1,(8),inst_21674,inst_21664);
} else {
if((state_val_21688 === (9))){
var state_21687__$1 = state_21687;
var statearr_21698_21725 = state_21687__$1;
(statearr_21698_21725[(2)] = tc);

(statearr_21698_21725[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (5))){
var inst_21667 = cljs.core.async.close_BANG_.call(null,tc);
var inst_21668 = cljs.core.async.close_BANG_.call(null,fc);
var state_21687__$1 = (function (){var statearr_21699 = state_21687;
(statearr_21699[(8)] = inst_21667);

return statearr_21699;
})();
var statearr_21700_21726 = state_21687__$1;
(statearr_21700_21726[(2)] = inst_21668);

(statearr_21700_21726[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (14))){
var inst_21681 = (state_21687[(2)]);
var state_21687__$1 = state_21687;
var statearr_21701_21727 = state_21687__$1;
(statearr_21701_21727[(2)] = inst_21681);

(statearr_21701_21727[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (10))){
var state_21687__$1 = state_21687;
var statearr_21702_21728 = state_21687__$1;
(statearr_21702_21728[(2)] = fc);

(statearr_21702_21728[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21688 === (8))){
var inst_21676 = (state_21687[(2)]);
var state_21687__$1 = state_21687;
if(cljs.core.truth_(inst_21676)){
var statearr_21703_21729 = state_21687__$1;
(statearr_21703_21729[(1)] = (12));

} else {
var statearr_21704_21730 = state_21687__$1;
(statearr_21704_21730[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___21716,tc,fc))
;
return ((function (switch__20926__auto__,c__21038__auto___21716,tc,fc){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_21708 = [null,null,null,null,null,null,null,null,null];
(statearr_21708[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_21708[(1)] = (1));

return statearr_21708;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_21687){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21687);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21709){if((e21709 instanceof Object)){
var ex__20930__auto__ = e21709;
var statearr_21710_21731 = state_21687;
(statearr_21710_21731[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21687);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21709;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21732 = state_21687;
state_21687 = G__21732;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_21687){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_21687);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___21716,tc,fc))
})();
var state__21040__auto__ = (function (){var statearr_21711 = f__21039__auto__.call(null);
(statearr_21711[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___21716);

return statearr_21711;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___21716,tc,fc))
);


return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [tc,fc], null);
});

cljs.core.async.split.cljs$lang$maxFixedArity = 4;
/**
 * f should be a function of 2 arguments. Returns a channel containing
 *   the single result of applying f to init and the first item from the
 *   channel, then applying f to that result and the 2nd item, etc. If
 *   the channel closes without yielding items, returns init and f is not
 *   called. ch must close before reduce produces a result.
 */
cljs.core.async.reduce = (function cljs$core$async$reduce(f,init,ch){
var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__){
return (function (state_21796){
var state_val_21797 = (state_21796[(1)]);
if((state_val_21797 === (7))){
var inst_21792 = (state_21796[(2)]);
var state_21796__$1 = state_21796;
var statearr_21798_21819 = state_21796__$1;
(statearr_21798_21819[(2)] = inst_21792);

(statearr_21798_21819[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (1))){
var inst_21776 = init;
var state_21796__$1 = (function (){var statearr_21799 = state_21796;
(statearr_21799[(7)] = inst_21776);

return statearr_21799;
})();
var statearr_21800_21820 = state_21796__$1;
(statearr_21800_21820[(2)] = null);

(statearr_21800_21820[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (4))){
var inst_21779 = (state_21796[(8)]);
var inst_21779__$1 = (state_21796[(2)]);
var inst_21780 = (inst_21779__$1 == null);
var state_21796__$1 = (function (){var statearr_21801 = state_21796;
(statearr_21801[(8)] = inst_21779__$1);

return statearr_21801;
})();
if(cljs.core.truth_(inst_21780)){
var statearr_21802_21821 = state_21796__$1;
(statearr_21802_21821[(1)] = (5));

} else {
var statearr_21803_21822 = state_21796__$1;
(statearr_21803_21822[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (6))){
var inst_21776 = (state_21796[(7)]);
var inst_21779 = (state_21796[(8)]);
var inst_21783 = (state_21796[(9)]);
var inst_21783__$1 = f.call(null,inst_21776,inst_21779);
var inst_21784 = cljs.core.reduced_QMARK_.call(null,inst_21783__$1);
var state_21796__$1 = (function (){var statearr_21804 = state_21796;
(statearr_21804[(9)] = inst_21783__$1);

return statearr_21804;
})();
if(inst_21784){
var statearr_21805_21823 = state_21796__$1;
(statearr_21805_21823[(1)] = (8));

} else {
var statearr_21806_21824 = state_21796__$1;
(statearr_21806_21824[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (3))){
var inst_21794 = (state_21796[(2)]);
var state_21796__$1 = state_21796;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21796__$1,inst_21794);
} else {
if((state_val_21797 === (2))){
var state_21796__$1 = state_21796;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21796__$1,(4),ch);
} else {
if((state_val_21797 === (9))){
var inst_21783 = (state_21796[(9)]);
var inst_21776 = inst_21783;
var state_21796__$1 = (function (){var statearr_21807 = state_21796;
(statearr_21807[(7)] = inst_21776);

return statearr_21807;
})();
var statearr_21808_21825 = state_21796__$1;
(statearr_21808_21825[(2)] = null);

(statearr_21808_21825[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (5))){
var inst_21776 = (state_21796[(7)]);
var state_21796__$1 = state_21796;
var statearr_21809_21826 = state_21796__$1;
(statearr_21809_21826[(2)] = inst_21776);

(statearr_21809_21826[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (10))){
var inst_21790 = (state_21796[(2)]);
var state_21796__$1 = state_21796;
var statearr_21810_21827 = state_21796__$1;
(statearr_21810_21827[(2)] = inst_21790);

(statearr_21810_21827[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21797 === (8))){
var inst_21783 = (state_21796[(9)]);
var inst_21786 = cljs.core.deref.call(null,inst_21783);
var state_21796__$1 = state_21796;
var statearr_21811_21828 = state_21796__$1;
(statearr_21811_21828[(2)] = inst_21786);

(statearr_21811_21828[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto__))
;
return ((function (switch__20926__auto__,c__21038__auto__){
return (function() {
var cljs$core$async$reduce_$_state_machine__20927__auto__ = null;
var cljs$core$async$reduce_$_state_machine__20927__auto____0 = (function (){
var statearr_21815 = [null,null,null,null,null,null,null,null,null,null];
(statearr_21815[(0)] = cljs$core$async$reduce_$_state_machine__20927__auto__);

(statearr_21815[(1)] = (1));

return statearr_21815;
});
var cljs$core$async$reduce_$_state_machine__20927__auto____1 = (function (state_21796){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21796);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21816){if((e21816 instanceof Object)){
var ex__20930__auto__ = e21816;
var statearr_21817_21829 = state_21796;
(statearr_21817_21829[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21796);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21816;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21830 = state_21796;
state_21796 = G__21830;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$reduce_$_state_machine__20927__auto__ = function(state_21796){
switch(arguments.length){
case 0:
return cljs$core$async$reduce_$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$reduce_$_state_machine__20927__auto____1.call(this,state_21796);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$reduce_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$reduce_$_state_machine__20927__auto____0;
cljs$core$async$reduce_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$reduce_$_state_machine__20927__auto____1;
return cljs$core$async$reduce_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__))
})();
var state__21040__auto__ = (function (){var statearr_21818 = f__21039__auto__.call(null);
(statearr_21818[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_21818;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__))
);

return c__21038__auto__;
});
/**
 * Puts the contents of coll into the supplied channel.
 * 
 *   By default the channel will be closed after the items are copied,
 *   but can be determined by the close? parameter.
 * 
 *   Returns a channel which will close after the items are copied.
 */
cljs.core.async.onto_chan = (function cljs$core$async$onto_chan(var_args){
var args21831 = [];
var len__19428__auto___21883 = arguments.length;
var i__19429__auto___21884 = (0);
while(true){
if((i__19429__auto___21884 < len__19428__auto___21883)){
args21831.push((arguments[i__19429__auto___21884]));

var G__21885 = (i__19429__auto___21884 + (1));
i__19429__auto___21884 = G__21885;
continue;
} else {
}
break;
}

var G__21833 = args21831.length;
switch (G__21833) {
case 2:
return cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21831.length)].join('')));

}
});

cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$2 = (function (ch,coll){
return cljs.core.async.onto_chan.call(null,ch,coll,true);
});

cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$3 = (function (ch,coll,close_QMARK_){
var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__){
return (function (state_21858){
var state_val_21859 = (state_21858[(1)]);
if((state_val_21859 === (7))){
var inst_21840 = (state_21858[(2)]);
var state_21858__$1 = state_21858;
var statearr_21860_21887 = state_21858__$1;
(statearr_21860_21887[(2)] = inst_21840);

(statearr_21860_21887[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (1))){
var inst_21834 = cljs.core.seq.call(null,coll);
var inst_21835 = inst_21834;
var state_21858__$1 = (function (){var statearr_21861 = state_21858;
(statearr_21861[(7)] = inst_21835);

return statearr_21861;
})();
var statearr_21862_21888 = state_21858__$1;
(statearr_21862_21888[(2)] = null);

(statearr_21862_21888[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (4))){
var inst_21835 = (state_21858[(7)]);
var inst_21838 = cljs.core.first.call(null,inst_21835);
var state_21858__$1 = state_21858;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21858__$1,(7),ch,inst_21838);
} else {
if((state_val_21859 === (13))){
var inst_21852 = (state_21858[(2)]);
var state_21858__$1 = state_21858;
var statearr_21863_21889 = state_21858__$1;
(statearr_21863_21889[(2)] = inst_21852);

(statearr_21863_21889[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (6))){
var inst_21843 = (state_21858[(2)]);
var state_21858__$1 = state_21858;
if(cljs.core.truth_(inst_21843)){
var statearr_21864_21890 = state_21858__$1;
(statearr_21864_21890[(1)] = (8));

} else {
var statearr_21865_21891 = state_21858__$1;
(statearr_21865_21891[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (3))){
var inst_21856 = (state_21858[(2)]);
var state_21858__$1 = state_21858;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21858__$1,inst_21856);
} else {
if((state_val_21859 === (12))){
var state_21858__$1 = state_21858;
var statearr_21866_21892 = state_21858__$1;
(statearr_21866_21892[(2)] = null);

(statearr_21866_21892[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (2))){
var inst_21835 = (state_21858[(7)]);
var state_21858__$1 = state_21858;
if(cljs.core.truth_(inst_21835)){
var statearr_21867_21893 = state_21858__$1;
(statearr_21867_21893[(1)] = (4));

} else {
var statearr_21868_21894 = state_21858__$1;
(statearr_21868_21894[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (11))){
var inst_21849 = cljs.core.async.close_BANG_.call(null,ch);
var state_21858__$1 = state_21858;
var statearr_21869_21895 = state_21858__$1;
(statearr_21869_21895[(2)] = inst_21849);

(statearr_21869_21895[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (9))){
var state_21858__$1 = state_21858;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21870_21896 = state_21858__$1;
(statearr_21870_21896[(1)] = (11));

} else {
var statearr_21871_21897 = state_21858__$1;
(statearr_21871_21897[(1)] = (12));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (5))){
var inst_21835 = (state_21858[(7)]);
var state_21858__$1 = state_21858;
var statearr_21872_21898 = state_21858__$1;
(statearr_21872_21898[(2)] = inst_21835);

(statearr_21872_21898[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (10))){
var inst_21854 = (state_21858[(2)]);
var state_21858__$1 = state_21858;
var statearr_21873_21899 = state_21858__$1;
(statearr_21873_21899[(2)] = inst_21854);

(statearr_21873_21899[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21859 === (8))){
var inst_21835 = (state_21858[(7)]);
var inst_21845 = cljs.core.next.call(null,inst_21835);
var inst_21835__$1 = inst_21845;
var state_21858__$1 = (function (){var statearr_21874 = state_21858;
(statearr_21874[(7)] = inst_21835__$1);

return statearr_21874;
})();
var statearr_21875_21900 = state_21858__$1;
(statearr_21875_21900[(2)] = null);

(statearr_21875_21900[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto__))
;
return ((function (switch__20926__auto__,c__21038__auto__){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_21879 = [null,null,null,null,null,null,null,null];
(statearr_21879[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_21879[(1)] = (1));

return statearr_21879;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_21858){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_21858);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e21880){if((e21880 instanceof Object)){
var ex__20930__auto__ = e21880;
var statearr_21881_21901 = state_21858;
(statearr_21881_21901[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21858);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21880;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21902 = state_21858;
state_21858 = G__21902;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_21858){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_21858);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__))
})();
var state__21040__auto__ = (function (){var statearr_21882 = f__21039__auto__.call(null);
(statearr_21882[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_21882;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__))
);

return c__21038__auto__;
});

cljs.core.async.onto_chan.cljs$lang$maxFixedArity = 3;
/**
 * Creates and returns a channel which contains the contents of coll,
 *   closing when exhausted.
 */
cljs.core.async.to_chan = (function cljs$core$async$to_chan(coll){
var ch = cljs.core.async.chan.call(null,cljs.core.bounded_count.call(null,(100),coll));
cljs.core.async.onto_chan.call(null,ch,coll);

return ch;
});

/**
 * @interface
 */
cljs.core.async.Mux = function(){};

cljs.core.async.muxch_STAR_ = (function cljs$core$async$muxch_STAR_(_){
if((!((_ == null))) && (!((_.cljs$core$async$Mux$muxch_STAR_$arity$1 == null)))){
return _.cljs$core$async$Mux$muxch_STAR_$arity$1(_);
} else {
var x__19025__auto__ = (((_ == null))?null:_);
var m__19026__auto__ = (cljs.core.async.muxch_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,_);
} else {
var m__19026__auto____$1 = (cljs.core.async.muxch_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,_);
} else {
throw cljs.core.missing_protocol.call(null,"Mux.muxch*",_);
}
}
}
});


/**
 * @interface
 */
cljs.core.async.Mult = function(){};

cljs.core.async.tap_STAR_ = (function cljs$core$async$tap_STAR_(m,ch,close_QMARK_){
if((!((m == null))) && (!((m.cljs$core$async$Mult$tap_STAR_$arity$3 == null)))){
return m.cljs$core$async$Mult$tap_STAR_$arity$3(m,ch,close_QMARK_);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.tap_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m,ch,close_QMARK_);
} else {
var m__19026__auto____$1 = (cljs.core.async.tap_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m,ch,close_QMARK_);
} else {
throw cljs.core.missing_protocol.call(null,"Mult.tap*",m);
}
}
}
});

cljs.core.async.untap_STAR_ = (function cljs$core$async$untap_STAR_(m,ch){
if((!((m == null))) && (!((m.cljs$core$async$Mult$untap_STAR_$arity$2 == null)))){
return m.cljs$core$async$Mult$untap_STAR_$arity$2(m,ch);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.untap_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m,ch);
} else {
var m__19026__auto____$1 = (cljs.core.async.untap_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m,ch);
} else {
throw cljs.core.missing_protocol.call(null,"Mult.untap*",m);
}
}
}
});

cljs.core.async.untap_all_STAR_ = (function cljs$core$async$untap_all_STAR_(m){
if((!((m == null))) && (!((m.cljs$core$async$Mult$untap_all_STAR_$arity$1 == null)))){
return m.cljs$core$async$Mult$untap_all_STAR_$arity$1(m);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.untap_all_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m);
} else {
var m__19026__auto____$1 = (cljs.core.async.untap_all_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m);
} else {
throw cljs.core.missing_protocol.call(null,"Mult.untap-all*",m);
}
}
}
});

/**
 * Creates and returns a mult(iple) of the supplied channel. Channels
 *   containing copies of the channel can be created with 'tap', and
 *   detached with 'untap'.
 * 
 *   Each item is distributed to all taps in parallel and synchronously,
 *   i.e. each tap must accept before the next item is distributed. Use
 *   buffering/windowing to prevent slow taps from holding up the mult.
 * 
 *   Items received when there are no taps get dropped.
 * 
 *   If a tap puts to a closed channel, it will be removed from the mult.
 */
cljs.core.async.mult = (function cljs$core$async$mult(ch){
var cs = cljs.core.atom.call(null,cljs.core.PersistentArrayMap.EMPTY);
var m = (function (){
if(typeof cljs.core.async.t_cljs$core$async22124 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.Mult}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22124 = (function (mult,ch,cs,meta22125){
this.mult = mult;
this.ch = ch;
this.cs = cs;
this.meta22125 = meta22125;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (cs){
return (function (_22126,meta22125__$1){
var self__ = this;
var _22126__$1 = this;
return (new cljs.core.async.t_cljs$core$async22124(self__.mult,self__.ch,self__.cs,meta22125__$1));
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (cs){
return (function (_22126){
var self__ = this;
var _22126__$1 = this;
return self__.meta22125;
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (cs){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.ch;
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$async$Mult$ = true;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$async$Mult$tap_STAR_$arity$3 = ((function (cs){
return (function (_,ch__$1,close_QMARK_){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.assoc,ch__$1,close_QMARK_);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$async$Mult$untap_STAR_$arity$2 = ((function (cs){
return (function (_,ch__$1){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.dissoc,ch__$1);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.prototype.cljs$core$async$Mult$untap_all_STAR_$arity$1 = ((function (cs){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.cs,cljs.core.PersistentArrayMap.EMPTY);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.getBasis = ((function (cs){
return (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"mult","mult",-1187640995,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Creates and returns a mult(iple) of the supplied channel. Channels\n  containing copies of the channel can be created with 'tap', and\n  detached with 'untap'.\n\n  Each item is distributed to all taps in parallel and synchronously,\n  i.e. each tap must accept before the next item is distributed. Use\n  buffering/windowing to prevent slow taps from holding up the mult.\n\n  Items received when there are no taps get dropped.\n\n  If a tap puts to a closed channel, it will be removed from the mult."], null)),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"cs","cs",-117024463,null),new cljs.core.Symbol(null,"meta22125","meta22125",-177663841,null)], null);
});})(cs))
;

cljs.core.async.t_cljs$core$async22124.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22124.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22124";

cljs.core.async.t_cljs$core$async22124.cljs$lang$ctorPrWriter = ((function (cs){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22124");
});})(cs))
;

cljs.core.async.__GT_t_cljs$core$async22124 = ((function (cs){
return (function cljs$core$async$mult_$___GT_t_cljs$core$async22124(mult__$1,ch__$1,cs__$1,meta22125){
return (new cljs.core.async.t_cljs$core$async22124(mult__$1,ch__$1,cs__$1,meta22125));
});})(cs))
;

}

return (new cljs.core.async.t_cljs$core$async22124(cljs$core$async$mult,ch,cs,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var dchan = cljs.core.async.chan.call(null,(1));
var dctr = cljs.core.atom.call(null,null);
var done = ((function (cs,m,dchan,dctr){
return (function (_){
if((cljs.core.swap_BANG_.call(null,dctr,cljs.core.dec) === (0))){
return cljs.core.async.put_BANG_.call(null,dchan,true);
} else {
return null;
}
});})(cs,m,dchan,dctr))
;
var c__21038__auto___22345 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___22345,cs,m,dchan,dctr,done){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___22345,cs,m,dchan,dctr,done){
return (function (state_22257){
var state_val_22258 = (state_22257[(1)]);
if((state_val_22258 === (7))){
var inst_22253 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22259_22346 = state_22257__$1;
(statearr_22259_22346[(2)] = inst_22253);

(statearr_22259_22346[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (20))){
var inst_22158 = (state_22257[(7)]);
var inst_22168 = cljs.core.first.call(null,inst_22158);
var inst_22169 = cljs.core.nth.call(null,inst_22168,(0),null);
var inst_22170 = cljs.core.nth.call(null,inst_22168,(1),null);
var state_22257__$1 = (function (){var statearr_22260 = state_22257;
(statearr_22260[(8)] = inst_22169);

return statearr_22260;
})();
if(cljs.core.truth_(inst_22170)){
var statearr_22261_22347 = state_22257__$1;
(statearr_22261_22347[(1)] = (22));

} else {
var statearr_22262_22348 = state_22257__$1;
(statearr_22262_22348[(1)] = (23));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (27))){
var inst_22129 = (state_22257[(9)]);
var inst_22205 = (state_22257[(10)]);
var inst_22200 = (state_22257[(11)]);
var inst_22198 = (state_22257[(12)]);
var inst_22205__$1 = cljs.core._nth.call(null,inst_22198,inst_22200);
var inst_22206 = cljs.core.async.put_BANG_.call(null,inst_22205__$1,inst_22129,done);
var state_22257__$1 = (function (){var statearr_22263 = state_22257;
(statearr_22263[(10)] = inst_22205__$1);

return statearr_22263;
})();
if(cljs.core.truth_(inst_22206)){
var statearr_22264_22349 = state_22257__$1;
(statearr_22264_22349[(1)] = (30));

} else {
var statearr_22265_22350 = state_22257__$1;
(statearr_22265_22350[(1)] = (31));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (1))){
var state_22257__$1 = state_22257;
var statearr_22266_22351 = state_22257__$1;
(statearr_22266_22351[(2)] = null);

(statearr_22266_22351[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (24))){
var inst_22158 = (state_22257[(7)]);
var inst_22175 = (state_22257[(2)]);
var inst_22176 = cljs.core.next.call(null,inst_22158);
var inst_22138 = inst_22176;
var inst_22139 = null;
var inst_22140 = (0);
var inst_22141 = (0);
var state_22257__$1 = (function (){var statearr_22267 = state_22257;
(statearr_22267[(13)] = inst_22175);

(statearr_22267[(14)] = inst_22140);

(statearr_22267[(15)] = inst_22138);

(statearr_22267[(16)] = inst_22139);

(statearr_22267[(17)] = inst_22141);

return statearr_22267;
})();
var statearr_22268_22352 = state_22257__$1;
(statearr_22268_22352[(2)] = null);

(statearr_22268_22352[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (39))){
var state_22257__$1 = state_22257;
var statearr_22272_22353 = state_22257__$1;
(statearr_22272_22353[(2)] = null);

(statearr_22272_22353[(1)] = (41));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (4))){
var inst_22129 = (state_22257[(9)]);
var inst_22129__$1 = (state_22257[(2)]);
var inst_22130 = (inst_22129__$1 == null);
var state_22257__$1 = (function (){var statearr_22273 = state_22257;
(statearr_22273[(9)] = inst_22129__$1);

return statearr_22273;
})();
if(cljs.core.truth_(inst_22130)){
var statearr_22274_22354 = state_22257__$1;
(statearr_22274_22354[(1)] = (5));

} else {
var statearr_22275_22355 = state_22257__$1;
(statearr_22275_22355[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (15))){
var inst_22140 = (state_22257[(14)]);
var inst_22138 = (state_22257[(15)]);
var inst_22139 = (state_22257[(16)]);
var inst_22141 = (state_22257[(17)]);
var inst_22154 = (state_22257[(2)]);
var inst_22155 = (inst_22141 + (1));
var tmp22269 = inst_22140;
var tmp22270 = inst_22138;
var tmp22271 = inst_22139;
var inst_22138__$1 = tmp22270;
var inst_22139__$1 = tmp22271;
var inst_22140__$1 = tmp22269;
var inst_22141__$1 = inst_22155;
var state_22257__$1 = (function (){var statearr_22276 = state_22257;
(statearr_22276[(14)] = inst_22140__$1);

(statearr_22276[(18)] = inst_22154);

(statearr_22276[(15)] = inst_22138__$1);

(statearr_22276[(16)] = inst_22139__$1);

(statearr_22276[(17)] = inst_22141__$1);

return statearr_22276;
})();
var statearr_22277_22356 = state_22257__$1;
(statearr_22277_22356[(2)] = null);

(statearr_22277_22356[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (21))){
var inst_22179 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22281_22357 = state_22257__$1;
(statearr_22281_22357[(2)] = inst_22179);

(statearr_22281_22357[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (31))){
var inst_22205 = (state_22257[(10)]);
var inst_22209 = done.call(null,null);
var inst_22210 = cljs.core.async.untap_STAR_.call(null,m,inst_22205);
var state_22257__$1 = (function (){var statearr_22282 = state_22257;
(statearr_22282[(19)] = inst_22209);

return statearr_22282;
})();
var statearr_22283_22358 = state_22257__$1;
(statearr_22283_22358[(2)] = inst_22210);

(statearr_22283_22358[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (32))){
var inst_22200 = (state_22257[(11)]);
var inst_22199 = (state_22257[(20)]);
var inst_22197 = (state_22257[(21)]);
var inst_22198 = (state_22257[(12)]);
var inst_22212 = (state_22257[(2)]);
var inst_22213 = (inst_22200 + (1));
var tmp22278 = inst_22199;
var tmp22279 = inst_22197;
var tmp22280 = inst_22198;
var inst_22197__$1 = tmp22279;
var inst_22198__$1 = tmp22280;
var inst_22199__$1 = tmp22278;
var inst_22200__$1 = inst_22213;
var state_22257__$1 = (function (){var statearr_22284 = state_22257;
(statearr_22284[(11)] = inst_22200__$1);

(statearr_22284[(20)] = inst_22199__$1);

(statearr_22284[(21)] = inst_22197__$1);

(statearr_22284[(22)] = inst_22212);

(statearr_22284[(12)] = inst_22198__$1);

return statearr_22284;
})();
var statearr_22285_22359 = state_22257__$1;
(statearr_22285_22359[(2)] = null);

(statearr_22285_22359[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (40))){
var inst_22225 = (state_22257[(23)]);
var inst_22229 = done.call(null,null);
var inst_22230 = cljs.core.async.untap_STAR_.call(null,m,inst_22225);
var state_22257__$1 = (function (){var statearr_22286 = state_22257;
(statearr_22286[(24)] = inst_22229);

return statearr_22286;
})();
var statearr_22287_22360 = state_22257__$1;
(statearr_22287_22360[(2)] = inst_22230);

(statearr_22287_22360[(1)] = (41));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (33))){
var inst_22216 = (state_22257[(25)]);
var inst_22218 = cljs.core.chunked_seq_QMARK_.call(null,inst_22216);
var state_22257__$1 = state_22257;
if(inst_22218){
var statearr_22288_22361 = state_22257__$1;
(statearr_22288_22361[(1)] = (36));

} else {
var statearr_22289_22362 = state_22257__$1;
(statearr_22289_22362[(1)] = (37));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (13))){
var inst_22148 = (state_22257[(26)]);
var inst_22151 = cljs.core.async.close_BANG_.call(null,inst_22148);
var state_22257__$1 = state_22257;
var statearr_22290_22363 = state_22257__$1;
(statearr_22290_22363[(2)] = inst_22151);

(statearr_22290_22363[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (22))){
var inst_22169 = (state_22257[(8)]);
var inst_22172 = cljs.core.async.close_BANG_.call(null,inst_22169);
var state_22257__$1 = state_22257;
var statearr_22291_22364 = state_22257__$1;
(statearr_22291_22364[(2)] = inst_22172);

(statearr_22291_22364[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (36))){
var inst_22216 = (state_22257[(25)]);
var inst_22220 = cljs.core.chunk_first.call(null,inst_22216);
var inst_22221 = cljs.core.chunk_rest.call(null,inst_22216);
var inst_22222 = cljs.core.count.call(null,inst_22220);
var inst_22197 = inst_22221;
var inst_22198 = inst_22220;
var inst_22199 = inst_22222;
var inst_22200 = (0);
var state_22257__$1 = (function (){var statearr_22292 = state_22257;
(statearr_22292[(11)] = inst_22200);

(statearr_22292[(20)] = inst_22199);

(statearr_22292[(21)] = inst_22197);

(statearr_22292[(12)] = inst_22198);

return statearr_22292;
})();
var statearr_22293_22365 = state_22257__$1;
(statearr_22293_22365[(2)] = null);

(statearr_22293_22365[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (41))){
var inst_22216 = (state_22257[(25)]);
var inst_22232 = (state_22257[(2)]);
var inst_22233 = cljs.core.next.call(null,inst_22216);
var inst_22197 = inst_22233;
var inst_22198 = null;
var inst_22199 = (0);
var inst_22200 = (0);
var state_22257__$1 = (function (){var statearr_22294 = state_22257;
(statearr_22294[(27)] = inst_22232);

(statearr_22294[(11)] = inst_22200);

(statearr_22294[(20)] = inst_22199);

(statearr_22294[(21)] = inst_22197);

(statearr_22294[(12)] = inst_22198);

return statearr_22294;
})();
var statearr_22295_22366 = state_22257__$1;
(statearr_22295_22366[(2)] = null);

(statearr_22295_22366[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (43))){
var state_22257__$1 = state_22257;
var statearr_22296_22367 = state_22257__$1;
(statearr_22296_22367[(2)] = null);

(statearr_22296_22367[(1)] = (44));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (29))){
var inst_22241 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22297_22368 = state_22257__$1;
(statearr_22297_22368[(2)] = inst_22241);

(statearr_22297_22368[(1)] = (26));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (44))){
var inst_22250 = (state_22257[(2)]);
var state_22257__$1 = (function (){var statearr_22298 = state_22257;
(statearr_22298[(28)] = inst_22250);

return statearr_22298;
})();
var statearr_22299_22369 = state_22257__$1;
(statearr_22299_22369[(2)] = null);

(statearr_22299_22369[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (6))){
var inst_22189 = (state_22257[(29)]);
var inst_22188 = cljs.core.deref.call(null,cs);
var inst_22189__$1 = cljs.core.keys.call(null,inst_22188);
var inst_22190 = cljs.core.count.call(null,inst_22189__$1);
var inst_22191 = cljs.core.reset_BANG_.call(null,dctr,inst_22190);
var inst_22196 = cljs.core.seq.call(null,inst_22189__$1);
var inst_22197 = inst_22196;
var inst_22198 = null;
var inst_22199 = (0);
var inst_22200 = (0);
var state_22257__$1 = (function (){var statearr_22300 = state_22257;
(statearr_22300[(29)] = inst_22189__$1);

(statearr_22300[(11)] = inst_22200);

(statearr_22300[(30)] = inst_22191);

(statearr_22300[(20)] = inst_22199);

(statearr_22300[(21)] = inst_22197);

(statearr_22300[(12)] = inst_22198);

return statearr_22300;
})();
var statearr_22301_22370 = state_22257__$1;
(statearr_22301_22370[(2)] = null);

(statearr_22301_22370[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (28))){
var inst_22197 = (state_22257[(21)]);
var inst_22216 = (state_22257[(25)]);
var inst_22216__$1 = cljs.core.seq.call(null,inst_22197);
var state_22257__$1 = (function (){var statearr_22302 = state_22257;
(statearr_22302[(25)] = inst_22216__$1);

return statearr_22302;
})();
if(inst_22216__$1){
var statearr_22303_22371 = state_22257__$1;
(statearr_22303_22371[(1)] = (33));

} else {
var statearr_22304_22372 = state_22257__$1;
(statearr_22304_22372[(1)] = (34));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (25))){
var inst_22200 = (state_22257[(11)]);
var inst_22199 = (state_22257[(20)]);
var inst_22202 = (inst_22200 < inst_22199);
var inst_22203 = inst_22202;
var state_22257__$1 = state_22257;
if(cljs.core.truth_(inst_22203)){
var statearr_22305_22373 = state_22257__$1;
(statearr_22305_22373[(1)] = (27));

} else {
var statearr_22306_22374 = state_22257__$1;
(statearr_22306_22374[(1)] = (28));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (34))){
var state_22257__$1 = state_22257;
var statearr_22307_22375 = state_22257__$1;
(statearr_22307_22375[(2)] = null);

(statearr_22307_22375[(1)] = (35));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (17))){
var state_22257__$1 = state_22257;
var statearr_22308_22376 = state_22257__$1;
(statearr_22308_22376[(2)] = null);

(statearr_22308_22376[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (3))){
var inst_22255 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22257__$1,inst_22255);
} else {
if((state_val_22258 === (12))){
var inst_22184 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22309_22377 = state_22257__$1;
(statearr_22309_22377[(2)] = inst_22184);

(statearr_22309_22377[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (2))){
var state_22257__$1 = state_22257;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22257__$1,(4),ch);
} else {
if((state_val_22258 === (23))){
var state_22257__$1 = state_22257;
var statearr_22310_22378 = state_22257__$1;
(statearr_22310_22378[(2)] = null);

(statearr_22310_22378[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (35))){
var inst_22239 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22311_22379 = state_22257__$1;
(statearr_22311_22379[(2)] = inst_22239);

(statearr_22311_22379[(1)] = (29));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (19))){
var inst_22158 = (state_22257[(7)]);
var inst_22162 = cljs.core.chunk_first.call(null,inst_22158);
var inst_22163 = cljs.core.chunk_rest.call(null,inst_22158);
var inst_22164 = cljs.core.count.call(null,inst_22162);
var inst_22138 = inst_22163;
var inst_22139 = inst_22162;
var inst_22140 = inst_22164;
var inst_22141 = (0);
var state_22257__$1 = (function (){var statearr_22312 = state_22257;
(statearr_22312[(14)] = inst_22140);

(statearr_22312[(15)] = inst_22138);

(statearr_22312[(16)] = inst_22139);

(statearr_22312[(17)] = inst_22141);

return statearr_22312;
})();
var statearr_22313_22380 = state_22257__$1;
(statearr_22313_22380[(2)] = null);

(statearr_22313_22380[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (11))){
var inst_22158 = (state_22257[(7)]);
var inst_22138 = (state_22257[(15)]);
var inst_22158__$1 = cljs.core.seq.call(null,inst_22138);
var state_22257__$1 = (function (){var statearr_22314 = state_22257;
(statearr_22314[(7)] = inst_22158__$1);

return statearr_22314;
})();
if(inst_22158__$1){
var statearr_22315_22381 = state_22257__$1;
(statearr_22315_22381[(1)] = (16));

} else {
var statearr_22316_22382 = state_22257__$1;
(statearr_22316_22382[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (9))){
var inst_22186 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22317_22383 = state_22257__$1;
(statearr_22317_22383[(2)] = inst_22186);

(statearr_22317_22383[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (5))){
var inst_22136 = cljs.core.deref.call(null,cs);
var inst_22137 = cljs.core.seq.call(null,inst_22136);
var inst_22138 = inst_22137;
var inst_22139 = null;
var inst_22140 = (0);
var inst_22141 = (0);
var state_22257__$1 = (function (){var statearr_22318 = state_22257;
(statearr_22318[(14)] = inst_22140);

(statearr_22318[(15)] = inst_22138);

(statearr_22318[(16)] = inst_22139);

(statearr_22318[(17)] = inst_22141);

return statearr_22318;
})();
var statearr_22319_22384 = state_22257__$1;
(statearr_22319_22384[(2)] = null);

(statearr_22319_22384[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (14))){
var state_22257__$1 = state_22257;
var statearr_22320_22385 = state_22257__$1;
(statearr_22320_22385[(2)] = null);

(statearr_22320_22385[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (45))){
var inst_22247 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22321_22386 = state_22257__$1;
(statearr_22321_22386[(2)] = inst_22247);

(statearr_22321_22386[(1)] = (44));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (26))){
var inst_22189 = (state_22257[(29)]);
var inst_22243 = (state_22257[(2)]);
var inst_22244 = cljs.core.seq.call(null,inst_22189);
var state_22257__$1 = (function (){var statearr_22322 = state_22257;
(statearr_22322[(31)] = inst_22243);

return statearr_22322;
})();
if(inst_22244){
var statearr_22323_22387 = state_22257__$1;
(statearr_22323_22387[(1)] = (42));

} else {
var statearr_22324_22388 = state_22257__$1;
(statearr_22324_22388[(1)] = (43));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (16))){
var inst_22158 = (state_22257[(7)]);
var inst_22160 = cljs.core.chunked_seq_QMARK_.call(null,inst_22158);
var state_22257__$1 = state_22257;
if(inst_22160){
var statearr_22325_22389 = state_22257__$1;
(statearr_22325_22389[(1)] = (19));

} else {
var statearr_22326_22390 = state_22257__$1;
(statearr_22326_22390[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (38))){
var inst_22236 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22327_22391 = state_22257__$1;
(statearr_22327_22391[(2)] = inst_22236);

(statearr_22327_22391[(1)] = (35));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (30))){
var state_22257__$1 = state_22257;
var statearr_22328_22392 = state_22257__$1;
(statearr_22328_22392[(2)] = null);

(statearr_22328_22392[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (10))){
var inst_22139 = (state_22257[(16)]);
var inst_22141 = (state_22257[(17)]);
var inst_22147 = cljs.core._nth.call(null,inst_22139,inst_22141);
var inst_22148 = cljs.core.nth.call(null,inst_22147,(0),null);
var inst_22149 = cljs.core.nth.call(null,inst_22147,(1),null);
var state_22257__$1 = (function (){var statearr_22329 = state_22257;
(statearr_22329[(26)] = inst_22148);

return statearr_22329;
})();
if(cljs.core.truth_(inst_22149)){
var statearr_22330_22393 = state_22257__$1;
(statearr_22330_22393[(1)] = (13));

} else {
var statearr_22331_22394 = state_22257__$1;
(statearr_22331_22394[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (18))){
var inst_22182 = (state_22257[(2)]);
var state_22257__$1 = state_22257;
var statearr_22332_22395 = state_22257__$1;
(statearr_22332_22395[(2)] = inst_22182);

(statearr_22332_22395[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (42))){
var state_22257__$1 = state_22257;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22257__$1,(45),dchan);
} else {
if((state_val_22258 === (37))){
var inst_22129 = (state_22257[(9)]);
var inst_22225 = (state_22257[(23)]);
var inst_22216 = (state_22257[(25)]);
var inst_22225__$1 = cljs.core.first.call(null,inst_22216);
var inst_22226 = cljs.core.async.put_BANG_.call(null,inst_22225__$1,inst_22129,done);
var state_22257__$1 = (function (){var statearr_22333 = state_22257;
(statearr_22333[(23)] = inst_22225__$1);

return statearr_22333;
})();
if(cljs.core.truth_(inst_22226)){
var statearr_22334_22396 = state_22257__$1;
(statearr_22334_22396[(1)] = (39));

} else {
var statearr_22335_22397 = state_22257__$1;
(statearr_22335_22397[(1)] = (40));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22258 === (8))){
var inst_22140 = (state_22257[(14)]);
var inst_22141 = (state_22257[(17)]);
var inst_22143 = (inst_22141 < inst_22140);
var inst_22144 = inst_22143;
var state_22257__$1 = state_22257;
if(cljs.core.truth_(inst_22144)){
var statearr_22336_22398 = state_22257__$1;
(statearr_22336_22398[(1)] = (10));

} else {
var statearr_22337_22399 = state_22257__$1;
(statearr_22337_22399[(1)] = (11));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___22345,cs,m,dchan,dctr,done))
;
return ((function (switch__20926__auto__,c__21038__auto___22345,cs,m,dchan,dctr,done){
return (function() {
var cljs$core$async$mult_$_state_machine__20927__auto__ = null;
var cljs$core$async$mult_$_state_machine__20927__auto____0 = (function (){
var statearr_22341 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22341[(0)] = cljs$core$async$mult_$_state_machine__20927__auto__);

(statearr_22341[(1)] = (1));

return statearr_22341;
});
var cljs$core$async$mult_$_state_machine__20927__auto____1 = (function (state_22257){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_22257);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e22342){if((e22342 instanceof Object)){
var ex__20930__auto__ = e22342;
var statearr_22343_22400 = state_22257;
(statearr_22343_22400[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22257);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22342;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22401 = state_22257;
state_22257 = G__22401;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$mult_$_state_machine__20927__auto__ = function(state_22257){
switch(arguments.length){
case 0:
return cljs$core$async$mult_$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$mult_$_state_machine__20927__auto____1.call(this,state_22257);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mult_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mult_$_state_machine__20927__auto____0;
cljs$core$async$mult_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mult_$_state_machine__20927__auto____1;
return cljs$core$async$mult_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___22345,cs,m,dchan,dctr,done))
})();
var state__21040__auto__ = (function (){var statearr_22344 = f__21039__auto__.call(null);
(statearr_22344[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___22345);

return statearr_22344;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___22345,cs,m,dchan,dctr,done))
);


return m;
});
/**
 * Copies the mult source onto the supplied channel.
 * 
 *   By default the channel will be closed when the source closes,
 *   but can be determined by the close? parameter.
 */
cljs.core.async.tap = (function cljs$core$async$tap(var_args){
var args22402 = [];
var len__19428__auto___22405 = arguments.length;
var i__19429__auto___22406 = (0);
while(true){
if((i__19429__auto___22406 < len__19428__auto___22405)){
args22402.push((arguments[i__19429__auto___22406]));

var G__22407 = (i__19429__auto___22406 + (1));
i__19429__auto___22406 = G__22407;
continue;
} else {
}
break;
}

var G__22404 = args22402.length;
switch (G__22404) {
case 2:
return cljs.core.async.tap.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.tap.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22402.length)].join('')));

}
});

cljs.core.async.tap.cljs$core$IFn$_invoke$arity$2 = (function (mult,ch){
return cljs.core.async.tap.call(null,mult,ch,true);
});

cljs.core.async.tap.cljs$core$IFn$_invoke$arity$3 = (function (mult,ch,close_QMARK_){
cljs.core.async.tap_STAR_.call(null,mult,ch,close_QMARK_);

return ch;
});

cljs.core.async.tap.cljs$lang$maxFixedArity = 3;
/**
 * Disconnects a target channel from a mult
 */
cljs.core.async.untap = (function cljs$core$async$untap(mult,ch){
return cljs.core.async.untap_STAR_.call(null,mult,ch);
});
/**
 * Disconnects all target channels from a mult
 */
cljs.core.async.untap_all = (function cljs$core$async$untap_all(mult){
return cljs.core.async.untap_all_STAR_.call(null,mult);
});

/**
 * @interface
 */
cljs.core.async.Mix = function(){};

cljs.core.async.admix_STAR_ = (function cljs$core$async$admix_STAR_(m,ch){
if((!((m == null))) && (!((m.cljs$core$async$Mix$admix_STAR_$arity$2 == null)))){
return m.cljs$core$async$Mix$admix_STAR_$arity$2(m,ch);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.admix_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m,ch);
} else {
var m__19026__auto____$1 = (cljs.core.async.admix_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m,ch);
} else {
throw cljs.core.missing_protocol.call(null,"Mix.admix*",m);
}
}
}
});

cljs.core.async.unmix_STAR_ = (function cljs$core$async$unmix_STAR_(m,ch){
if((!((m == null))) && (!((m.cljs$core$async$Mix$unmix_STAR_$arity$2 == null)))){
return m.cljs$core$async$Mix$unmix_STAR_$arity$2(m,ch);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.unmix_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m,ch);
} else {
var m__19026__auto____$1 = (cljs.core.async.unmix_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m,ch);
} else {
throw cljs.core.missing_protocol.call(null,"Mix.unmix*",m);
}
}
}
});

cljs.core.async.unmix_all_STAR_ = (function cljs$core$async$unmix_all_STAR_(m){
if((!((m == null))) && (!((m.cljs$core$async$Mix$unmix_all_STAR_$arity$1 == null)))){
return m.cljs$core$async$Mix$unmix_all_STAR_$arity$1(m);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.unmix_all_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m);
} else {
var m__19026__auto____$1 = (cljs.core.async.unmix_all_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m);
} else {
throw cljs.core.missing_protocol.call(null,"Mix.unmix-all*",m);
}
}
}
});

cljs.core.async.toggle_STAR_ = (function cljs$core$async$toggle_STAR_(m,state_map){
if((!((m == null))) && (!((m.cljs$core$async$Mix$toggle_STAR_$arity$2 == null)))){
return m.cljs$core$async$Mix$toggle_STAR_$arity$2(m,state_map);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.toggle_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m,state_map);
} else {
var m__19026__auto____$1 = (cljs.core.async.toggle_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m,state_map);
} else {
throw cljs.core.missing_protocol.call(null,"Mix.toggle*",m);
}
}
}
});

cljs.core.async.solo_mode_STAR_ = (function cljs$core$async$solo_mode_STAR_(m,mode){
if((!((m == null))) && (!((m.cljs$core$async$Mix$solo_mode_STAR_$arity$2 == null)))){
return m.cljs$core$async$Mix$solo_mode_STAR_$arity$2(m,mode);
} else {
var x__19025__auto__ = (((m == null))?null:m);
var m__19026__auto__ = (cljs.core.async.solo_mode_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,m,mode);
} else {
var m__19026__auto____$1 = (cljs.core.async.solo_mode_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,m,mode);
} else {
throw cljs.core.missing_protocol.call(null,"Mix.solo-mode*",m);
}
}
}
});

cljs.core.async.ioc_alts_BANG_ = (function cljs$core$async$ioc_alts_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___22419 = arguments.length;
var i__19429__auto___22420 = (0);
while(true){
if((i__19429__auto___22420 < len__19428__auto___22419)){
args__19435__auto__.push((arguments[i__19429__auto___22420]));

var G__22421 = (i__19429__auto___22420 + (1));
i__19429__auto___22420 = G__22421;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((3) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((3)),(0))):null);
return cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),argseq__19436__auto__);
});

cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (state,cont_block,ports,p__22413){
var map__22414 = p__22413;
var map__22414__$1 = ((((!((map__22414 == null)))?((((map__22414.cljs$lang$protocol_mask$partition0$ & (64))) || (map__22414.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__22414):map__22414);
var opts = map__22414__$1;
var statearr_22416_22422 = state;
(statearr_22416_22422[cljs.core.async.impl.ioc_helpers.STATE_IDX] = cont_block);


var temp__4657__auto__ = cljs.core.async.do_alts.call(null,((function (map__22414,map__22414__$1,opts){
return (function (val){
var statearr_22417_22423 = state;
(statearr_22417_22423[cljs.core.async.impl.ioc_helpers.VALUE_IDX] = val);


return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state);
});})(map__22414,map__22414__$1,opts))
,ports,opts);
if(cljs.core.truth_(temp__4657__auto__)){
var cb = temp__4657__auto__;
var statearr_22418_22424 = state;
(statearr_22418_22424[cljs.core.async.impl.ioc_helpers.VALUE_IDX] = cljs.core.deref.call(null,cb));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
});

cljs.core.async.ioc_alts_BANG_.cljs$lang$maxFixedArity = (3);

cljs.core.async.ioc_alts_BANG_.cljs$lang$applyTo = (function (seq22409){
var G__22410 = cljs.core.first.call(null,seq22409);
var seq22409__$1 = cljs.core.next.call(null,seq22409);
var G__22411 = cljs.core.first.call(null,seq22409__$1);
var seq22409__$2 = cljs.core.next.call(null,seq22409__$1);
var G__22412 = cljs.core.first.call(null,seq22409__$2);
var seq22409__$3 = cljs.core.next.call(null,seq22409__$2);
return cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__22410,G__22411,G__22412,seq22409__$3);
});
/**
 * Creates and returns a mix of one or more input channels which will
 *   be put on the supplied out channel. Input sources can be added to
 *   the mix with 'admix', and removed with 'unmix'. A mix supports
 *   soloing, muting and pausing multiple inputs atomically using
 *   'toggle', and can solo using either muting or pausing as determined
 *   by 'solo-mode'.
 * 
 *   Each channel can have zero or more boolean modes set via 'toggle':
 * 
 *   :solo - when true, only this (ond other soloed) channel(s) will appear
 *        in the mix output channel. :mute and :pause states of soloed
 *        channels are ignored. If solo-mode is :mute, non-soloed
 *        channels are muted, if :pause, non-soloed channels are
 *        paused.
 * 
 *   :mute - muted channels will have their contents consumed but not included in the mix
 *   :pause - paused channels will not have their contents consumed (and thus also not included in the mix)
 */
cljs.core.async.mix = (function cljs$core$async$mix(out){
var cs = cljs.core.atom.call(null,cljs.core.PersistentArrayMap.EMPTY);
var solo_modes = new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"pause","pause",-2095325672),null,new cljs.core.Keyword(null,"mute","mute",1151223646),null], null), null);
var attrs = cljs.core.conj.call(null,solo_modes,new cljs.core.Keyword(null,"solo","solo",-316350075));
var solo_mode = cljs.core.atom.call(null,new cljs.core.Keyword(null,"mute","mute",1151223646));
var change = cljs.core.async.chan.call(null);
var changed = ((function (cs,solo_modes,attrs,solo_mode,change){
return (function (){
return cljs.core.async.put_BANG_.call(null,change,true);
});})(cs,solo_modes,attrs,solo_mode,change))
;
var pick = ((function (cs,solo_modes,attrs,solo_mode,change,changed){
return (function (attr,chs){
return cljs.core.reduce_kv.call(null,((function (cs,solo_modes,attrs,solo_mode,change,changed){
return (function (ret,c,v){
if(cljs.core.truth_(attr.call(null,v))){
return cljs.core.conj.call(null,ret,c);
} else {
return ret;
}
});})(cs,solo_modes,attrs,solo_mode,change,changed))
,cljs.core.PersistentHashSet.EMPTY,chs);
});})(cs,solo_modes,attrs,solo_mode,change,changed))
;
var calc_state = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick){
return (function (){
var chs = cljs.core.deref.call(null,cs);
var mode = cljs.core.deref.call(null,solo_mode);
var solos = pick.call(null,new cljs.core.Keyword(null,"solo","solo",-316350075),chs);
var pauses = pick.call(null,new cljs.core.Keyword(null,"pause","pause",-2095325672),chs);
return new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"solos","solos",1441458643),solos,new cljs.core.Keyword(null,"mutes","mutes",1068806309),pick.call(null,new cljs.core.Keyword(null,"mute","mute",1151223646),chs),new cljs.core.Keyword(null,"reads","reads",-1215067361),cljs.core.conj.call(null,(((cljs.core._EQ_.call(null,mode,new cljs.core.Keyword(null,"pause","pause",-2095325672))) && (!(cljs.core.empty_QMARK_.call(null,solos))))?cljs.core.vec.call(null,solos):cljs.core.vec.call(null,cljs.core.remove.call(null,pauses,cljs.core.keys.call(null,chs)))),change)], null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick))
;
var m = (function (){
if(typeof cljs.core.async.t_cljs$core$async22588 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mix}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22588 = (function (change,mix,solo_mode,pick,cs,calc_state,out,changed,solo_modes,attrs,meta22589){
this.change = change;
this.mix = mix;
this.solo_mode = solo_mode;
this.pick = pick;
this.cs = cs;
this.calc_state = calc_state;
this.out = out;
this.changed = changed;
this.solo_modes = solo_modes;
this.attrs = attrs;
this.meta22589 = meta22589;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_22590,meta22589__$1){
var self__ = this;
var _22590__$1 = this;
return (new cljs.core.async.t_cljs$core$async22588(self__.change,self__.mix,self__.solo_mode,self__.pick,self__.cs,self__.calc_state,self__.out,self__.changed,self__.solo_modes,self__.attrs,meta22589__$1));
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_22590){
var self__ = this;
var _22590__$1 = this;
return self__.meta22589;
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.out;
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mix$ = true;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mix$admix_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,ch){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.assoc,ch,cljs.core.PersistentArrayMap.EMPTY);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mix$unmix_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,ch){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.dissoc,ch);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mix$unmix_all_STAR_$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.cs,cljs.core.PersistentArrayMap.EMPTY);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mix$toggle_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,state_map){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.partial.call(null,cljs.core.merge_with,cljs.core.merge),state_map);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.prototype.cljs$core$async$Mix$solo_mode_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,mode){
var self__ = this;
var ___$1 = this;
if(cljs.core.truth_(self__.solo_modes.call(null,mode))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str([cljs.core.str("mode must be one of: "),cljs.core.str(self__.solo_modes)].join('')),cljs.core.str("\n"),cljs.core.str(cljs.core.pr_str.call(null,cljs.core.list(new cljs.core.Symbol(null,"solo-modes","solo-modes",882180540,null),new cljs.core.Symbol(null,"mode","mode",-2000032078,null))))].join('')));
}

cljs.core.reset_BANG_.call(null,self__.solo_mode,mode);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.getBasis = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (){
return new cljs.core.PersistentVector(null, 11, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"change","change",477485025,null),cljs.core.with_meta(new cljs.core.Symbol(null,"mix","mix",2121373763,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"out","out",729986010,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Creates and returns a mix of one or more input channels which will\n  be put on the supplied out channel. Input sources can be added to\n  the mix with 'admix', and removed with 'unmix'. A mix supports\n  soloing, muting and pausing multiple inputs atomically using\n  'toggle', and can solo using either muting or pausing as determined\n  by 'solo-mode'.\n\n  Each channel can have zero or more boolean modes set via 'toggle':\n\n  :solo - when true, only this (ond other soloed) channel(s) will appear\n          in the mix output channel. :mute and :pause states of soloed\n          channels are ignored. If solo-mode is :mute, non-soloed\n          channels are muted, if :pause, non-soloed channels are\n          paused.\n\n  :mute - muted channels will have their contents consumed but not included in the mix\n  :pause - paused channels will not have their contents consumed (and thus also not included in the mix)\n"], null)),new cljs.core.Symbol(null,"solo-mode","solo-mode",2031788074,null),new cljs.core.Symbol(null,"pick","pick",1300068175,null),new cljs.core.Symbol(null,"cs","cs",-117024463,null),new cljs.core.Symbol(null,"calc-state","calc-state",-349968968,null),new cljs.core.Symbol(null,"out","out",729986010,null),new cljs.core.Symbol(null,"changed","changed",-2083710852,null),new cljs.core.Symbol(null,"solo-modes","solo-modes",882180540,null),new cljs.core.Symbol(null,"attrs","attrs",-450137186,null),new cljs.core.Symbol(null,"meta22589","meta22589",212109135,null)], null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22588.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22588.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22588";

cljs.core.async.t_cljs$core$async22588.cljs$lang$ctorPrWriter = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22588");
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.__GT_t_cljs$core$async22588 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function cljs$core$async$mix_$___GT_t_cljs$core$async22588(change__$1,mix__$1,solo_mode__$1,pick__$1,cs__$1,calc_state__$1,out__$1,changed__$1,solo_modes__$1,attrs__$1,meta22589){
return (new cljs.core.async.t_cljs$core$async22588(change__$1,mix__$1,solo_mode__$1,pick__$1,cs__$1,calc_state__$1,out__$1,changed__$1,solo_modes__$1,attrs__$1,meta22589));
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

}

return (new cljs.core.async.t_cljs$core$async22588(change,cljs$core$async$mix,solo_mode,pick,cs,calc_state,out,changed,solo_modes,attrs,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var c__21038__auto___22751 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___22751,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___22751,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function (state_22688){
var state_val_22689 = (state_22688[(1)]);
if((state_val_22689 === (7))){
var inst_22606 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
var statearr_22690_22752 = state_22688__$1;
(statearr_22690_22752[(2)] = inst_22606);

(statearr_22690_22752[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (20))){
var inst_22618 = (state_22688[(7)]);
var state_22688__$1 = state_22688;
var statearr_22691_22753 = state_22688__$1;
(statearr_22691_22753[(2)] = inst_22618);

(statearr_22691_22753[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (27))){
var state_22688__$1 = state_22688;
var statearr_22692_22754 = state_22688__$1;
(statearr_22692_22754[(2)] = null);

(statearr_22692_22754[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (1))){
var inst_22594 = (state_22688[(8)]);
var inst_22594__$1 = calc_state.call(null);
var inst_22596 = (inst_22594__$1 == null);
var inst_22597 = cljs.core.not.call(null,inst_22596);
var state_22688__$1 = (function (){var statearr_22693 = state_22688;
(statearr_22693[(8)] = inst_22594__$1);

return statearr_22693;
})();
if(inst_22597){
var statearr_22694_22755 = state_22688__$1;
(statearr_22694_22755[(1)] = (2));

} else {
var statearr_22695_22756 = state_22688__$1;
(statearr_22695_22756[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (24))){
var inst_22648 = (state_22688[(9)]);
var inst_22641 = (state_22688[(10)]);
var inst_22662 = (state_22688[(11)]);
var inst_22662__$1 = inst_22641.call(null,inst_22648);
var state_22688__$1 = (function (){var statearr_22696 = state_22688;
(statearr_22696[(11)] = inst_22662__$1);

return statearr_22696;
})();
if(cljs.core.truth_(inst_22662__$1)){
var statearr_22697_22757 = state_22688__$1;
(statearr_22697_22757[(1)] = (29));

} else {
var statearr_22698_22758 = state_22688__$1;
(statearr_22698_22758[(1)] = (30));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (4))){
var inst_22609 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22609)){
var statearr_22699_22759 = state_22688__$1;
(statearr_22699_22759[(1)] = (8));

} else {
var statearr_22700_22760 = state_22688__$1;
(statearr_22700_22760[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (15))){
var inst_22635 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22635)){
var statearr_22701_22761 = state_22688__$1;
(statearr_22701_22761[(1)] = (19));

} else {
var statearr_22702_22762 = state_22688__$1;
(statearr_22702_22762[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (21))){
var inst_22640 = (state_22688[(12)]);
var inst_22640__$1 = (state_22688[(2)]);
var inst_22641 = cljs.core.get.call(null,inst_22640__$1,new cljs.core.Keyword(null,"solos","solos",1441458643));
var inst_22642 = cljs.core.get.call(null,inst_22640__$1,new cljs.core.Keyword(null,"mutes","mutes",1068806309));
var inst_22643 = cljs.core.get.call(null,inst_22640__$1,new cljs.core.Keyword(null,"reads","reads",-1215067361));
var state_22688__$1 = (function (){var statearr_22703 = state_22688;
(statearr_22703[(13)] = inst_22642);

(statearr_22703[(12)] = inst_22640__$1);

(statearr_22703[(10)] = inst_22641);

return statearr_22703;
})();
return cljs.core.async.ioc_alts_BANG_.call(null,state_22688__$1,(22),inst_22643);
} else {
if((state_val_22689 === (31))){
var inst_22670 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22670)){
var statearr_22704_22763 = state_22688__$1;
(statearr_22704_22763[(1)] = (32));

} else {
var statearr_22705_22764 = state_22688__$1;
(statearr_22705_22764[(1)] = (33));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (32))){
var inst_22647 = (state_22688[(14)]);
var state_22688__$1 = state_22688;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_22688__$1,(35),out,inst_22647);
} else {
if((state_val_22689 === (33))){
var inst_22640 = (state_22688[(12)]);
var inst_22618 = inst_22640;
var state_22688__$1 = (function (){var statearr_22706 = state_22688;
(statearr_22706[(7)] = inst_22618);

return statearr_22706;
})();
var statearr_22707_22765 = state_22688__$1;
(statearr_22707_22765[(2)] = null);

(statearr_22707_22765[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (13))){
var inst_22618 = (state_22688[(7)]);
var inst_22625 = inst_22618.cljs$lang$protocol_mask$partition0$;
var inst_22626 = (inst_22625 & (64));
var inst_22627 = inst_22618.cljs$core$ISeq$;
var inst_22628 = (inst_22626) || (inst_22627);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22628)){
var statearr_22708_22766 = state_22688__$1;
(statearr_22708_22766[(1)] = (16));

} else {
var statearr_22709_22767 = state_22688__$1;
(statearr_22709_22767[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (22))){
var inst_22647 = (state_22688[(14)]);
var inst_22648 = (state_22688[(9)]);
var inst_22646 = (state_22688[(2)]);
var inst_22647__$1 = cljs.core.nth.call(null,inst_22646,(0),null);
var inst_22648__$1 = cljs.core.nth.call(null,inst_22646,(1),null);
var inst_22649 = (inst_22647__$1 == null);
var inst_22650 = cljs.core._EQ_.call(null,inst_22648__$1,change);
var inst_22651 = (inst_22649) || (inst_22650);
var state_22688__$1 = (function (){var statearr_22710 = state_22688;
(statearr_22710[(14)] = inst_22647__$1);

(statearr_22710[(9)] = inst_22648__$1);

return statearr_22710;
})();
if(cljs.core.truth_(inst_22651)){
var statearr_22711_22768 = state_22688__$1;
(statearr_22711_22768[(1)] = (23));

} else {
var statearr_22712_22769 = state_22688__$1;
(statearr_22712_22769[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (36))){
var inst_22640 = (state_22688[(12)]);
var inst_22618 = inst_22640;
var state_22688__$1 = (function (){var statearr_22713 = state_22688;
(statearr_22713[(7)] = inst_22618);

return statearr_22713;
})();
var statearr_22714_22770 = state_22688__$1;
(statearr_22714_22770[(2)] = null);

(statearr_22714_22770[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (29))){
var inst_22662 = (state_22688[(11)]);
var state_22688__$1 = state_22688;
var statearr_22715_22771 = state_22688__$1;
(statearr_22715_22771[(2)] = inst_22662);

(statearr_22715_22771[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (6))){
var state_22688__$1 = state_22688;
var statearr_22716_22772 = state_22688__$1;
(statearr_22716_22772[(2)] = false);

(statearr_22716_22772[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (28))){
var inst_22658 = (state_22688[(2)]);
var inst_22659 = calc_state.call(null);
var inst_22618 = inst_22659;
var state_22688__$1 = (function (){var statearr_22717 = state_22688;
(statearr_22717[(7)] = inst_22618);

(statearr_22717[(15)] = inst_22658);

return statearr_22717;
})();
var statearr_22718_22773 = state_22688__$1;
(statearr_22718_22773[(2)] = null);

(statearr_22718_22773[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (25))){
var inst_22684 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
var statearr_22719_22774 = state_22688__$1;
(statearr_22719_22774[(2)] = inst_22684);

(statearr_22719_22774[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (34))){
var inst_22682 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
var statearr_22720_22775 = state_22688__$1;
(statearr_22720_22775[(2)] = inst_22682);

(statearr_22720_22775[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (17))){
var state_22688__$1 = state_22688;
var statearr_22721_22776 = state_22688__$1;
(statearr_22721_22776[(2)] = false);

(statearr_22721_22776[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (3))){
var state_22688__$1 = state_22688;
var statearr_22722_22777 = state_22688__$1;
(statearr_22722_22777[(2)] = false);

(statearr_22722_22777[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (12))){
var inst_22686 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22688__$1,inst_22686);
} else {
if((state_val_22689 === (2))){
var inst_22594 = (state_22688[(8)]);
var inst_22599 = inst_22594.cljs$lang$protocol_mask$partition0$;
var inst_22600 = (inst_22599 & (64));
var inst_22601 = inst_22594.cljs$core$ISeq$;
var inst_22602 = (inst_22600) || (inst_22601);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22602)){
var statearr_22723_22778 = state_22688__$1;
(statearr_22723_22778[(1)] = (5));

} else {
var statearr_22724_22779 = state_22688__$1;
(statearr_22724_22779[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (23))){
var inst_22647 = (state_22688[(14)]);
var inst_22653 = (inst_22647 == null);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22653)){
var statearr_22725_22780 = state_22688__$1;
(statearr_22725_22780[(1)] = (26));

} else {
var statearr_22726_22781 = state_22688__$1;
(statearr_22726_22781[(1)] = (27));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (35))){
var inst_22673 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
if(cljs.core.truth_(inst_22673)){
var statearr_22727_22782 = state_22688__$1;
(statearr_22727_22782[(1)] = (36));

} else {
var statearr_22728_22783 = state_22688__$1;
(statearr_22728_22783[(1)] = (37));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (19))){
var inst_22618 = (state_22688[(7)]);
var inst_22637 = cljs.core.apply.call(null,cljs.core.hash_map,inst_22618);
var state_22688__$1 = state_22688;
var statearr_22729_22784 = state_22688__$1;
(statearr_22729_22784[(2)] = inst_22637);

(statearr_22729_22784[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (11))){
var inst_22618 = (state_22688[(7)]);
var inst_22622 = (inst_22618 == null);
var inst_22623 = cljs.core.not.call(null,inst_22622);
var state_22688__$1 = state_22688;
if(inst_22623){
var statearr_22730_22785 = state_22688__$1;
(statearr_22730_22785[(1)] = (13));

} else {
var statearr_22731_22786 = state_22688__$1;
(statearr_22731_22786[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (9))){
var inst_22594 = (state_22688[(8)]);
var state_22688__$1 = state_22688;
var statearr_22732_22787 = state_22688__$1;
(statearr_22732_22787[(2)] = inst_22594);

(statearr_22732_22787[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (5))){
var state_22688__$1 = state_22688;
var statearr_22733_22788 = state_22688__$1;
(statearr_22733_22788[(2)] = true);

(statearr_22733_22788[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (14))){
var state_22688__$1 = state_22688;
var statearr_22734_22789 = state_22688__$1;
(statearr_22734_22789[(2)] = false);

(statearr_22734_22789[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (26))){
var inst_22648 = (state_22688[(9)]);
var inst_22655 = cljs.core.swap_BANG_.call(null,cs,cljs.core.dissoc,inst_22648);
var state_22688__$1 = state_22688;
var statearr_22735_22790 = state_22688__$1;
(statearr_22735_22790[(2)] = inst_22655);

(statearr_22735_22790[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (16))){
var state_22688__$1 = state_22688;
var statearr_22736_22791 = state_22688__$1;
(statearr_22736_22791[(2)] = true);

(statearr_22736_22791[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (38))){
var inst_22678 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
var statearr_22737_22792 = state_22688__$1;
(statearr_22737_22792[(2)] = inst_22678);

(statearr_22737_22792[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (30))){
var inst_22642 = (state_22688[(13)]);
var inst_22648 = (state_22688[(9)]);
var inst_22641 = (state_22688[(10)]);
var inst_22665 = cljs.core.empty_QMARK_.call(null,inst_22641);
var inst_22666 = inst_22642.call(null,inst_22648);
var inst_22667 = cljs.core.not.call(null,inst_22666);
var inst_22668 = (inst_22665) && (inst_22667);
var state_22688__$1 = state_22688;
var statearr_22738_22793 = state_22688__$1;
(statearr_22738_22793[(2)] = inst_22668);

(statearr_22738_22793[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (10))){
var inst_22594 = (state_22688[(8)]);
var inst_22614 = (state_22688[(2)]);
var inst_22615 = cljs.core.get.call(null,inst_22614,new cljs.core.Keyword(null,"solos","solos",1441458643));
var inst_22616 = cljs.core.get.call(null,inst_22614,new cljs.core.Keyword(null,"mutes","mutes",1068806309));
var inst_22617 = cljs.core.get.call(null,inst_22614,new cljs.core.Keyword(null,"reads","reads",-1215067361));
var inst_22618 = inst_22594;
var state_22688__$1 = (function (){var statearr_22739 = state_22688;
(statearr_22739[(16)] = inst_22615);

(statearr_22739[(17)] = inst_22617);

(statearr_22739[(7)] = inst_22618);

(statearr_22739[(18)] = inst_22616);

return statearr_22739;
})();
var statearr_22740_22794 = state_22688__$1;
(statearr_22740_22794[(2)] = null);

(statearr_22740_22794[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (18))){
var inst_22632 = (state_22688[(2)]);
var state_22688__$1 = state_22688;
var statearr_22741_22795 = state_22688__$1;
(statearr_22741_22795[(2)] = inst_22632);

(statearr_22741_22795[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (37))){
var state_22688__$1 = state_22688;
var statearr_22742_22796 = state_22688__$1;
(statearr_22742_22796[(2)] = null);

(statearr_22742_22796[(1)] = (38));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22689 === (8))){
var inst_22594 = (state_22688[(8)]);
var inst_22611 = cljs.core.apply.call(null,cljs.core.hash_map,inst_22594);
var state_22688__$1 = state_22688;
var statearr_22743_22797 = state_22688__$1;
(statearr_22743_22797[(2)] = inst_22611);

(statearr_22743_22797[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___22751,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
;
return ((function (switch__20926__auto__,c__21038__auto___22751,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function() {
var cljs$core$async$mix_$_state_machine__20927__auto__ = null;
var cljs$core$async$mix_$_state_machine__20927__auto____0 = (function (){
var statearr_22747 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22747[(0)] = cljs$core$async$mix_$_state_machine__20927__auto__);

(statearr_22747[(1)] = (1));

return statearr_22747;
});
var cljs$core$async$mix_$_state_machine__20927__auto____1 = (function (state_22688){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_22688);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e22748){if((e22748 instanceof Object)){
var ex__20930__auto__ = e22748;
var statearr_22749_22798 = state_22688;
(statearr_22749_22798[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22688);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22748;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22799 = state_22688;
state_22688 = G__22799;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$mix_$_state_machine__20927__auto__ = function(state_22688){
switch(arguments.length){
case 0:
return cljs$core$async$mix_$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$mix_$_state_machine__20927__auto____1.call(this,state_22688);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mix_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mix_$_state_machine__20927__auto____0;
cljs$core$async$mix_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mix_$_state_machine__20927__auto____1;
return cljs$core$async$mix_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___22751,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
})();
var state__21040__auto__ = (function (){var statearr_22750 = f__21039__auto__.call(null);
(statearr_22750[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___22751);

return statearr_22750;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___22751,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
);


return m;
});
/**
 * Adds ch as an input to the mix
 */
cljs.core.async.admix = (function cljs$core$async$admix(mix,ch){
return cljs.core.async.admix_STAR_.call(null,mix,ch);
});
/**
 * Removes ch as an input to the mix
 */
cljs.core.async.unmix = (function cljs$core$async$unmix(mix,ch){
return cljs.core.async.unmix_STAR_.call(null,mix,ch);
});
/**
 * removes all inputs from the mix
 */
cljs.core.async.unmix_all = (function cljs$core$async$unmix_all(mix){
return cljs.core.async.unmix_all_STAR_.call(null,mix);
});
/**
 * Atomically sets the state(s) of one or more channels in a mix. The
 *   state map is a map of channels -> channel-state-map. A
 *   channel-state-map is a map of attrs -> boolean, where attr is one or
 *   more of :mute, :pause or :solo. Any states supplied are merged with
 *   the current state.
 * 
 *   Note that channels can be added to a mix via toggle, which can be
 *   used to add channels in a particular (e.g. paused) state.
 */
cljs.core.async.toggle = (function cljs$core$async$toggle(mix,state_map){
return cljs.core.async.toggle_STAR_.call(null,mix,state_map);
});
/**
 * Sets the solo mode of the mix. mode must be one of :mute or :pause
 */
cljs.core.async.solo_mode = (function cljs$core$async$solo_mode(mix,mode){
return cljs.core.async.solo_mode_STAR_.call(null,mix,mode);
});

/**
 * @interface
 */
cljs.core.async.Pub = function(){};

cljs.core.async.sub_STAR_ = (function cljs$core$async$sub_STAR_(p,v,ch,close_QMARK_){
if((!((p == null))) && (!((p.cljs$core$async$Pub$sub_STAR_$arity$4 == null)))){
return p.cljs$core$async$Pub$sub_STAR_$arity$4(p,v,ch,close_QMARK_);
} else {
var x__19025__auto__ = (((p == null))?null:p);
var m__19026__auto__ = (cljs.core.async.sub_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,p,v,ch,close_QMARK_);
} else {
var m__19026__auto____$1 = (cljs.core.async.sub_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,p,v,ch,close_QMARK_);
} else {
throw cljs.core.missing_protocol.call(null,"Pub.sub*",p);
}
}
}
});

cljs.core.async.unsub_STAR_ = (function cljs$core$async$unsub_STAR_(p,v,ch){
if((!((p == null))) && (!((p.cljs$core$async$Pub$unsub_STAR_$arity$3 == null)))){
return p.cljs$core$async$Pub$unsub_STAR_$arity$3(p,v,ch);
} else {
var x__19025__auto__ = (((p == null))?null:p);
var m__19026__auto__ = (cljs.core.async.unsub_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,p,v,ch);
} else {
var m__19026__auto____$1 = (cljs.core.async.unsub_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,p,v,ch);
} else {
throw cljs.core.missing_protocol.call(null,"Pub.unsub*",p);
}
}
}
});

cljs.core.async.unsub_all_STAR_ = (function cljs$core$async$unsub_all_STAR_(var_args){
var args22800 = [];
var len__19428__auto___22803 = arguments.length;
var i__19429__auto___22804 = (0);
while(true){
if((i__19429__auto___22804 < len__19428__auto___22803)){
args22800.push((arguments[i__19429__auto___22804]));

var G__22805 = (i__19429__auto___22804 + (1));
i__19429__auto___22804 = G__22805;
continue;
} else {
}
break;
}

var G__22802 = args22800.length;
switch (G__22802) {
case 1:
return cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22800.length)].join('')));

}
});

cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$1 = (function (p){
if((!((p == null))) && (!((p.cljs$core$async$Pub$unsub_all_STAR_$arity$1 == null)))){
return p.cljs$core$async$Pub$unsub_all_STAR_$arity$1(p);
} else {
var x__19025__auto__ = (((p == null))?null:p);
var m__19026__auto__ = (cljs.core.async.unsub_all_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,p);
} else {
var m__19026__auto____$1 = (cljs.core.async.unsub_all_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,p);
} else {
throw cljs.core.missing_protocol.call(null,"Pub.unsub-all*",p);
}
}
}
});

cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$2 = (function (p,v){
if((!((p == null))) && (!((p.cljs$core$async$Pub$unsub_all_STAR_$arity$2 == null)))){
return p.cljs$core$async$Pub$unsub_all_STAR_$arity$2(p,v);
} else {
var x__19025__auto__ = (((p == null))?null:p);
var m__19026__auto__ = (cljs.core.async.unsub_all_STAR_[goog.typeOf(x__19025__auto__)]);
if(!((m__19026__auto__ == null))){
return m__19026__auto__.call(null,p,v);
} else {
var m__19026__auto____$1 = (cljs.core.async.unsub_all_STAR_["_"]);
if(!((m__19026__auto____$1 == null))){
return m__19026__auto____$1.call(null,p,v);
} else {
throw cljs.core.missing_protocol.call(null,"Pub.unsub-all*",p);
}
}
}
});

cljs.core.async.unsub_all_STAR_.cljs$lang$maxFixedArity = 2;

/**
 * Creates and returns a pub(lication) of the supplied channel,
 *   partitioned into topics by the topic-fn. topic-fn will be applied to
 *   each value on the channel and the result will determine the 'topic'
 *   on which that value will be put. Channels can be subscribed to
 *   receive copies of topics using 'sub', and unsubscribed using
 *   'unsub'. Each topic will be handled by an internal mult on a
 *   dedicated channel. By default these internal channels are
 *   unbuffered, but a buf-fn can be supplied which, given a topic,
 *   creates a buffer with desired properties.
 * 
 *   Each item is distributed to all subs in parallel and synchronously,
 *   i.e. each sub must accept before the next item is distributed. Use
 *   buffering/windowing to prevent slow subs from holding up the pub.
 * 
 *   Items received when there are no matching subs get dropped.
 * 
 *   Note that if buf-fns are used then each topic is handled
 *   asynchronously, i.e. if a channel is subscribed to more than one
 *   topic it should not expect them to be interleaved identically with
 *   the source.
 */
cljs.core.async.pub = (function cljs$core$async$pub(var_args){
var args22808 = [];
var len__19428__auto___22933 = arguments.length;
var i__19429__auto___22934 = (0);
while(true){
if((i__19429__auto___22934 < len__19428__auto___22933)){
args22808.push((arguments[i__19429__auto___22934]));

var G__22935 = (i__19429__auto___22934 + (1));
i__19429__auto___22934 = G__22935;
continue;
} else {
}
break;
}

var G__22810 = args22808.length;
switch (G__22810) {
case 2:
return cljs.core.async.pub.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.pub.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22808.length)].join('')));

}
});

cljs.core.async.pub.cljs$core$IFn$_invoke$arity$2 = (function (ch,topic_fn){
return cljs.core.async.pub.call(null,ch,topic_fn,cljs.core.constantly.call(null,null));
});

cljs.core.async.pub.cljs$core$IFn$_invoke$arity$3 = (function (ch,topic_fn,buf_fn){
var mults = cljs.core.atom.call(null,cljs.core.PersistentArrayMap.EMPTY);
var ensure_mult = ((function (mults){
return (function (topic){
var or__18370__auto__ = cljs.core.get.call(null,cljs.core.deref.call(null,mults),topic);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return cljs.core.get.call(null,cljs.core.swap_BANG_.call(null,mults,((function (or__18370__auto__,mults){
return (function (p1__22807_SHARP_){
if(cljs.core.truth_(p1__22807_SHARP_.call(null,topic))){
return p1__22807_SHARP_;
} else {
return cljs.core.assoc.call(null,p1__22807_SHARP_,topic,cljs.core.async.mult.call(null,cljs.core.async.chan.call(null,buf_fn.call(null,topic))));
}
});})(or__18370__auto__,mults))
),topic);
}
});})(mults))
;
var p = (function (){
if(typeof cljs.core.async.t_cljs$core$async22811 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.Pub}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22811 = (function (ch,topic_fn,buf_fn,mults,ensure_mult,meta22812){
this.ch = ch;
this.topic_fn = topic_fn;
this.buf_fn = buf_fn;
this.mults = mults;
this.ensure_mult = ensure_mult;
this.meta22812 = meta22812;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (mults,ensure_mult){
return (function (_22813,meta22812__$1){
var self__ = this;
var _22813__$1 = this;
return (new cljs.core.async.t_cljs$core$async22811(self__.ch,self__.topic_fn,self__.buf_fn,self__.mults,self__.ensure_mult,meta22812__$1));
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (mults,ensure_mult){
return (function (_22813){
var self__ = this;
var _22813__$1 = this;
return self__.meta22812;
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (mults,ensure_mult){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.ch;
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Pub$ = true;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Pub$sub_STAR_$arity$4 = ((function (mults,ensure_mult){
return (function (p,topic,ch__$1,close_QMARK_){
var self__ = this;
var p__$1 = this;
var m = self__.ensure_mult.call(null,topic);
return cljs.core.async.tap.call(null,m,ch__$1,close_QMARK_);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Pub$unsub_STAR_$arity$3 = ((function (mults,ensure_mult){
return (function (p,topic,ch__$1){
var self__ = this;
var p__$1 = this;
var temp__4657__auto__ = cljs.core.get.call(null,cljs.core.deref.call(null,self__.mults),topic);
if(cljs.core.truth_(temp__4657__auto__)){
var m = temp__4657__auto__;
return cljs.core.async.untap.call(null,m,ch__$1);
} else {
return null;
}
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Pub$unsub_all_STAR_$arity$1 = ((function (mults,ensure_mult){
return (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.reset_BANG_.call(null,self__.mults,cljs.core.PersistentArrayMap.EMPTY);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.prototype.cljs$core$async$Pub$unsub_all_STAR_$arity$2 = ((function (mults,ensure_mult){
return (function (_,topic){
var self__ = this;
var ___$1 = this;
return cljs.core.swap_BANG_.call(null,self__.mults,cljs.core.dissoc,topic);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.getBasis = ((function (mults,ensure_mult){
return (function (){
return new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"topic-fn","topic-fn",-862449736,null),new cljs.core.Symbol(null,"buf-fn","buf-fn",-1200281591,null),new cljs.core.Symbol(null,"mults","mults",-461114485,null),new cljs.core.Symbol(null,"ensure-mult","ensure-mult",1796584816,null),new cljs.core.Symbol(null,"meta22812","meta22812",-620018170,null)], null);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22811.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22811.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22811";

cljs.core.async.t_cljs$core$async22811.cljs$lang$ctorPrWriter = ((function (mults,ensure_mult){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22811");
});})(mults,ensure_mult))
;

cljs.core.async.__GT_t_cljs$core$async22811 = ((function (mults,ensure_mult){
return (function cljs$core$async$__GT_t_cljs$core$async22811(ch__$1,topic_fn__$1,buf_fn__$1,mults__$1,ensure_mult__$1,meta22812){
return (new cljs.core.async.t_cljs$core$async22811(ch__$1,topic_fn__$1,buf_fn__$1,mults__$1,ensure_mult__$1,meta22812));
});})(mults,ensure_mult))
;

}

return (new cljs.core.async.t_cljs$core$async22811(ch,topic_fn,buf_fn,mults,ensure_mult,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var c__21038__auto___22937 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___22937,mults,ensure_mult,p){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___22937,mults,ensure_mult,p){
return (function (state_22885){
var state_val_22886 = (state_22885[(1)]);
if((state_val_22886 === (7))){
var inst_22881 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
var statearr_22887_22938 = state_22885__$1;
(statearr_22887_22938[(2)] = inst_22881);

(statearr_22887_22938[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (20))){
var state_22885__$1 = state_22885;
var statearr_22888_22939 = state_22885__$1;
(statearr_22888_22939[(2)] = null);

(statearr_22888_22939[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (1))){
var state_22885__$1 = state_22885;
var statearr_22889_22940 = state_22885__$1;
(statearr_22889_22940[(2)] = null);

(statearr_22889_22940[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (24))){
var inst_22864 = (state_22885[(7)]);
var inst_22873 = cljs.core.swap_BANG_.call(null,mults,cljs.core.dissoc,inst_22864);
var state_22885__$1 = state_22885;
var statearr_22890_22941 = state_22885__$1;
(statearr_22890_22941[(2)] = inst_22873);

(statearr_22890_22941[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (4))){
var inst_22816 = (state_22885[(8)]);
var inst_22816__$1 = (state_22885[(2)]);
var inst_22817 = (inst_22816__$1 == null);
var state_22885__$1 = (function (){var statearr_22891 = state_22885;
(statearr_22891[(8)] = inst_22816__$1);

return statearr_22891;
})();
if(cljs.core.truth_(inst_22817)){
var statearr_22892_22942 = state_22885__$1;
(statearr_22892_22942[(1)] = (5));

} else {
var statearr_22893_22943 = state_22885__$1;
(statearr_22893_22943[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (15))){
var inst_22858 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
var statearr_22894_22944 = state_22885__$1;
(statearr_22894_22944[(2)] = inst_22858);

(statearr_22894_22944[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (21))){
var inst_22878 = (state_22885[(2)]);
var state_22885__$1 = (function (){var statearr_22895 = state_22885;
(statearr_22895[(9)] = inst_22878);

return statearr_22895;
})();
var statearr_22896_22945 = state_22885__$1;
(statearr_22896_22945[(2)] = null);

(statearr_22896_22945[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (13))){
var inst_22840 = (state_22885[(10)]);
var inst_22842 = cljs.core.chunked_seq_QMARK_.call(null,inst_22840);
var state_22885__$1 = state_22885;
if(inst_22842){
var statearr_22897_22946 = state_22885__$1;
(statearr_22897_22946[(1)] = (16));

} else {
var statearr_22898_22947 = state_22885__$1;
(statearr_22898_22947[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (22))){
var inst_22870 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
if(cljs.core.truth_(inst_22870)){
var statearr_22899_22948 = state_22885__$1;
(statearr_22899_22948[(1)] = (23));

} else {
var statearr_22900_22949 = state_22885__$1;
(statearr_22900_22949[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (6))){
var inst_22866 = (state_22885[(11)]);
var inst_22816 = (state_22885[(8)]);
var inst_22864 = (state_22885[(7)]);
var inst_22864__$1 = topic_fn.call(null,inst_22816);
var inst_22865 = cljs.core.deref.call(null,mults);
var inst_22866__$1 = cljs.core.get.call(null,inst_22865,inst_22864__$1);
var state_22885__$1 = (function (){var statearr_22901 = state_22885;
(statearr_22901[(11)] = inst_22866__$1);

(statearr_22901[(7)] = inst_22864__$1);

return statearr_22901;
})();
if(cljs.core.truth_(inst_22866__$1)){
var statearr_22902_22950 = state_22885__$1;
(statearr_22902_22950[(1)] = (19));

} else {
var statearr_22903_22951 = state_22885__$1;
(statearr_22903_22951[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (25))){
var inst_22875 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
var statearr_22904_22952 = state_22885__$1;
(statearr_22904_22952[(2)] = inst_22875);

(statearr_22904_22952[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (17))){
var inst_22840 = (state_22885[(10)]);
var inst_22849 = cljs.core.first.call(null,inst_22840);
var inst_22850 = cljs.core.async.muxch_STAR_.call(null,inst_22849);
var inst_22851 = cljs.core.async.close_BANG_.call(null,inst_22850);
var inst_22852 = cljs.core.next.call(null,inst_22840);
var inst_22826 = inst_22852;
var inst_22827 = null;
var inst_22828 = (0);
var inst_22829 = (0);
var state_22885__$1 = (function (){var statearr_22905 = state_22885;
(statearr_22905[(12)] = inst_22828);

(statearr_22905[(13)] = inst_22851);

(statearr_22905[(14)] = inst_22826);

(statearr_22905[(15)] = inst_22827);

(statearr_22905[(16)] = inst_22829);

return statearr_22905;
})();
var statearr_22906_22953 = state_22885__$1;
(statearr_22906_22953[(2)] = null);

(statearr_22906_22953[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (3))){
var inst_22883 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22885__$1,inst_22883);
} else {
if((state_val_22886 === (12))){
var inst_22860 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
var statearr_22907_22954 = state_22885__$1;
(statearr_22907_22954[(2)] = inst_22860);

(statearr_22907_22954[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (2))){
var state_22885__$1 = state_22885;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22885__$1,(4),ch);
} else {
if((state_val_22886 === (23))){
var state_22885__$1 = state_22885;
var statearr_22908_22955 = state_22885__$1;
(statearr_22908_22955[(2)] = null);

(statearr_22908_22955[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (19))){
var inst_22866 = (state_22885[(11)]);
var inst_22816 = (state_22885[(8)]);
var inst_22868 = cljs.core.async.muxch_STAR_.call(null,inst_22866);
var state_22885__$1 = state_22885;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_22885__$1,(22),inst_22868,inst_22816);
} else {
if((state_val_22886 === (11))){
var inst_22840 = (state_22885[(10)]);
var inst_22826 = (state_22885[(14)]);
var inst_22840__$1 = cljs.core.seq.call(null,inst_22826);
var state_22885__$1 = (function (){var statearr_22909 = state_22885;
(statearr_22909[(10)] = inst_22840__$1);

return statearr_22909;
})();
if(inst_22840__$1){
var statearr_22910_22956 = state_22885__$1;
(statearr_22910_22956[(1)] = (13));

} else {
var statearr_22911_22957 = state_22885__$1;
(statearr_22911_22957[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (9))){
var inst_22862 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
var statearr_22912_22958 = state_22885__$1;
(statearr_22912_22958[(2)] = inst_22862);

(statearr_22912_22958[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (5))){
var inst_22823 = cljs.core.deref.call(null,mults);
var inst_22824 = cljs.core.vals.call(null,inst_22823);
var inst_22825 = cljs.core.seq.call(null,inst_22824);
var inst_22826 = inst_22825;
var inst_22827 = null;
var inst_22828 = (0);
var inst_22829 = (0);
var state_22885__$1 = (function (){var statearr_22913 = state_22885;
(statearr_22913[(12)] = inst_22828);

(statearr_22913[(14)] = inst_22826);

(statearr_22913[(15)] = inst_22827);

(statearr_22913[(16)] = inst_22829);

return statearr_22913;
})();
var statearr_22914_22959 = state_22885__$1;
(statearr_22914_22959[(2)] = null);

(statearr_22914_22959[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (14))){
var state_22885__$1 = state_22885;
var statearr_22918_22960 = state_22885__$1;
(statearr_22918_22960[(2)] = null);

(statearr_22918_22960[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (16))){
var inst_22840 = (state_22885[(10)]);
var inst_22844 = cljs.core.chunk_first.call(null,inst_22840);
var inst_22845 = cljs.core.chunk_rest.call(null,inst_22840);
var inst_22846 = cljs.core.count.call(null,inst_22844);
var inst_22826 = inst_22845;
var inst_22827 = inst_22844;
var inst_22828 = inst_22846;
var inst_22829 = (0);
var state_22885__$1 = (function (){var statearr_22919 = state_22885;
(statearr_22919[(12)] = inst_22828);

(statearr_22919[(14)] = inst_22826);

(statearr_22919[(15)] = inst_22827);

(statearr_22919[(16)] = inst_22829);

return statearr_22919;
})();
var statearr_22920_22961 = state_22885__$1;
(statearr_22920_22961[(2)] = null);

(statearr_22920_22961[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (10))){
var inst_22828 = (state_22885[(12)]);
var inst_22826 = (state_22885[(14)]);
var inst_22827 = (state_22885[(15)]);
var inst_22829 = (state_22885[(16)]);
var inst_22834 = cljs.core._nth.call(null,inst_22827,inst_22829);
var inst_22835 = cljs.core.async.muxch_STAR_.call(null,inst_22834);
var inst_22836 = cljs.core.async.close_BANG_.call(null,inst_22835);
var inst_22837 = (inst_22829 + (1));
var tmp22915 = inst_22828;
var tmp22916 = inst_22826;
var tmp22917 = inst_22827;
var inst_22826__$1 = tmp22916;
var inst_22827__$1 = tmp22917;
var inst_22828__$1 = tmp22915;
var inst_22829__$1 = inst_22837;
var state_22885__$1 = (function (){var statearr_22921 = state_22885;
(statearr_22921[(12)] = inst_22828__$1);

(statearr_22921[(17)] = inst_22836);

(statearr_22921[(14)] = inst_22826__$1);

(statearr_22921[(15)] = inst_22827__$1);

(statearr_22921[(16)] = inst_22829__$1);

return statearr_22921;
})();
var statearr_22922_22962 = state_22885__$1;
(statearr_22922_22962[(2)] = null);

(statearr_22922_22962[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (18))){
var inst_22855 = (state_22885[(2)]);
var state_22885__$1 = state_22885;
var statearr_22923_22963 = state_22885__$1;
(statearr_22923_22963[(2)] = inst_22855);

(statearr_22923_22963[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22886 === (8))){
var inst_22828 = (state_22885[(12)]);
var inst_22829 = (state_22885[(16)]);
var inst_22831 = (inst_22829 < inst_22828);
var inst_22832 = inst_22831;
var state_22885__$1 = state_22885;
if(cljs.core.truth_(inst_22832)){
var statearr_22924_22964 = state_22885__$1;
(statearr_22924_22964[(1)] = (10));

} else {
var statearr_22925_22965 = state_22885__$1;
(statearr_22925_22965[(1)] = (11));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___22937,mults,ensure_mult,p))
;
return ((function (switch__20926__auto__,c__21038__auto___22937,mults,ensure_mult,p){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_22929 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22929[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_22929[(1)] = (1));

return statearr_22929;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_22885){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_22885);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e22930){if((e22930 instanceof Object)){
var ex__20930__auto__ = e22930;
var statearr_22931_22966 = state_22885;
(statearr_22931_22966[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22885);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22930;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22967 = state_22885;
state_22885 = G__22967;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_22885){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_22885);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___22937,mults,ensure_mult,p))
})();
var state__21040__auto__ = (function (){var statearr_22932 = f__21039__auto__.call(null);
(statearr_22932[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___22937);

return statearr_22932;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___22937,mults,ensure_mult,p))
);


return p;
});

cljs.core.async.pub.cljs$lang$maxFixedArity = 3;
/**
 * Subscribes a channel to a topic of a pub.
 * 
 *   By default the channel will be closed when the source closes,
 *   but can be determined by the close? parameter.
 */
cljs.core.async.sub = (function cljs$core$async$sub(var_args){
var args22968 = [];
var len__19428__auto___22971 = arguments.length;
var i__19429__auto___22972 = (0);
while(true){
if((i__19429__auto___22972 < len__19428__auto___22971)){
args22968.push((arguments[i__19429__auto___22972]));

var G__22973 = (i__19429__auto___22972 + (1));
i__19429__auto___22972 = G__22973;
continue;
} else {
}
break;
}

var G__22970 = args22968.length;
switch (G__22970) {
case 3:
return cljs.core.async.sub.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
case 4:
return cljs.core.async.sub.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22968.length)].join('')));

}
});

cljs.core.async.sub.cljs$core$IFn$_invoke$arity$3 = (function (p,topic,ch){
return cljs.core.async.sub.call(null,p,topic,ch,true);
});

cljs.core.async.sub.cljs$core$IFn$_invoke$arity$4 = (function (p,topic,ch,close_QMARK_){
return cljs.core.async.sub_STAR_.call(null,p,topic,ch,close_QMARK_);
});

cljs.core.async.sub.cljs$lang$maxFixedArity = 4;
/**
 * Unsubscribes a channel from a topic of a pub
 */
cljs.core.async.unsub = (function cljs$core$async$unsub(p,topic,ch){
return cljs.core.async.unsub_STAR_.call(null,p,topic,ch);
});
/**
 * Unsubscribes all channels from a pub, or a topic of a pub
 */
cljs.core.async.unsub_all = (function cljs$core$async$unsub_all(var_args){
var args22975 = [];
var len__19428__auto___22978 = arguments.length;
var i__19429__auto___22979 = (0);
while(true){
if((i__19429__auto___22979 < len__19428__auto___22978)){
args22975.push((arguments[i__19429__auto___22979]));

var G__22980 = (i__19429__auto___22979 + (1));
i__19429__auto___22979 = G__22980;
continue;
} else {
}
break;
}

var G__22977 = args22975.length;
switch (G__22977) {
case 1:
return cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22975.length)].join('')));

}
});

cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$1 = (function (p){
return cljs.core.async.unsub_all_STAR_.call(null,p);
});

cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$2 = (function (p,topic){
return cljs.core.async.unsub_all_STAR_.call(null,p,topic);
});

cljs.core.async.unsub_all.cljs$lang$maxFixedArity = 2;
/**
 * Takes a function and a collection of source channels, and returns a
 *   channel which contains the values produced by applying f to the set
 *   of first items taken from each source channel, followed by applying
 *   f to the set of second items from each channel, until any one of the
 *   channels is closed, at which point the output channel will be
 *   closed. The returned channel will be unbuffered by default, or a
 *   buf-or-n can be supplied
 */
cljs.core.async.map = (function cljs$core$async$map(var_args){
var args22982 = [];
var len__19428__auto___23053 = arguments.length;
var i__19429__auto___23054 = (0);
while(true){
if((i__19429__auto___23054 < len__19428__auto___23053)){
args22982.push((arguments[i__19429__auto___23054]));

var G__23055 = (i__19429__auto___23054 + (1));
i__19429__auto___23054 = G__23055;
continue;
} else {
}
break;
}

var G__22984 = args22982.length;
switch (G__22984) {
case 2:
return cljs.core.async.map.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.map.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22982.length)].join('')));

}
});

cljs.core.async.map.cljs$core$IFn$_invoke$arity$2 = (function (f,chs){
return cljs.core.async.map.call(null,f,chs,null);
});

cljs.core.async.map.cljs$core$IFn$_invoke$arity$3 = (function (f,chs,buf_or_n){
var chs__$1 = cljs.core.vec.call(null,chs);
var out = cljs.core.async.chan.call(null,buf_or_n);
var cnt = cljs.core.count.call(null,chs__$1);
var rets = cljs.core.object_array.call(null,cnt);
var dchan = cljs.core.async.chan.call(null,(1));
var dctr = cljs.core.atom.call(null,null);
var done = cljs.core.mapv.call(null,((function (chs__$1,out,cnt,rets,dchan,dctr){
return (function (i){
return ((function (chs__$1,out,cnt,rets,dchan,dctr){
return (function (ret){
(rets[i] = ret);

if((cljs.core.swap_BANG_.call(null,dctr,cljs.core.dec) === (0))){
return cljs.core.async.put_BANG_.call(null,dchan,rets.slice((0)));
} else {
return null;
}
});
;})(chs__$1,out,cnt,rets,dchan,dctr))
});})(chs__$1,out,cnt,rets,dchan,dctr))
,cljs.core.range.call(null,cnt));
var c__21038__auto___23057 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23057,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23057,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function (state_23023){
var state_val_23024 = (state_23023[(1)]);
if((state_val_23024 === (7))){
var state_23023__$1 = state_23023;
var statearr_23025_23058 = state_23023__$1;
(statearr_23025_23058[(2)] = null);

(statearr_23025_23058[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (1))){
var state_23023__$1 = state_23023;
var statearr_23026_23059 = state_23023__$1;
(statearr_23026_23059[(2)] = null);

(statearr_23026_23059[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (4))){
var inst_22987 = (state_23023[(7)]);
var inst_22989 = (inst_22987 < cnt);
var state_23023__$1 = state_23023;
if(cljs.core.truth_(inst_22989)){
var statearr_23027_23060 = state_23023__$1;
(statearr_23027_23060[(1)] = (6));

} else {
var statearr_23028_23061 = state_23023__$1;
(statearr_23028_23061[(1)] = (7));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (15))){
var inst_23019 = (state_23023[(2)]);
var state_23023__$1 = state_23023;
var statearr_23029_23062 = state_23023__$1;
(statearr_23029_23062[(2)] = inst_23019);

(statearr_23029_23062[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (13))){
var inst_23012 = cljs.core.async.close_BANG_.call(null,out);
var state_23023__$1 = state_23023;
var statearr_23030_23063 = state_23023__$1;
(statearr_23030_23063[(2)] = inst_23012);

(statearr_23030_23063[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (6))){
var state_23023__$1 = state_23023;
var statearr_23031_23064 = state_23023__$1;
(statearr_23031_23064[(2)] = null);

(statearr_23031_23064[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (3))){
var inst_23021 = (state_23023[(2)]);
var state_23023__$1 = state_23023;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23023__$1,inst_23021);
} else {
if((state_val_23024 === (12))){
var inst_23009 = (state_23023[(8)]);
var inst_23009__$1 = (state_23023[(2)]);
var inst_23010 = cljs.core.some.call(null,cljs.core.nil_QMARK_,inst_23009__$1);
var state_23023__$1 = (function (){var statearr_23032 = state_23023;
(statearr_23032[(8)] = inst_23009__$1);

return statearr_23032;
})();
if(cljs.core.truth_(inst_23010)){
var statearr_23033_23065 = state_23023__$1;
(statearr_23033_23065[(1)] = (13));

} else {
var statearr_23034_23066 = state_23023__$1;
(statearr_23034_23066[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (2))){
var inst_22986 = cljs.core.reset_BANG_.call(null,dctr,cnt);
var inst_22987 = (0);
var state_23023__$1 = (function (){var statearr_23035 = state_23023;
(statearr_23035[(7)] = inst_22987);

(statearr_23035[(9)] = inst_22986);

return statearr_23035;
})();
var statearr_23036_23067 = state_23023__$1;
(statearr_23036_23067[(2)] = null);

(statearr_23036_23067[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (11))){
var inst_22987 = (state_23023[(7)]);
var _ = cljs.core.async.impl.ioc_helpers.add_exception_frame.call(null,state_23023,(10),Object,null,(9));
var inst_22996 = chs__$1.call(null,inst_22987);
var inst_22997 = done.call(null,inst_22987);
var inst_22998 = cljs.core.async.take_BANG_.call(null,inst_22996,inst_22997);
var state_23023__$1 = state_23023;
var statearr_23037_23068 = state_23023__$1;
(statearr_23037_23068[(2)] = inst_22998);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23023__$1);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (9))){
var inst_22987 = (state_23023[(7)]);
var inst_23000 = (state_23023[(2)]);
var inst_23001 = (inst_22987 + (1));
var inst_22987__$1 = inst_23001;
var state_23023__$1 = (function (){var statearr_23038 = state_23023;
(statearr_23038[(10)] = inst_23000);

(statearr_23038[(7)] = inst_22987__$1);

return statearr_23038;
})();
var statearr_23039_23069 = state_23023__$1;
(statearr_23039_23069[(2)] = null);

(statearr_23039_23069[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (5))){
var inst_23007 = (state_23023[(2)]);
var state_23023__$1 = (function (){var statearr_23040 = state_23023;
(statearr_23040[(11)] = inst_23007);

return statearr_23040;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23023__$1,(12),dchan);
} else {
if((state_val_23024 === (14))){
var inst_23009 = (state_23023[(8)]);
var inst_23014 = cljs.core.apply.call(null,f,inst_23009);
var state_23023__$1 = state_23023;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23023__$1,(16),out,inst_23014);
} else {
if((state_val_23024 === (16))){
var inst_23016 = (state_23023[(2)]);
var state_23023__$1 = (function (){var statearr_23041 = state_23023;
(statearr_23041[(12)] = inst_23016);

return statearr_23041;
})();
var statearr_23042_23070 = state_23023__$1;
(statearr_23042_23070[(2)] = null);

(statearr_23042_23070[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (10))){
var inst_22991 = (state_23023[(2)]);
var inst_22992 = cljs.core.swap_BANG_.call(null,dctr,cljs.core.dec);
var state_23023__$1 = (function (){var statearr_23043 = state_23023;
(statearr_23043[(13)] = inst_22991);

return statearr_23043;
})();
var statearr_23044_23071 = state_23023__$1;
(statearr_23044_23071[(2)] = inst_22992);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23023__$1);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23024 === (8))){
var inst_23005 = (state_23023[(2)]);
var state_23023__$1 = state_23023;
var statearr_23045_23072 = state_23023__$1;
(statearr_23045_23072[(2)] = inst_23005);

(statearr_23045_23072[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23057,chs__$1,out,cnt,rets,dchan,dctr,done))
;
return ((function (switch__20926__auto__,c__21038__auto___23057,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23049 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23049[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23049[(1)] = (1));

return statearr_23049;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23023){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23023);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23050){if((e23050 instanceof Object)){
var ex__20930__auto__ = e23050;
var statearr_23051_23073 = state_23023;
(statearr_23051_23073[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23023);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23050;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23074 = state_23023;
state_23023 = G__23074;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23023){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23023);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23057,chs__$1,out,cnt,rets,dchan,dctr,done))
})();
var state__21040__auto__ = (function (){var statearr_23052 = f__21039__auto__.call(null);
(statearr_23052[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23057);

return statearr_23052;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23057,chs__$1,out,cnt,rets,dchan,dctr,done))
);


return out;
});

cljs.core.async.map.cljs$lang$maxFixedArity = 3;
/**
 * Takes a collection of source channels and returns a channel which
 *   contains all values taken from them. The returned channel will be
 *   unbuffered by default, or a buf-or-n can be supplied. The channel
 *   will close after all the source channels have closed.
 */
cljs.core.async.merge = (function cljs$core$async$merge(var_args){
var args23076 = [];
var len__19428__auto___23132 = arguments.length;
var i__19429__auto___23133 = (0);
while(true){
if((i__19429__auto___23133 < len__19428__auto___23132)){
args23076.push((arguments[i__19429__auto___23133]));

var G__23134 = (i__19429__auto___23133 + (1));
i__19429__auto___23133 = G__23134;
continue;
} else {
}
break;
}

var G__23078 = args23076.length;
switch (G__23078) {
case 1:
return cljs.core.async.merge.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.merge.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23076.length)].join('')));

}
});

cljs.core.async.merge.cljs$core$IFn$_invoke$arity$1 = (function (chs){
return cljs.core.async.merge.call(null,chs,null);
});

cljs.core.async.merge.cljs$core$IFn$_invoke$arity$2 = (function (chs,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21038__auto___23136 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23136,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23136,out){
return (function (state_23108){
var state_val_23109 = (state_23108[(1)]);
if((state_val_23109 === (7))){
var inst_23087 = (state_23108[(7)]);
var inst_23088 = (state_23108[(8)]);
var inst_23087__$1 = (state_23108[(2)]);
var inst_23088__$1 = cljs.core.nth.call(null,inst_23087__$1,(0),null);
var inst_23089 = cljs.core.nth.call(null,inst_23087__$1,(1),null);
var inst_23090 = (inst_23088__$1 == null);
var state_23108__$1 = (function (){var statearr_23110 = state_23108;
(statearr_23110[(7)] = inst_23087__$1);

(statearr_23110[(9)] = inst_23089);

(statearr_23110[(8)] = inst_23088__$1);

return statearr_23110;
})();
if(cljs.core.truth_(inst_23090)){
var statearr_23111_23137 = state_23108__$1;
(statearr_23111_23137[(1)] = (8));

} else {
var statearr_23112_23138 = state_23108__$1;
(statearr_23112_23138[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (1))){
var inst_23079 = cljs.core.vec.call(null,chs);
var inst_23080 = inst_23079;
var state_23108__$1 = (function (){var statearr_23113 = state_23108;
(statearr_23113[(10)] = inst_23080);

return statearr_23113;
})();
var statearr_23114_23139 = state_23108__$1;
(statearr_23114_23139[(2)] = null);

(statearr_23114_23139[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (4))){
var inst_23080 = (state_23108[(10)]);
var state_23108__$1 = state_23108;
return cljs.core.async.ioc_alts_BANG_.call(null,state_23108__$1,(7),inst_23080);
} else {
if((state_val_23109 === (6))){
var inst_23104 = (state_23108[(2)]);
var state_23108__$1 = state_23108;
var statearr_23115_23140 = state_23108__$1;
(statearr_23115_23140[(2)] = inst_23104);

(statearr_23115_23140[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (3))){
var inst_23106 = (state_23108[(2)]);
var state_23108__$1 = state_23108;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23108__$1,inst_23106);
} else {
if((state_val_23109 === (2))){
var inst_23080 = (state_23108[(10)]);
var inst_23082 = cljs.core.count.call(null,inst_23080);
var inst_23083 = (inst_23082 > (0));
var state_23108__$1 = state_23108;
if(cljs.core.truth_(inst_23083)){
var statearr_23117_23141 = state_23108__$1;
(statearr_23117_23141[(1)] = (4));

} else {
var statearr_23118_23142 = state_23108__$1;
(statearr_23118_23142[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (11))){
var inst_23080 = (state_23108[(10)]);
var inst_23097 = (state_23108[(2)]);
var tmp23116 = inst_23080;
var inst_23080__$1 = tmp23116;
var state_23108__$1 = (function (){var statearr_23119 = state_23108;
(statearr_23119[(10)] = inst_23080__$1);

(statearr_23119[(11)] = inst_23097);

return statearr_23119;
})();
var statearr_23120_23143 = state_23108__$1;
(statearr_23120_23143[(2)] = null);

(statearr_23120_23143[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (9))){
var inst_23088 = (state_23108[(8)]);
var state_23108__$1 = state_23108;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23108__$1,(11),out,inst_23088);
} else {
if((state_val_23109 === (5))){
var inst_23102 = cljs.core.async.close_BANG_.call(null,out);
var state_23108__$1 = state_23108;
var statearr_23121_23144 = state_23108__$1;
(statearr_23121_23144[(2)] = inst_23102);

(statearr_23121_23144[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (10))){
var inst_23100 = (state_23108[(2)]);
var state_23108__$1 = state_23108;
var statearr_23122_23145 = state_23108__$1;
(statearr_23122_23145[(2)] = inst_23100);

(statearr_23122_23145[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23109 === (8))){
var inst_23087 = (state_23108[(7)]);
var inst_23089 = (state_23108[(9)]);
var inst_23080 = (state_23108[(10)]);
var inst_23088 = (state_23108[(8)]);
var inst_23092 = (function (){var cs = inst_23080;
var vec__23085 = inst_23087;
var v = inst_23088;
var c = inst_23089;
return ((function (cs,vec__23085,v,c,inst_23087,inst_23089,inst_23080,inst_23088,state_val_23109,c__21038__auto___23136,out){
return (function (p1__23075_SHARP_){
return cljs.core.not_EQ_.call(null,c,p1__23075_SHARP_);
});
;})(cs,vec__23085,v,c,inst_23087,inst_23089,inst_23080,inst_23088,state_val_23109,c__21038__auto___23136,out))
})();
var inst_23093 = cljs.core.filterv.call(null,inst_23092,inst_23080);
var inst_23080__$1 = inst_23093;
var state_23108__$1 = (function (){var statearr_23123 = state_23108;
(statearr_23123[(10)] = inst_23080__$1);

return statearr_23123;
})();
var statearr_23124_23146 = state_23108__$1;
(statearr_23124_23146[(2)] = null);

(statearr_23124_23146[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23136,out))
;
return ((function (switch__20926__auto__,c__21038__auto___23136,out){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23128 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23128[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23128[(1)] = (1));

return statearr_23128;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23108){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23108);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23129){if((e23129 instanceof Object)){
var ex__20930__auto__ = e23129;
var statearr_23130_23147 = state_23108;
(statearr_23130_23147[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23108);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23129;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23148 = state_23108;
state_23108 = G__23148;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23108){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23108);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23136,out))
})();
var state__21040__auto__ = (function (){var statearr_23131 = f__21039__auto__.call(null);
(statearr_23131[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23136);

return statearr_23131;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23136,out))
);


return out;
});

cljs.core.async.merge.cljs$lang$maxFixedArity = 2;
/**
 * Returns a channel containing the single (collection) result of the
 *   items taken from the channel conjoined to the supplied
 *   collection. ch must close before into produces a result.
 */
cljs.core.async.into = (function cljs$core$async$into(coll,ch){
return cljs.core.async.reduce.call(null,cljs.core.conj,coll,ch);
});
/**
 * Returns a channel that will return, at most, n items from ch. After n items
 * have been returned, or ch has been closed, the return chanel will close.
 * 
 *   The output channel is unbuffered by default, unless buf-or-n is given.
 */
cljs.core.async.take = (function cljs$core$async$take(var_args){
var args23149 = [];
var len__19428__auto___23198 = arguments.length;
var i__19429__auto___23199 = (0);
while(true){
if((i__19429__auto___23199 < len__19428__auto___23198)){
args23149.push((arguments[i__19429__auto___23199]));

var G__23200 = (i__19429__auto___23199 + (1));
i__19429__auto___23199 = G__23200;
continue;
} else {
}
break;
}

var G__23151 = args23149.length;
switch (G__23151) {
case 2:
return cljs.core.async.take.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.take.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23149.length)].join('')));

}
});

cljs.core.async.take.cljs$core$IFn$_invoke$arity$2 = (function (n,ch){
return cljs.core.async.take.call(null,n,ch,null);
});

cljs.core.async.take.cljs$core$IFn$_invoke$arity$3 = (function (n,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21038__auto___23202 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23202,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23202,out){
return (function (state_23175){
var state_val_23176 = (state_23175[(1)]);
if((state_val_23176 === (7))){
var inst_23157 = (state_23175[(7)]);
var inst_23157__$1 = (state_23175[(2)]);
var inst_23158 = (inst_23157__$1 == null);
var inst_23159 = cljs.core.not.call(null,inst_23158);
var state_23175__$1 = (function (){var statearr_23177 = state_23175;
(statearr_23177[(7)] = inst_23157__$1);

return statearr_23177;
})();
if(inst_23159){
var statearr_23178_23203 = state_23175__$1;
(statearr_23178_23203[(1)] = (8));

} else {
var statearr_23179_23204 = state_23175__$1;
(statearr_23179_23204[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (1))){
var inst_23152 = (0);
var state_23175__$1 = (function (){var statearr_23180 = state_23175;
(statearr_23180[(8)] = inst_23152);

return statearr_23180;
})();
var statearr_23181_23205 = state_23175__$1;
(statearr_23181_23205[(2)] = null);

(statearr_23181_23205[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (4))){
var state_23175__$1 = state_23175;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23175__$1,(7),ch);
} else {
if((state_val_23176 === (6))){
var inst_23170 = (state_23175[(2)]);
var state_23175__$1 = state_23175;
var statearr_23182_23206 = state_23175__$1;
(statearr_23182_23206[(2)] = inst_23170);

(statearr_23182_23206[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (3))){
var inst_23172 = (state_23175[(2)]);
var inst_23173 = cljs.core.async.close_BANG_.call(null,out);
var state_23175__$1 = (function (){var statearr_23183 = state_23175;
(statearr_23183[(9)] = inst_23172);

return statearr_23183;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23175__$1,inst_23173);
} else {
if((state_val_23176 === (2))){
var inst_23152 = (state_23175[(8)]);
var inst_23154 = (inst_23152 < n);
var state_23175__$1 = state_23175;
if(cljs.core.truth_(inst_23154)){
var statearr_23184_23207 = state_23175__$1;
(statearr_23184_23207[(1)] = (4));

} else {
var statearr_23185_23208 = state_23175__$1;
(statearr_23185_23208[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (11))){
var inst_23152 = (state_23175[(8)]);
var inst_23162 = (state_23175[(2)]);
var inst_23163 = (inst_23152 + (1));
var inst_23152__$1 = inst_23163;
var state_23175__$1 = (function (){var statearr_23186 = state_23175;
(statearr_23186[(10)] = inst_23162);

(statearr_23186[(8)] = inst_23152__$1);

return statearr_23186;
})();
var statearr_23187_23209 = state_23175__$1;
(statearr_23187_23209[(2)] = null);

(statearr_23187_23209[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (9))){
var state_23175__$1 = state_23175;
var statearr_23188_23210 = state_23175__$1;
(statearr_23188_23210[(2)] = null);

(statearr_23188_23210[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (5))){
var state_23175__$1 = state_23175;
var statearr_23189_23211 = state_23175__$1;
(statearr_23189_23211[(2)] = null);

(statearr_23189_23211[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (10))){
var inst_23167 = (state_23175[(2)]);
var state_23175__$1 = state_23175;
var statearr_23190_23212 = state_23175__$1;
(statearr_23190_23212[(2)] = inst_23167);

(statearr_23190_23212[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23176 === (8))){
var inst_23157 = (state_23175[(7)]);
var state_23175__$1 = state_23175;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23175__$1,(11),out,inst_23157);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23202,out))
;
return ((function (switch__20926__auto__,c__21038__auto___23202,out){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23194 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_23194[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23194[(1)] = (1));

return statearr_23194;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23175){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23175);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23195){if((e23195 instanceof Object)){
var ex__20930__auto__ = e23195;
var statearr_23196_23213 = state_23175;
(statearr_23196_23213[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23175);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23195;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23214 = state_23175;
state_23175 = G__23214;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23175){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23175);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23202,out))
})();
var state__21040__auto__ = (function (){var statearr_23197 = f__21039__auto__.call(null);
(statearr_23197[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23202);

return statearr_23197;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23202,out))
);


return out;
});

cljs.core.async.take.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.map_LT_ = (function cljs$core$async$map_LT_(f,ch){
if(typeof cljs.core.async.t_cljs$core$async23222 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23222 = (function (map_LT_,f,ch,meta23223){
this.map_LT_ = map_LT_;
this.f = f;
this.ch = ch;
this.meta23223 = meta23223;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23224,meta23223__$1){
var self__ = this;
var _23224__$1 = this;
return (new cljs.core.async.t_cljs$core$async23222(self__.map_LT_,self__.f,self__.ch,meta23223__$1));
});

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23224){
var self__ = this;
var _23224__$1 = this;
return self__.meta23223;
});

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$Channel$closed_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,(function (){
if(typeof cljs.core.async.t_cljs$core$async23225 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23225 = (function (map_LT_,f,ch,meta23223,_,fn1,meta23226){
this.map_LT_ = map_LT_;
this.f = f;
this.ch = ch;
this.meta23223 = meta23223;
this._ = _;
this.fn1 = fn1;
this.meta23226 = meta23226;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23225.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (___$1){
return (function (_23227,meta23226__$1){
var self__ = this;
var _23227__$1 = this;
return (new cljs.core.async.t_cljs$core$async23225(self__.map_LT_,self__.f,self__.ch,self__.meta23223,self__._,self__.fn1,meta23226__$1));
});})(___$1))
;

cljs.core.async.t_cljs$core$async23225.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (___$1){
return (function (_23227){
var self__ = this;
var _23227__$1 = this;
return self__.meta23226;
});})(___$1))
;

cljs.core.async.t_cljs$core$async23225.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async23225.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
return cljs.core.async.impl.protocols.active_QMARK_.call(null,self__.fn1);
});})(___$1))
;

cljs.core.async.t_cljs$core$async23225.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
return true;
});})(___$1))
;

cljs.core.async.t_cljs$core$async23225.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
var f1 = cljs.core.async.impl.protocols.commit.call(null,self__.fn1);
return ((function (f1,___$2,___$1){
return (function (p1__23215_SHARP_){
return f1.call(null,(((p1__23215_SHARP_ == null))?null:self__.f.call(null,p1__23215_SHARP_)));
});
;})(f1,___$2,___$1))
});})(___$1))
;

cljs.core.async.t_cljs$core$async23225.getBasis = ((function (___$1){
return (function (){
return new cljs.core.PersistentVector(null, 7, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map<","map<",-1235808357,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23223","meta23223",-1171842754,null),cljs.core.with_meta(new cljs.core.Symbol(null,"_","_",-1201019570,null),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"tag","tag",-1290361223),new cljs.core.Symbol("cljs.core.async","t_cljs$core$async23222","cljs.core.async/t_cljs$core$async23222",-211761479,null)], null)),new cljs.core.Symbol(null,"fn1","fn1",895834444,null),new cljs.core.Symbol(null,"meta23226","meta23226",618019040,null)], null);
});})(___$1))
;

cljs.core.async.t_cljs$core$async23225.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23225.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23225";

cljs.core.async.t_cljs$core$async23225.cljs$lang$ctorPrWriter = ((function (___$1){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23225");
});})(___$1))
;

cljs.core.async.__GT_t_cljs$core$async23225 = ((function (___$1){
return (function cljs$core$async$map_LT__$___GT_t_cljs$core$async23225(map_LT___$1,f__$1,ch__$1,meta23223__$1,___$2,fn1__$1,meta23226){
return (new cljs.core.async.t_cljs$core$async23225(map_LT___$1,f__$1,ch__$1,meta23223__$1,___$2,fn1__$1,meta23226));
});})(___$1))
;

}

return (new cljs.core.async.t_cljs$core$async23225(self__.map_LT_,self__.f,self__.ch,self__.meta23223,___$1,fn1,cljs.core.PersistentArrayMap.EMPTY));
})()
);
if(cljs.core.truth_((function (){var and__18358__auto__ = ret;
if(cljs.core.truth_(and__18358__auto__)){
return !((cljs.core.deref.call(null,ret) == null));
} else {
return and__18358__auto__;
}
})())){
return cljs.core.async.impl.channels.box.call(null,self__.f.call(null,cljs.core.deref.call(null,ret)));
} else {
return ret;
}
});

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23222.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,val,fn1);
});

cljs.core.async.t_cljs$core$async23222.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map<","map<",-1235808357,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23223","meta23223",-1171842754,null)], null);
});

cljs.core.async.t_cljs$core$async23222.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23222.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23222";

cljs.core.async.t_cljs$core$async23222.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23222");
});

cljs.core.async.__GT_t_cljs$core$async23222 = (function cljs$core$async$map_LT__$___GT_t_cljs$core$async23222(map_LT___$1,f__$1,ch__$1,meta23223){
return (new cljs.core.async.t_cljs$core$async23222(map_LT___$1,f__$1,ch__$1,meta23223));
});

}

return (new cljs.core.async.t_cljs$core$async23222(cljs$core$async$map_LT_,f,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.map_GT_ = (function cljs$core$async$map_GT_(f,ch){
if(typeof cljs.core.async.t_cljs$core$async23231 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23231 = (function (map_GT_,f,ch,meta23232){
this.map_GT_ = map_GT_;
this.f = f;
this.ch = ch;
this.meta23232 = meta23232;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23233,meta23232__$1){
var self__ = this;
var _23233__$1 = this;
return (new cljs.core.async.t_cljs$core$async23231(self__.map_GT_,self__.f,self__.ch,meta23232__$1));
});

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23233){
var self__ = this;
var _23233__$1 = this;
return self__.meta23232;
});

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,fn1);
});

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23231.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,self__.f.call(null,val),fn1);
});

cljs.core.async.t_cljs$core$async23231.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map>","map>",1676369295,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23232","meta23232",634853383,null)], null);
});

cljs.core.async.t_cljs$core$async23231.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23231.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23231";

cljs.core.async.t_cljs$core$async23231.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23231");
});

cljs.core.async.__GT_t_cljs$core$async23231 = (function cljs$core$async$map_GT__$___GT_t_cljs$core$async23231(map_GT___$1,f__$1,ch__$1,meta23232){
return (new cljs.core.async.t_cljs$core$async23231(map_GT___$1,f__$1,ch__$1,meta23232));
});

}

return (new cljs.core.async.t_cljs$core$async23231(cljs$core$async$map_GT_,f,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.filter_GT_ = (function cljs$core$async$filter_GT_(p,ch){
if(typeof cljs.core.async.t_cljs$core$async23237 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23237 = (function (filter_GT_,p,ch,meta23238){
this.filter_GT_ = filter_GT_;
this.p = p;
this.ch = ch;
this.meta23238 = meta23238;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23239,meta23238__$1){
var self__ = this;
var _23239__$1 = this;
return (new cljs.core.async.t_cljs$core$async23237(self__.filter_GT_,self__.p,self__.ch,meta23238__$1));
});

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23239){
var self__ = this;
var _23239__$1 = this;
return self__.meta23238;
});

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$Channel$closed_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,fn1);
});

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23237.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
if(cljs.core.truth_(self__.p.call(null,val))){
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,val,fn1);
} else {
return cljs.core.async.impl.channels.box.call(null,cljs.core.not.call(null,cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch)));
}
});

cljs.core.async.t_cljs$core$async23237.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"filter>","filter>",-37644455,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"p","p",1791580836,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"p","p",1791580836,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23238","meta23238",-1947601864,null)], null);
});

cljs.core.async.t_cljs$core$async23237.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23237.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23237";

cljs.core.async.t_cljs$core$async23237.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23237");
});

cljs.core.async.__GT_t_cljs$core$async23237 = (function cljs$core$async$filter_GT__$___GT_t_cljs$core$async23237(filter_GT___$1,p__$1,ch__$1,meta23238){
return (new cljs.core.async.t_cljs$core$async23237(filter_GT___$1,p__$1,ch__$1,meta23238));
});

}

return (new cljs.core.async.t_cljs$core$async23237(cljs$core$async$filter_GT_,p,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.remove_GT_ = (function cljs$core$async$remove_GT_(p,ch){
return cljs.core.async.filter_GT_.call(null,cljs.core.complement.call(null,p),ch);
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.filter_LT_ = (function cljs$core$async$filter_LT_(var_args){
var args23240 = [];
var len__19428__auto___23284 = arguments.length;
var i__19429__auto___23285 = (0);
while(true){
if((i__19429__auto___23285 < len__19428__auto___23284)){
args23240.push((arguments[i__19429__auto___23285]));

var G__23286 = (i__19429__auto___23285 + (1));
i__19429__auto___23285 = G__23286;
continue;
} else {
}
break;
}

var G__23242 = args23240.length;
switch (G__23242) {
case 2:
return cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23240.length)].join('')));

}
});

cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.filter_LT_.call(null,p,ch,null);
});

cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$3 = (function (p,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21038__auto___23288 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23288,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23288,out){
return (function (state_23263){
var state_val_23264 = (state_23263[(1)]);
if((state_val_23264 === (7))){
var inst_23259 = (state_23263[(2)]);
var state_23263__$1 = state_23263;
var statearr_23265_23289 = state_23263__$1;
(statearr_23265_23289[(2)] = inst_23259);

(statearr_23265_23289[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (1))){
var state_23263__$1 = state_23263;
var statearr_23266_23290 = state_23263__$1;
(statearr_23266_23290[(2)] = null);

(statearr_23266_23290[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (4))){
var inst_23245 = (state_23263[(7)]);
var inst_23245__$1 = (state_23263[(2)]);
var inst_23246 = (inst_23245__$1 == null);
var state_23263__$1 = (function (){var statearr_23267 = state_23263;
(statearr_23267[(7)] = inst_23245__$1);

return statearr_23267;
})();
if(cljs.core.truth_(inst_23246)){
var statearr_23268_23291 = state_23263__$1;
(statearr_23268_23291[(1)] = (5));

} else {
var statearr_23269_23292 = state_23263__$1;
(statearr_23269_23292[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (6))){
var inst_23245 = (state_23263[(7)]);
var inst_23250 = p.call(null,inst_23245);
var state_23263__$1 = state_23263;
if(cljs.core.truth_(inst_23250)){
var statearr_23270_23293 = state_23263__$1;
(statearr_23270_23293[(1)] = (8));

} else {
var statearr_23271_23294 = state_23263__$1;
(statearr_23271_23294[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (3))){
var inst_23261 = (state_23263[(2)]);
var state_23263__$1 = state_23263;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23263__$1,inst_23261);
} else {
if((state_val_23264 === (2))){
var state_23263__$1 = state_23263;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23263__$1,(4),ch);
} else {
if((state_val_23264 === (11))){
var inst_23253 = (state_23263[(2)]);
var state_23263__$1 = state_23263;
var statearr_23272_23295 = state_23263__$1;
(statearr_23272_23295[(2)] = inst_23253);

(statearr_23272_23295[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (9))){
var state_23263__$1 = state_23263;
var statearr_23273_23296 = state_23263__$1;
(statearr_23273_23296[(2)] = null);

(statearr_23273_23296[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (5))){
var inst_23248 = cljs.core.async.close_BANG_.call(null,out);
var state_23263__$1 = state_23263;
var statearr_23274_23297 = state_23263__$1;
(statearr_23274_23297[(2)] = inst_23248);

(statearr_23274_23297[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (10))){
var inst_23256 = (state_23263[(2)]);
var state_23263__$1 = (function (){var statearr_23275 = state_23263;
(statearr_23275[(8)] = inst_23256);

return statearr_23275;
})();
var statearr_23276_23298 = state_23263__$1;
(statearr_23276_23298[(2)] = null);

(statearr_23276_23298[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23264 === (8))){
var inst_23245 = (state_23263[(7)]);
var state_23263__$1 = state_23263;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23263__$1,(11),out,inst_23245);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23288,out))
;
return ((function (switch__20926__auto__,c__21038__auto___23288,out){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23280 = [null,null,null,null,null,null,null,null,null];
(statearr_23280[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23280[(1)] = (1));

return statearr_23280;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23263){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23263);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23281){if((e23281 instanceof Object)){
var ex__20930__auto__ = e23281;
var statearr_23282_23299 = state_23263;
(statearr_23282_23299[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23263);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23281;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23300 = state_23263;
state_23263 = G__23300;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23263){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23263);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23288,out))
})();
var state__21040__auto__ = (function (){var statearr_23283 = f__21039__auto__.call(null);
(statearr_23283[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23288);

return statearr_23283;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23288,out))
);


return out;
});

cljs.core.async.filter_LT_.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.remove_LT_ = (function cljs$core$async$remove_LT_(var_args){
var args23301 = [];
var len__19428__auto___23304 = arguments.length;
var i__19429__auto___23305 = (0);
while(true){
if((i__19429__auto___23305 < len__19428__auto___23304)){
args23301.push((arguments[i__19429__auto___23305]));

var G__23306 = (i__19429__auto___23305 + (1));
i__19429__auto___23305 = G__23306;
continue;
} else {
}
break;
}

var G__23303 = args23301.length;
switch (G__23303) {
case 2:
return cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23301.length)].join('')));

}
});

cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.remove_LT_.call(null,p,ch,null);
});

cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$3 = (function (p,ch,buf_or_n){
return cljs.core.async.filter_LT_.call(null,cljs.core.complement.call(null,p),ch,buf_or_n);
});

cljs.core.async.remove_LT_.cljs$lang$maxFixedArity = 3;
cljs.core.async.mapcat_STAR_ = (function cljs$core$async$mapcat_STAR_(f,in$,out){
var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__){
return (function (state_23473){
var state_val_23474 = (state_23473[(1)]);
if((state_val_23474 === (7))){
var inst_23469 = (state_23473[(2)]);
var state_23473__$1 = state_23473;
var statearr_23475_23516 = state_23473__$1;
(statearr_23475_23516[(2)] = inst_23469);

(statearr_23475_23516[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (20))){
var inst_23439 = (state_23473[(7)]);
var inst_23450 = (state_23473[(2)]);
var inst_23451 = cljs.core.next.call(null,inst_23439);
var inst_23425 = inst_23451;
var inst_23426 = null;
var inst_23427 = (0);
var inst_23428 = (0);
var state_23473__$1 = (function (){var statearr_23476 = state_23473;
(statearr_23476[(8)] = inst_23426);

(statearr_23476[(9)] = inst_23425);

(statearr_23476[(10)] = inst_23450);

(statearr_23476[(11)] = inst_23428);

(statearr_23476[(12)] = inst_23427);

return statearr_23476;
})();
var statearr_23477_23517 = state_23473__$1;
(statearr_23477_23517[(2)] = null);

(statearr_23477_23517[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (1))){
var state_23473__$1 = state_23473;
var statearr_23478_23518 = state_23473__$1;
(statearr_23478_23518[(2)] = null);

(statearr_23478_23518[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (4))){
var inst_23414 = (state_23473[(13)]);
var inst_23414__$1 = (state_23473[(2)]);
var inst_23415 = (inst_23414__$1 == null);
var state_23473__$1 = (function (){var statearr_23479 = state_23473;
(statearr_23479[(13)] = inst_23414__$1);

return statearr_23479;
})();
if(cljs.core.truth_(inst_23415)){
var statearr_23480_23519 = state_23473__$1;
(statearr_23480_23519[(1)] = (5));

} else {
var statearr_23481_23520 = state_23473__$1;
(statearr_23481_23520[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (15))){
var state_23473__$1 = state_23473;
var statearr_23485_23521 = state_23473__$1;
(statearr_23485_23521[(2)] = null);

(statearr_23485_23521[(1)] = (16));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (21))){
var state_23473__$1 = state_23473;
var statearr_23486_23522 = state_23473__$1;
(statearr_23486_23522[(2)] = null);

(statearr_23486_23522[(1)] = (23));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (13))){
var inst_23426 = (state_23473[(8)]);
var inst_23425 = (state_23473[(9)]);
var inst_23428 = (state_23473[(11)]);
var inst_23427 = (state_23473[(12)]);
var inst_23435 = (state_23473[(2)]);
var inst_23436 = (inst_23428 + (1));
var tmp23482 = inst_23426;
var tmp23483 = inst_23425;
var tmp23484 = inst_23427;
var inst_23425__$1 = tmp23483;
var inst_23426__$1 = tmp23482;
var inst_23427__$1 = tmp23484;
var inst_23428__$1 = inst_23436;
var state_23473__$1 = (function (){var statearr_23487 = state_23473;
(statearr_23487[(8)] = inst_23426__$1);

(statearr_23487[(9)] = inst_23425__$1);

(statearr_23487[(11)] = inst_23428__$1);

(statearr_23487[(14)] = inst_23435);

(statearr_23487[(12)] = inst_23427__$1);

return statearr_23487;
})();
var statearr_23488_23523 = state_23473__$1;
(statearr_23488_23523[(2)] = null);

(statearr_23488_23523[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (22))){
var state_23473__$1 = state_23473;
var statearr_23489_23524 = state_23473__$1;
(statearr_23489_23524[(2)] = null);

(statearr_23489_23524[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (6))){
var inst_23414 = (state_23473[(13)]);
var inst_23423 = f.call(null,inst_23414);
var inst_23424 = cljs.core.seq.call(null,inst_23423);
var inst_23425 = inst_23424;
var inst_23426 = null;
var inst_23427 = (0);
var inst_23428 = (0);
var state_23473__$1 = (function (){var statearr_23490 = state_23473;
(statearr_23490[(8)] = inst_23426);

(statearr_23490[(9)] = inst_23425);

(statearr_23490[(11)] = inst_23428);

(statearr_23490[(12)] = inst_23427);

return statearr_23490;
})();
var statearr_23491_23525 = state_23473__$1;
(statearr_23491_23525[(2)] = null);

(statearr_23491_23525[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (17))){
var inst_23439 = (state_23473[(7)]);
var inst_23443 = cljs.core.chunk_first.call(null,inst_23439);
var inst_23444 = cljs.core.chunk_rest.call(null,inst_23439);
var inst_23445 = cljs.core.count.call(null,inst_23443);
var inst_23425 = inst_23444;
var inst_23426 = inst_23443;
var inst_23427 = inst_23445;
var inst_23428 = (0);
var state_23473__$1 = (function (){var statearr_23492 = state_23473;
(statearr_23492[(8)] = inst_23426);

(statearr_23492[(9)] = inst_23425);

(statearr_23492[(11)] = inst_23428);

(statearr_23492[(12)] = inst_23427);

return statearr_23492;
})();
var statearr_23493_23526 = state_23473__$1;
(statearr_23493_23526[(2)] = null);

(statearr_23493_23526[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (3))){
var inst_23471 = (state_23473[(2)]);
var state_23473__$1 = state_23473;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23473__$1,inst_23471);
} else {
if((state_val_23474 === (12))){
var inst_23459 = (state_23473[(2)]);
var state_23473__$1 = state_23473;
var statearr_23494_23527 = state_23473__$1;
(statearr_23494_23527[(2)] = inst_23459);

(statearr_23494_23527[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (2))){
var state_23473__$1 = state_23473;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23473__$1,(4),in$);
} else {
if((state_val_23474 === (23))){
var inst_23467 = (state_23473[(2)]);
var state_23473__$1 = state_23473;
var statearr_23495_23528 = state_23473__$1;
(statearr_23495_23528[(2)] = inst_23467);

(statearr_23495_23528[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (19))){
var inst_23454 = (state_23473[(2)]);
var state_23473__$1 = state_23473;
var statearr_23496_23529 = state_23473__$1;
(statearr_23496_23529[(2)] = inst_23454);

(statearr_23496_23529[(1)] = (16));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (11))){
var inst_23425 = (state_23473[(9)]);
var inst_23439 = (state_23473[(7)]);
var inst_23439__$1 = cljs.core.seq.call(null,inst_23425);
var state_23473__$1 = (function (){var statearr_23497 = state_23473;
(statearr_23497[(7)] = inst_23439__$1);

return statearr_23497;
})();
if(inst_23439__$1){
var statearr_23498_23530 = state_23473__$1;
(statearr_23498_23530[(1)] = (14));

} else {
var statearr_23499_23531 = state_23473__$1;
(statearr_23499_23531[(1)] = (15));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (9))){
var inst_23461 = (state_23473[(2)]);
var inst_23462 = cljs.core.async.impl.protocols.closed_QMARK_.call(null,out);
var state_23473__$1 = (function (){var statearr_23500 = state_23473;
(statearr_23500[(15)] = inst_23461);

return statearr_23500;
})();
if(cljs.core.truth_(inst_23462)){
var statearr_23501_23532 = state_23473__$1;
(statearr_23501_23532[(1)] = (21));

} else {
var statearr_23502_23533 = state_23473__$1;
(statearr_23502_23533[(1)] = (22));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (5))){
var inst_23417 = cljs.core.async.close_BANG_.call(null,out);
var state_23473__$1 = state_23473;
var statearr_23503_23534 = state_23473__$1;
(statearr_23503_23534[(2)] = inst_23417);

(statearr_23503_23534[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (14))){
var inst_23439 = (state_23473[(7)]);
var inst_23441 = cljs.core.chunked_seq_QMARK_.call(null,inst_23439);
var state_23473__$1 = state_23473;
if(inst_23441){
var statearr_23504_23535 = state_23473__$1;
(statearr_23504_23535[(1)] = (17));

} else {
var statearr_23505_23536 = state_23473__$1;
(statearr_23505_23536[(1)] = (18));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (16))){
var inst_23457 = (state_23473[(2)]);
var state_23473__$1 = state_23473;
var statearr_23506_23537 = state_23473__$1;
(statearr_23506_23537[(2)] = inst_23457);

(statearr_23506_23537[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23474 === (10))){
var inst_23426 = (state_23473[(8)]);
var inst_23428 = (state_23473[(11)]);
var inst_23433 = cljs.core._nth.call(null,inst_23426,inst_23428);
var state_23473__$1 = state_23473;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23473__$1,(13),out,inst_23433);
} else {
if((state_val_23474 === (18))){
var inst_23439 = (state_23473[(7)]);
var inst_23448 = cljs.core.first.call(null,inst_23439);
var state_23473__$1 = state_23473;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23473__$1,(20),out,inst_23448);
} else {
if((state_val_23474 === (8))){
var inst_23428 = (state_23473[(11)]);
var inst_23427 = (state_23473[(12)]);
var inst_23430 = (inst_23428 < inst_23427);
var inst_23431 = inst_23430;
var state_23473__$1 = state_23473;
if(cljs.core.truth_(inst_23431)){
var statearr_23507_23538 = state_23473__$1;
(statearr_23507_23538[(1)] = (10));

} else {
var statearr_23508_23539 = state_23473__$1;
(statearr_23508_23539[(1)] = (11));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto__))
;
return ((function (switch__20926__auto__,c__21038__auto__){
return (function() {
var cljs$core$async$mapcat_STAR__$_state_machine__20927__auto__ = null;
var cljs$core$async$mapcat_STAR__$_state_machine__20927__auto____0 = (function (){
var statearr_23512 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23512[(0)] = cljs$core$async$mapcat_STAR__$_state_machine__20927__auto__);

(statearr_23512[(1)] = (1));

return statearr_23512;
});
var cljs$core$async$mapcat_STAR__$_state_machine__20927__auto____1 = (function (state_23473){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23473);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23513){if((e23513 instanceof Object)){
var ex__20930__auto__ = e23513;
var statearr_23514_23540 = state_23473;
(statearr_23514_23540[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23473);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23513;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23541 = state_23473;
state_23473 = G__23541;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$mapcat_STAR__$_state_machine__20927__auto__ = function(state_23473){
switch(arguments.length){
case 0:
return cljs$core$async$mapcat_STAR__$_state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$mapcat_STAR__$_state_machine__20927__auto____1.call(this,state_23473);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mapcat_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mapcat_STAR__$_state_machine__20927__auto____0;
cljs$core$async$mapcat_STAR__$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mapcat_STAR__$_state_machine__20927__auto____1;
return cljs$core$async$mapcat_STAR__$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__))
})();
var state__21040__auto__ = (function (){var statearr_23515 = f__21039__auto__.call(null);
(statearr_23515[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_23515;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__))
);

return c__21038__auto__;
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.mapcat_LT_ = (function cljs$core$async$mapcat_LT_(var_args){
var args23542 = [];
var len__19428__auto___23545 = arguments.length;
var i__19429__auto___23546 = (0);
while(true){
if((i__19429__auto___23546 < len__19428__auto___23545)){
args23542.push((arguments[i__19429__auto___23546]));

var G__23547 = (i__19429__auto___23546 + (1));
i__19429__auto___23546 = G__23547;
continue;
} else {
}
break;
}

var G__23544 = args23542.length;
switch (G__23544) {
case 2:
return cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23542.length)].join('')));

}
});

cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$2 = (function (f,in$){
return cljs.core.async.mapcat_LT_.call(null,f,in$,null);
});

cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$3 = (function (f,in$,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
cljs.core.async.mapcat_STAR_.call(null,f,in$,out);

return out;
});

cljs.core.async.mapcat_LT_.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.mapcat_GT_ = (function cljs$core$async$mapcat_GT_(var_args){
var args23549 = [];
var len__19428__auto___23552 = arguments.length;
var i__19429__auto___23553 = (0);
while(true){
if((i__19429__auto___23553 < len__19428__auto___23552)){
args23549.push((arguments[i__19429__auto___23553]));

var G__23554 = (i__19429__auto___23553 + (1));
i__19429__auto___23553 = G__23554;
continue;
} else {
}
break;
}

var G__23551 = args23549.length;
switch (G__23551) {
case 2:
return cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23549.length)].join('')));

}
});

cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$2 = (function (f,out){
return cljs.core.async.mapcat_GT_.call(null,f,out,null);
});

cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$3 = (function (f,out,buf_or_n){
var in$ = cljs.core.async.chan.call(null,buf_or_n);
cljs.core.async.mapcat_STAR_.call(null,f,in$,out);

return in$;
});

cljs.core.async.mapcat_GT_.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.unique = (function cljs$core$async$unique(var_args){
var args23556 = [];
var len__19428__auto___23607 = arguments.length;
var i__19429__auto___23608 = (0);
while(true){
if((i__19429__auto___23608 < len__19428__auto___23607)){
args23556.push((arguments[i__19429__auto___23608]));

var G__23609 = (i__19429__auto___23608 + (1));
i__19429__auto___23608 = G__23609;
continue;
} else {
}
break;
}

var G__23558 = args23556.length;
switch (G__23558) {
case 1:
return cljs.core.async.unique.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unique.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23556.length)].join('')));

}
});

cljs.core.async.unique.cljs$core$IFn$_invoke$arity$1 = (function (ch){
return cljs.core.async.unique.call(null,ch,null);
});

cljs.core.async.unique.cljs$core$IFn$_invoke$arity$2 = (function (ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21038__auto___23611 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23611,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23611,out){
return (function (state_23582){
var state_val_23583 = (state_23582[(1)]);
if((state_val_23583 === (7))){
var inst_23577 = (state_23582[(2)]);
var state_23582__$1 = state_23582;
var statearr_23584_23612 = state_23582__$1;
(statearr_23584_23612[(2)] = inst_23577);

(statearr_23584_23612[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (1))){
var inst_23559 = null;
var state_23582__$1 = (function (){var statearr_23585 = state_23582;
(statearr_23585[(7)] = inst_23559);

return statearr_23585;
})();
var statearr_23586_23613 = state_23582__$1;
(statearr_23586_23613[(2)] = null);

(statearr_23586_23613[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (4))){
var inst_23562 = (state_23582[(8)]);
var inst_23562__$1 = (state_23582[(2)]);
var inst_23563 = (inst_23562__$1 == null);
var inst_23564 = cljs.core.not.call(null,inst_23563);
var state_23582__$1 = (function (){var statearr_23587 = state_23582;
(statearr_23587[(8)] = inst_23562__$1);

return statearr_23587;
})();
if(inst_23564){
var statearr_23588_23614 = state_23582__$1;
(statearr_23588_23614[(1)] = (5));

} else {
var statearr_23589_23615 = state_23582__$1;
(statearr_23589_23615[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (6))){
var state_23582__$1 = state_23582;
var statearr_23590_23616 = state_23582__$1;
(statearr_23590_23616[(2)] = null);

(statearr_23590_23616[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (3))){
var inst_23579 = (state_23582[(2)]);
var inst_23580 = cljs.core.async.close_BANG_.call(null,out);
var state_23582__$1 = (function (){var statearr_23591 = state_23582;
(statearr_23591[(9)] = inst_23579);

return statearr_23591;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23582__$1,inst_23580);
} else {
if((state_val_23583 === (2))){
var state_23582__$1 = state_23582;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23582__$1,(4),ch);
} else {
if((state_val_23583 === (11))){
var inst_23562 = (state_23582[(8)]);
var inst_23571 = (state_23582[(2)]);
var inst_23559 = inst_23562;
var state_23582__$1 = (function (){var statearr_23592 = state_23582;
(statearr_23592[(10)] = inst_23571);

(statearr_23592[(7)] = inst_23559);

return statearr_23592;
})();
var statearr_23593_23617 = state_23582__$1;
(statearr_23593_23617[(2)] = null);

(statearr_23593_23617[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (9))){
var inst_23562 = (state_23582[(8)]);
var state_23582__$1 = state_23582;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23582__$1,(11),out,inst_23562);
} else {
if((state_val_23583 === (5))){
var inst_23562 = (state_23582[(8)]);
var inst_23559 = (state_23582[(7)]);
var inst_23566 = cljs.core._EQ_.call(null,inst_23562,inst_23559);
var state_23582__$1 = state_23582;
if(inst_23566){
var statearr_23595_23618 = state_23582__$1;
(statearr_23595_23618[(1)] = (8));

} else {
var statearr_23596_23619 = state_23582__$1;
(statearr_23596_23619[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (10))){
var inst_23574 = (state_23582[(2)]);
var state_23582__$1 = state_23582;
var statearr_23597_23620 = state_23582__$1;
(statearr_23597_23620[(2)] = inst_23574);

(statearr_23597_23620[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23583 === (8))){
var inst_23559 = (state_23582[(7)]);
var tmp23594 = inst_23559;
var inst_23559__$1 = tmp23594;
var state_23582__$1 = (function (){var statearr_23598 = state_23582;
(statearr_23598[(7)] = inst_23559__$1);

return statearr_23598;
})();
var statearr_23599_23621 = state_23582__$1;
(statearr_23599_23621[(2)] = null);

(statearr_23599_23621[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23611,out))
;
return ((function (switch__20926__auto__,c__21038__auto___23611,out){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23603 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_23603[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23603[(1)] = (1));

return statearr_23603;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23582){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23582);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23604){if((e23604 instanceof Object)){
var ex__20930__auto__ = e23604;
var statearr_23605_23622 = state_23582;
(statearr_23605_23622[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23582);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23604;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23623 = state_23582;
state_23582 = G__23623;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23582){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23582);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23611,out))
})();
var state__21040__auto__ = (function (){var statearr_23606 = f__21039__auto__.call(null);
(statearr_23606[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23611);

return statearr_23606;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23611,out))
);


return out;
});

cljs.core.async.unique.cljs$lang$maxFixedArity = 2;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.partition = (function cljs$core$async$partition(var_args){
var args23624 = [];
var len__19428__auto___23694 = arguments.length;
var i__19429__auto___23695 = (0);
while(true){
if((i__19429__auto___23695 < len__19428__auto___23694)){
args23624.push((arguments[i__19429__auto___23695]));

var G__23696 = (i__19429__auto___23695 + (1));
i__19429__auto___23695 = G__23696;
continue;
} else {
}
break;
}

var G__23626 = args23624.length;
switch (G__23626) {
case 2:
return cljs.core.async.partition.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.partition.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23624.length)].join('')));

}
});

cljs.core.async.partition.cljs$core$IFn$_invoke$arity$2 = (function (n,ch){
return cljs.core.async.partition.call(null,n,ch,null);
});

cljs.core.async.partition.cljs$core$IFn$_invoke$arity$3 = (function (n,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21038__auto___23698 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23698,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23698,out){
return (function (state_23664){
var state_val_23665 = (state_23664[(1)]);
if((state_val_23665 === (7))){
var inst_23660 = (state_23664[(2)]);
var state_23664__$1 = state_23664;
var statearr_23666_23699 = state_23664__$1;
(statearr_23666_23699[(2)] = inst_23660);

(statearr_23666_23699[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (1))){
var inst_23627 = (new Array(n));
var inst_23628 = inst_23627;
var inst_23629 = (0);
var state_23664__$1 = (function (){var statearr_23667 = state_23664;
(statearr_23667[(7)] = inst_23628);

(statearr_23667[(8)] = inst_23629);

return statearr_23667;
})();
var statearr_23668_23700 = state_23664__$1;
(statearr_23668_23700[(2)] = null);

(statearr_23668_23700[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (4))){
var inst_23632 = (state_23664[(9)]);
var inst_23632__$1 = (state_23664[(2)]);
var inst_23633 = (inst_23632__$1 == null);
var inst_23634 = cljs.core.not.call(null,inst_23633);
var state_23664__$1 = (function (){var statearr_23669 = state_23664;
(statearr_23669[(9)] = inst_23632__$1);

return statearr_23669;
})();
if(inst_23634){
var statearr_23670_23701 = state_23664__$1;
(statearr_23670_23701[(1)] = (5));

} else {
var statearr_23671_23702 = state_23664__$1;
(statearr_23671_23702[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (15))){
var inst_23654 = (state_23664[(2)]);
var state_23664__$1 = state_23664;
var statearr_23672_23703 = state_23664__$1;
(statearr_23672_23703[(2)] = inst_23654);

(statearr_23672_23703[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (13))){
var state_23664__$1 = state_23664;
var statearr_23673_23704 = state_23664__$1;
(statearr_23673_23704[(2)] = null);

(statearr_23673_23704[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (6))){
var inst_23629 = (state_23664[(8)]);
var inst_23650 = (inst_23629 > (0));
var state_23664__$1 = state_23664;
if(cljs.core.truth_(inst_23650)){
var statearr_23674_23705 = state_23664__$1;
(statearr_23674_23705[(1)] = (12));

} else {
var statearr_23675_23706 = state_23664__$1;
(statearr_23675_23706[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (3))){
var inst_23662 = (state_23664[(2)]);
var state_23664__$1 = state_23664;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23664__$1,inst_23662);
} else {
if((state_val_23665 === (12))){
var inst_23628 = (state_23664[(7)]);
var inst_23652 = cljs.core.vec.call(null,inst_23628);
var state_23664__$1 = state_23664;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23664__$1,(15),out,inst_23652);
} else {
if((state_val_23665 === (2))){
var state_23664__$1 = state_23664;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23664__$1,(4),ch);
} else {
if((state_val_23665 === (11))){
var inst_23644 = (state_23664[(2)]);
var inst_23645 = (new Array(n));
var inst_23628 = inst_23645;
var inst_23629 = (0);
var state_23664__$1 = (function (){var statearr_23676 = state_23664;
(statearr_23676[(7)] = inst_23628);

(statearr_23676[(10)] = inst_23644);

(statearr_23676[(8)] = inst_23629);

return statearr_23676;
})();
var statearr_23677_23707 = state_23664__$1;
(statearr_23677_23707[(2)] = null);

(statearr_23677_23707[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (9))){
var inst_23628 = (state_23664[(7)]);
var inst_23642 = cljs.core.vec.call(null,inst_23628);
var state_23664__$1 = state_23664;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23664__$1,(11),out,inst_23642);
} else {
if((state_val_23665 === (5))){
var inst_23637 = (state_23664[(11)]);
var inst_23628 = (state_23664[(7)]);
var inst_23629 = (state_23664[(8)]);
var inst_23632 = (state_23664[(9)]);
var inst_23636 = (inst_23628[inst_23629] = inst_23632);
var inst_23637__$1 = (inst_23629 + (1));
var inst_23638 = (inst_23637__$1 < n);
var state_23664__$1 = (function (){var statearr_23678 = state_23664;
(statearr_23678[(11)] = inst_23637__$1);

(statearr_23678[(12)] = inst_23636);

return statearr_23678;
})();
if(cljs.core.truth_(inst_23638)){
var statearr_23679_23708 = state_23664__$1;
(statearr_23679_23708[(1)] = (8));

} else {
var statearr_23680_23709 = state_23664__$1;
(statearr_23680_23709[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (14))){
var inst_23657 = (state_23664[(2)]);
var inst_23658 = cljs.core.async.close_BANG_.call(null,out);
var state_23664__$1 = (function (){var statearr_23682 = state_23664;
(statearr_23682[(13)] = inst_23657);

return statearr_23682;
})();
var statearr_23683_23710 = state_23664__$1;
(statearr_23683_23710[(2)] = inst_23658);

(statearr_23683_23710[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (10))){
var inst_23648 = (state_23664[(2)]);
var state_23664__$1 = state_23664;
var statearr_23684_23711 = state_23664__$1;
(statearr_23684_23711[(2)] = inst_23648);

(statearr_23684_23711[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23665 === (8))){
var inst_23637 = (state_23664[(11)]);
var inst_23628 = (state_23664[(7)]);
var tmp23681 = inst_23628;
var inst_23628__$1 = tmp23681;
var inst_23629 = inst_23637;
var state_23664__$1 = (function (){var statearr_23685 = state_23664;
(statearr_23685[(7)] = inst_23628__$1);

(statearr_23685[(8)] = inst_23629);

return statearr_23685;
})();
var statearr_23686_23712 = state_23664__$1;
(statearr_23686_23712[(2)] = null);

(statearr_23686_23712[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23698,out))
;
return ((function (switch__20926__auto__,c__21038__auto___23698,out){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23690 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23690[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23690[(1)] = (1));

return statearr_23690;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23664){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23664);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23691){if((e23691 instanceof Object)){
var ex__20930__auto__ = e23691;
var statearr_23692_23713 = state_23664;
(statearr_23692_23713[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23664);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23691;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23714 = state_23664;
state_23664 = G__23714;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23664){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23664);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23698,out))
})();
var state__21040__auto__ = (function (){var statearr_23693 = f__21039__auto__.call(null);
(statearr_23693[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23698);

return statearr_23693;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23698,out))
);


return out;
});

cljs.core.async.partition.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.partition_by = (function cljs$core$async$partition_by(var_args){
var args23715 = [];
var len__19428__auto___23789 = arguments.length;
var i__19429__auto___23790 = (0);
while(true){
if((i__19429__auto___23790 < len__19428__auto___23789)){
args23715.push((arguments[i__19429__auto___23790]));

var G__23791 = (i__19429__auto___23790 + (1));
i__19429__auto___23790 = G__23791;
continue;
} else {
}
break;
}

var G__23717 = args23715.length;
switch (G__23717) {
case 2:
return cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23715.length)].join('')));

}
});

cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$2 = (function (f,ch){
return cljs.core.async.partition_by.call(null,f,ch,null);
});

cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$3 = (function (f,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21038__auto___23793 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___23793,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___23793,out){
return (function (state_23759){
var state_val_23760 = (state_23759[(1)]);
if((state_val_23760 === (7))){
var inst_23755 = (state_23759[(2)]);
var state_23759__$1 = state_23759;
var statearr_23761_23794 = state_23759__$1;
(statearr_23761_23794[(2)] = inst_23755);

(statearr_23761_23794[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (1))){
var inst_23718 = [];
var inst_23719 = inst_23718;
var inst_23720 = new cljs.core.Keyword("cljs.core.async","nothing","cljs.core.async/nothing",-69252123);
var state_23759__$1 = (function (){var statearr_23762 = state_23759;
(statearr_23762[(7)] = inst_23720);

(statearr_23762[(8)] = inst_23719);

return statearr_23762;
})();
var statearr_23763_23795 = state_23759__$1;
(statearr_23763_23795[(2)] = null);

(statearr_23763_23795[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (4))){
var inst_23723 = (state_23759[(9)]);
var inst_23723__$1 = (state_23759[(2)]);
var inst_23724 = (inst_23723__$1 == null);
var inst_23725 = cljs.core.not.call(null,inst_23724);
var state_23759__$1 = (function (){var statearr_23764 = state_23759;
(statearr_23764[(9)] = inst_23723__$1);

return statearr_23764;
})();
if(inst_23725){
var statearr_23765_23796 = state_23759__$1;
(statearr_23765_23796[(1)] = (5));

} else {
var statearr_23766_23797 = state_23759__$1;
(statearr_23766_23797[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (15))){
var inst_23749 = (state_23759[(2)]);
var state_23759__$1 = state_23759;
var statearr_23767_23798 = state_23759__$1;
(statearr_23767_23798[(2)] = inst_23749);

(statearr_23767_23798[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (13))){
var state_23759__$1 = state_23759;
var statearr_23768_23799 = state_23759__$1;
(statearr_23768_23799[(2)] = null);

(statearr_23768_23799[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (6))){
var inst_23719 = (state_23759[(8)]);
var inst_23744 = inst_23719.length;
var inst_23745 = (inst_23744 > (0));
var state_23759__$1 = state_23759;
if(cljs.core.truth_(inst_23745)){
var statearr_23769_23800 = state_23759__$1;
(statearr_23769_23800[(1)] = (12));

} else {
var statearr_23770_23801 = state_23759__$1;
(statearr_23770_23801[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (3))){
var inst_23757 = (state_23759[(2)]);
var state_23759__$1 = state_23759;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23759__$1,inst_23757);
} else {
if((state_val_23760 === (12))){
var inst_23719 = (state_23759[(8)]);
var inst_23747 = cljs.core.vec.call(null,inst_23719);
var state_23759__$1 = state_23759;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23759__$1,(15),out,inst_23747);
} else {
if((state_val_23760 === (2))){
var state_23759__$1 = state_23759;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23759__$1,(4),ch);
} else {
if((state_val_23760 === (11))){
var inst_23727 = (state_23759[(10)]);
var inst_23723 = (state_23759[(9)]);
var inst_23737 = (state_23759[(2)]);
var inst_23738 = [];
var inst_23739 = inst_23738.push(inst_23723);
var inst_23719 = inst_23738;
var inst_23720 = inst_23727;
var state_23759__$1 = (function (){var statearr_23771 = state_23759;
(statearr_23771[(11)] = inst_23739);

(statearr_23771[(7)] = inst_23720);

(statearr_23771[(12)] = inst_23737);

(statearr_23771[(8)] = inst_23719);

return statearr_23771;
})();
var statearr_23772_23802 = state_23759__$1;
(statearr_23772_23802[(2)] = null);

(statearr_23772_23802[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (9))){
var inst_23719 = (state_23759[(8)]);
var inst_23735 = cljs.core.vec.call(null,inst_23719);
var state_23759__$1 = state_23759;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23759__$1,(11),out,inst_23735);
} else {
if((state_val_23760 === (5))){
var inst_23720 = (state_23759[(7)]);
var inst_23727 = (state_23759[(10)]);
var inst_23723 = (state_23759[(9)]);
var inst_23727__$1 = f.call(null,inst_23723);
var inst_23728 = cljs.core._EQ_.call(null,inst_23727__$1,inst_23720);
var inst_23729 = cljs.core.keyword_identical_QMARK_.call(null,inst_23720,new cljs.core.Keyword("cljs.core.async","nothing","cljs.core.async/nothing",-69252123));
var inst_23730 = (inst_23728) || (inst_23729);
var state_23759__$1 = (function (){var statearr_23773 = state_23759;
(statearr_23773[(10)] = inst_23727__$1);

return statearr_23773;
})();
if(cljs.core.truth_(inst_23730)){
var statearr_23774_23803 = state_23759__$1;
(statearr_23774_23803[(1)] = (8));

} else {
var statearr_23775_23804 = state_23759__$1;
(statearr_23775_23804[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (14))){
var inst_23752 = (state_23759[(2)]);
var inst_23753 = cljs.core.async.close_BANG_.call(null,out);
var state_23759__$1 = (function (){var statearr_23777 = state_23759;
(statearr_23777[(13)] = inst_23752);

return statearr_23777;
})();
var statearr_23778_23805 = state_23759__$1;
(statearr_23778_23805[(2)] = inst_23753);

(statearr_23778_23805[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (10))){
var inst_23742 = (state_23759[(2)]);
var state_23759__$1 = state_23759;
var statearr_23779_23806 = state_23759__$1;
(statearr_23779_23806[(2)] = inst_23742);

(statearr_23779_23806[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23760 === (8))){
var inst_23727 = (state_23759[(10)]);
var inst_23723 = (state_23759[(9)]);
var inst_23719 = (state_23759[(8)]);
var inst_23732 = inst_23719.push(inst_23723);
var tmp23776 = inst_23719;
var inst_23719__$1 = tmp23776;
var inst_23720 = inst_23727;
var state_23759__$1 = (function (){var statearr_23780 = state_23759;
(statearr_23780[(14)] = inst_23732);

(statearr_23780[(7)] = inst_23720);

(statearr_23780[(8)] = inst_23719__$1);

return statearr_23780;
})();
var statearr_23781_23807 = state_23759__$1;
(statearr_23781_23807[(2)] = null);

(statearr_23781_23807[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
});})(c__21038__auto___23793,out))
;
return ((function (switch__20926__auto__,c__21038__auto___23793,out){
return (function() {
var cljs$core$async$state_machine__20927__auto__ = null;
var cljs$core$async$state_machine__20927__auto____0 = (function (){
var statearr_23785 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23785[(0)] = cljs$core$async$state_machine__20927__auto__);

(statearr_23785[(1)] = (1));

return statearr_23785;
});
var cljs$core$async$state_machine__20927__auto____1 = (function (state_23759){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_23759);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e23786){if((e23786 instanceof Object)){
var ex__20930__auto__ = e23786;
var statearr_23787_23808 = state_23759;
(statearr_23787_23808[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23759);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23786;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23809 = state_23759;
state_23759 = G__23809;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
cljs$core$async$state_machine__20927__auto__ = function(state_23759){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20927__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20927__auto____1.call(this,state_23759);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20927__auto____0;
cljs$core$async$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20927__auto____1;
return cljs$core$async$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___23793,out))
})();
var state__21040__auto__ = (function (){var statearr_23788 = f__21039__auto__.call(null);
(statearr_23788[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___23793);

return statearr_23788;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___23793,out))
);


return out;
});

cljs.core.async.partition_by.cljs$lang$maxFixedArity = 3;

//# sourceMappingURL=async.js.map