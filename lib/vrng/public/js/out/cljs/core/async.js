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
var args21082 = [];
var len__19428__auto___21088 = arguments.length;
var i__19429__auto___21089 = (0);
while(true){
if((i__19429__auto___21089 < len__19428__auto___21088)){
args21082.push((arguments[i__19429__auto___21089]));

var G__21090 = (i__19429__auto___21089 + (1));
i__19429__auto___21089 = G__21090;
continue;
} else {
}
break;
}

var G__21084 = args21082.length;
switch (G__21084) {
case 1:
return cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21082.length)].join('')));

}
});

cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$1 = (function (f){
return cljs.core.async.fn_handler.call(null,f,true);
});

cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$2 = (function (f,blockable){
if(typeof cljs.core.async.t_cljs$core$async21085 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21085 = (function (f,blockable,meta21086){
this.f = f;
this.blockable = blockable;
this.meta21086 = meta21086;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21085.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_21087,meta21086__$1){
var self__ = this;
var _21087__$1 = this;
return (new cljs.core.async.t_cljs$core$async21085(self__.f,self__.blockable,meta21086__$1));
});

cljs.core.async.t_cljs$core$async21085.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_21087){
var self__ = this;
var _21087__$1 = this;
return self__.meta21086;
});

cljs.core.async.t_cljs$core$async21085.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21085.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return true;
});

cljs.core.async.t_cljs$core$async21085.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return self__.blockable;
});

cljs.core.async.t_cljs$core$async21085.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return self__.f;
});

cljs.core.async.t_cljs$core$async21085.getBasis = (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"blockable","blockable",-28395259,null),new cljs.core.Symbol(null,"meta21086","meta21086",360134220,null)], null);
});

cljs.core.async.t_cljs$core$async21085.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21085.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21085";

cljs.core.async.t_cljs$core$async21085.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21085");
});

cljs.core.async.__GT_t_cljs$core$async21085 = (function cljs$core$async$__GT_t_cljs$core$async21085(f__$1,blockable__$1,meta21086){
return (new cljs.core.async.t_cljs$core$async21085(f__$1,blockable__$1,meta21086));
});

}

return (new cljs.core.async.t_cljs$core$async21085(f,blockable,cljs.core.PersistentArrayMap.EMPTY));
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
var args21094 = [];
var len__19428__auto___21097 = arguments.length;
var i__19429__auto___21098 = (0);
while(true){
if((i__19429__auto___21098 < len__19428__auto___21097)){
args21094.push((arguments[i__19429__auto___21098]));

var G__21099 = (i__19429__auto___21098 + (1));
i__19429__auto___21098 = G__21099;
continue;
} else {
}
break;
}

var G__21096 = args21094.length;
switch (G__21096) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21094.length)].join('')));

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
var args21101 = [];
var len__19428__auto___21104 = arguments.length;
var i__19429__auto___21105 = (0);
while(true){
if((i__19429__auto___21105 < len__19428__auto___21104)){
args21101.push((arguments[i__19429__auto___21105]));

var G__21106 = (i__19429__auto___21105 + (1));
i__19429__auto___21105 = G__21106;
continue;
} else {
}
break;
}

var G__21103 = args21101.length;
switch (G__21103) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21101.length)].join('')));

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
var args21108 = [];
var len__19428__auto___21111 = arguments.length;
var i__19429__auto___21112 = (0);
while(true){
if((i__19429__auto___21112 < len__19428__auto___21111)){
args21108.push((arguments[i__19429__auto___21112]));

var G__21113 = (i__19429__auto___21112 + (1));
i__19429__auto___21112 = G__21113;
continue;
} else {
}
break;
}

var G__21110 = args21108.length;
switch (G__21110) {
case 2:
return cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21108.length)].join('')));

}
});

cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$2 = (function (port,fn1){
return cljs.core.async.take_BANG_.call(null,port,fn1,true);
});

cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$3 = (function (port,fn1,on_caller_QMARK_){
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.fn_handler.call(null,fn1));
if(cljs.core.truth_(ret)){
var val_21115 = cljs.core.deref.call(null,ret);
if(cljs.core.truth_(on_caller_QMARK_)){
fn1.call(null,val_21115);
} else {
cljs.core.async.impl.dispatch.run.call(null,((function (val_21115,ret){
return (function (){
return fn1.call(null,val_21115);
});})(val_21115,ret))
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
var args21116 = [];
var len__19428__auto___21119 = arguments.length;
var i__19429__auto___21120 = (0);
while(true){
if((i__19429__auto___21120 < len__19428__auto___21119)){
args21116.push((arguments[i__19429__auto___21120]));

var G__21121 = (i__19429__auto___21120 + (1));
i__19429__auto___21120 = G__21121;
continue;
} else {
}
break;
}

var G__21118 = args21116.length;
switch (G__21118) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21116.length)].join('')));

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
var n__19273__auto___21123 = n;
var x_21124 = (0);
while(true){
if((x_21124 < n__19273__auto___21123)){
(a[x_21124] = (0));

var G__21125 = (x_21124 + (1));
x_21124 = G__21125;
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

var G__21126 = (i + (1));
i = G__21126;
continue;
}
break;
}
});
cljs.core.async.alt_flag = (function cljs$core$async$alt_flag(){
var flag = cljs.core.atom.call(null,true);
if(typeof cljs.core.async.t_cljs$core$async21130 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21130 = (function (alt_flag,flag,meta21131){
this.alt_flag = alt_flag;
this.flag = flag;
this.meta21131 = meta21131;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21130.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (flag){
return (function (_21132,meta21131__$1){
var self__ = this;
var _21132__$1 = this;
return (new cljs.core.async.t_cljs$core$async21130(self__.alt_flag,self__.flag,meta21131__$1));
});})(flag))
;

cljs.core.async.t_cljs$core$async21130.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (flag){
return (function (_21132){
var self__ = this;
var _21132__$1 = this;
return self__.meta21131;
});})(flag))
;

cljs.core.async.t_cljs$core$async21130.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21130.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.deref.call(null,self__.flag);
});})(flag))
;

cljs.core.async.t_cljs$core$async21130.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
return true;
});})(flag))
;

cljs.core.async.t_cljs$core$async21130.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.flag,null);

return true;
});})(flag))
;

cljs.core.async.t_cljs$core$async21130.getBasis = ((function (flag){
return (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"alt-flag","alt-flag",-1794972754,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"private","private",-558947994),true,new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(cljs.core.PersistentVector.EMPTY))], null)),new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"meta21131","meta21131",-1775622888,null)], null);
});})(flag))
;

cljs.core.async.t_cljs$core$async21130.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21130.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21130";

cljs.core.async.t_cljs$core$async21130.cljs$lang$ctorPrWriter = ((function (flag){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21130");
});})(flag))
;

cljs.core.async.__GT_t_cljs$core$async21130 = ((function (flag){
return (function cljs$core$async$alt_flag_$___GT_t_cljs$core$async21130(alt_flag__$1,flag__$1,meta21131){
return (new cljs.core.async.t_cljs$core$async21130(alt_flag__$1,flag__$1,meta21131));
});})(flag))
;

}

return (new cljs.core.async.t_cljs$core$async21130(cljs$core$async$alt_flag,flag,cljs.core.PersistentArrayMap.EMPTY));
});
cljs.core.async.alt_handler = (function cljs$core$async$alt_handler(flag,cb){
if(typeof cljs.core.async.t_cljs$core$async21136 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21136 = (function (alt_handler,flag,cb,meta21137){
this.alt_handler = alt_handler;
this.flag = flag;
this.cb = cb;
this.meta21137 = meta21137;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21136.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_21138,meta21137__$1){
var self__ = this;
var _21138__$1 = this;
return (new cljs.core.async.t_cljs$core$async21136(self__.alt_handler,self__.flag,self__.cb,meta21137__$1));
});

cljs.core.async.t_cljs$core$async21136.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_21138){
var self__ = this;
var _21138__$1 = this;
return self__.meta21137;
});

cljs.core.async.t_cljs$core$async21136.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21136.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.active_QMARK_.call(null,self__.flag);
});

cljs.core.async.t_cljs$core$async21136.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return true;
});

cljs.core.async.t_cljs$core$async21136.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.async.impl.protocols.commit.call(null,self__.flag);

return self__.cb;
});

cljs.core.async.t_cljs$core$async21136.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"alt-handler","alt-handler",963786170,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"private","private",-558947994),true,new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"cb","cb",-2064487928,null)], null)))], null)),new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"cb","cb",-2064487928,null),new cljs.core.Symbol(null,"meta21137","meta21137",1741562251,null)], null);
});

cljs.core.async.t_cljs$core$async21136.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21136.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21136";

cljs.core.async.t_cljs$core$async21136.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21136");
});

cljs.core.async.__GT_t_cljs$core$async21136 = (function cljs$core$async$alt_handler_$___GT_t_cljs$core$async21136(alt_handler__$1,flag__$1,cb__$1,meta21137){
return (new cljs.core.async.t_cljs$core$async21136(alt_handler__$1,flag__$1,cb__$1,meta21137));
});

}

return (new cljs.core.async.t_cljs$core$async21136(cljs$core$async$alt_handler,flag,cb,cljs.core.PersistentArrayMap.EMPTY));
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
return (function (p1__21139_SHARP_){
return fret.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [p1__21139_SHARP_,wport], null));
});})(i,val,idx,port,wport,flag,n,idxs,priority))
));
})():cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.alt_handler.call(null,flag,((function (i,idx,port,wport,flag,n,idxs,priority){
return (function (p1__21140_SHARP_){
return fret.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [p1__21140_SHARP_,port], null));
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
var G__21141 = (i + (1));
i = G__21141;
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
var len__19428__auto___21147 = arguments.length;
var i__19429__auto___21148 = (0);
while(true){
if((i__19429__auto___21148 < len__19428__auto___21147)){
args__19435__auto__.push((arguments[i__19429__auto___21148]));

var G__21149 = (i__19429__auto___21148 + (1));
i__19429__auto___21148 = G__21149;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ports,p__21144){
var map__21145 = p__21144;
var map__21145__$1 = ((((!((map__21145 == null)))?((((map__21145.cljs$lang$protocol_mask$partition0$ & (64))) || (map__21145.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__21145):map__21145);
var opts = map__21145__$1;
throw (new Error("alts! used not in (go ...) block"));
});

cljs.core.async.alts_BANG_.cljs$lang$maxFixedArity = (1);

cljs.core.async.alts_BANG_.cljs$lang$applyTo = (function (seq21142){
var G__21143 = cljs.core.first.call(null,seq21142);
var seq21142__$1 = cljs.core.next.call(null,seq21142);
return cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__21143,seq21142__$1);
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
var args21150 = [];
var len__19428__auto___21200 = arguments.length;
var i__19429__auto___21201 = (0);
while(true){
if((i__19429__auto___21201 < len__19428__auto___21200)){
args21150.push((arguments[i__19429__auto___21201]));

var G__21202 = (i__19429__auto___21201 + (1));
i__19429__auto___21201 = G__21202;
continue;
} else {
}
break;
}

var G__21152 = args21150.length;
switch (G__21152) {
case 2:
return cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21150.length)].join('')));

}
});

cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$2 = (function (from,to){
return cljs.core.async.pipe.call(null,from,to,true);
});

cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$3 = (function (from,to,close_QMARK_){
var c__21037__auto___21204 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___21204){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___21204){
return (function (state_21176){
var state_val_21177 = (state_21176[(1)]);
if((state_val_21177 === (7))){
var inst_21172 = (state_21176[(2)]);
var state_21176__$1 = state_21176;
var statearr_21178_21205 = state_21176__$1;
(statearr_21178_21205[(2)] = inst_21172);

(statearr_21178_21205[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (1))){
var state_21176__$1 = state_21176;
var statearr_21179_21206 = state_21176__$1;
(statearr_21179_21206[(2)] = null);

(statearr_21179_21206[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (4))){
var inst_21155 = (state_21176[(7)]);
var inst_21155__$1 = (state_21176[(2)]);
var inst_21156 = (inst_21155__$1 == null);
var state_21176__$1 = (function (){var statearr_21180 = state_21176;
(statearr_21180[(7)] = inst_21155__$1);

return statearr_21180;
})();
if(cljs.core.truth_(inst_21156)){
var statearr_21181_21207 = state_21176__$1;
(statearr_21181_21207[(1)] = (5));

} else {
var statearr_21182_21208 = state_21176__$1;
(statearr_21182_21208[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (13))){
var state_21176__$1 = state_21176;
var statearr_21183_21209 = state_21176__$1;
(statearr_21183_21209[(2)] = null);

(statearr_21183_21209[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (6))){
var inst_21155 = (state_21176[(7)]);
var state_21176__$1 = state_21176;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21176__$1,(11),to,inst_21155);
} else {
if((state_val_21177 === (3))){
var inst_21174 = (state_21176[(2)]);
var state_21176__$1 = state_21176;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21176__$1,inst_21174);
} else {
if((state_val_21177 === (12))){
var state_21176__$1 = state_21176;
var statearr_21184_21210 = state_21176__$1;
(statearr_21184_21210[(2)] = null);

(statearr_21184_21210[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (2))){
var state_21176__$1 = state_21176;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21176__$1,(4),from);
} else {
if((state_val_21177 === (11))){
var inst_21165 = (state_21176[(2)]);
var state_21176__$1 = state_21176;
if(cljs.core.truth_(inst_21165)){
var statearr_21185_21211 = state_21176__$1;
(statearr_21185_21211[(1)] = (12));

} else {
var statearr_21186_21212 = state_21176__$1;
(statearr_21186_21212[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (9))){
var state_21176__$1 = state_21176;
var statearr_21187_21213 = state_21176__$1;
(statearr_21187_21213[(2)] = null);

(statearr_21187_21213[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (5))){
var state_21176__$1 = state_21176;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21188_21214 = state_21176__$1;
(statearr_21188_21214[(1)] = (8));

} else {
var statearr_21189_21215 = state_21176__$1;
(statearr_21189_21215[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (14))){
var inst_21170 = (state_21176[(2)]);
var state_21176__$1 = state_21176;
var statearr_21190_21216 = state_21176__$1;
(statearr_21190_21216[(2)] = inst_21170);

(statearr_21190_21216[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (10))){
var inst_21162 = (state_21176[(2)]);
var state_21176__$1 = state_21176;
var statearr_21191_21217 = state_21176__$1;
(statearr_21191_21217[(2)] = inst_21162);

(statearr_21191_21217[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21177 === (8))){
var inst_21159 = cljs.core.async.close_BANG_.call(null,to);
var state_21176__$1 = state_21176;
var statearr_21192_21218 = state_21176__$1;
(statearr_21192_21218[(2)] = inst_21159);

(statearr_21192_21218[(1)] = (10));


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
});})(c__21037__auto___21204))
;
return ((function (switch__20925__auto__,c__21037__auto___21204){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_21196 = [null,null,null,null,null,null,null,null];
(statearr_21196[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_21196[(1)] = (1));

return statearr_21196;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_21176){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21176);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21197){if((e21197 instanceof Object)){
var ex__20929__auto__ = e21197;
var statearr_21198_21219 = state_21176;
(statearr_21198_21219[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21176);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21197;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21220 = state_21176;
state_21176 = G__21220;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_21176){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_21176);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___21204))
})();
var state__21039__auto__ = (function (){var statearr_21199 = f__21038__auto__.call(null);
(statearr_21199[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___21204);

return statearr_21199;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___21204))
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
return (function (p__21404){
var vec__21405 = p__21404;
var v = cljs.core.nth.call(null,vec__21405,(0),null);
var p = cljs.core.nth.call(null,vec__21405,(1),null);
var job = vec__21405;
if((job == null)){
cljs.core.async.close_BANG_.call(null,results);

return null;
} else {
var res = cljs.core.async.chan.call(null,(1),xf,ex_handler);
var c__21037__auto___21587 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___21587,res,vec__21405,v,p,job,jobs,results){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___21587,res,vec__21405,v,p,job,jobs,results){
return (function (state_21410){
var state_val_21411 = (state_21410[(1)]);
if((state_val_21411 === (1))){
var state_21410__$1 = state_21410;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21410__$1,(2),res,v);
} else {
if((state_val_21411 === (2))){
var inst_21407 = (state_21410[(2)]);
var inst_21408 = cljs.core.async.close_BANG_.call(null,res);
var state_21410__$1 = (function (){var statearr_21412 = state_21410;
(statearr_21412[(7)] = inst_21407);

return statearr_21412;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21410__$1,inst_21408);
} else {
return null;
}
}
});})(c__21037__auto___21587,res,vec__21405,v,p,job,jobs,results))
;
return ((function (switch__20925__auto__,c__21037__auto___21587,res,vec__21405,v,p,job,jobs,results){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0 = (function (){
var statearr_21416 = [null,null,null,null,null,null,null,null];
(statearr_21416[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__);

(statearr_21416[(1)] = (1));

return statearr_21416;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1 = (function (state_21410){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21410);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21417){if((e21417 instanceof Object)){
var ex__20929__auto__ = e21417;
var statearr_21418_21588 = state_21410;
(statearr_21418_21588[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21410);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21417;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21589 = state_21410;
state_21410 = G__21589;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = function(state_21410){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1.call(this,state_21410);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___21587,res,vec__21405,v,p,job,jobs,results))
})();
var state__21039__auto__ = (function (){var statearr_21419 = f__21038__auto__.call(null);
(statearr_21419[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___21587);

return statearr_21419;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___21587,res,vec__21405,v,p,job,jobs,results))
);


cljs.core.async.put_BANG_.call(null,p,res);

return true;
}
});})(jobs,results))
;
var async = ((function (jobs,results,process){
return (function (p__21420){
var vec__21421 = p__21420;
var v = cljs.core.nth.call(null,vec__21421,(0),null);
var p = cljs.core.nth.call(null,vec__21421,(1),null);
var job = vec__21421;
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
var n__19273__auto___21590 = n;
var __21591 = (0);
while(true){
if((__21591 < n__19273__auto___21590)){
var G__21422_21592 = (((type instanceof cljs.core.Keyword))?type.fqn:null);
switch (G__21422_21592) {
case "compute":
var c__21037__auto___21594 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (__21591,c__21037__auto___21594,G__21422_21592,n__19273__auto___21590,jobs,results,process,async){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (__21591,c__21037__auto___21594,G__21422_21592,n__19273__auto___21590,jobs,results,process,async){
return (function (state_21435){
var state_val_21436 = (state_21435[(1)]);
if((state_val_21436 === (1))){
var state_21435__$1 = state_21435;
var statearr_21437_21595 = state_21435__$1;
(statearr_21437_21595[(2)] = null);

(statearr_21437_21595[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21436 === (2))){
var state_21435__$1 = state_21435;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21435__$1,(4),jobs);
} else {
if((state_val_21436 === (3))){
var inst_21433 = (state_21435[(2)]);
var state_21435__$1 = state_21435;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21435__$1,inst_21433);
} else {
if((state_val_21436 === (4))){
var inst_21425 = (state_21435[(2)]);
var inst_21426 = process.call(null,inst_21425);
var state_21435__$1 = state_21435;
if(cljs.core.truth_(inst_21426)){
var statearr_21438_21596 = state_21435__$1;
(statearr_21438_21596[(1)] = (5));

} else {
var statearr_21439_21597 = state_21435__$1;
(statearr_21439_21597[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21436 === (5))){
var state_21435__$1 = state_21435;
var statearr_21440_21598 = state_21435__$1;
(statearr_21440_21598[(2)] = null);

(statearr_21440_21598[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21436 === (6))){
var state_21435__$1 = state_21435;
var statearr_21441_21599 = state_21435__$1;
(statearr_21441_21599[(2)] = null);

(statearr_21441_21599[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21436 === (7))){
var inst_21431 = (state_21435[(2)]);
var state_21435__$1 = state_21435;
var statearr_21442_21600 = state_21435__$1;
(statearr_21442_21600[(2)] = inst_21431);

(statearr_21442_21600[(1)] = (3));


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
});})(__21591,c__21037__auto___21594,G__21422_21592,n__19273__auto___21590,jobs,results,process,async))
;
return ((function (__21591,switch__20925__auto__,c__21037__auto___21594,G__21422_21592,n__19273__auto___21590,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0 = (function (){
var statearr_21446 = [null,null,null,null,null,null,null];
(statearr_21446[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__);

(statearr_21446[(1)] = (1));

return statearr_21446;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1 = (function (state_21435){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21435);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21447){if((e21447 instanceof Object)){
var ex__20929__auto__ = e21447;
var statearr_21448_21601 = state_21435;
(statearr_21448_21601[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21435);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21447;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21602 = state_21435;
state_21435 = G__21602;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = function(state_21435){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1.call(this,state_21435);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__;
})()
;})(__21591,switch__20925__auto__,c__21037__auto___21594,G__21422_21592,n__19273__auto___21590,jobs,results,process,async))
})();
var state__21039__auto__ = (function (){var statearr_21449 = f__21038__auto__.call(null);
(statearr_21449[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___21594);

return statearr_21449;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(__21591,c__21037__auto___21594,G__21422_21592,n__19273__auto___21590,jobs,results,process,async))
);


break;
case "async":
var c__21037__auto___21603 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (__21591,c__21037__auto___21603,G__21422_21592,n__19273__auto___21590,jobs,results,process,async){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (__21591,c__21037__auto___21603,G__21422_21592,n__19273__auto___21590,jobs,results,process,async){
return (function (state_21462){
var state_val_21463 = (state_21462[(1)]);
if((state_val_21463 === (1))){
var state_21462__$1 = state_21462;
var statearr_21464_21604 = state_21462__$1;
(statearr_21464_21604[(2)] = null);

(statearr_21464_21604[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21463 === (2))){
var state_21462__$1 = state_21462;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21462__$1,(4),jobs);
} else {
if((state_val_21463 === (3))){
var inst_21460 = (state_21462[(2)]);
var state_21462__$1 = state_21462;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21462__$1,inst_21460);
} else {
if((state_val_21463 === (4))){
var inst_21452 = (state_21462[(2)]);
var inst_21453 = async.call(null,inst_21452);
var state_21462__$1 = state_21462;
if(cljs.core.truth_(inst_21453)){
var statearr_21465_21605 = state_21462__$1;
(statearr_21465_21605[(1)] = (5));

} else {
var statearr_21466_21606 = state_21462__$1;
(statearr_21466_21606[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21463 === (5))){
var state_21462__$1 = state_21462;
var statearr_21467_21607 = state_21462__$1;
(statearr_21467_21607[(2)] = null);

(statearr_21467_21607[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21463 === (6))){
var state_21462__$1 = state_21462;
var statearr_21468_21608 = state_21462__$1;
(statearr_21468_21608[(2)] = null);

(statearr_21468_21608[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21463 === (7))){
var inst_21458 = (state_21462[(2)]);
var state_21462__$1 = state_21462;
var statearr_21469_21609 = state_21462__$1;
(statearr_21469_21609[(2)] = inst_21458);

(statearr_21469_21609[(1)] = (3));


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
});})(__21591,c__21037__auto___21603,G__21422_21592,n__19273__auto___21590,jobs,results,process,async))
;
return ((function (__21591,switch__20925__auto__,c__21037__auto___21603,G__21422_21592,n__19273__auto___21590,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0 = (function (){
var statearr_21473 = [null,null,null,null,null,null,null];
(statearr_21473[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__);

(statearr_21473[(1)] = (1));

return statearr_21473;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1 = (function (state_21462){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21462);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21474){if((e21474 instanceof Object)){
var ex__20929__auto__ = e21474;
var statearr_21475_21610 = state_21462;
(statearr_21475_21610[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21462);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21474;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21611 = state_21462;
state_21462 = G__21611;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = function(state_21462){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1.call(this,state_21462);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__;
})()
;})(__21591,switch__20925__auto__,c__21037__auto___21603,G__21422_21592,n__19273__auto___21590,jobs,results,process,async))
})();
var state__21039__auto__ = (function (){var statearr_21476 = f__21038__auto__.call(null);
(statearr_21476[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___21603);

return statearr_21476;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(__21591,c__21037__auto___21603,G__21422_21592,n__19273__auto___21590,jobs,results,process,async))
);


break;
default:
throw (new Error([cljs.core.str("No matching clause: "),cljs.core.str(type)].join('')));

}

var G__21612 = (__21591 + (1));
__21591 = G__21612;
continue;
} else {
}
break;
}

var c__21037__auto___21613 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___21613,jobs,results,process,async){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___21613,jobs,results,process,async){
return (function (state_21498){
var state_val_21499 = (state_21498[(1)]);
if((state_val_21499 === (1))){
var state_21498__$1 = state_21498;
var statearr_21500_21614 = state_21498__$1;
(statearr_21500_21614[(2)] = null);

(statearr_21500_21614[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21499 === (2))){
var state_21498__$1 = state_21498;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21498__$1,(4),from);
} else {
if((state_val_21499 === (3))){
var inst_21496 = (state_21498[(2)]);
var state_21498__$1 = state_21498;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21498__$1,inst_21496);
} else {
if((state_val_21499 === (4))){
var inst_21479 = (state_21498[(7)]);
var inst_21479__$1 = (state_21498[(2)]);
var inst_21480 = (inst_21479__$1 == null);
var state_21498__$1 = (function (){var statearr_21501 = state_21498;
(statearr_21501[(7)] = inst_21479__$1);

return statearr_21501;
})();
if(cljs.core.truth_(inst_21480)){
var statearr_21502_21615 = state_21498__$1;
(statearr_21502_21615[(1)] = (5));

} else {
var statearr_21503_21616 = state_21498__$1;
(statearr_21503_21616[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21499 === (5))){
var inst_21482 = cljs.core.async.close_BANG_.call(null,jobs);
var state_21498__$1 = state_21498;
var statearr_21504_21617 = state_21498__$1;
(statearr_21504_21617[(2)] = inst_21482);

(statearr_21504_21617[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21499 === (6))){
var inst_21479 = (state_21498[(7)]);
var inst_21484 = (state_21498[(8)]);
var inst_21484__$1 = cljs.core.async.chan.call(null,(1));
var inst_21485 = cljs.core.PersistentVector.EMPTY_NODE;
var inst_21486 = [inst_21479,inst_21484__$1];
var inst_21487 = (new cljs.core.PersistentVector(null,2,(5),inst_21485,inst_21486,null));
var state_21498__$1 = (function (){var statearr_21505 = state_21498;
(statearr_21505[(8)] = inst_21484__$1);

return statearr_21505;
})();
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21498__$1,(8),jobs,inst_21487);
} else {
if((state_val_21499 === (7))){
var inst_21494 = (state_21498[(2)]);
var state_21498__$1 = state_21498;
var statearr_21506_21618 = state_21498__$1;
(statearr_21506_21618[(2)] = inst_21494);

(statearr_21506_21618[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21499 === (8))){
var inst_21484 = (state_21498[(8)]);
var inst_21489 = (state_21498[(2)]);
var state_21498__$1 = (function (){var statearr_21507 = state_21498;
(statearr_21507[(9)] = inst_21489);

return statearr_21507;
})();
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21498__$1,(9),results,inst_21484);
} else {
if((state_val_21499 === (9))){
var inst_21491 = (state_21498[(2)]);
var state_21498__$1 = (function (){var statearr_21508 = state_21498;
(statearr_21508[(10)] = inst_21491);

return statearr_21508;
})();
var statearr_21509_21619 = state_21498__$1;
(statearr_21509_21619[(2)] = null);

(statearr_21509_21619[(1)] = (2));


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
});})(c__21037__auto___21613,jobs,results,process,async))
;
return ((function (switch__20925__auto__,c__21037__auto___21613,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0 = (function (){
var statearr_21513 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_21513[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__);

(statearr_21513[(1)] = (1));

return statearr_21513;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1 = (function (state_21498){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21498);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21514){if((e21514 instanceof Object)){
var ex__20929__auto__ = e21514;
var statearr_21515_21620 = state_21498;
(statearr_21515_21620[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21498);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21514;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21621 = state_21498;
state_21498 = G__21621;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = function(state_21498){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1.call(this,state_21498);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___21613,jobs,results,process,async))
})();
var state__21039__auto__ = (function (){var statearr_21516 = f__21038__auto__.call(null);
(statearr_21516[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___21613);

return statearr_21516;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___21613,jobs,results,process,async))
);


var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__,jobs,results,process,async){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__,jobs,results,process,async){
return (function (state_21554){
var state_val_21555 = (state_21554[(1)]);
if((state_val_21555 === (7))){
var inst_21550 = (state_21554[(2)]);
var state_21554__$1 = state_21554;
var statearr_21556_21622 = state_21554__$1;
(statearr_21556_21622[(2)] = inst_21550);

(statearr_21556_21622[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (20))){
var state_21554__$1 = state_21554;
var statearr_21557_21623 = state_21554__$1;
(statearr_21557_21623[(2)] = null);

(statearr_21557_21623[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (1))){
var state_21554__$1 = state_21554;
var statearr_21558_21624 = state_21554__$1;
(statearr_21558_21624[(2)] = null);

(statearr_21558_21624[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (4))){
var inst_21519 = (state_21554[(7)]);
var inst_21519__$1 = (state_21554[(2)]);
var inst_21520 = (inst_21519__$1 == null);
var state_21554__$1 = (function (){var statearr_21559 = state_21554;
(statearr_21559[(7)] = inst_21519__$1);

return statearr_21559;
})();
if(cljs.core.truth_(inst_21520)){
var statearr_21560_21625 = state_21554__$1;
(statearr_21560_21625[(1)] = (5));

} else {
var statearr_21561_21626 = state_21554__$1;
(statearr_21561_21626[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (15))){
var inst_21532 = (state_21554[(8)]);
var state_21554__$1 = state_21554;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21554__$1,(18),to,inst_21532);
} else {
if((state_val_21555 === (21))){
var inst_21545 = (state_21554[(2)]);
var state_21554__$1 = state_21554;
var statearr_21562_21627 = state_21554__$1;
(statearr_21562_21627[(2)] = inst_21545);

(statearr_21562_21627[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (13))){
var inst_21547 = (state_21554[(2)]);
var state_21554__$1 = (function (){var statearr_21563 = state_21554;
(statearr_21563[(9)] = inst_21547);

return statearr_21563;
})();
var statearr_21564_21628 = state_21554__$1;
(statearr_21564_21628[(2)] = null);

(statearr_21564_21628[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (6))){
var inst_21519 = (state_21554[(7)]);
var state_21554__$1 = state_21554;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21554__$1,(11),inst_21519);
} else {
if((state_val_21555 === (17))){
var inst_21540 = (state_21554[(2)]);
var state_21554__$1 = state_21554;
if(cljs.core.truth_(inst_21540)){
var statearr_21565_21629 = state_21554__$1;
(statearr_21565_21629[(1)] = (19));

} else {
var statearr_21566_21630 = state_21554__$1;
(statearr_21566_21630[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (3))){
var inst_21552 = (state_21554[(2)]);
var state_21554__$1 = state_21554;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21554__$1,inst_21552);
} else {
if((state_val_21555 === (12))){
var inst_21529 = (state_21554[(10)]);
var state_21554__$1 = state_21554;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21554__$1,(14),inst_21529);
} else {
if((state_val_21555 === (2))){
var state_21554__$1 = state_21554;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21554__$1,(4),results);
} else {
if((state_val_21555 === (19))){
var state_21554__$1 = state_21554;
var statearr_21567_21631 = state_21554__$1;
(statearr_21567_21631[(2)] = null);

(statearr_21567_21631[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (11))){
var inst_21529 = (state_21554[(2)]);
var state_21554__$1 = (function (){var statearr_21568 = state_21554;
(statearr_21568[(10)] = inst_21529);

return statearr_21568;
})();
var statearr_21569_21632 = state_21554__$1;
(statearr_21569_21632[(2)] = null);

(statearr_21569_21632[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (9))){
var state_21554__$1 = state_21554;
var statearr_21570_21633 = state_21554__$1;
(statearr_21570_21633[(2)] = null);

(statearr_21570_21633[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (5))){
var state_21554__$1 = state_21554;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21571_21634 = state_21554__$1;
(statearr_21571_21634[(1)] = (8));

} else {
var statearr_21572_21635 = state_21554__$1;
(statearr_21572_21635[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (14))){
var inst_21532 = (state_21554[(8)]);
var inst_21534 = (state_21554[(11)]);
var inst_21532__$1 = (state_21554[(2)]);
var inst_21533 = (inst_21532__$1 == null);
var inst_21534__$1 = cljs.core.not.call(null,inst_21533);
var state_21554__$1 = (function (){var statearr_21573 = state_21554;
(statearr_21573[(8)] = inst_21532__$1);

(statearr_21573[(11)] = inst_21534__$1);

return statearr_21573;
})();
if(inst_21534__$1){
var statearr_21574_21636 = state_21554__$1;
(statearr_21574_21636[(1)] = (15));

} else {
var statearr_21575_21637 = state_21554__$1;
(statearr_21575_21637[(1)] = (16));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (16))){
var inst_21534 = (state_21554[(11)]);
var state_21554__$1 = state_21554;
var statearr_21576_21638 = state_21554__$1;
(statearr_21576_21638[(2)] = inst_21534);

(statearr_21576_21638[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (10))){
var inst_21526 = (state_21554[(2)]);
var state_21554__$1 = state_21554;
var statearr_21577_21639 = state_21554__$1;
(statearr_21577_21639[(2)] = inst_21526);

(statearr_21577_21639[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (18))){
var inst_21537 = (state_21554[(2)]);
var state_21554__$1 = state_21554;
var statearr_21578_21640 = state_21554__$1;
(statearr_21578_21640[(2)] = inst_21537);

(statearr_21578_21640[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21555 === (8))){
var inst_21523 = cljs.core.async.close_BANG_.call(null,to);
var state_21554__$1 = state_21554;
var statearr_21579_21641 = state_21554__$1;
(statearr_21579_21641[(2)] = inst_21523);

(statearr_21579_21641[(1)] = (10));


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
});})(c__21037__auto__,jobs,results,process,async))
;
return ((function (switch__20925__auto__,c__21037__auto__,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0 = (function (){
var statearr_21583 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_21583[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__);

(statearr_21583[(1)] = (1));

return statearr_21583;
});
var cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1 = (function (state_21554){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21554);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21584){if((e21584 instanceof Object)){
var ex__20929__auto__ = e21584;
var statearr_21585_21642 = state_21554;
(statearr_21585_21642[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21554);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21584;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21643 = state_21554;
state_21554 = G__21643;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__ = function(state_21554){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1.call(this,state_21554);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__20926__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__,jobs,results,process,async))
})();
var state__21039__auto__ = (function (){var statearr_21586 = f__21038__auto__.call(null);
(statearr_21586[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_21586;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__,jobs,results,process,async))
);

return c__21037__auto__;
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
var args21644 = [];
var len__19428__auto___21647 = arguments.length;
var i__19429__auto___21648 = (0);
while(true){
if((i__19429__auto___21648 < len__19428__auto___21647)){
args21644.push((arguments[i__19429__auto___21648]));

var G__21649 = (i__19429__auto___21648 + (1));
i__19429__auto___21648 = G__21649;
continue;
} else {
}
break;
}

var G__21646 = args21644.length;
switch (G__21646) {
case 4:
return cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
case 5:
return cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$5((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]),(arguments[(4)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21644.length)].join('')));

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
var args21651 = [];
var len__19428__auto___21654 = arguments.length;
var i__19429__auto___21655 = (0);
while(true){
if((i__19429__auto___21655 < len__19428__auto___21654)){
args21651.push((arguments[i__19429__auto___21655]));

var G__21656 = (i__19429__auto___21655 + (1));
i__19429__auto___21655 = G__21656;
continue;
} else {
}
break;
}

var G__21653 = args21651.length;
switch (G__21653) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21651.length)].join('')));

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
var args21658 = [];
var len__19428__auto___21711 = arguments.length;
var i__19429__auto___21712 = (0);
while(true){
if((i__19429__auto___21712 < len__19428__auto___21711)){
args21658.push((arguments[i__19429__auto___21712]));

var G__21713 = (i__19429__auto___21712 + (1));
i__19429__auto___21712 = G__21713;
continue;
} else {
}
break;
}

var G__21660 = args21658.length;
switch (G__21660) {
case 2:
return cljs.core.async.split.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 4:
return cljs.core.async.split.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21658.length)].join('')));

}
});

cljs.core.async.split.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.split.call(null,p,ch,null,null);
});

cljs.core.async.split.cljs$core$IFn$_invoke$arity$4 = (function (p,ch,t_buf_or_n,f_buf_or_n){
var tc = cljs.core.async.chan.call(null,t_buf_or_n);
var fc = cljs.core.async.chan.call(null,f_buf_or_n);
var c__21037__auto___21715 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___21715,tc,fc){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___21715,tc,fc){
return (function (state_21686){
var state_val_21687 = (state_21686[(1)]);
if((state_val_21687 === (7))){
var inst_21682 = (state_21686[(2)]);
var state_21686__$1 = state_21686;
var statearr_21688_21716 = state_21686__$1;
(statearr_21688_21716[(2)] = inst_21682);

(statearr_21688_21716[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (1))){
var state_21686__$1 = state_21686;
var statearr_21689_21717 = state_21686__$1;
(statearr_21689_21717[(2)] = null);

(statearr_21689_21717[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (4))){
var inst_21663 = (state_21686[(7)]);
var inst_21663__$1 = (state_21686[(2)]);
var inst_21664 = (inst_21663__$1 == null);
var state_21686__$1 = (function (){var statearr_21690 = state_21686;
(statearr_21690[(7)] = inst_21663__$1);

return statearr_21690;
})();
if(cljs.core.truth_(inst_21664)){
var statearr_21691_21718 = state_21686__$1;
(statearr_21691_21718[(1)] = (5));

} else {
var statearr_21692_21719 = state_21686__$1;
(statearr_21692_21719[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (13))){
var state_21686__$1 = state_21686;
var statearr_21693_21720 = state_21686__$1;
(statearr_21693_21720[(2)] = null);

(statearr_21693_21720[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (6))){
var inst_21663 = (state_21686[(7)]);
var inst_21669 = p.call(null,inst_21663);
var state_21686__$1 = state_21686;
if(cljs.core.truth_(inst_21669)){
var statearr_21694_21721 = state_21686__$1;
(statearr_21694_21721[(1)] = (9));

} else {
var statearr_21695_21722 = state_21686__$1;
(statearr_21695_21722[(1)] = (10));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (3))){
var inst_21684 = (state_21686[(2)]);
var state_21686__$1 = state_21686;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21686__$1,inst_21684);
} else {
if((state_val_21687 === (12))){
var state_21686__$1 = state_21686;
var statearr_21696_21723 = state_21686__$1;
(statearr_21696_21723[(2)] = null);

(statearr_21696_21723[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (2))){
var state_21686__$1 = state_21686;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21686__$1,(4),ch);
} else {
if((state_val_21687 === (11))){
var inst_21663 = (state_21686[(7)]);
var inst_21673 = (state_21686[(2)]);
var state_21686__$1 = state_21686;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21686__$1,(8),inst_21673,inst_21663);
} else {
if((state_val_21687 === (9))){
var state_21686__$1 = state_21686;
var statearr_21697_21724 = state_21686__$1;
(statearr_21697_21724[(2)] = tc);

(statearr_21697_21724[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (5))){
var inst_21666 = cljs.core.async.close_BANG_.call(null,tc);
var inst_21667 = cljs.core.async.close_BANG_.call(null,fc);
var state_21686__$1 = (function (){var statearr_21698 = state_21686;
(statearr_21698[(8)] = inst_21666);

return statearr_21698;
})();
var statearr_21699_21725 = state_21686__$1;
(statearr_21699_21725[(2)] = inst_21667);

(statearr_21699_21725[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (14))){
var inst_21680 = (state_21686[(2)]);
var state_21686__$1 = state_21686;
var statearr_21700_21726 = state_21686__$1;
(statearr_21700_21726[(2)] = inst_21680);

(statearr_21700_21726[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (10))){
var state_21686__$1 = state_21686;
var statearr_21701_21727 = state_21686__$1;
(statearr_21701_21727[(2)] = fc);

(statearr_21701_21727[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21687 === (8))){
var inst_21675 = (state_21686[(2)]);
var state_21686__$1 = state_21686;
if(cljs.core.truth_(inst_21675)){
var statearr_21702_21728 = state_21686__$1;
(statearr_21702_21728[(1)] = (12));

} else {
var statearr_21703_21729 = state_21686__$1;
(statearr_21703_21729[(1)] = (13));

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
});})(c__21037__auto___21715,tc,fc))
;
return ((function (switch__20925__auto__,c__21037__auto___21715,tc,fc){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_21707 = [null,null,null,null,null,null,null,null,null];
(statearr_21707[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_21707[(1)] = (1));

return statearr_21707;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_21686){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21686);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21708){if((e21708 instanceof Object)){
var ex__20929__auto__ = e21708;
var statearr_21709_21730 = state_21686;
(statearr_21709_21730[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21686);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21708;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21731 = state_21686;
state_21686 = G__21731;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_21686){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_21686);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___21715,tc,fc))
})();
var state__21039__auto__ = (function (){var statearr_21710 = f__21038__auto__.call(null);
(statearr_21710[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___21715);

return statearr_21710;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___21715,tc,fc))
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
var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__){
return (function (state_21795){
var state_val_21796 = (state_21795[(1)]);
if((state_val_21796 === (7))){
var inst_21791 = (state_21795[(2)]);
var state_21795__$1 = state_21795;
var statearr_21797_21818 = state_21795__$1;
(statearr_21797_21818[(2)] = inst_21791);

(statearr_21797_21818[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (1))){
var inst_21775 = init;
var state_21795__$1 = (function (){var statearr_21798 = state_21795;
(statearr_21798[(7)] = inst_21775);

return statearr_21798;
})();
var statearr_21799_21819 = state_21795__$1;
(statearr_21799_21819[(2)] = null);

(statearr_21799_21819[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (4))){
var inst_21778 = (state_21795[(8)]);
var inst_21778__$1 = (state_21795[(2)]);
var inst_21779 = (inst_21778__$1 == null);
var state_21795__$1 = (function (){var statearr_21800 = state_21795;
(statearr_21800[(8)] = inst_21778__$1);

return statearr_21800;
})();
if(cljs.core.truth_(inst_21779)){
var statearr_21801_21820 = state_21795__$1;
(statearr_21801_21820[(1)] = (5));

} else {
var statearr_21802_21821 = state_21795__$1;
(statearr_21802_21821[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (6))){
var inst_21775 = (state_21795[(7)]);
var inst_21778 = (state_21795[(8)]);
var inst_21782 = (state_21795[(9)]);
var inst_21782__$1 = f.call(null,inst_21775,inst_21778);
var inst_21783 = cljs.core.reduced_QMARK_.call(null,inst_21782__$1);
var state_21795__$1 = (function (){var statearr_21803 = state_21795;
(statearr_21803[(9)] = inst_21782__$1);

return statearr_21803;
})();
if(inst_21783){
var statearr_21804_21822 = state_21795__$1;
(statearr_21804_21822[(1)] = (8));

} else {
var statearr_21805_21823 = state_21795__$1;
(statearr_21805_21823[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (3))){
var inst_21793 = (state_21795[(2)]);
var state_21795__$1 = state_21795;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21795__$1,inst_21793);
} else {
if((state_val_21796 === (2))){
var state_21795__$1 = state_21795;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21795__$1,(4),ch);
} else {
if((state_val_21796 === (9))){
var inst_21782 = (state_21795[(9)]);
var inst_21775 = inst_21782;
var state_21795__$1 = (function (){var statearr_21806 = state_21795;
(statearr_21806[(7)] = inst_21775);

return statearr_21806;
})();
var statearr_21807_21824 = state_21795__$1;
(statearr_21807_21824[(2)] = null);

(statearr_21807_21824[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (5))){
var inst_21775 = (state_21795[(7)]);
var state_21795__$1 = state_21795;
var statearr_21808_21825 = state_21795__$1;
(statearr_21808_21825[(2)] = inst_21775);

(statearr_21808_21825[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (10))){
var inst_21789 = (state_21795[(2)]);
var state_21795__$1 = state_21795;
var statearr_21809_21826 = state_21795__$1;
(statearr_21809_21826[(2)] = inst_21789);

(statearr_21809_21826[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21796 === (8))){
var inst_21782 = (state_21795[(9)]);
var inst_21785 = cljs.core.deref.call(null,inst_21782);
var state_21795__$1 = state_21795;
var statearr_21810_21827 = state_21795__$1;
(statearr_21810_21827[(2)] = inst_21785);

(statearr_21810_21827[(1)] = (10));


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
});})(c__21037__auto__))
;
return ((function (switch__20925__auto__,c__21037__auto__){
return (function() {
var cljs$core$async$reduce_$_state_machine__20926__auto__ = null;
var cljs$core$async$reduce_$_state_machine__20926__auto____0 = (function (){
var statearr_21814 = [null,null,null,null,null,null,null,null,null,null];
(statearr_21814[(0)] = cljs$core$async$reduce_$_state_machine__20926__auto__);

(statearr_21814[(1)] = (1));

return statearr_21814;
});
var cljs$core$async$reduce_$_state_machine__20926__auto____1 = (function (state_21795){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21795);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21815){if((e21815 instanceof Object)){
var ex__20929__auto__ = e21815;
var statearr_21816_21828 = state_21795;
(statearr_21816_21828[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21795);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21815;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21829 = state_21795;
state_21795 = G__21829;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$reduce_$_state_machine__20926__auto__ = function(state_21795){
switch(arguments.length){
case 0:
return cljs$core$async$reduce_$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$reduce_$_state_machine__20926__auto____1.call(this,state_21795);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$reduce_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$reduce_$_state_machine__20926__auto____0;
cljs$core$async$reduce_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$reduce_$_state_machine__20926__auto____1;
return cljs$core$async$reduce_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__))
})();
var state__21039__auto__ = (function (){var statearr_21817 = f__21038__auto__.call(null);
(statearr_21817[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_21817;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__))
);

return c__21037__auto__;
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
var args21830 = [];
var len__19428__auto___21882 = arguments.length;
var i__19429__auto___21883 = (0);
while(true){
if((i__19429__auto___21883 < len__19428__auto___21882)){
args21830.push((arguments[i__19429__auto___21883]));

var G__21884 = (i__19429__auto___21883 + (1));
i__19429__auto___21883 = G__21884;
continue;
} else {
}
break;
}

var G__21832 = args21830.length;
switch (G__21832) {
case 2:
return cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21830.length)].join('')));

}
});

cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$2 = (function (ch,coll){
return cljs.core.async.onto_chan.call(null,ch,coll,true);
});

cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$3 = (function (ch,coll,close_QMARK_){
var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__){
return (function (state_21857){
var state_val_21858 = (state_21857[(1)]);
if((state_val_21858 === (7))){
var inst_21839 = (state_21857[(2)]);
var state_21857__$1 = state_21857;
var statearr_21859_21886 = state_21857__$1;
(statearr_21859_21886[(2)] = inst_21839);

(statearr_21859_21886[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (1))){
var inst_21833 = cljs.core.seq.call(null,coll);
var inst_21834 = inst_21833;
var state_21857__$1 = (function (){var statearr_21860 = state_21857;
(statearr_21860[(7)] = inst_21834);

return statearr_21860;
})();
var statearr_21861_21887 = state_21857__$1;
(statearr_21861_21887[(2)] = null);

(statearr_21861_21887[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (4))){
var inst_21834 = (state_21857[(7)]);
var inst_21837 = cljs.core.first.call(null,inst_21834);
var state_21857__$1 = state_21857;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21857__$1,(7),ch,inst_21837);
} else {
if((state_val_21858 === (13))){
var inst_21851 = (state_21857[(2)]);
var state_21857__$1 = state_21857;
var statearr_21862_21888 = state_21857__$1;
(statearr_21862_21888[(2)] = inst_21851);

(statearr_21862_21888[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (6))){
var inst_21842 = (state_21857[(2)]);
var state_21857__$1 = state_21857;
if(cljs.core.truth_(inst_21842)){
var statearr_21863_21889 = state_21857__$1;
(statearr_21863_21889[(1)] = (8));

} else {
var statearr_21864_21890 = state_21857__$1;
(statearr_21864_21890[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (3))){
var inst_21855 = (state_21857[(2)]);
var state_21857__$1 = state_21857;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21857__$1,inst_21855);
} else {
if((state_val_21858 === (12))){
var state_21857__$1 = state_21857;
var statearr_21865_21891 = state_21857__$1;
(statearr_21865_21891[(2)] = null);

(statearr_21865_21891[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (2))){
var inst_21834 = (state_21857[(7)]);
var state_21857__$1 = state_21857;
if(cljs.core.truth_(inst_21834)){
var statearr_21866_21892 = state_21857__$1;
(statearr_21866_21892[(1)] = (4));

} else {
var statearr_21867_21893 = state_21857__$1;
(statearr_21867_21893[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (11))){
var inst_21848 = cljs.core.async.close_BANG_.call(null,ch);
var state_21857__$1 = state_21857;
var statearr_21868_21894 = state_21857__$1;
(statearr_21868_21894[(2)] = inst_21848);

(statearr_21868_21894[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (9))){
var state_21857__$1 = state_21857;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21869_21895 = state_21857__$1;
(statearr_21869_21895[(1)] = (11));

} else {
var statearr_21870_21896 = state_21857__$1;
(statearr_21870_21896[(1)] = (12));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (5))){
var inst_21834 = (state_21857[(7)]);
var state_21857__$1 = state_21857;
var statearr_21871_21897 = state_21857__$1;
(statearr_21871_21897[(2)] = inst_21834);

(statearr_21871_21897[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (10))){
var inst_21853 = (state_21857[(2)]);
var state_21857__$1 = state_21857;
var statearr_21872_21898 = state_21857__$1;
(statearr_21872_21898[(2)] = inst_21853);

(statearr_21872_21898[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21858 === (8))){
var inst_21834 = (state_21857[(7)]);
var inst_21844 = cljs.core.next.call(null,inst_21834);
var inst_21834__$1 = inst_21844;
var state_21857__$1 = (function (){var statearr_21873 = state_21857;
(statearr_21873[(7)] = inst_21834__$1);

return statearr_21873;
})();
var statearr_21874_21899 = state_21857__$1;
(statearr_21874_21899[(2)] = null);

(statearr_21874_21899[(1)] = (2));


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
});})(c__21037__auto__))
;
return ((function (switch__20925__auto__,c__21037__auto__){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_21878 = [null,null,null,null,null,null,null,null];
(statearr_21878[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_21878[(1)] = (1));

return statearr_21878;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_21857){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_21857);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e21879){if((e21879 instanceof Object)){
var ex__20929__auto__ = e21879;
var statearr_21880_21900 = state_21857;
(statearr_21880_21900[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21857);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21879;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21901 = state_21857;
state_21857 = G__21901;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_21857){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_21857);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__))
})();
var state__21039__auto__ = (function (){var statearr_21881 = f__21038__auto__.call(null);
(statearr_21881[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_21881;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__))
);

return c__21037__auto__;
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
if(typeof cljs.core.async.t_cljs$core$async22123 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.Mult}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22123 = (function (mult,ch,cs,meta22124){
this.mult = mult;
this.ch = ch;
this.cs = cs;
this.meta22124 = meta22124;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (cs){
return (function (_22125,meta22124__$1){
var self__ = this;
var _22125__$1 = this;
return (new cljs.core.async.t_cljs$core$async22123(self__.mult,self__.ch,self__.cs,meta22124__$1));
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (cs){
return (function (_22125){
var self__ = this;
var _22125__$1 = this;
return self__.meta22124;
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (cs){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.ch;
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$async$Mult$ = true;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$async$Mult$tap_STAR_$arity$3 = ((function (cs){
return (function (_,ch__$1,close_QMARK_){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.assoc,ch__$1,close_QMARK_);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$async$Mult$untap_STAR_$arity$2 = ((function (cs){
return (function (_,ch__$1){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.dissoc,ch__$1);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.prototype.cljs$core$async$Mult$untap_all_STAR_$arity$1 = ((function (cs){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.cs,cljs.core.PersistentArrayMap.EMPTY);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.getBasis = ((function (cs){
return (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"mult","mult",-1187640995,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Creates and returns a mult(iple) of the supplied channel. Channels\n  containing copies of the channel can be created with 'tap', and\n  detached with 'untap'.\n\n  Each item is distributed to all taps in parallel and synchronously,\n  i.e. each tap must accept before the next item is distributed. Use\n  buffering/windowing to prevent slow taps from holding up the mult.\n\n  Items received when there are no taps get dropped.\n\n  If a tap puts to a closed channel, it will be removed from the mult."], null)),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"cs","cs",-117024463,null),new cljs.core.Symbol(null,"meta22124","meta22124",2062554087,null)], null);
});})(cs))
;

cljs.core.async.t_cljs$core$async22123.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22123.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22123";

cljs.core.async.t_cljs$core$async22123.cljs$lang$ctorPrWriter = ((function (cs){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22123");
});})(cs))
;

cljs.core.async.__GT_t_cljs$core$async22123 = ((function (cs){
return (function cljs$core$async$mult_$___GT_t_cljs$core$async22123(mult__$1,ch__$1,cs__$1,meta22124){
return (new cljs.core.async.t_cljs$core$async22123(mult__$1,ch__$1,cs__$1,meta22124));
});})(cs))
;

}

return (new cljs.core.async.t_cljs$core$async22123(cljs$core$async$mult,ch,cs,cljs.core.PersistentArrayMap.EMPTY));
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
var c__21037__auto___22344 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___22344,cs,m,dchan,dctr,done){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___22344,cs,m,dchan,dctr,done){
return (function (state_22256){
var state_val_22257 = (state_22256[(1)]);
if((state_val_22257 === (7))){
var inst_22252 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22258_22345 = state_22256__$1;
(statearr_22258_22345[(2)] = inst_22252);

(statearr_22258_22345[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (20))){
var inst_22157 = (state_22256[(7)]);
var inst_22167 = cljs.core.first.call(null,inst_22157);
var inst_22168 = cljs.core.nth.call(null,inst_22167,(0),null);
var inst_22169 = cljs.core.nth.call(null,inst_22167,(1),null);
var state_22256__$1 = (function (){var statearr_22259 = state_22256;
(statearr_22259[(8)] = inst_22168);

return statearr_22259;
})();
if(cljs.core.truth_(inst_22169)){
var statearr_22260_22346 = state_22256__$1;
(statearr_22260_22346[(1)] = (22));

} else {
var statearr_22261_22347 = state_22256__$1;
(statearr_22261_22347[(1)] = (23));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (27))){
var inst_22204 = (state_22256[(9)]);
var inst_22128 = (state_22256[(10)]);
var inst_22199 = (state_22256[(11)]);
var inst_22197 = (state_22256[(12)]);
var inst_22204__$1 = cljs.core._nth.call(null,inst_22197,inst_22199);
var inst_22205 = cljs.core.async.put_BANG_.call(null,inst_22204__$1,inst_22128,done);
var state_22256__$1 = (function (){var statearr_22262 = state_22256;
(statearr_22262[(9)] = inst_22204__$1);

return statearr_22262;
})();
if(cljs.core.truth_(inst_22205)){
var statearr_22263_22348 = state_22256__$1;
(statearr_22263_22348[(1)] = (30));

} else {
var statearr_22264_22349 = state_22256__$1;
(statearr_22264_22349[(1)] = (31));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (1))){
var state_22256__$1 = state_22256;
var statearr_22265_22350 = state_22256__$1;
(statearr_22265_22350[(2)] = null);

(statearr_22265_22350[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (24))){
var inst_22157 = (state_22256[(7)]);
var inst_22174 = (state_22256[(2)]);
var inst_22175 = cljs.core.next.call(null,inst_22157);
var inst_22137 = inst_22175;
var inst_22138 = null;
var inst_22139 = (0);
var inst_22140 = (0);
var state_22256__$1 = (function (){var statearr_22266 = state_22256;
(statearr_22266[(13)] = inst_22140);

(statearr_22266[(14)] = inst_22138);

(statearr_22266[(15)] = inst_22174);

(statearr_22266[(16)] = inst_22137);

(statearr_22266[(17)] = inst_22139);

return statearr_22266;
})();
var statearr_22267_22351 = state_22256__$1;
(statearr_22267_22351[(2)] = null);

(statearr_22267_22351[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (39))){
var state_22256__$1 = state_22256;
var statearr_22271_22352 = state_22256__$1;
(statearr_22271_22352[(2)] = null);

(statearr_22271_22352[(1)] = (41));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (4))){
var inst_22128 = (state_22256[(10)]);
var inst_22128__$1 = (state_22256[(2)]);
var inst_22129 = (inst_22128__$1 == null);
var state_22256__$1 = (function (){var statearr_22272 = state_22256;
(statearr_22272[(10)] = inst_22128__$1);

return statearr_22272;
})();
if(cljs.core.truth_(inst_22129)){
var statearr_22273_22353 = state_22256__$1;
(statearr_22273_22353[(1)] = (5));

} else {
var statearr_22274_22354 = state_22256__$1;
(statearr_22274_22354[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (15))){
var inst_22140 = (state_22256[(13)]);
var inst_22138 = (state_22256[(14)]);
var inst_22137 = (state_22256[(16)]);
var inst_22139 = (state_22256[(17)]);
var inst_22153 = (state_22256[(2)]);
var inst_22154 = (inst_22140 + (1));
var tmp22268 = inst_22138;
var tmp22269 = inst_22137;
var tmp22270 = inst_22139;
var inst_22137__$1 = tmp22269;
var inst_22138__$1 = tmp22268;
var inst_22139__$1 = tmp22270;
var inst_22140__$1 = inst_22154;
var state_22256__$1 = (function (){var statearr_22275 = state_22256;
(statearr_22275[(13)] = inst_22140__$1);

(statearr_22275[(14)] = inst_22138__$1);

(statearr_22275[(16)] = inst_22137__$1);

(statearr_22275[(17)] = inst_22139__$1);

(statearr_22275[(18)] = inst_22153);

return statearr_22275;
})();
var statearr_22276_22355 = state_22256__$1;
(statearr_22276_22355[(2)] = null);

(statearr_22276_22355[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (21))){
var inst_22178 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22280_22356 = state_22256__$1;
(statearr_22280_22356[(2)] = inst_22178);

(statearr_22280_22356[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (31))){
var inst_22204 = (state_22256[(9)]);
var inst_22208 = done.call(null,null);
var inst_22209 = cljs.core.async.untap_STAR_.call(null,m,inst_22204);
var state_22256__$1 = (function (){var statearr_22281 = state_22256;
(statearr_22281[(19)] = inst_22208);

return statearr_22281;
})();
var statearr_22282_22357 = state_22256__$1;
(statearr_22282_22357[(2)] = inst_22209);

(statearr_22282_22357[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (32))){
var inst_22196 = (state_22256[(20)]);
var inst_22199 = (state_22256[(11)]);
var inst_22197 = (state_22256[(12)]);
var inst_22198 = (state_22256[(21)]);
var inst_22211 = (state_22256[(2)]);
var inst_22212 = (inst_22199 + (1));
var tmp22277 = inst_22196;
var tmp22278 = inst_22197;
var tmp22279 = inst_22198;
var inst_22196__$1 = tmp22277;
var inst_22197__$1 = tmp22278;
var inst_22198__$1 = tmp22279;
var inst_22199__$1 = inst_22212;
var state_22256__$1 = (function (){var statearr_22283 = state_22256;
(statearr_22283[(20)] = inst_22196__$1);

(statearr_22283[(11)] = inst_22199__$1);

(statearr_22283[(12)] = inst_22197__$1);

(statearr_22283[(21)] = inst_22198__$1);

(statearr_22283[(22)] = inst_22211);

return statearr_22283;
})();
var statearr_22284_22358 = state_22256__$1;
(statearr_22284_22358[(2)] = null);

(statearr_22284_22358[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (40))){
var inst_22224 = (state_22256[(23)]);
var inst_22228 = done.call(null,null);
var inst_22229 = cljs.core.async.untap_STAR_.call(null,m,inst_22224);
var state_22256__$1 = (function (){var statearr_22285 = state_22256;
(statearr_22285[(24)] = inst_22228);

return statearr_22285;
})();
var statearr_22286_22359 = state_22256__$1;
(statearr_22286_22359[(2)] = inst_22229);

(statearr_22286_22359[(1)] = (41));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (33))){
var inst_22215 = (state_22256[(25)]);
var inst_22217 = cljs.core.chunked_seq_QMARK_.call(null,inst_22215);
var state_22256__$1 = state_22256;
if(inst_22217){
var statearr_22287_22360 = state_22256__$1;
(statearr_22287_22360[(1)] = (36));

} else {
var statearr_22288_22361 = state_22256__$1;
(statearr_22288_22361[(1)] = (37));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (13))){
var inst_22147 = (state_22256[(26)]);
var inst_22150 = cljs.core.async.close_BANG_.call(null,inst_22147);
var state_22256__$1 = state_22256;
var statearr_22289_22362 = state_22256__$1;
(statearr_22289_22362[(2)] = inst_22150);

(statearr_22289_22362[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (22))){
var inst_22168 = (state_22256[(8)]);
var inst_22171 = cljs.core.async.close_BANG_.call(null,inst_22168);
var state_22256__$1 = state_22256;
var statearr_22290_22363 = state_22256__$1;
(statearr_22290_22363[(2)] = inst_22171);

(statearr_22290_22363[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (36))){
var inst_22215 = (state_22256[(25)]);
var inst_22219 = cljs.core.chunk_first.call(null,inst_22215);
var inst_22220 = cljs.core.chunk_rest.call(null,inst_22215);
var inst_22221 = cljs.core.count.call(null,inst_22219);
var inst_22196 = inst_22220;
var inst_22197 = inst_22219;
var inst_22198 = inst_22221;
var inst_22199 = (0);
var state_22256__$1 = (function (){var statearr_22291 = state_22256;
(statearr_22291[(20)] = inst_22196);

(statearr_22291[(11)] = inst_22199);

(statearr_22291[(12)] = inst_22197);

(statearr_22291[(21)] = inst_22198);

return statearr_22291;
})();
var statearr_22292_22364 = state_22256__$1;
(statearr_22292_22364[(2)] = null);

(statearr_22292_22364[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (41))){
var inst_22215 = (state_22256[(25)]);
var inst_22231 = (state_22256[(2)]);
var inst_22232 = cljs.core.next.call(null,inst_22215);
var inst_22196 = inst_22232;
var inst_22197 = null;
var inst_22198 = (0);
var inst_22199 = (0);
var state_22256__$1 = (function (){var statearr_22293 = state_22256;
(statearr_22293[(20)] = inst_22196);

(statearr_22293[(27)] = inst_22231);

(statearr_22293[(11)] = inst_22199);

(statearr_22293[(12)] = inst_22197);

(statearr_22293[(21)] = inst_22198);

return statearr_22293;
})();
var statearr_22294_22365 = state_22256__$1;
(statearr_22294_22365[(2)] = null);

(statearr_22294_22365[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (43))){
var state_22256__$1 = state_22256;
var statearr_22295_22366 = state_22256__$1;
(statearr_22295_22366[(2)] = null);

(statearr_22295_22366[(1)] = (44));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (29))){
var inst_22240 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22296_22367 = state_22256__$1;
(statearr_22296_22367[(2)] = inst_22240);

(statearr_22296_22367[(1)] = (26));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (44))){
var inst_22249 = (state_22256[(2)]);
var state_22256__$1 = (function (){var statearr_22297 = state_22256;
(statearr_22297[(28)] = inst_22249);

return statearr_22297;
})();
var statearr_22298_22368 = state_22256__$1;
(statearr_22298_22368[(2)] = null);

(statearr_22298_22368[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (6))){
var inst_22188 = (state_22256[(29)]);
var inst_22187 = cljs.core.deref.call(null,cs);
var inst_22188__$1 = cljs.core.keys.call(null,inst_22187);
var inst_22189 = cljs.core.count.call(null,inst_22188__$1);
var inst_22190 = cljs.core.reset_BANG_.call(null,dctr,inst_22189);
var inst_22195 = cljs.core.seq.call(null,inst_22188__$1);
var inst_22196 = inst_22195;
var inst_22197 = null;
var inst_22198 = (0);
var inst_22199 = (0);
var state_22256__$1 = (function (){var statearr_22299 = state_22256;
(statearr_22299[(20)] = inst_22196);

(statearr_22299[(30)] = inst_22190);

(statearr_22299[(11)] = inst_22199);

(statearr_22299[(12)] = inst_22197);

(statearr_22299[(21)] = inst_22198);

(statearr_22299[(29)] = inst_22188__$1);

return statearr_22299;
})();
var statearr_22300_22369 = state_22256__$1;
(statearr_22300_22369[(2)] = null);

(statearr_22300_22369[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (28))){
var inst_22196 = (state_22256[(20)]);
var inst_22215 = (state_22256[(25)]);
var inst_22215__$1 = cljs.core.seq.call(null,inst_22196);
var state_22256__$1 = (function (){var statearr_22301 = state_22256;
(statearr_22301[(25)] = inst_22215__$1);

return statearr_22301;
})();
if(inst_22215__$1){
var statearr_22302_22370 = state_22256__$1;
(statearr_22302_22370[(1)] = (33));

} else {
var statearr_22303_22371 = state_22256__$1;
(statearr_22303_22371[(1)] = (34));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (25))){
var inst_22199 = (state_22256[(11)]);
var inst_22198 = (state_22256[(21)]);
var inst_22201 = (inst_22199 < inst_22198);
var inst_22202 = inst_22201;
var state_22256__$1 = state_22256;
if(cljs.core.truth_(inst_22202)){
var statearr_22304_22372 = state_22256__$1;
(statearr_22304_22372[(1)] = (27));

} else {
var statearr_22305_22373 = state_22256__$1;
(statearr_22305_22373[(1)] = (28));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (34))){
var state_22256__$1 = state_22256;
var statearr_22306_22374 = state_22256__$1;
(statearr_22306_22374[(2)] = null);

(statearr_22306_22374[(1)] = (35));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (17))){
var state_22256__$1 = state_22256;
var statearr_22307_22375 = state_22256__$1;
(statearr_22307_22375[(2)] = null);

(statearr_22307_22375[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (3))){
var inst_22254 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22256__$1,inst_22254);
} else {
if((state_val_22257 === (12))){
var inst_22183 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22308_22376 = state_22256__$1;
(statearr_22308_22376[(2)] = inst_22183);

(statearr_22308_22376[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (2))){
var state_22256__$1 = state_22256;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22256__$1,(4),ch);
} else {
if((state_val_22257 === (23))){
var state_22256__$1 = state_22256;
var statearr_22309_22377 = state_22256__$1;
(statearr_22309_22377[(2)] = null);

(statearr_22309_22377[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (35))){
var inst_22238 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22310_22378 = state_22256__$1;
(statearr_22310_22378[(2)] = inst_22238);

(statearr_22310_22378[(1)] = (29));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (19))){
var inst_22157 = (state_22256[(7)]);
var inst_22161 = cljs.core.chunk_first.call(null,inst_22157);
var inst_22162 = cljs.core.chunk_rest.call(null,inst_22157);
var inst_22163 = cljs.core.count.call(null,inst_22161);
var inst_22137 = inst_22162;
var inst_22138 = inst_22161;
var inst_22139 = inst_22163;
var inst_22140 = (0);
var state_22256__$1 = (function (){var statearr_22311 = state_22256;
(statearr_22311[(13)] = inst_22140);

(statearr_22311[(14)] = inst_22138);

(statearr_22311[(16)] = inst_22137);

(statearr_22311[(17)] = inst_22139);

return statearr_22311;
})();
var statearr_22312_22379 = state_22256__$1;
(statearr_22312_22379[(2)] = null);

(statearr_22312_22379[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (11))){
var inst_22137 = (state_22256[(16)]);
var inst_22157 = (state_22256[(7)]);
var inst_22157__$1 = cljs.core.seq.call(null,inst_22137);
var state_22256__$1 = (function (){var statearr_22313 = state_22256;
(statearr_22313[(7)] = inst_22157__$1);

return statearr_22313;
})();
if(inst_22157__$1){
var statearr_22314_22380 = state_22256__$1;
(statearr_22314_22380[(1)] = (16));

} else {
var statearr_22315_22381 = state_22256__$1;
(statearr_22315_22381[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (9))){
var inst_22185 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22316_22382 = state_22256__$1;
(statearr_22316_22382[(2)] = inst_22185);

(statearr_22316_22382[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (5))){
var inst_22135 = cljs.core.deref.call(null,cs);
var inst_22136 = cljs.core.seq.call(null,inst_22135);
var inst_22137 = inst_22136;
var inst_22138 = null;
var inst_22139 = (0);
var inst_22140 = (0);
var state_22256__$1 = (function (){var statearr_22317 = state_22256;
(statearr_22317[(13)] = inst_22140);

(statearr_22317[(14)] = inst_22138);

(statearr_22317[(16)] = inst_22137);

(statearr_22317[(17)] = inst_22139);

return statearr_22317;
})();
var statearr_22318_22383 = state_22256__$1;
(statearr_22318_22383[(2)] = null);

(statearr_22318_22383[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (14))){
var state_22256__$1 = state_22256;
var statearr_22319_22384 = state_22256__$1;
(statearr_22319_22384[(2)] = null);

(statearr_22319_22384[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (45))){
var inst_22246 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22320_22385 = state_22256__$1;
(statearr_22320_22385[(2)] = inst_22246);

(statearr_22320_22385[(1)] = (44));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (26))){
var inst_22188 = (state_22256[(29)]);
var inst_22242 = (state_22256[(2)]);
var inst_22243 = cljs.core.seq.call(null,inst_22188);
var state_22256__$1 = (function (){var statearr_22321 = state_22256;
(statearr_22321[(31)] = inst_22242);

return statearr_22321;
})();
if(inst_22243){
var statearr_22322_22386 = state_22256__$1;
(statearr_22322_22386[(1)] = (42));

} else {
var statearr_22323_22387 = state_22256__$1;
(statearr_22323_22387[(1)] = (43));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (16))){
var inst_22157 = (state_22256[(7)]);
var inst_22159 = cljs.core.chunked_seq_QMARK_.call(null,inst_22157);
var state_22256__$1 = state_22256;
if(inst_22159){
var statearr_22324_22388 = state_22256__$1;
(statearr_22324_22388[(1)] = (19));

} else {
var statearr_22325_22389 = state_22256__$1;
(statearr_22325_22389[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (38))){
var inst_22235 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22326_22390 = state_22256__$1;
(statearr_22326_22390[(2)] = inst_22235);

(statearr_22326_22390[(1)] = (35));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (30))){
var state_22256__$1 = state_22256;
var statearr_22327_22391 = state_22256__$1;
(statearr_22327_22391[(2)] = null);

(statearr_22327_22391[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (10))){
var inst_22140 = (state_22256[(13)]);
var inst_22138 = (state_22256[(14)]);
var inst_22146 = cljs.core._nth.call(null,inst_22138,inst_22140);
var inst_22147 = cljs.core.nth.call(null,inst_22146,(0),null);
var inst_22148 = cljs.core.nth.call(null,inst_22146,(1),null);
var state_22256__$1 = (function (){var statearr_22328 = state_22256;
(statearr_22328[(26)] = inst_22147);

return statearr_22328;
})();
if(cljs.core.truth_(inst_22148)){
var statearr_22329_22392 = state_22256__$1;
(statearr_22329_22392[(1)] = (13));

} else {
var statearr_22330_22393 = state_22256__$1;
(statearr_22330_22393[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (18))){
var inst_22181 = (state_22256[(2)]);
var state_22256__$1 = state_22256;
var statearr_22331_22394 = state_22256__$1;
(statearr_22331_22394[(2)] = inst_22181);

(statearr_22331_22394[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (42))){
var state_22256__$1 = state_22256;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22256__$1,(45),dchan);
} else {
if((state_val_22257 === (37))){
var inst_22128 = (state_22256[(10)]);
var inst_22215 = (state_22256[(25)]);
var inst_22224 = (state_22256[(23)]);
var inst_22224__$1 = cljs.core.first.call(null,inst_22215);
var inst_22225 = cljs.core.async.put_BANG_.call(null,inst_22224__$1,inst_22128,done);
var state_22256__$1 = (function (){var statearr_22332 = state_22256;
(statearr_22332[(23)] = inst_22224__$1);

return statearr_22332;
})();
if(cljs.core.truth_(inst_22225)){
var statearr_22333_22395 = state_22256__$1;
(statearr_22333_22395[(1)] = (39));

} else {
var statearr_22334_22396 = state_22256__$1;
(statearr_22334_22396[(1)] = (40));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22257 === (8))){
var inst_22140 = (state_22256[(13)]);
var inst_22139 = (state_22256[(17)]);
var inst_22142 = (inst_22140 < inst_22139);
var inst_22143 = inst_22142;
var state_22256__$1 = state_22256;
if(cljs.core.truth_(inst_22143)){
var statearr_22335_22397 = state_22256__$1;
(statearr_22335_22397[(1)] = (10));

} else {
var statearr_22336_22398 = state_22256__$1;
(statearr_22336_22398[(1)] = (11));

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
});})(c__21037__auto___22344,cs,m,dchan,dctr,done))
;
return ((function (switch__20925__auto__,c__21037__auto___22344,cs,m,dchan,dctr,done){
return (function() {
var cljs$core$async$mult_$_state_machine__20926__auto__ = null;
var cljs$core$async$mult_$_state_machine__20926__auto____0 = (function (){
var statearr_22340 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22340[(0)] = cljs$core$async$mult_$_state_machine__20926__auto__);

(statearr_22340[(1)] = (1));

return statearr_22340;
});
var cljs$core$async$mult_$_state_machine__20926__auto____1 = (function (state_22256){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_22256);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e22341){if((e22341 instanceof Object)){
var ex__20929__auto__ = e22341;
var statearr_22342_22399 = state_22256;
(statearr_22342_22399[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22256);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22341;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22400 = state_22256;
state_22256 = G__22400;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$mult_$_state_machine__20926__auto__ = function(state_22256){
switch(arguments.length){
case 0:
return cljs$core$async$mult_$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$mult_$_state_machine__20926__auto____1.call(this,state_22256);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mult_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mult_$_state_machine__20926__auto____0;
cljs$core$async$mult_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mult_$_state_machine__20926__auto____1;
return cljs$core$async$mult_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___22344,cs,m,dchan,dctr,done))
})();
var state__21039__auto__ = (function (){var statearr_22343 = f__21038__auto__.call(null);
(statearr_22343[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___22344);

return statearr_22343;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___22344,cs,m,dchan,dctr,done))
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
var args22401 = [];
var len__19428__auto___22404 = arguments.length;
var i__19429__auto___22405 = (0);
while(true){
if((i__19429__auto___22405 < len__19428__auto___22404)){
args22401.push((arguments[i__19429__auto___22405]));

var G__22406 = (i__19429__auto___22405 + (1));
i__19429__auto___22405 = G__22406;
continue;
} else {
}
break;
}

var G__22403 = args22401.length;
switch (G__22403) {
case 2:
return cljs.core.async.tap.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.tap.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22401.length)].join('')));

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
var len__19428__auto___22418 = arguments.length;
var i__19429__auto___22419 = (0);
while(true){
if((i__19429__auto___22419 < len__19428__auto___22418)){
args__19435__auto__.push((arguments[i__19429__auto___22419]));

var G__22420 = (i__19429__auto___22419 + (1));
i__19429__auto___22419 = G__22420;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((3) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((3)),(0))):null);
return cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),argseq__19436__auto__);
});

cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (state,cont_block,ports,p__22412){
var map__22413 = p__22412;
var map__22413__$1 = ((((!((map__22413 == null)))?((((map__22413.cljs$lang$protocol_mask$partition0$ & (64))) || (map__22413.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__22413):map__22413);
var opts = map__22413__$1;
var statearr_22415_22421 = state;
(statearr_22415_22421[cljs.core.async.impl.ioc_helpers.STATE_IDX] = cont_block);


var temp__4657__auto__ = cljs.core.async.do_alts.call(null,((function (map__22413,map__22413__$1,opts){
return (function (val){
var statearr_22416_22422 = state;
(statearr_22416_22422[cljs.core.async.impl.ioc_helpers.VALUE_IDX] = val);


return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state);
});})(map__22413,map__22413__$1,opts))
,ports,opts);
if(cljs.core.truth_(temp__4657__auto__)){
var cb = temp__4657__auto__;
var statearr_22417_22423 = state;
(statearr_22417_22423[cljs.core.async.impl.ioc_helpers.VALUE_IDX] = cljs.core.deref.call(null,cb));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
});

cljs.core.async.ioc_alts_BANG_.cljs$lang$maxFixedArity = (3);

cljs.core.async.ioc_alts_BANG_.cljs$lang$applyTo = (function (seq22408){
var G__22409 = cljs.core.first.call(null,seq22408);
var seq22408__$1 = cljs.core.next.call(null,seq22408);
var G__22410 = cljs.core.first.call(null,seq22408__$1);
var seq22408__$2 = cljs.core.next.call(null,seq22408__$1);
var G__22411 = cljs.core.first.call(null,seq22408__$2);
var seq22408__$3 = cljs.core.next.call(null,seq22408__$2);
return cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__22409,G__22410,G__22411,seq22408__$3);
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
if(typeof cljs.core.async.t_cljs$core$async22587 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mix}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22587 = (function (change,mix,solo_mode,pick,cs,calc_state,out,changed,solo_modes,attrs,meta22588){
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
this.meta22588 = meta22588;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_22589,meta22588__$1){
var self__ = this;
var _22589__$1 = this;
return (new cljs.core.async.t_cljs$core$async22587(self__.change,self__.mix,self__.solo_mode,self__.pick,self__.cs,self__.calc_state,self__.out,self__.changed,self__.solo_modes,self__.attrs,meta22588__$1));
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_22589){
var self__ = this;
var _22589__$1 = this;
return self__.meta22588;
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.out;
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mix$ = true;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mix$admix_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,ch){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.assoc,ch,cljs.core.PersistentArrayMap.EMPTY);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mix$unmix_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,ch){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.dissoc,ch);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mix$unmix_all_STAR_$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.cs,cljs.core.PersistentArrayMap.EMPTY);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mix$toggle_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,state_map){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.partial.call(null,cljs.core.merge_with,cljs.core.merge),state_map);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.prototype.cljs$core$async$Mix$solo_mode_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
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

cljs.core.async.t_cljs$core$async22587.getBasis = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (){
return new cljs.core.PersistentVector(null, 11, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"change","change",477485025,null),cljs.core.with_meta(new cljs.core.Symbol(null,"mix","mix",2121373763,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"out","out",729986010,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Creates and returns a mix of one or more input channels which will\n  be put on the supplied out channel. Input sources can be added to\n  the mix with 'admix', and removed with 'unmix'. A mix supports\n  soloing, muting and pausing multiple inputs atomically using\n  'toggle', and can solo using either muting or pausing as determined\n  by 'solo-mode'.\n\n  Each channel can have zero or more boolean modes set via 'toggle':\n\n  :solo - when true, only this (ond other soloed) channel(s) will appear\n          in the mix output channel. :mute and :pause states of soloed\n          channels are ignored. If solo-mode is :mute, non-soloed\n          channels are muted, if :pause, non-soloed channels are\n          paused.\n\n  :mute - muted channels will have their contents consumed but not included in the mix\n  :pause - paused channels will not have their contents consumed (and thus also not included in the mix)\n"], null)),new cljs.core.Symbol(null,"solo-mode","solo-mode",2031788074,null),new cljs.core.Symbol(null,"pick","pick",1300068175,null),new cljs.core.Symbol(null,"cs","cs",-117024463,null),new cljs.core.Symbol(null,"calc-state","calc-state",-349968968,null),new cljs.core.Symbol(null,"out","out",729986010,null),new cljs.core.Symbol(null,"changed","changed",-2083710852,null),new cljs.core.Symbol(null,"solo-modes","solo-modes",882180540,null),new cljs.core.Symbol(null,"attrs","attrs",-450137186,null),new cljs.core.Symbol(null,"meta22588","meta22588",2090491587,null)], null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22587.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22587.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22587";

cljs.core.async.t_cljs$core$async22587.cljs$lang$ctorPrWriter = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22587");
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.__GT_t_cljs$core$async22587 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function cljs$core$async$mix_$___GT_t_cljs$core$async22587(change__$1,mix__$1,solo_mode__$1,pick__$1,cs__$1,calc_state__$1,out__$1,changed__$1,solo_modes__$1,attrs__$1,meta22588){
return (new cljs.core.async.t_cljs$core$async22587(change__$1,mix__$1,solo_mode__$1,pick__$1,cs__$1,calc_state__$1,out__$1,changed__$1,solo_modes__$1,attrs__$1,meta22588));
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

}

return (new cljs.core.async.t_cljs$core$async22587(change,cljs$core$async$mix,solo_mode,pick,cs,calc_state,out,changed,solo_modes,attrs,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var c__21037__auto___22750 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___22750,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___22750,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function (state_22687){
var state_val_22688 = (state_22687[(1)]);
if((state_val_22688 === (7))){
var inst_22605 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
var statearr_22689_22751 = state_22687__$1;
(statearr_22689_22751[(2)] = inst_22605);

(statearr_22689_22751[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (20))){
var inst_22617 = (state_22687[(7)]);
var state_22687__$1 = state_22687;
var statearr_22690_22752 = state_22687__$1;
(statearr_22690_22752[(2)] = inst_22617);

(statearr_22690_22752[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (27))){
var state_22687__$1 = state_22687;
var statearr_22691_22753 = state_22687__$1;
(statearr_22691_22753[(2)] = null);

(statearr_22691_22753[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (1))){
var inst_22593 = (state_22687[(8)]);
var inst_22593__$1 = calc_state.call(null);
var inst_22595 = (inst_22593__$1 == null);
var inst_22596 = cljs.core.not.call(null,inst_22595);
var state_22687__$1 = (function (){var statearr_22692 = state_22687;
(statearr_22692[(8)] = inst_22593__$1);

return statearr_22692;
})();
if(inst_22596){
var statearr_22693_22754 = state_22687__$1;
(statearr_22693_22754[(1)] = (2));

} else {
var statearr_22694_22755 = state_22687__$1;
(statearr_22694_22755[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (24))){
var inst_22661 = (state_22687[(9)]);
var inst_22647 = (state_22687[(10)]);
var inst_22640 = (state_22687[(11)]);
var inst_22661__$1 = inst_22640.call(null,inst_22647);
var state_22687__$1 = (function (){var statearr_22695 = state_22687;
(statearr_22695[(9)] = inst_22661__$1);

return statearr_22695;
})();
if(cljs.core.truth_(inst_22661__$1)){
var statearr_22696_22756 = state_22687__$1;
(statearr_22696_22756[(1)] = (29));

} else {
var statearr_22697_22757 = state_22687__$1;
(statearr_22697_22757[(1)] = (30));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (4))){
var inst_22608 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22608)){
var statearr_22698_22758 = state_22687__$1;
(statearr_22698_22758[(1)] = (8));

} else {
var statearr_22699_22759 = state_22687__$1;
(statearr_22699_22759[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (15))){
var inst_22634 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22634)){
var statearr_22700_22760 = state_22687__$1;
(statearr_22700_22760[(1)] = (19));

} else {
var statearr_22701_22761 = state_22687__$1;
(statearr_22701_22761[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (21))){
var inst_22639 = (state_22687[(12)]);
var inst_22639__$1 = (state_22687[(2)]);
var inst_22640 = cljs.core.get.call(null,inst_22639__$1,new cljs.core.Keyword(null,"solos","solos",1441458643));
var inst_22641 = cljs.core.get.call(null,inst_22639__$1,new cljs.core.Keyword(null,"mutes","mutes",1068806309));
var inst_22642 = cljs.core.get.call(null,inst_22639__$1,new cljs.core.Keyword(null,"reads","reads",-1215067361));
var state_22687__$1 = (function (){var statearr_22702 = state_22687;
(statearr_22702[(11)] = inst_22640);

(statearr_22702[(13)] = inst_22641);

(statearr_22702[(12)] = inst_22639__$1);

return statearr_22702;
})();
return cljs.core.async.ioc_alts_BANG_.call(null,state_22687__$1,(22),inst_22642);
} else {
if((state_val_22688 === (31))){
var inst_22669 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22669)){
var statearr_22703_22762 = state_22687__$1;
(statearr_22703_22762[(1)] = (32));

} else {
var statearr_22704_22763 = state_22687__$1;
(statearr_22704_22763[(1)] = (33));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (32))){
var inst_22646 = (state_22687[(14)]);
var state_22687__$1 = state_22687;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_22687__$1,(35),out,inst_22646);
} else {
if((state_val_22688 === (33))){
var inst_22639 = (state_22687[(12)]);
var inst_22617 = inst_22639;
var state_22687__$1 = (function (){var statearr_22705 = state_22687;
(statearr_22705[(7)] = inst_22617);

return statearr_22705;
})();
var statearr_22706_22764 = state_22687__$1;
(statearr_22706_22764[(2)] = null);

(statearr_22706_22764[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (13))){
var inst_22617 = (state_22687[(7)]);
var inst_22624 = inst_22617.cljs$lang$protocol_mask$partition0$;
var inst_22625 = (inst_22624 & (64));
var inst_22626 = inst_22617.cljs$core$ISeq$;
var inst_22627 = (inst_22625) || (inst_22626);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22627)){
var statearr_22707_22765 = state_22687__$1;
(statearr_22707_22765[(1)] = (16));

} else {
var statearr_22708_22766 = state_22687__$1;
(statearr_22708_22766[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (22))){
var inst_22646 = (state_22687[(14)]);
var inst_22647 = (state_22687[(10)]);
var inst_22645 = (state_22687[(2)]);
var inst_22646__$1 = cljs.core.nth.call(null,inst_22645,(0),null);
var inst_22647__$1 = cljs.core.nth.call(null,inst_22645,(1),null);
var inst_22648 = (inst_22646__$1 == null);
var inst_22649 = cljs.core._EQ_.call(null,inst_22647__$1,change);
var inst_22650 = (inst_22648) || (inst_22649);
var state_22687__$1 = (function (){var statearr_22709 = state_22687;
(statearr_22709[(14)] = inst_22646__$1);

(statearr_22709[(10)] = inst_22647__$1);

return statearr_22709;
})();
if(cljs.core.truth_(inst_22650)){
var statearr_22710_22767 = state_22687__$1;
(statearr_22710_22767[(1)] = (23));

} else {
var statearr_22711_22768 = state_22687__$1;
(statearr_22711_22768[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (36))){
var inst_22639 = (state_22687[(12)]);
var inst_22617 = inst_22639;
var state_22687__$1 = (function (){var statearr_22712 = state_22687;
(statearr_22712[(7)] = inst_22617);

return statearr_22712;
})();
var statearr_22713_22769 = state_22687__$1;
(statearr_22713_22769[(2)] = null);

(statearr_22713_22769[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (29))){
var inst_22661 = (state_22687[(9)]);
var state_22687__$1 = state_22687;
var statearr_22714_22770 = state_22687__$1;
(statearr_22714_22770[(2)] = inst_22661);

(statearr_22714_22770[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (6))){
var state_22687__$1 = state_22687;
var statearr_22715_22771 = state_22687__$1;
(statearr_22715_22771[(2)] = false);

(statearr_22715_22771[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (28))){
var inst_22657 = (state_22687[(2)]);
var inst_22658 = calc_state.call(null);
var inst_22617 = inst_22658;
var state_22687__$1 = (function (){var statearr_22716 = state_22687;
(statearr_22716[(7)] = inst_22617);

(statearr_22716[(15)] = inst_22657);

return statearr_22716;
})();
var statearr_22717_22772 = state_22687__$1;
(statearr_22717_22772[(2)] = null);

(statearr_22717_22772[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (25))){
var inst_22683 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
var statearr_22718_22773 = state_22687__$1;
(statearr_22718_22773[(2)] = inst_22683);

(statearr_22718_22773[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (34))){
var inst_22681 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
var statearr_22719_22774 = state_22687__$1;
(statearr_22719_22774[(2)] = inst_22681);

(statearr_22719_22774[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (17))){
var state_22687__$1 = state_22687;
var statearr_22720_22775 = state_22687__$1;
(statearr_22720_22775[(2)] = false);

(statearr_22720_22775[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (3))){
var state_22687__$1 = state_22687;
var statearr_22721_22776 = state_22687__$1;
(statearr_22721_22776[(2)] = false);

(statearr_22721_22776[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (12))){
var inst_22685 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22687__$1,inst_22685);
} else {
if((state_val_22688 === (2))){
var inst_22593 = (state_22687[(8)]);
var inst_22598 = inst_22593.cljs$lang$protocol_mask$partition0$;
var inst_22599 = (inst_22598 & (64));
var inst_22600 = inst_22593.cljs$core$ISeq$;
var inst_22601 = (inst_22599) || (inst_22600);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22601)){
var statearr_22722_22777 = state_22687__$1;
(statearr_22722_22777[(1)] = (5));

} else {
var statearr_22723_22778 = state_22687__$1;
(statearr_22723_22778[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (23))){
var inst_22646 = (state_22687[(14)]);
var inst_22652 = (inst_22646 == null);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22652)){
var statearr_22724_22779 = state_22687__$1;
(statearr_22724_22779[(1)] = (26));

} else {
var statearr_22725_22780 = state_22687__$1;
(statearr_22725_22780[(1)] = (27));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (35))){
var inst_22672 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
if(cljs.core.truth_(inst_22672)){
var statearr_22726_22781 = state_22687__$1;
(statearr_22726_22781[(1)] = (36));

} else {
var statearr_22727_22782 = state_22687__$1;
(statearr_22727_22782[(1)] = (37));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (19))){
var inst_22617 = (state_22687[(7)]);
var inst_22636 = cljs.core.apply.call(null,cljs.core.hash_map,inst_22617);
var state_22687__$1 = state_22687;
var statearr_22728_22783 = state_22687__$1;
(statearr_22728_22783[(2)] = inst_22636);

(statearr_22728_22783[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (11))){
var inst_22617 = (state_22687[(7)]);
var inst_22621 = (inst_22617 == null);
var inst_22622 = cljs.core.not.call(null,inst_22621);
var state_22687__$1 = state_22687;
if(inst_22622){
var statearr_22729_22784 = state_22687__$1;
(statearr_22729_22784[(1)] = (13));

} else {
var statearr_22730_22785 = state_22687__$1;
(statearr_22730_22785[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (9))){
var inst_22593 = (state_22687[(8)]);
var state_22687__$1 = state_22687;
var statearr_22731_22786 = state_22687__$1;
(statearr_22731_22786[(2)] = inst_22593);

(statearr_22731_22786[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (5))){
var state_22687__$1 = state_22687;
var statearr_22732_22787 = state_22687__$1;
(statearr_22732_22787[(2)] = true);

(statearr_22732_22787[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (14))){
var state_22687__$1 = state_22687;
var statearr_22733_22788 = state_22687__$1;
(statearr_22733_22788[(2)] = false);

(statearr_22733_22788[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (26))){
var inst_22647 = (state_22687[(10)]);
var inst_22654 = cljs.core.swap_BANG_.call(null,cs,cljs.core.dissoc,inst_22647);
var state_22687__$1 = state_22687;
var statearr_22734_22789 = state_22687__$1;
(statearr_22734_22789[(2)] = inst_22654);

(statearr_22734_22789[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (16))){
var state_22687__$1 = state_22687;
var statearr_22735_22790 = state_22687__$1;
(statearr_22735_22790[(2)] = true);

(statearr_22735_22790[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (38))){
var inst_22677 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
var statearr_22736_22791 = state_22687__$1;
(statearr_22736_22791[(2)] = inst_22677);

(statearr_22736_22791[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (30))){
var inst_22647 = (state_22687[(10)]);
var inst_22640 = (state_22687[(11)]);
var inst_22641 = (state_22687[(13)]);
var inst_22664 = cljs.core.empty_QMARK_.call(null,inst_22640);
var inst_22665 = inst_22641.call(null,inst_22647);
var inst_22666 = cljs.core.not.call(null,inst_22665);
var inst_22667 = (inst_22664) && (inst_22666);
var state_22687__$1 = state_22687;
var statearr_22737_22792 = state_22687__$1;
(statearr_22737_22792[(2)] = inst_22667);

(statearr_22737_22792[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (10))){
var inst_22593 = (state_22687[(8)]);
var inst_22613 = (state_22687[(2)]);
var inst_22614 = cljs.core.get.call(null,inst_22613,new cljs.core.Keyword(null,"solos","solos",1441458643));
var inst_22615 = cljs.core.get.call(null,inst_22613,new cljs.core.Keyword(null,"mutes","mutes",1068806309));
var inst_22616 = cljs.core.get.call(null,inst_22613,new cljs.core.Keyword(null,"reads","reads",-1215067361));
var inst_22617 = inst_22593;
var state_22687__$1 = (function (){var statearr_22738 = state_22687;
(statearr_22738[(16)] = inst_22615);

(statearr_22738[(7)] = inst_22617);

(statearr_22738[(17)] = inst_22616);

(statearr_22738[(18)] = inst_22614);

return statearr_22738;
})();
var statearr_22739_22793 = state_22687__$1;
(statearr_22739_22793[(2)] = null);

(statearr_22739_22793[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (18))){
var inst_22631 = (state_22687[(2)]);
var state_22687__$1 = state_22687;
var statearr_22740_22794 = state_22687__$1;
(statearr_22740_22794[(2)] = inst_22631);

(statearr_22740_22794[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (37))){
var state_22687__$1 = state_22687;
var statearr_22741_22795 = state_22687__$1;
(statearr_22741_22795[(2)] = null);

(statearr_22741_22795[(1)] = (38));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22688 === (8))){
var inst_22593 = (state_22687[(8)]);
var inst_22610 = cljs.core.apply.call(null,cljs.core.hash_map,inst_22593);
var state_22687__$1 = state_22687;
var statearr_22742_22796 = state_22687__$1;
(statearr_22742_22796[(2)] = inst_22610);

(statearr_22742_22796[(1)] = (10));


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
});})(c__21037__auto___22750,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
;
return ((function (switch__20925__auto__,c__21037__auto___22750,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function() {
var cljs$core$async$mix_$_state_machine__20926__auto__ = null;
var cljs$core$async$mix_$_state_machine__20926__auto____0 = (function (){
var statearr_22746 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22746[(0)] = cljs$core$async$mix_$_state_machine__20926__auto__);

(statearr_22746[(1)] = (1));

return statearr_22746;
});
var cljs$core$async$mix_$_state_machine__20926__auto____1 = (function (state_22687){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_22687);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e22747){if((e22747 instanceof Object)){
var ex__20929__auto__ = e22747;
var statearr_22748_22797 = state_22687;
(statearr_22748_22797[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22687);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22747;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22798 = state_22687;
state_22687 = G__22798;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$mix_$_state_machine__20926__auto__ = function(state_22687){
switch(arguments.length){
case 0:
return cljs$core$async$mix_$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$mix_$_state_machine__20926__auto____1.call(this,state_22687);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mix_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mix_$_state_machine__20926__auto____0;
cljs$core$async$mix_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mix_$_state_machine__20926__auto____1;
return cljs$core$async$mix_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___22750,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
})();
var state__21039__auto__ = (function (){var statearr_22749 = f__21038__auto__.call(null);
(statearr_22749[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___22750);

return statearr_22749;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___22750,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
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
var args22799 = [];
var len__19428__auto___22802 = arguments.length;
var i__19429__auto___22803 = (0);
while(true){
if((i__19429__auto___22803 < len__19428__auto___22802)){
args22799.push((arguments[i__19429__auto___22803]));

var G__22804 = (i__19429__auto___22803 + (1));
i__19429__auto___22803 = G__22804;
continue;
} else {
}
break;
}

var G__22801 = args22799.length;
switch (G__22801) {
case 1:
return cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22799.length)].join('')));

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
var args22807 = [];
var len__19428__auto___22932 = arguments.length;
var i__19429__auto___22933 = (0);
while(true){
if((i__19429__auto___22933 < len__19428__auto___22932)){
args22807.push((arguments[i__19429__auto___22933]));

var G__22934 = (i__19429__auto___22933 + (1));
i__19429__auto___22933 = G__22934;
continue;
} else {
}
break;
}

var G__22809 = args22807.length;
switch (G__22809) {
case 2:
return cljs.core.async.pub.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.pub.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22807.length)].join('')));

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
return (function (p1__22806_SHARP_){
if(cljs.core.truth_(p1__22806_SHARP_.call(null,topic))){
return p1__22806_SHARP_;
} else {
return cljs.core.assoc.call(null,p1__22806_SHARP_,topic,cljs.core.async.mult.call(null,cljs.core.async.chan.call(null,buf_fn.call(null,topic))));
}
});})(or__18370__auto__,mults))
),topic);
}
});})(mults))
;
var p = (function (){
if(typeof cljs.core.async.t_cljs$core$async22810 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.Pub}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22810 = (function (ch,topic_fn,buf_fn,mults,ensure_mult,meta22811){
this.ch = ch;
this.topic_fn = topic_fn;
this.buf_fn = buf_fn;
this.mults = mults;
this.ensure_mult = ensure_mult;
this.meta22811 = meta22811;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (mults,ensure_mult){
return (function (_22812,meta22811__$1){
var self__ = this;
var _22812__$1 = this;
return (new cljs.core.async.t_cljs$core$async22810(self__.ch,self__.topic_fn,self__.buf_fn,self__.mults,self__.ensure_mult,meta22811__$1));
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (mults,ensure_mult){
return (function (_22812){
var self__ = this;
var _22812__$1 = this;
return self__.meta22811;
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (mults,ensure_mult){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.ch;
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Pub$ = true;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Pub$sub_STAR_$arity$4 = ((function (mults,ensure_mult){
return (function (p,topic,ch__$1,close_QMARK_){
var self__ = this;
var p__$1 = this;
var m = self__.ensure_mult.call(null,topic);
return cljs.core.async.tap.call(null,m,ch__$1,close_QMARK_);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Pub$unsub_STAR_$arity$3 = ((function (mults,ensure_mult){
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

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Pub$unsub_all_STAR_$arity$1 = ((function (mults,ensure_mult){
return (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.reset_BANG_.call(null,self__.mults,cljs.core.PersistentArrayMap.EMPTY);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.prototype.cljs$core$async$Pub$unsub_all_STAR_$arity$2 = ((function (mults,ensure_mult){
return (function (_,topic){
var self__ = this;
var ___$1 = this;
return cljs.core.swap_BANG_.call(null,self__.mults,cljs.core.dissoc,topic);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.getBasis = ((function (mults,ensure_mult){
return (function (){
return new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"topic-fn","topic-fn",-862449736,null),new cljs.core.Symbol(null,"buf-fn","buf-fn",-1200281591,null),new cljs.core.Symbol(null,"mults","mults",-461114485,null),new cljs.core.Symbol(null,"ensure-mult","ensure-mult",1796584816,null),new cljs.core.Symbol(null,"meta22811","meta22811",-80561425,null)], null);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22810.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22810.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22810";

cljs.core.async.t_cljs$core$async22810.cljs$lang$ctorPrWriter = ((function (mults,ensure_mult){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22810");
});})(mults,ensure_mult))
;

cljs.core.async.__GT_t_cljs$core$async22810 = ((function (mults,ensure_mult){
return (function cljs$core$async$__GT_t_cljs$core$async22810(ch__$1,topic_fn__$1,buf_fn__$1,mults__$1,ensure_mult__$1,meta22811){
return (new cljs.core.async.t_cljs$core$async22810(ch__$1,topic_fn__$1,buf_fn__$1,mults__$1,ensure_mult__$1,meta22811));
});})(mults,ensure_mult))
;

}

return (new cljs.core.async.t_cljs$core$async22810(ch,topic_fn,buf_fn,mults,ensure_mult,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var c__21037__auto___22936 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___22936,mults,ensure_mult,p){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___22936,mults,ensure_mult,p){
return (function (state_22884){
var state_val_22885 = (state_22884[(1)]);
if((state_val_22885 === (7))){
var inst_22880 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
var statearr_22886_22937 = state_22884__$1;
(statearr_22886_22937[(2)] = inst_22880);

(statearr_22886_22937[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (20))){
var state_22884__$1 = state_22884;
var statearr_22887_22938 = state_22884__$1;
(statearr_22887_22938[(2)] = null);

(statearr_22887_22938[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (1))){
var state_22884__$1 = state_22884;
var statearr_22888_22939 = state_22884__$1;
(statearr_22888_22939[(2)] = null);

(statearr_22888_22939[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (24))){
var inst_22863 = (state_22884[(7)]);
var inst_22872 = cljs.core.swap_BANG_.call(null,mults,cljs.core.dissoc,inst_22863);
var state_22884__$1 = state_22884;
var statearr_22889_22940 = state_22884__$1;
(statearr_22889_22940[(2)] = inst_22872);

(statearr_22889_22940[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (4))){
var inst_22815 = (state_22884[(8)]);
var inst_22815__$1 = (state_22884[(2)]);
var inst_22816 = (inst_22815__$1 == null);
var state_22884__$1 = (function (){var statearr_22890 = state_22884;
(statearr_22890[(8)] = inst_22815__$1);

return statearr_22890;
})();
if(cljs.core.truth_(inst_22816)){
var statearr_22891_22941 = state_22884__$1;
(statearr_22891_22941[(1)] = (5));

} else {
var statearr_22892_22942 = state_22884__$1;
(statearr_22892_22942[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (15))){
var inst_22857 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
var statearr_22893_22943 = state_22884__$1;
(statearr_22893_22943[(2)] = inst_22857);

(statearr_22893_22943[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (21))){
var inst_22877 = (state_22884[(2)]);
var state_22884__$1 = (function (){var statearr_22894 = state_22884;
(statearr_22894[(9)] = inst_22877);

return statearr_22894;
})();
var statearr_22895_22944 = state_22884__$1;
(statearr_22895_22944[(2)] = null);

(statearr_22895_22944[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (13))){
var inst_22839 = (state_22884[(10)]);
var inst_22841 = cljs.core.chunked_seq_QMARK_.call(null,inst_22839);
var state_22884__$1 = state_22884;
if(inst_22841){
var statearr_22896_22945 = state_22884__$1;
(statearr_22896_22945[(1)] = (16));

} else {
var statearr_22897_22946 = state_22884__$1;
(statearr_22897_22946[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (22))){
var inst_22869 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
if(cljs.core.truth_(inst_22869)){
var statearr_22898_22947 = state_22884__$1;
(statearr_22898_22947[(1)] = (23));

} else {
var statearr_22899_22948 = state_22884__$1;
(statearr_22899_22948[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (6))){
var inst_22865 = (state_22884[(11)]);
var inst_22815 = (state_22884[(8)]);
var inst_22863 = (state_22884[(7)]);
var inst_22863__$1 = topic_fn.call(null,inst_22815);
var inst_22864 = cljs.core.deref.call(null,mults);
var inst_22865__$1 = cljs.core.get.call(null,inst_22864,inst_22863__$1);
var state_22884__$1 = (function (){var statearr_22900 = state_22884;
(statearr_22900[(11)] = inst_22865__$1);

(statearr_22900[(7)] = inst_22863__$1);

return statearr_22900;
})();
if(cljs.core.truth_(inst_22865__$1)){
var statearr_22901_22949 = state_22884__$1;
(statearr_22901_22949[(1)] = (19));

} else {
var statearr_22902_22950 = state_22884__$1;
(statearr_22902_22950[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (25))){
var inst_22874 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
var statearr_22903_22951 = state_22884__$1;
(statearr_22903_22951[(2)] = inst_22874);

(statearr_22903_22951[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (17))){
var inst_22839 = (state_22884[(10)]);
var inst_22848 = cljs.core.first.call(null,inst_22839);
var inst_22849 = cljs.core.async.muxch_STAR_.call(null,inst_22848);
var inst_22850 = cljs.core.async.close_BANG_.call(null,inst_22849);
var inst_22851 = cljs.core.next.call(null,inst_22839);
var inst_22825 = inst_22851;
var inst_22826 = null;
var inst_22827 = (0);
var inst_22828 = (0);
var state_22884__$1 = (function (){var statearr_22904 = state_22884;
(statearr_22904[(12)] = inst_22828);

(statearr_22904[(13)] = inst_22850);

(statearr_22904[(14)] = inst_22826);

(statearr_22904[(15)] = inst_22825);

(statearr_22904[(16)] = inst_22827);

return statearr_22904;
})();
var statearr_22905_22952 = state_22884__$1;
(statearr_22905_22952[(2)] = null);

(statearr_22905_22952[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (3))){
var inst_22882 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22884__$1,inst_22882);
} else {
if((state_val_22885 === (12))){
var inst_22859 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
var statearr_22906_22953 = state_22884__$1;
(statearr_22906_22953[(2)] = inst_22859);

(statearr_22906_22953[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (2))){
var state_22884__$1 = state_22884;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22884__$1,(4),ch);
} else {
if((state_val_22885 === (23))){
var state_22884__$1 = state_22884;
var statearr_22907_22954 = state_22884__$1;
(statearr_22907_22954[(2)] = null);

(statearr_22907_22954[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (19))){
var inst_22865 = (state_22884[(11)]);
var inst_22815 = (state_22884[(8)]);
var inst_22867 = cljs.core.async.muxch_STAR_.call(null,inst_22865);
var state_22884__$1 = state_22884;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_22884__$1,(22),inst_22867,inst_22815);
} else {
if((state_val_22885 === (11))){
var inst_22825 = (state_22884[(15)]);
var inst_22839 = (state_22884[(10)]);
var inst_22839__$1 = cljs.core.seq.call(null,inst_22825);
var state_22884__$1 = (function (){var statearr_22908 = state_22884;
(statearr_22908[(10)] = inst_22839__$1);

return statearr_22908;
})();
if(inst_22839__$1){
var statearr_22909_22955 = state_22884__$1;
(statearr_22909_22955[(1)] = (13));

} else {
var statearr_22910_22956 = state_22884__$1;
(statearr_22910_22956[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (9))){
var inst_22861 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
var statearr_22911_22957 = state_22884__$1;
(statearr_22911_22957[(2)] = inst_22861);

(statearr_22911_22957[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (5))){
var inst_22822 = cljs.core.deref.call(null,mults);
var inst_22823 = cljs.core.vals.call(null,inst_22822);
var inst_22824 = cljs.core.seq.call(null,inst_22823);
var inst_22825 = inst_22824;
var inst_22826 = null;
var inst_22827 = (0);
var inst_22828 = (0);
var state_22884__$1 = (function (){var statearr_22912 = state_22884;
(statearr_22912[(12)] = inst_22828);

(statearr_22912[(14)] = inst_22826);

(statearr_22912[(15)] = inst_22825);

(statearr_22912[(16)] = inst_22827);

return statearr_22912;
})();
var statearr_22913_22958 = state_22884__$1;
(statearr_22913_22958[(2)] = null);

(statearr_22913_22958[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (14))){
var state_22884__$1 = state_22884;
var statearr_22917_22959 = state_22884__$1;
(statearr_22917_22959[(2)] = null);

(statearr_22917_22959[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (16))){
var inst_22839 = (state_22884[(10)]);
var inst_22843 = cljs.core.chunk_first.call(null,inst_22839);
var inst_22844 = cljs.core.chunk_rest.call(null,inst_22839);
var inst_22845 = cljs.core.count.call(null,inst_22843);
var inst_22825 = inst_22844;
var inst_22826 = inst_22843;
var inst_22827 = inst_22845;
var inst_22828 = (0);
var state_22884__$1 = (function (){var statearr_22918 = state_22884;
(statearr_22918[(12)] = inst_22828);

(statearr_22918[(14)] = inst_22826);

(statearr_22918[(15)] = inst_22825);

(statearr_22918[(16)] = inst_22827);

return statearr_22918;
})();
var statearr_22919_22960 = state_22884__$1;
(statearr_22919_22960[(2)] = null);

(statearr_22919_22960[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (10))){
var inst_22828 = (state_22884[(12)]);
var inst_22826 = (state_22884[(14)]);
var inst_22825 = (state_22884[(15)]);
var inst_22827 = (state_22884[(16)]);
var inst_22833 = cljs.core._nth.call(null,inst_22826,inst_22828);
var inst_22834 = cljs.core.async.muxch_STAR_.call(null,inst_22833);
var inst_22835 = cljs.core.async.close_BANG_.call(null,inst_22834);
var inst_22836 = (inst_22828 + (1));
var tmp22914 = inst_22826;
var tmp22915 = inst_22825;
var tmp22916 = inst_22827;
var inst_22825__$1 = tmp22915;
var inst_22826__$1 = tmp22914;
var inst_22827__$1 = tmp22916;
var inst_22828__$1 = inst_22836;
var state_22884__$1 = (function (){var statearr_22920 = state_22884;
(statearr_22920[(12)] = inst_22828__$1);

(statearr_22920[(17)] = inst_22835);

(statearr_22920[(14)] = inst_22826__$1);

(statearr_22920[(15)] = inst_22825__$1);

(statearr_22920[(16)] = inst_22827__$1);

return statearr_22920;
})();
var statearr_22921_22961 = state_22884__$1;
(statearr_22921_22961[(2)] = null);

(statearr_22921_22961[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (18))){
var inst_22854 = (state_22884[(2)]);
var state_22884__$1 = state_22884;
var statearr_22922_22962 = state_22884__$1;
(statearr_22922_22962[(2)] = inst_22854);

(statearr_22922_22962[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22885 === (8))){
var inst_22828 = (state_22884[(12)]);
var inst_22827 = (state_22884[(16)]);
var inst_22830 = (inst_22828 < inst_22827);
var inst_22831 = inst_22830;
var state_22884__$1 = state_22884;
if(cljs.core.truth_(inst_22831)){
var statearr_22923_22963 = state_22884__$1;
(statearr_22923_22963[(1)] = (10));

} else {
var statearr_22924_22964 = state_22884__$1;
(statearr_22924_22964[(1)] = (11));

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
});})(c__21037__auto___22936,mults,ensure_mult,p))
;
return ((function (switch__20925__auto__,c__21037__auto___22936,mults,ensure_mult,p){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_22928 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22928[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_22928[(1)] = (1));

return statearr_22928;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_22884){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_22884);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e22929){if((e22929 instanceof Object)){
var ex__20929__auto__ = e22929;
var statearr_22930_22965 = state_22884;
(statearr_22930_22965[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22884);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22929;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22966 = state_22884;
state_22884 = G__22966;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_22884){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_22884);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___22936,mults,ensure_mult,p))
})();
var state__21039__auto__ = (function (){var statearr_22931 = f__21038__auto__.call(null);
(statearr_22931[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___22936);

return statearr_22931;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___22936,mults,ensure_mult,p))
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
var args22967 = [];
var len__19428__auto___22970 = arguments.length;
var i__19429__auto___22971 = (0);
while(true){
if((i__19429__auto___22971 < len__19428__auto___22970)){
args22967.push((arguments[i__19429__auto___22971]));

var G__22972 = (i__19429__auto___22971 + (1));
i__19429__auto___22971 = G__22972;
continue;
} else {
}
break;
}

var G__22969 = args22967.length;
switch (G__22969) {
case 3:
return cljs.core.async.sub.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
case 4:
return cljs.core.async.sub.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22967.length)].join('')));

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
var args22974 = [];
var len__19428__auto___22977 = arguments.length;
var i__19429__auto___22978 = (0);
while(true){
if((i__19429__auto___22978 < len__19428__auto___22977)){
args22974.push((arguments[i__19429__auto___22978]));

var G__22979 = (i__19429__auto___22978 + (1));
i__19429__auto___22978 = G__22979;
continue;
} else {
}
break;
}

var G__22976 = args22974.length;
switch (G__22976) {
case 1:
return cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22974.length)].join('')));

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
var args22981 = [];
var len__19428__auto___23052 = arguments.length;
var i__19429__auto___23053 = (0);
while(true){
if((i__19429__auto___23053 < len__19428__auto___23052)){
args22981.push((arguments[i__19429__auto___23053]));

var G__23054 = (i__19429__auto___23053 + (1));
i__19429__auto___23053 = G__23054;
continue;
} else {
}
break;
}

var G__22983 = args22981.length;
switch (G__22983) {
case 2:
return cljs.core.async.map.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.map.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22981.length)].join('')));

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
var c__21037__auto___23056 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23056,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23056,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function (state_23022){
var state_val_23023 = (state_23022[(1)]);
if((state_val_23023 === (7))){
var state_23022__$1 = state_23022;
var statearr_23024_23057 = state_23022__$1;
(statearr_23024_23057[(2)] = null);

(statearr_23024_23057[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (1))){
var state_23022__$1 = state_23022;
var statearr_23025_23058 = state_23022__$1;
(statearr_23025_23058[(2)] = null);

(statearr_23025_23058[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (4))){
var inst_22986 = (state_23022[(7)]);
var inst_22988 = (inst_22986 < cnt);
var state_23022__$1 = state_23022;
if(cljs.core.truth_(inst_22988)){
var statearr_23026_23059 = state_23022__$1;
(statearr_23026_23059[(1)] = (6));

} else {
var statearr_23027_23060 = state_23022__$1;
(statearr_23027_23060[(1)] = (7));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (15))){
var inst_23018 = (state_23022[(2)]);
var state_23022__$1 = state_23022;
var statearr_23028_23061 = state_23022__$1;
(statearr_23028_23061[(2)] = inst_23018);

(statearr_23028_23061[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (13))){
var inst_23011 = cljs.core.async.close_BANG_.call(null,out);
var state_23022__$1 = state_23022;
var statearr_23029_23062 = state_23022__$1;
(statearr_23029_23062[(2)] = inst_23011);

(statearr_23029_23062[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (6))){
var state_23022__$1 = state_23022;
var statearr_23030_23063 = state_23022__$1;
(statearr_23030_23063[(2)] = null);

(statearr_23030_23063[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (3))){
var inst_23020 = (state_23022[(2)]);
var state_23022__$1 = state_23022;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23022__$1,inst_23020);
} else {
if((state_val_23023 === (12))){
var inst_23008 = (state_23022[(8)]);
var inst_23008__$1 = (state_23022[(2)]);
var inst_23009 = cljs.core.some.call(null,cljs.core.nil_QMARK_,inst_23008__$1);
var state_23022__$1 = (function (){var statearr_23031 = state_23022;
(statearr_23031[(8)] = inst_23008__$1);

return statearr_23031;
})();
if(cljs.core.truth_(inst_23009)){
var statearr_23032_23064 = state_23022__$1;
(statearr_23032_23064[(1)] = (13));

} else {
var statearr_23033_23065 = state_23022__$1;
(statearr_23033_23065[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (2))){
var inst_22985 = cljs.core.reset_BANG_.call(null,dctr,cnt);
var inst_22986 = (0);
var state_23022__$1 = (function (){var statearr_23034 = state_23022;
(statearr_23034[(7)] = inst_22986);

(statearr_23034[(9)] = inst_22985);

return statearr_23034;
})();
var statearr_23035_23066 = state_23022__$1;
(statearr_23035_23066[(2)] = null);

(statearr_23035_23066[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (11))){
var inst_22986 = (state_23022[(7)]);
var _ = cljs.core.async.impl.ioc_helpers.add_exception_frame.call(null,state_23022,(10),Object,null,(9));
var inst_22995 = chs__$1.call(null,inst_22986);
var inst_22996 = done.call(null,inst_22986);
var inst_22997 = cljs.core.async.take_BANG_.call(null,inst_22995,inst_22996);
var state_23022__$1 = state_23022;
var statearr_23036_23067 = state_23022__$1;
(statearr_23036_23067[(2)] = inst_22997);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23022__$1);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (9))){
var inst_22986 = (state_23022[(7)]);
var inst_22999 = (state_23022[(2)]);
var inst_23000 = (inst_22986 + (1));
var inst_22986__$1 = inst_23000;
var state_23022__$1 = (function (){var statearr_23037 = state_23022;
(statearr_23037[(10)] = inst_22999);

(statearr_23037[(7)] = inst_22986__$1);

return statearr_23037;
})();
var statearr_23038_23068 = state_23022__$1;
(statearr_23038_23068[(2)] = null);

(statearr_23038_23068[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (5))){
var inst_23006 = (state_23022[(2)]);
var state_23022__$1 = (function (){var statearr_23039 = state_23022;
(statearr_23039[(11)] = inst_23006);

return statearr_23039;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23022__$1,(12),dchan);
} else {
if((state_val_23023 === (14))){
var inst_23008 = (state_23022[(8)]);
var inst_23013 = cljs.core.apply.call(null,f,inst_23008);
var state_23022__$1 = state_23022;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23022__$1,(16),out,inst_23013);
} else {
if((state_val_23023 === (16))){
var inst_23015 = (state_23022[(2)]);
var state_23022__$1 = (function (){var statearr_23040 = state_23022;
(statearr_23040[(12)] = inst_23015);

return statearr_23040;
})();
var statearr_23041_23069 = state_23022__$1;
(statearr_23041_23069[(2)] = null);

(statearr_23041_23069[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (10))){
var inst_22990 = (state_23022[(2)]);
var inst_22991 = cljs.core.swap_BANG_.call(null,dctr,cljs.core.dec);
var state_23022__$1 = (function (){var statearr_23042 = state_23022;
(statearr_23042[(13)] = inst_22990);

return statearr_23042;
})();
var statearr_23043_23070 = state_23022__$1;
(statearr_23043_23070[(2)] = inst_22991);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23022__$1);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23023 === (8))){
var inst_23004 = (state_23022[(2)]);
var state_23022__$1 = state_23022;
var statearr_23044_23071 = state_23022__$1;
(statearr_23044_23071[(2)] = inst_23004);

(statearr_23044_23071[(1)] = (5));


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
});})(c__21037__auto___23056,chs__$1,out,cnt,rets,dchan,dctr,done))
;
return ((function (switch__20925__auto__,c__21037__auto___23056,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23048 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23048[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23048[(1)] = (1));

return statearr_23048;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23022){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23022);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23049){if((e23049 instanceof Object)){
var ex__20929__auto__ = e23049;
var statearr_23050_23072 = state_23022;
(statearr_23050_23072[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23022);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23049;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23073 = state_23022;
state_23022 = G__23073;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23022){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23022);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23056,chs__$1,out,cnt,rets,dchan,dctr,done))
})();
var state__21039__auto__ = (function (){var statearr_23051 = f__21038__auto__.call(null);
(statearr_23051[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23056);

return statearr_23051;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23056,chs__$1,out,cnt,rets,dchan,dctr,done))
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
var args23075 = [];
var len__19428__auto___23131 = arguments.length;
var i__19429__auto___23132 = (0);
while(true){
if((i__19429__auto___23132 < len__19428__auto___23131)){
args23075.push((arguments[i__19429__auto___23132]));

var G__23133 = (i__19429__auto___23132 + (1));
i__19429__auto___23132 = G__23133;
continue;
} else {
}
break;
}

var G__23077 = args23075.length;
switch (G__23077) {
case 1:
return cljs.core.async.merge.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.merge.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23075.length)].join('')));

}
});

cljs.core.async.merge.cljs$core$IFn$_invoke$arity$1 = (function (chs){
return cljs.core.async.merge.call(null,chs,null);
});

cljs.core.async.merge.cljs$core$IFn$_invoke$arity$2 = (function (chs,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21037__auto___23135 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23135,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23135,out){
return (function (state_23107){
var state_val_23108 = (state_23107[(1)]);
if((state_val_23108 === (7))){
var inst_23087 = (state_23107[(7)]);
var inst_23086 = (state_23107[(8)]);
var inst_23086__$1 = (state_23107[(2)]);
var inst_23087__$1 = cljs.core.nth.call(null,inst_23086__$1,(0),null);
var inst_23088 = cljs.core.nth.call(null,inst_23086__$1,(1),null);
var inst_23089 = (inst_23087__$1 == null);
var state_23107__$1 = (function (){var statearr_23109 = state_23107;
(statearr_23109[(7)] = inst_23087__$1);

(statearr_23109[(8)] = inst_23086__$1);

(statearr_23109[(9)] = inst_23088);

return statearr_23109;
})();
if(cljs.core.truth_(inst_23089)){
var statearr_23110_23136 = state_23107__$1;
(statearr_23110_23136[(1)] = (8));

} else {
var statearr_23111_23137 = state_23107__$1;
(statearr_23111_23137[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (1))){
var inst_23078 = cljs.core.vec.call(null,chs);
var inst_23079 = inst_23078;
var state_23107__$1 = (function (){var statearr_23112 = state_23107;
(statearr_23112[(10)] = inst_23079);

return statearr_23112;
})();
var statearr_23113_23138 = state_23107__$1;
(statearr_23113_23138[(2)] = null);

(statearr_23113_23138[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (4))){
var inst_23079 = (state_23107[(10)]);
var state_23107__$1 = state_23107;
return cljs.core.async.ioc_alts_BANG_.call(null,state_23107__$1,(7),inst_23079);
} else {
if((state_val_23108 === (6))){
var inst_23103 = (state_23107[(2)]);
var state_23107__$1 = state_23107;
var statearr_23114_23139 = state_23107__$1;
(statearr_23114_23139[(2)] = inst_23103);

(statearr_23114_23139[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (3))){
var inst_23105 = (state_23107[(2)]);
var state_23107__$1 = state_23107;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23107__$1,inst_23105);
} else {
if((state_val_23108 === (2))){
var inst_23079 = (state_23107[(10)]);
var inst_23081 = cljs.core.count.call(null,inst_23079);
var inst_23082 = (inst_23081 > (0));
var state_23107__$1 = state_23107;
if(cljs.core.truth_(inst_23082)){
var statearr_23116_23140 = state_23107__$1;
(statearr_23116_23140[(1)] = (4));

} else {
var statearr_23117_23141 = state_23107__$1;
(statearr_23117_23141[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (11))){
var inst_23079 = (state_23107[(10)]);
var inst_23096 = (state_23107[(2)]);
var tmp23115 = inst_23079;
var inst_23079__$1 = tmp23115;
var state_23107__$1 = (function (){var statearr_23118 = state_23107;
(statearr_23118[(11)] = inst_23096);

(statearr_23118[(10)] = inst_23079__$1);

return statearr_23118;
})();
var statearr_23119_23142 = state_23107__$1;
(statearr_23119_23142[(2)] = null);

(statearr_23119_23142[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (9))){
var inst_23087 = (state_23107[(7)]);
var state_23107__$1 = state_23107;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23107__$1,(11),out,inst_23087);
} else {
if((state_val_23108 === (5))){
var inst_23101 = cljs.core.async.close_BANG_.call(null,out);
var state_23107__$1 = state_23107;
var statearr_23120_23143 = state_23107__$1;
(statearr_23120_23143[(2)] = inst_23101);

(statearr_23120_23143[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (10))){
var inst_23099 = (state_23107[(2)]);
var state_23107__$1 = state_23107;
var statearr_23121_23144 = state_23107__$1;
(statearr_23121_23144[(2)] = inst_23099);

(statearr_23121_23144[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23108 === (8))){
var inst_23087 = (state_23107[(7)]);
var inst_23086 = (state_23107[(8)]);
var inst_23079 = (state_23107[(10)]);
var inst_23088 = (state_23107[(9)]);
var inst_23091 = (function (){var cs = inst_23079;
var vec__23084 = inst_23086;
var v = inst_23087;
var c = inst_23088;
return ((function (cs,vec__23084,v,c,inst_23087,inst_23086,inst_23079,inst_23088,state_val_23108,c__21037__auto___23135,out){
return (function (p1__23074_SHARP_){
return cljs.core.not_EQ_.call(null,c,p1__23074_SHARP_);
});
;})(cs,vec__23084,v,c,inst_23087,inst_23086,inst_23079,inst_23088,state_val_23108,c__21037__auto___23135,out))
})();
var inst_23092 = cljs.core.filterv.call(null,inst_23091,inst_23079);
var inst_23079__$1 = inst_23092;
var state_23107__$1 = (function (){var statearr_23122 = state_23107;
(statearr_23122[(10)] = inst_23079__$1);

return statearr_23122;
})();
var statearr_23123_23145 = state_23107__$1;
(statearr_23123_23145[(2)] = null);

(statearr_23123_23145[(1)] = (2));


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
});})(c__21037__auto___23135,out))
;
return ((function (switch__20925__auto__,c__21037__auto___23135,out){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23127 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23127[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23127[(1)] = (1));

return statearr_23127;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23107){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23107);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23128){if((e23128 instanceof Object)){
var ex__20929__auto__ = e23128;
var statearr_23129_23146 = state_23107;
(statearr_23129_23146[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23107);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23128;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23147 = state_23107;
state_23107 = G__23147;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23107){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23107);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23135,out))
})();
var state__21039__auto__ = (function (){var statearr_23130 = f__21038__auto__.call(null);
(statearr_23130[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23135);

return statearr_23130;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23135,out))
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
var args23148 = [];
var len__19428__auto___23197 = arguments.length;
var i__19429__auto___23198 = (0);
while(true){
if((i__19429__auto___23198 < len__19428__auto___23197)){
args23148.push((arguments[i__19429__auto___23198]));

var G__23199 = (i__19429__auto___23198 + (1));
i__19429__auto___23198 = G__23199;
continue;
} else {
}
break;
}

var G__23150 = args23148.length;
switch (G__23150) {
case 2:
return cljs.core.async.take.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.take.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23148.length)].join('')));

}
});

cljs.core.async.take.cljs$core$IFn$_invoke$arity$2 = (function (n,ch){
return cljs.core.async.take.call(null,n,ch,null);
});

cljs.core.async.take.cljs$core$IFn$_invoke$arity$3 = (function (n,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21037__auto___23201 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23201,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23201,out){
return (function (state_23174){
var state_val_23175 = (state_23174[(1)]);
if((state_val_23175 === (7))){
var inst_23156 = (state_23174[(7)]);
var inst_23156__$1 = (state_23174[(2)]);
var inst_23157 = (inst_23156__$1 == null);
var inst_23158 = cljs.core.not.call(null,inst_23157);
var state_23174__$1 = (function (){var statearr_23176 = state_23174;
(statearr_23176[(7)] = inst_23156__$1);

return statearr_23176;
})();
if(inst_23158){
var statearr_23177_23202 = state_23174__$1;
(statearr_23177_23202[(1)] = (8));

} else {
var statearr_23178_23203 = state_23174__$1;
(statearr_23178_23203[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (1))){
var inst_23151 = (0);
var state_23174__$1 = (function (){var statearr_23179 = state_23174;
(statearr_23179[(8)] = inst_23151);

return statearr_23179;
})();
var statearr_23180_23204 = state_23174__$1;
(statearr_23180_23204[(2)] = null);

(statearr_23180_23204[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (4))){
var state_23174__$1 = state_23174;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23174__$1,(7),ch);
} else {
if((state_val_23175 === (6))){
var inst_23169 = (state_23174[(2)]);
var state_23174__$1 = state_23174;
var statearr_23181_23205 = state_23174__$1;
(statearr_23181_23205[(2)] = inst_23169);

(statearr_23181_23205[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (3))){
var inst_23171 = (state_23174[(2)]);
var inst_23172 = cljs.core.async.close_BANG_.call(null,out);
var state_23174__$1 = (function (){var statearr_23182 = state_23174;
(statearr_23182[(9)] = inst_23171);

return statearr_23182;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23174__$1,inst_23172);
} else {
if((state_val_23175 === (2))){
var inst_23151 = (state_23174[(8)]);
var inst_23153 = (inst_23151 < n);
var state_23174__$1 = state_23174;
if(cljs.core.truth_(inst_23153)){
var statearr_23183_23206 = state_23174__$1;
(statearr_23183_23206[(1)] = (4));

} else {
var statearr_23184_23207 = state_23174__$1;
(statearr_23184_23207[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (11))){
var inst_23151 = (state_23174[(8)]);
var inst_23161 = (state_23174[(2)]);
var inst_23162 = (inst_23151 + (1));
var inst_23151__$1 = inst_23162;
var state_23174__$1 = (function (){var statearr_23185 = state_23174;
(statearr_23185[(10)] = inst_23161);

(statearr_23185[(8)] = inst_23151__$1);

return statearr_23185;
})();
var statearr_23186_23208 = state_23174__$1;
(statearr_23186_23208[(2)] = null);

(statearr_23186_23208[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (9))){
var state_23174__$1 = state_23174;
var statearr_23187_23209 = state_23174__$1;
(statearr_23187_23209[(2)] = null);

(statearr_23187_23209[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (5))){
var state_23174__$1 = state_23174;
var statearr_23188_23210 = state_23174__$1;
(statearr_23188_23210[(2)] = null);

(statearr_23188_23210[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (10))){
var inst_23166 = (state_23174[(2)]);
var state_23174__$1 = state_23174;
var statearr_23189_23211 = state_23174__$1;
(statearr_23189_23211[(2)] = inst_23166);

(statearr_23189_23211[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23175 === (8))){
var inst_23156 = (state_23174[(7)]);
var state_23174__$1 = state_23174;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23174__$1,(11),out,inst_23156);
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
});})(c__21037__auto___23201,out))
;
return ((function (switch__20925__auto__,c__21037__auto___23201,out){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23193 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_23193[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23193[(1)] = (1));

return statearr_23193;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23174){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23174);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23194){if((e23194 instanceof Object)){
var ex__20929__auto__ = e23194;
var statearr_23195_23212 = state_23174;
(statearr_23195_23212[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23174);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23194;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23213 = state_23174;
state_23174 = G__23213;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23174){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23174);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23201,out))
})();
var state__21039__auto__ = (function (){var statearr_23196 = f__21038__auto__.call(null);
(statearr_23196[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23201);

return statearr_23196;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23201,out))
);


return out;
});

cljs.core.async.take.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.map_LT_ = (function cljs$core$async$map_LT_(f,ch){
if(typeof cljs.core.async.t_cljs$core$async23221 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23221 = (function (map_LT_,f,ch,meta23222){
this.map_LT_ = map_LT_;
this.f = f;
this.ch = ch;
this.meta23222 = meta23222;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23223,meta23222__$1){
var self__ = this;
var _23223__$1 = this;
return (new cljs.core.async.t_cljs$core$async23221(self__.map_LT_,self__.f,self__.ch,meta23222__$1));
});

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23223){
var self__ = this;
var _23223__$1 = this;
return self__.meta23222;
});

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$Channel$closed_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,(function (){
if(typeof cljs.core.async.t_cljs$core$async23224 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23224 = (function (map_LT_,f,ch,meta23222,_,fn1,meta23225){
this.map_LT_ = map_LT_;
this.f = f;
this.ch = ch;
this.meta23222 = meta23222;
this._ = _;
this.fn1 = fn1;
this.meta23225 = meta23225;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23224.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (___$1){
return (function (_23226,meta23225__$1){
var self__ = this;
var _23226__$1 = this;
return (new cljs.core.async.t_cljs$core$async23224(self__.map_LT_,self__.f,self__.ch,self__.meta23222,self__._,self__.fn1,meta23225__$1));
});})(___$1))
;

cljs.core.async.t_cljs$core$async23224.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (___$1){
return (function (_23226){
var self__ = this;
var _23226__$1 = this;
return self__.meta23225;
});})(___$1))
;

cljs.core.async.t_cljs$core$async23224.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async23224.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
return cljs.core.async.impl.protocols.active_QMARK_.call(null,self__.fn1);
});})(___$1))
;

cljs.core.async.t_cljs$core$async23224.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
return true;
});})(___$1))
;

cljs.core.async.t_cljs$core$async23224.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
var f1 = cljs.core.async.impl.protocols.commit.call(null,self__.fn1);
return ((function (f1,___$2,___$1){
return (function (p1__23214_SHARP_){
return f1.call(null,(((p1__23214_SHARP_ == null))?null:self__.f.call(null,p1__23214_SHARP_)));
});
;})(f1,___$2,___$1))
});})(___$1))
;

cljs.core.async.t_cljs$core$async23224.getBasis = ((function (___$1){
return (function (){
return new cljs.core.PersistentVector(null, 7, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map<","map<",-1235808357,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23222","meta23222",129792482,null),cljs.core.with_meta(new cljs.core.Symbol(null,"_","_",-1201019570,null),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"tag","tag",-1290361223),new cljs.core.Symbol("cljs.core.async","t_cljs$core$async23221","cljs.core.async/t_cljs$core$async23221",-281496791,null)], null)),new cljs.core.Symbol(null,"fn1","fn1",895834444,null),new cljs.core.Symbol(null,"meta23225","meta23225",1277133223,null)], null);
});})(___$1))
;

cljs.core.async.t_cljs$core$async23224.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23224.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23224";

cljs.core.async.t_cljs$core$async23224.cljs$lang$ctorPrWriter = ((function (___$1){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23224");
});})(___$1))
;

cljs.core.async.__GT_t_cljs$core$async23224 = ((function (___$1){
return (function cljs$core$async$map_LT__$___GT_t_cljs$core$async23224(map_LT___$1,f__$1,ch__$1,meta23222__$1,___$2,fn1__$1,meta23225){
return (new cljs.core.async.t_cljs$core$async23224(map_LT___$1,f__$1,ch__$1,meta23222__$1,___$2,fn1__$1,meta23225));
});})(___$1))
;

}

return (new cljs.core.async.t_cljs$core$async23224(self__.map_LT_,self__.f,self__.ch,self__.meta23222,___$1,fn1,cljs.core.PersistentArrayMap.EMPTY));
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

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23221.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,val,fn1);
});

cljs.core.async.t_cljs$core$async23221.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map<","map<",-1235808357,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23222","meta23222",129792482,null)], null);
});

cljs.core.async.t_cljs$core$async23221.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23221.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23221";

cljs.core.async.t_cljs$core$async23221.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23221");
});

cljs.core.async.__GT_t_cljs$core$async23221 = (function cljs$core$async$map_LT__$___GT_t_cljs$core$async23221(map_LT___$1,f__$1,ch__$1,meta23222){
return (new cljs.core.async.t_cljs$core$async23221(map_LT___$1,f__$1,ch__$1,meta23222));
});

}

return (new cljs.core.async.t_cljs$core$async23221(cljs$core$async$map_LT_,f,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.map_GT_ = (function cljs$core$async$map_GT_(f,ch){
if(typeof cljs.core.async.t_cljs$core$async23230 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23230 = (function (map_GT_,f,ch,meta23231){
this.map_GT_ = map_GT_;
this.f = f;
this.ch = ch;
this.meta23231 = meta23231;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23232,meta23231__$1){
var self__ = this;
var _23232__$1 = this;
return (new cljs.core.async.t_cljs$core$async23230(self__.map_GT_,self__.f,self__.ch,meta23231__$1));
});

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23232){
var self__ = this;
var _23232__$1 = this;
return self__.meta23231;
});

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,fn1);
});

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23230.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,self__.f.call(null,val),fn1);
});

cljs.core.async.t_cljs$core$async23230.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map>","map>",1676369295,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23231","meta23231",-1051178705,null)], null);
});

cljs.core.async.t_cljs$core$async23230.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23230.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23230";

cljs.core.async.t_cljs$core$async23230.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23230");
});

cljs.core.async.__GT_t_cljs$core$async23230 = (function cljs$core$async$map_GT__$___GT_t_cljs$core$async23230(map_GT___$1,f__$1,ch__$1,meta23231){
return (new cljs.core.async.t_cljs$core$async23230(map_GT___$1,f__$1,ch__$1,meta23231));
});

}

return (new cljs.core.async.t_cljs$core$async23230(cljs$core$async$map_GT_,f,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.filter_GT_ = (function cljs$core$async$filter_GT_(p,ch){
if(typeof cljs.core.async.t_cljs$core$async23236 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23236 = (function (filter_GT_,p,ch,meta23237){
this.filter_GT_ = filter_GT_;
this.p = p;
this.ch = ch;
this.meta23237 = meta23237;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23238,meta23237__$1){
var self__ = this;
var _23238__$1 = this;
return (new cljs.core.async.t_cljs$core$async23236(self__.filter_GT_,self__.p,self__.ch,meta23237__$1));
});

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23238){
var self__ = this;
var _23238__$1 = this;
return self__.meta23237;
});

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$Channel$closed_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,fn1);
});

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23236.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
if(cljs.core.truth_(self__.p.call(null,val))){
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,val,fn1);
} else {
return cljs.core.async.impl.channels.box.call(null,cljs.core.not.call(null,cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch)));
}
});

cljs.core.async.t_cljs$core$async23236.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"filter>","filter>",-37644455,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"p","p",1791580836,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"p","p",1791580836,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23237","meta23237",-911584570,null)], null);
});

cljs.core.async.t_cljs$core$async23236.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23236.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23236";

cljs.core.async.t_cljs$core$async23236.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23236");
});

cljs.core.async.__GT_t_cljs$core$async23236 = (function cljs$core$async$filter_GT__$___GT_t_cljs$core$async23236(filter_GT___$1,p__$1,ch__$1,meta23237){
return (new cljs.core.async.t_cljs$core$async23236(filter_GT___$1,p__$1,ch__$1,meta23237));
});

}

return (new cljs.core.async.t_cljs$core$async23236(cljs$core$async$filter_GT_,p,ch,cljs.core.PersistentArrayMap.EMPTY));
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
var args23239 = [];
var len__19428__auto___23283 = arguments.length;
var i__19429__auto___23284 = (0);
while(true){
if((i__19429__auto___23284 < len__19428__auto___23283)){
args23239.push((arguments[i__19429__auto___23284]));

var G__23285 = (i__19429__auto___23284 + (1));
i__19429__auto___23284 = G__23285;
continue;
} else {
}
break;
}

var G__23241 = args23239.length;
switch (G__23241) {
case 2:
return cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23239.length)].join('')));

}
});

cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.filter_LT_.call(null,p,ch,null);
});

cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$3 = (function (p,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21037__auto___23287 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23287,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23287,out){
return (function (state_23262){
var state_val_23263 = (state_23262[(1)]);
if((state_val_23263 === (7))){
var inst_23258 = (state_23262[(2)]);
var state_23262__$1 = state_23262;
var statearr_23264_23288 = state_23262__$1;
(statearr_23264_23288[(2)] = inst_23258);

(statearr_23264_23288[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (1))){
var state_23262__$1 = state_23262;
var statearr_23265_23289 = state_23262__$1;
(statearr_23265_23289[(2)] = null);

(statearr_23265_23289[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (4))){
var inst_23244 = (state_23262[(7)]);
var inst_23244__$1 = (state_23262[(2)]);
var inst_23245 = (inst_23244__$1 == null);
var state_23262__$1 = (function (){var statearr_23266 = state_23262;
(statearr_23266[(7)] = inst_23244__$1);

return statearr_23266;
})();
if(cljs.core.truth_(inst_23245)){
var statearr_23267_23290 = state_23262__$1;
(statearr_23267_23290[(1)] = (5));

} else {
var statearr_23268_23291 = state_23262__$1;
(statearr_23268_23291[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (6))){
var inst_23244 = (state_23262[(7)]);
var inst_23249 = p.call(null,inst_23244);
var state_23262__$1 = state_23262;
if(cljs.core.truth_(inst_23249)){
var statearr_23269_23292 = state_23262__$1;
(statearr_23269_23292[(1)] = (8));

} else {
var statearr_23270_23293 = state_23262__$1;
(statearr_23270_23293[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (3))){
var inst_23260 = (state_23262[(2)]);
var state_23262__$1 = state_23262;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23262__$1,inst_23260);
} else {
if((state_val_23263 === (2))){
var state_23262__$1 = state_23262;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23262__$1,(4),ch);
} else {
if((state_val_23263 === (11))){
var inst_23252 = (state_23262[(2)]);
var state_23262__$1 = state_23262;
var statearr_23271_23294 = state_23262__$1;
(statearr_23271_23294[(2)] = inst_23252);

(statearr_23271_23294[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (9))){
var state_23262__$1 = state_23262;
var statearr_23272_23295 = state_23262__$1;
(statearr_23272_23295[(2)] = null);

(statearr_23272_23295[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (5))){
var inst_23247 = cljs.core.async.close_BANG_.call(null,out);
var state_23262__$1 = state_23262;
var statearr_23273_23296 = state_23262__$1;
(statearr_23273_23296[(2)] = inst_23247);

(statearr_23273_23296[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (10))){
var inst_23255 = (state_23262[(2)]);
var state_23262__$1 = (function (){var statearr_23274 = state_23262;
(statearr_23274[(8)] = inst_23255);

return statearr_23274;
})();
var statearr_23275_23297 = state_23262__$1;
(statearr_23275_23297[(2)] = null);

(statearr_23275_23297[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23263 === (8))){
var inst_23244 = (state_23262[(7)]);
var state_23262__$1 = state_23262;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23262__$1,(11),out,inst_23244);
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
});})(c__21037__auto___23287,out))
;
return ((function (switch__20925__auto__,c__21037__auto___23287,out){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23279 = [null,null,null,null,null,null,null,null,null];
(statearr_23279[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23279[(1)] = (1));

return statearr_23279;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23262){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23262);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23280){if((e23280 instanceof Object)){
var ex__20929__auto__ = e23280;
var statearr_23281_23298 = state_23262;
(statearr_23281_23298[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23262);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23280;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23299 = state_23262;
state_23262 = G__23299;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23262){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23262);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23287,out))
})();
var state__21039__auto__ = (function (){var statearr_23282 = f__21038__auto__.call(null);
(statearr_23282[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23287);

return statearr_23282;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23287,out))
);


return out;
});

cljs.core.async.filter_LT_.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.remove_LT_ = (function cljs$core$async$remove_LT_(var_args){
var args23300 = [];
var len__19428__auto___23303 = arguments.length;
var i__19429__auto___23304 = (0);
while(true){
if((i__19429__auto___23304 < len__19428__auto___23303)){
args23300.push((arguments[i__19429__auto___23304]));

var G__23305 = (i__19429__auto___23304 + (1));
i__19429__auto___23304 = G__23305;
continue;
} else {
}
break;
}

var G__23302 = args23300.length;
switch (G__23302) {
case 2:
return cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23300.length)].join('')));

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
var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__){
return (function (state_23472){
var state_val_23473 = (state_23472[(1)]);
if((state_val_23473 === (7))){
var inst_23468 = (state_23472[(2)]);
var state_23472__$1 = state_23472;
var statearr_23474_23515 = state_23472__$1;
(statearr_23474_23515[(2)] = inst_23468);

(statearr_23474_23515[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (20))){
var inst_23438 = (state_23472[(7)]);
var inst_23449 = (state_23472[(2)]);
var inst_23450 = cljs.core.next.call(null,inst_23438);
var inst_23424 = inst_23450;
var inst_23425 = null;
var inst_23426 = (0);
var inst_23427 = (0);
var state_23472__$1 = (function (){var statearr_23475 = state_23472;
(statearr_23475[(8)] = inst_23426);

(statearr_23475[(9)] = inst_23425);

(statearr_23475[(10)] = inst_23424);

(statearr_23475[(11)] = inst_23449);

(statearr_23475[(12)] = inst_23427);

return statearr_23475;
})();
var statearr_23476_23516 = state_23472__$1;
(statearr_23476_23516[(2)] = null);

(statearr_23476_23516[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (1))){
var state_23472__$1 = state_23472;
var statearr_23477_23517 = state_23472__$1;
(statearr_23477_23517[(2)] = null);

(statearr_23477_23517[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (4))){
var inst_23413 = (state_23472[(13)]);
var inst_23413__$1 = (state_23472[(2)]);
var inst_23414 = (inst_23413__$1 == null);
var state_23472__$1 = (function (){var statearr_23478 = state_23472;
(statearr_23478[(13)] = inst_23413__$1);

return statearr_23478;
})();
if(cljs.core.truth_(inst_23414)){
var statearr_23479_23518 = state_23472__$1;
(statearr_23479_23518[(1)] = (5));

} else {
var statearr_23480_23519 = state_23472__$1;
(statearr_23480_23519[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (15))){
var state_23472__$1 = state_23472;
var statearr_23484_23520 = state_23472__$1;
(statearr_23484_23520[(2)] = null);

(statearr_23484_23520[(1)] = (16));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (21))){
var state_23472__$1 = state_23472;
var statearr_23485_23521 = state_23472__$1;
(statearr_23485_23521[(2)] = null);

(statearr_23485_23521[(1)] = (23));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (13))){
var inst_23426 = (state_23472[(8)]);
var inst_23425 = (state_23472[(9)]);
var inst_23424 = (state_23472[(10)]);
var inst_23427 = (state_23472[(12)]);
var inst_23434 = (state_23472[(2)]);
var inst_23435 = (inst_23427 + (1));
var tmp23481 = inst_23426;
var tmp23482 = inst_23425;
var tmp23483 = inst_23424;
var inst_23424__$1 = tmp23483;
var inst_23425__$1 = tmp23482;
var inst_23426__$1 = tmp23481;
var inst_23427__$1 = inst_23435;
var state_23472__$1 = (function (){var statearr_23486 = state_23472;
(statearr_23486[(8)] = inst_23426__$1);

(statearr_23486[(9)] = inst_23425__$1);

(statearr_23486[(14)] = inst_23434);

(statearr_23486[(10)] = inst_23424__$1);

(statearr_23486[(12)] = inst_23427__$1);

return statearr_23486;
})();
var statearr_23487_23522 = state_23472__$1;
(statearr_23487_23522[(2)] = null);

(statearr_23487_23522[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (22))){
var state_23472__$1 = state_23472;
var statearr_23488_23523 = state_23472__$1;
(statearr_23488_23523[(2)] = null);

(statearr_23488_23523[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (6))){
var inst_23413 = (state_23472[(13)]);
var inst_23422 = f.call(null,inst_23413);
var inst_23423 = cljs.core.seq.call(null,inst_23422);
var inst_23424 = inst_23423;
var inst_23425 = null;
var inst_23426 = (0);
var inst_23427 = (0);
var state_23472__$1 = (function (){var statearr_23489 = state_23472;
(statearr_23489[(8)] = inst_23426);

(statearr_23489[(9)] = inst_23425);

(statearr_23489[(10)] = inst_23424);

(statearr_23489[(12)] = inst_23427);

return statearr_23489;
})();
var statearr_23490_23524 = state_23472__$1;
(statearr_23490_23524[(2)] = null);

(statearr_23490_23524[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (17))){
var inst_23438 = (state_23472[(7)]);
var inst_23442 = cljs.core.chunk_first.call(null,inst_23438);
var inst_23443 = cljs.core.chunk_rest.call(null,inst_23438);
var inst_23444 = cljs.core.count.call(null,inst_23442);
var inst_23424 = inst_23443;
var inst_23425 = inst_23442;
var inst_23426 = inst_23444;
var inst_23427 = (0);
var state_23472__$1 = (function (){var statearr_23491 = state_23472;
(statearr_23491[(8)] = inst_23426);

(statearr_23491[(9)] = inst_23425);

(statearr_23491[(10)] = inst_23424);

(statearr_23491[(12)] = inst_23427);

return statearr_23491;
})();
var statearr_23492_23525 = state_23472__$1;
(statearr_23492_23525[(2)] = null);

(statearr_23492_23525[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (3))){
var inst_23470 = (state_23472[(2)]);
var state_23472__$1 = state_23472;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23472__$1,inst_23470);
} else {
if((state_val_23473 === (12))){
var inst_23458 = (state_23472[(2)]);
var state_23472__$1 = state_23472;
var statearr_23493_23526 = state_23472__$1;
(statearr_23493_23526[(2)] = inst_23458);

(statearr_23493_23526[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (2))){
var state_23472__$1 = state_23472;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23472__$1,(4),in$);
} else {
if((state_val_23473 === (23))){
var inst_23466 = (state_23472[(2)]);
var state_23472__$1 = state_23472;
var statearr_23494_23527 = state_23472__$1;
(statearr_23494_23527[(2)] = inst_23466);

(statearr_23494_23527[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (19))){
var inst_23453 = (state_23472[(2)]);
var state_23472__$1 = state_23472;
var statearr_23495_23528 = state_23472__$1;
(statearr_23495_23528[(2)] = inst_23453);

(statearr_23495_23528[(1)] = (16));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (11))){
var inst_23438 = (state_23472[(7)]);
var inst_23424 = (state_23472[(10)]);
var inst_23438__$1 = cljs.core.seq.call(null,inst_23424);
var state_23472__$1 = (function (){var statearr_23496 = state_23472;
(statearr_23496[(7)] = inst_23438__$1);

return statearr_23496;
})();
if(inst_23438__$1){
var statearr_23497_23529 = state_23472__$1;
(statearr_23497_23529[(1)] = (14));

} else {
var statearr_23498_23530 = state_23472__$1;
(statearr_23498_23530[(1)] = (15));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (9))){
var inst_23460 = (state_23472[(2)]);
var inst_23461 = cljs.core.async.impl.protocols.closed_QMARK_.call(null,out);
var state_23472__$1 = (function (){var statearr_23499 = state_23472;
(statearr_23499[(15)] = inst_23460);

return statearr_23499;
})();
if(cljs.core.truth_(inst_23461)){
var statearr_23500_23531 = state_23472__$1;
(statearr_23500_23531[(1)] = (21));

} else {
var statearr_23501_23532 = state_23472__$1;
(statearr_23501_23532[(1)] = (22));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (5))){
var inst_23416 = cljs.core.async.close_BANG_.call(null,out);
var state_23472__$1 = state_23472;
var statearr_23502_23533 = state_23472__$1;
(statearr_23502_23533[(2)] = inst_23416);

(statearr_23502_23533[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (14))){
var inst_23438 = (state_23472[(7)]);
var inst_23440 = cljs.core.chunked_seq_QMARK_.call(null,inst_23438);
var state_23472__$1 = state_23472;
if(inst_23440){
var statearr_23503_23534 = state_23472__$1;
(statearr_23503_23534[(1)] = (17));

} else {
var statearr_23504_23535 = state_23472__$1;
(statearr_23504_23535[(1)] = (18));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (16))){
var inst_23456 = (state_23472[(2)]);
var state_23472__$1 = state_23472;
var statearr_23505_23536 = state_23472__$1;
(statearr_23505_23536[(2)] = inst_23456);

(statearr_23505_23536[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23473 === (10))){
var inst_23425 = (state_23472[(9)]);
var inst_23427 = (state_23472[(12)]);
var inst_23432 = cljs.core._nth.call(null,inst_23425,inst_23427);
var state_23472__$1 = state_23472;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23472__$1,(13),out,inst_23432);
} else {
if((state_val_23473 === (18))){
var inst_23438 = (state_23472[(7)]);
var inst_23447 = cljs.core.first.call(null,inst_23438);
var state_23472__$1 = state_23472;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23472__$1,(20),out,inst_23447);
} else {
if((state_val_23473 === (8))){
var inst_23426 = (state_23472[(8)]);
var inst_23427 = (state_23472[(12)]);
var inst_23429 = (inst_23427 < inst_23426);
var inst_23430 = inst_23429;
var state_23472__$1 = state_23472;
if(cljs.core.truth_(inst_23430)){
var statearr_23506_23537 = state_23472__$1;
(statearr_23506_23537[(1)] = (10));

} else {
var statearr_23507_23538 = state_23472__$1;
(statearr_23507_23538[(1)] = (11));

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
});})(c__21037__auto__))
;
return ((function (switch__20925__auto__,c__21037__auto__){
return (function() {
var cljs$core$async$mapcat_STAR__$_state_machine__20926__auto__ = null;
var cljs$core$async$mapcat_STAR__$_state_machine__20926__auto____0 = (function (){
var statearr_23511 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23511[(0)] = cljs$core$async$mapcat_STAR__$_state_machine__20926__auto__);

(statearr_23511[(1)] = (1));

return statearr_23511;
});
var cljs$core$async$mapcat_STAR__$_state_machine__20926__auto____1 = (function (state_23472){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23472);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23512){if((e23512 instanceof Object)){
var ex__20929__auto__ = e23512;
var statearr_23513_23539 = state_23472;
(statearr_23513_23539[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23472);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23512;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23540 = state_23472;
state_23472 = G__23540;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$mapcat_STAR__$_state_machine__20926__auto__ = function(state_23472){
switch(arguments.length){
case 0:
return cljs$core$async$mapcat_STAR__$_state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$mapcat_STAR__$_state_machine__20926__auto____1.call(this,state_23472);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mapcat_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mapcat_STAR__$_state_machine__20926__auto____0;
cljs$core$async$mapcat_STAR__$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mapcat_STAR__$_state_machine__20926__auto____1;
return cljs$core$async$mapcat_STAR__$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__))
})();
var state__21039__auto__ = (function (){var statearr_23514 = f__21038__auto__.call(null);
(statearr_23514[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_23514;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__))
);

return c__21037__auto__;
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.mapcat_LT_ = (function cljs$core$async$mapcat_LT_(var_args){
var args23541 = [];
var len__19428__auto___23544 = arguments.length;
var i__19429__auto___23545 = (0);
while(true){
if((i__19429__auto___23545 < len__19428__auto___23544)){
args23541.push((arguments[i__19429__auto___23545]));

var G__23546 = (i__19429__auto___23545 + (1));
i__19429__auto___23545 = G__23546;
continue;
} else {
}
break;
}

var G__23543 = args23541.length;
switch (G__23543) {
case 2:
return cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23541.length)].join('')));

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
var args23548 = [];
var len__19428__auto___23551 = arguments.length;
var i__19429__auto___23552 = (0);
while(true){
if((i__19429__auto___23552 < len__19428__auto___23551)){
args23548.push((arguments[i__19429__auto___23552]));

var G__23553 = (i__19429__auto___23552 + (1));
i__19429__auto___23552 = G__23553;
continue;
} else {
}
break;
}

var G__23550 = args23548.length;
switch (G__23550) {
case 2:
return cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23548.length)].join('')));

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
var args23555 = [];
var len__19428__auto___23606 = arguments.length;
var i__19429__auto___23607 = (0);
while(true){
if((i__19429__auto___23607 < len__19428__auto___23606)){
args23555.push((arguments[i__19429__auto___23607]));

var G__23608 = (i__19429__auto___23607 + (1));
i__19429__auto___23607 = G__23608;
continue;
} else {
}
break;
}

var G__23557 = args23555.length;
switch (G__23557) {
case 1:
return cljs.core.async.unique.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unique.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23555.length)].join('')));

}
});

cljs.core.async.unique.cljs$core$IFn$_invoke$arity$1 = (function (ch){
return cljs.core.async.unique.call(null,ch,null);
});

cljs.core.async.unique.cljs$core$IFn$_invoke$arity$2 = (function (ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21037__auto___23610 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23610,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23610,out){
return (function (state_23581){
var state_val_23582 = (state_23581[(1)]);
if((state_val_23582 === (7))){
var inst_23576 = (state_23581[(2)]);
var state_23581__$1 = state_23581;
var statearr_23583_23611 = state_23581__$1;
(statearr_23583_23611[(2)] = inst_23576);

(statearr_23583_23611[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (1))){
var inst_23558 = null;
var state_23581__$1 = (function (){var statearr_23584 = state_23581;
(statearr_23584[(7)] = inst_23558);

return statearr_23584;
})();
var statearr_23585_23612 = state_23581__$1;
(statearr_23585_23612[(2)] = null);

(statearr_23585_23612[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (4))){
var inst_23561 = (state_23581[(8)]);
var inst_23561__$1 = (state_23581[(2)]);
var inst_23562 = (inst_23561__$1 == null);
var inst_23563 = cljs.core.not.call(null,inst_23562);
var state_23581__$1 = (function (){var statearr_23586 = state_23581;
(statearr_23586[(8)] = inst_23561__$1);

return statearr_23586;
})();
if(inst_23563){
var statearr_23587_23613 = state_23581__$1;
(statearr_23587_23613[(1)] = (5));

} else {
var statearr_23588_23614 = state_23581__$1;
(statearr_23588_23614[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (6))){
var state_23581__$1 = state_23581;
var statearr_23589_23615 = state_23581__$1;
(statearr_23589_23615[(2)] = null);

(statearr_23589_23615[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (3))){
var inst_23578 = (state_23581[(2)]);
var inst_23579 = cljs.core.async.close_BANG_.call(null,out);
var state_23581__$1 = (function (){var statearr_23590 = state_23581;
(statearr_23590[(9)] = inst_23578);

return statearr_23590;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23581__$1,inst_23579);
} else {
if((state_val_23582 === (2))){
var state_23581__$1 = state_23581;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23581__$1,(4),ch);
} else {
if((state_val_23582 === (11))){
var inst_23561 = (state_23581[(8)]);
var inst_23570 = (state_23581[(2)]);
var inst_23558 = inst_23561;
var state_23581__$1 = (function (){var statearr_23591 = state_23581;
(statearr_23591[(7)] = inst_23558);

(statearr_23591[(10)] = inst_23570);

return statearr_23591;
})();
var statearr_23592_23616 = state_23581__$1;
(statearr_23592_23616[(2)] = null);

(statearr_23592_23616[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (9))){
var inst_23561 = (state_23581[(8)]);
var state_23581__$1 = state_23581;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23581__$1,(11),out,inst_23561);
} else {
if((state_val_23582 === (5))){
var inst_23558 = (state_23581[(7)]);
var inst_23561 = (state_23581[(8)]);
var inst_23565 = cljs.core._EQ_.call(null,inst_23561,inst_23558);
var state_23581__$1 = state_23581;
if(inst_23565){
var statearr_23594_23617 = state_23581__$1;
(statearr_23594_23617[(1)] = (8));

} else {
var statearr_23595_23618 = state_23581__$1;
(statearr_23595_23618[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (10))){
var inst_23573 = (state_23581[(2)]);
var state_23581__$1 = state_23581;
var statearr_23596_23619 = state_23581__$1;
(statearr_23596_23619[(2)] = inst_23573);

(statearr_23596_23619[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23582 === (8))){
var inst_23558 = (state_23581[(7)]);
var tmp23593 = inst_23558;
var inst_23558__$1 = tmp23593;
var state_23581__$1 = (function (){var statearr_23597 = state_23581;
(statearr_23597[(7)] = inst_23558__$1);

return statearr_23597;
})();
var statearr_23598_23620 = state_23581__$1;
(statearr_23598_23620[(2)] = null);

(statearr_23598_23620[(1)] = (2));


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
});})(c__21037__auto___23610,out))
;
return ((function (switch__20925__auto__,c__21037__auto___23610,out){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23602 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_23602[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23602[(1)] = (1));

return statearr_23602;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23581){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23581);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23603){if((e23603 instanceof Object)){
var ex__20929__auto__ = e23603;
var statearr_23604_23621 = state_23581;
(statearr_23604_23621[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23581);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23603;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23622 = state_23581;
state_23581 = G__23622;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23581){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23581);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23610,out))
})();
var state__21039__auto__ = (function (){var statearr_23605 = f__21038__auto__.call(null);
(statearr_23605[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23610);

return statearr_23605;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23610,out))
);


return out;
});

cljs.core.async.unique.cljs$lang$maxFixedArity = 2;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.partition = (function cljs$core$async$partition(var_args){
var args23623 = [];
var len__19428__auto___23693 = arguments.length;
var i__19429__auto___23694 = (0);
while(true){
if((i__19429__auto___23694 < len__19428__auto___23693)){
args23623.push((arguments[i__19429__auto___23694]));

var G__23695 = (i__19429__auto___23694 + (1));
i__19429__auto___23694 = G__23695;
continue;
} else {
}
break;
}

var G__23625 = args23623.length;
switch (G__23625) {
case 2:
return cljs.core.async.partition.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.partition.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23623.length)].join('')));

}
});

cljs.core.async.partition.cljs$core$IFn$_invoke$arity$2 = (function (n,ch){
return cljs.core.async.partition.call(null,n,ch,null);
});

cljs.core.async.partition.cljs$core$IFn$_invoke$arity$3 = (function (n,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21037__auto___23697 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23697,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23697,out){
return (function (state_23663){
var state_val_23664 = (state_23663[(1)]);
if((state_val_23664 === (7))){
var inst_23659 = (state_23663[(2)]);
var state_23663__$1 = state_23663;
var statearr_23665_23698 = state_23663__$1;
(statearr_23665_23698[(2)] = inst_23659);

(statearr_23665_23698[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (1))){
var inst_23626 = (new Array(n));
var inst_23627 = inst_23626;
var inst_23628 = (0);
var state_23663__$1 = (function (){var statearr_23666 = state_23663;
(statearr_23666[(7)] = inst_23628);

(statearr_23666[(8)] = inst_23627);

return statearr_23666;
})();
var statearr_23667_23699 = state_23663__$1;
(statearr_23667_23699[(2)] = null);

(statearr_23667_23699[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (4))){
var inst_23631 = (state_23663[(9)]);
var inst_23631__$1 = (state_23663[(2)]);
var inst_23632 = (inst_23631__$1 == null);
var inst_23633 = cljs.core.not.call(null,inst_23632);
var state_23663__$1 = (function (){var statearr_23668 = state_23663;
(statearr_23668[(9)] = inst_23631__$1);

return statearr_23668;
})();
if(inst_23633){
var statearr_23669_23700 = state_23663__$1;
(statearr_23669_23700[(1)] = (5));

} else {
var statearr_23670_23701 = state_23663__$1;
(statearr_23670_23701[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (15))){
var inst_23653 = (state_23663[(2)]);
var state_23663__$1 = state_23663;
var statearr_23671_23702 = state_23663__$1;
(statearr_23671_23702[(2)] = inst_23653);

(statearr_23671_23702[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (13))){
var state_23663__$1 = state_23663;
var statearr_23672_23703 = state_23663__$1;
(statearr_23672_23703[(2)] = null);

(statearr_23672_23703[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (6))){
var inst_23628 = (state_23663[(7)]);
var inst_23649 = (inst_23628 > (0));
var state_23663__$1 = state_23663;
if(cljs.core.truth_(inst_23649)){
var statearr_23673_23704 = state_23663__$1;
(statearr_23673_23704[(1)] = (12));

} else {
var statearr_23674_23705 = state_23663__$1;
(statearr_23674_23705[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (3))){
var inst_23661 = (state_23663[(2)]);
var state_23663__$1 = state_23663;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23663__$1,inst_23661);
} else {
if((state_val_23664 === (12))){
var inst_23627 = (state_23663[(8)]);
var inst_23651 = cljs.core.vec.call(null,inst_23627);
var state_23663__$1 = state_23663;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23663__$1,(15),out,inst_23651);
} else {
if((state_val_23664 === (2))){
var state_23663__$1 = state_23663;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23663__$1,(4),ch);
} else {
if((state_val_23664 === (11))){
var inst_23643 = (state_23663[(2)]);
var inst_23644 = (new Array(n));
var inst_23627 = inst_23644;
var inst_23628 = (0);
var state_23663__$1 = (function (){var statearr_23675 = state_23663;
(statearr_23675[(7)] = inst_23628);

(statearr_23675[(10)] = inst_23643);

(statearr_23675[(8)] = inst_23627);

return statearr_23675;
})();
var statearr_23676_23706 = state_23663__$1;
(statearr_23676_23706[(2)] = null);

(statearr_23676_23706[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (9))){
var inst_23627 = (state_23663[(8)]);
var inst_23641 = cljs.core.vec.call(null,inst_23627);
var state_23663__$1 = state_23663;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23663__$1,(11),out,inst_23641);
} else {
if((state_val_23664 === (5))){
var inst_23628 = (state_23663[(7)]);
var inst_23627 = (state_23663[(8)]);
var inst_23631 = (state_23663[(9)]);
var inst_23636 = (state_23663[(11)]);
var inst_23635 = (inst_23627[inst_23628] = inst_23631);
var inst_23636__$1 = (inst_23628 + (1));
var inst_23637 = (inst_23636__$1 < n);
var state_23663__$1 = (function (){var statearr_23677 = state_23663;
(statearr_23677[(11)] = inst_23636__$1);

(statearr_23677[(12)] = inst_23635);

return statearr_23677;
})();
if(cljs.core.truth_(inst_23637)){
var statearr_23678_23707 = state_23663__$1;
(statearr_23678_23707[(1)] = (8));

} else {
var statearr_23679_23708 = state_23663__$1;
(statearr_23679_23708[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (14))){
var inst_23656 = (state_23663[(2)]);
var inst_23657 = cljs.core.async.close_BANG_.call(null,out);
var state_23663__$1 = (function (){var statearr_23681 = state_23663;
(statearr_23681[(13)] = inst_23656);

return statearr_23681;
})();
var statearr_23682_23709 = state_23663__$1;
(statearr_23682_23709[(2)] = inst_23657);

(statearr_23682_23709[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (10))){
var inst_23647 = (state_23663[(2)]);
var state_23663__$1 = state_23663;
var statearr_23683_23710 = state_23663__$1;
(statearr_23683_23710[(2)] = inst_23647);

(statearr_23683_23710[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23664 === (8))){
var inst_23627 = (state_23663[(8)]);
var inst_23636 = (state_23663[(11)]);
var tmp23680 = inst_23627;
var inst_23627__$1 = tmp23680;
var inst_23628 = inst_23636;
var state_23663__$1 = (function (){var statearr_23684 = state_23663;
(statearr_23684[(7)] = inst_23628);

(statearr_23684[(8)] = inst_23627__$1);

return statearr_23684;
})();
var statearr_23685_23711 = state_23663__$1;
(statearr_23685_23711[(2)] = null);

(statearr_23685_23711[(1)] = (2));


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
});})(c__21037__auto___23697,out))
;
return ((function (switch__20925__auto__,c__21037__auto___23697,out){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23689 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23689[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23689[(1)] = (1));

return statearr_23689;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23663){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23663);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23690){if((e23690 instanceof Object)){
var ex__20929__auto__ = e23690;
var statearr_23691_23712 = state_23663;
(statearr_23691_23712[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23663);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23690;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23713 = state_23663;
state_23663 = G__23713;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23663){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23663);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23697,out))
})();
var state__21039__auto__ = (function (){var statearr_23692 = f__21038__auto__.call(null);
(statearr_23692[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23697);

return statearr_23692;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23697,out))
);


return out;
});

cljs.core.async.partition.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.partition_by = (function cljs$core$async$partition_by(var_args){
var args23714 = [];
var len__19428__auto___23788 = arguments.length;
var i__19429__auto___23789 = (0);
while(true){
if((i__19429__auto___23789 < len__19428__auto___23788)){
args23714.push((arguments[i__19429__auto___23789]));

var G__23790 = (i__19429__auto___23789 + (1));
i__19429__auto___23789 = G__23790;
continue;
} else {
}
break;
}

var G__23716 = args23714.length;
switch (G__23716) {
case 2:
return cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23714.length)].join('')));

}
});

cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$2 = (function (f,ch){
return cljs.core.async.partition_by.call(null,f,ch,null);
});

cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$3 = (function (f,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21037__auto___23792 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___23792,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___23792,out){
return (function (state_23758){
var state_val_23759 = (state_23758[(1)]);
if((state_val_23759 === (7))){
var inst_23754 = (state_23758[(2)]);
var state_23758__$1 = state_23758;
var statearr_23760_23793 = state_23758__$1;
(statearr_23760_23793[(2)] = inst_23754);

(statearr_23760_23793[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (1))){
var inst_23717 = [];
var inst_23718 = inst_23717;
var inst_23719 = new cljs.core.Keyword("cljs.core.async","nothing","cljs.core.async/nothing",-69252123);
var state_23758__$1 = (function (){var statearr_23761 = state_23758;
(statearr_23761[(7)] = inst_23718);

(statearr_23761[(8)] = inst_23719);

return statearr_23761;
})();
var statearr_23762_23794 = state_23758__$1;
(statearr_23762_23794[(2)] = null);

(statearr_23762_23794[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (4))){
var inst_23722 = (state_23758[(9)]);
var inst_23722__$1 = (state_23758[(2)]);
var inst_23723 = (inst_23722__$1 == null);
var inst_23724 = cljs.core.not.call(null,inst_23723);
var state_23758__$1 = (function (){var statearr_23763 = state_23758;
(statearr_23763[(9)] = inst_23722__$1);

return statearr_23763;
})();
if(inst_23724){
var statearr_23764_23795 = state_23758__$1;
(statearr_23764_23795[(1)] = (5));

} else {
var statearr_23765_23796 = state_23758__$1;
(statearr_23765_23796[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (15))){
var inst_23748 = (state_23758[(2)]);
var state_23758__$1 = state_23758;
var statearr_23766_23797 = state_23758__$1;
(statearr_23766_23797[(2)] = inst_23748);

(statearr_23766_23797[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (13))){
var state_23758__$1 = state_23758;
var statearr_23767_23798 = state_23758__$1;
(statearr_23767_23798[(2)] = null);

(statearr_23767_23798[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (6))){
var inst_23718 = (state_23758[(7)]);
var inst_23743 = inst_23718.length;
var inst_23744 = (inst_23743 > (0));
var state_23758__$1 = state_23758;
if(cljs.core.truth_(inst_23744)){
var statearr_23768_23799 = state_23758__$1;
(statearr_23768_23799[(1)] = (12));

} else {
var statearr_23769_23800 = state_23758__$1;
(statearr_23769_23800[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (3))){
var inst_23756 = (state_23758[(2)]);
var state_23758__$1 = state_23758;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23758__$1,inst_23756);
} else {
if((state_val_23759 === (12))){
var inst_23718 = (state_23758[(7)]);
var inst_23746 = cljs.core.vec.call(null,inst_23718);
var state_23758__$1 = state_23758;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23758__$1,(15),out,inst_23746);
} else {
if((state_val_23759 === (2))){
var state_23758__$1 = state_23758;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23758__$1,(4),ch);
} else {
if((state_val_23759 === (11))){
var inst_23722 = (state_23758[(9)]);
var inst_23726 = (state_23758[(10)]);
var inst_23736 = (state_23758[(2)]);
var inst_23737 = [];
var inst_23738 = inst_23737.push(inst_23722);
var inst_23718 = inst_23737;
var inst_23719 = inst_23726;
var state_23758__$1 = (function (){var statearr_23770 = state_23758;
(statearr_23770[(11)] = inst_23736);

(statearr_23770[(12)] = inst_23738);

(statearr_23770[(7)] = inst_23718);

(statearr_23770[(8)] = inst_23719);

return statearr_23770;
})();
var statearr_23771_23801 = state_23758__$1;
(statearr_23771_23801[(2)] = null);

(statearr_23771_23801[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (9))){
var inst_23718 = (state_23758[(7)]);
var inst_23734 = cljs.core.vec.call(null,inst_23718);
var state_23758__$1 = state_23758;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23758__$1,(11),out,inst_23734);
} else {
if((state_val_23759 === (5))){
var inst_23722 = (state_23758[(9)]);
var inst_23726 = (state_23758[(10)]);
var inst_23719 = (state_23758[(8)]);
var inst_23726__$1 = f.call(null,inst_23722);
var inst_23727 = cljs.core._EQ_.call(null,inst_23726__$1,inst_23719);
var inst_23728 = cljs.core.keyword_identical_QMARK_.call(null,inst_23719,new cljs.core.Keyword("cljs.core.async","nothing","cljs.core.async/nothing",-69252123));
var inst_23729 = (inst_23727) || (inst_23728);
var state_23758__$1 = (function (){var statearr_23772 = state_23758;
(statearr_23772[(10)] = inst_23726__$1);

return statearr_23772;
})();
if(cljs.core.truth_(inst_23729)){
var statearr_23773_23802 = state_23758__$1;
(statearr_23773_23802[(1)] = (8));

} else {
var statearr_23774_23803 = state_23758__$1;
(statearr_23774_23803[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (14))){
var inst_23751 = (state_23758[(2)]);
var inst_23752 = cljs.core.async.close_BANG_.call(null,out);
var state_23758__$1 = (function (){var statearr_23776 = state_23758;
(statearr_23776[(13)] = inst_23751);

return statearr_23776;
})();
var statearr_23777_23804 = state_23758__$1;
(statearr_23777_23804[(2)] = inst_23752);

(statearr_23777_23804[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (10))){
var inst_23741 = (state_23758[(2)]);
var state_23758__$1 = state_23758;
var statearr_23778_23805 = state_23758__$1;
(statearr_23778_23805[(2)] = inst_23741);

(statearr_23778_23805[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23759 === (8))){
var inst_23722 = (state_23758[(9)]);
var inst_23726 = (state_23758[(10)]);
var inst_23718 = (state_23758[(7)]);
var inst_23731 = inst_23718.push(inst_23722);
var tmp23775 = inst_23718;
var inst_23718__$1 = tmp23775;
var inst_23719 = inst_23726;
var state_23758__$1 = (function (){var statearr_23779 = state_23758;
(statearr_23779[(14)] = inst_23731);

(statearr_23779[(7)] = inst_23718__$1);

(statearr_23779[(8)] = inst_23719);

return statearr_23779;
})();
var statearr_23780_23806 = state_23758__$1;
(statearr_23780_23806[(2)] = null);

(statearr_23780_23806[(1)] = (2));


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
});})(c__21037__auto___23792,out))
;
return ((function (switch__20925__auto__,c__21037__auto___23792,out){
return (function() {
var cljs$core$async$state_machine__20926__auto__ = null;
var cljs$core$async$state_machine__20926__auto____0 = (function (){
var statearr_23784 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23784[(0)] = cljs$core$async$state_machine__20926__auto__);

(statearr_23784[(1)] = (1));

return statearr_23784;
});
var cljs$core$async$state_machine__20926__auto____1 = (function (state_23758){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_23758);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e23785){if((e23785 instanceof Object)){
var ex__20929__auto__ = e23785;
var statearr_23786_23807 = state_23758;
(statearr_23786_23807[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23758);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23785;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23808 = state_23758;
state_23758 = G__23808;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
cljs$core$async$state_machine__20926__auto__ = function(state_23758){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__20926__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__20926__auto____1.call(this,state_23758);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__20926__auto____0;
cljs$core$async$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__20926__auto____1;
return cljs$core$async$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___23792,out))
})();
var state__21039__auto__ = (function (){var statearr_23787 = f__21038__auto__.call(null);
(statearr_23787[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___23792);

return statearr_23787;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___23792,out))
);


return out;
});

cljs.core.async.partition_by.cljs$lang$maxFixedArity = 3;

//# sourceMappingURL=async.js.map