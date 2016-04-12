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
var args21217 = [];
var len__19428__auto___21223 = arguments.length;
var i__19429__auto___21224 = (0);
while(true){
if((i__19429__auto___21224 < len__19428__auto___21223)){
args21217.push((arguments[i__19429__auto___21224]));

var G__21225 = (i__19429__auto___21224 + (1));
i__19429__auto___21224 = G__21225;
continue;
} else {
}
break;
}

var G__21219 = args21217.length;
switch (G__21219) {
case 1:
return cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21217.length)].join('')));

}
});

cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$1 = (function (f){
return cljs.core.async.fn_handler.call(null,f,true);
});

cljs.core.async.fn_handler.cljs$core$IFn$_invoke$arity$2 = (function (f,blockable){
if(typeof cljs.core.async.t_cljs$core$async21220 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21220 = (function (f,blockable,meta21221){
this.f = f;
this.blockable = blockable;
this.meta21221 = meta21221;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21220.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_21222,meta21221__$1){
var self__ = this;
var _21222__$1 = this;
return (new cljs.core.async.t_cljs$core$async21220(self__.f,self__.blockable,meta21221__$1));
});

cljs.core.async.t_cljs$core$async21220.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_21222){
var self__ = this;
var _21222__$1 = this;
return self__.meta21221;
});

cljs.core.async.t_cljs$core$async21220.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21220.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return true;
});

cljs.core.async.t_cljs$core$async21220.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return self__.blockable;
});

cljs.core.async.t_cljs$core$async21220.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return self__.f;
});

cljs.core.async.t_cljs$core$async21220.getBasis = (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"blockable","blockable",-28395259,null),new cljs.core.Symbol(null,"meta21221","meta21221",-1874102203,null)], null);
});

cljs.core.async.t_cljs$core$async21220.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21220.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21220";

cljs.core.async.t_cljs$core$async21220.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21220");
});

cljs.core.async.__GT_t_cljs$core$async21220 = (function cljs$core$async$__GT_t_cljs$core$async21220(f__$1,blockable__$1,meta21221){
return (new cljs.core.async.t_cljs$core$async21220(f__$1,blockable__$1,meta21221));
});

}

return (new cljs.core.async.t_cljs$core$async21220(f,blockable,cljs.core.PersistentArrayMap.EMPTY));
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
var args21229 = [];
var len__19428__auto___21232 = arguments.length;
var i__19429__auto___21233 = (0);
while(true){
if((i__19429__auto___21233 < len__19428__auto___21232)){
args21229.push((arguments[i__19429__auto___21233]));

var G__21234 = (i__19429__auto___21233 + (1));
i__19429__auto___21233 = G__21234;
continue;
} else {
}
break;
}

var G__21231 = args21229.length;
switch (G__21231) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21229.length)].join('')));

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
var args21236 = [];
var len__19428__auto___21239 = arguments.length;
var i__19429__auto___21240 = (0);
while(true){
if((i__19429__auto___21240 < len__19428__auto___21239)){
args21236.push((arguments[i__19429__auto___21240]));

var G__21241 = (i__19429__auto___21240 + (1));
i__19429__auto___21240 = G__21241;
continue;
} else {
}
break;
}

var G__21238 = args21236.length;
switch (G__21238) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21236.length)].join('')));

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
var args21243 = [];
var len__19428__auto___21246 = arguments.length;
var i__19429__auto___21247 = (0);
while(true){
if((i__19429__auto___21247 < len__19428__auto___21246)){
args21243.push((arguments[i__19429__auto___21247]));

var G__21248 = (i__19429__auto___21247 + (1));
i__19429__auto___21247 = G__21248;
continue;
} else {
}
break;
}

var G__21245 = args21243.length;
switch (G__21245) {
case 2:
return cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21243.length)].join('')));

}
});

cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$2 = (function (port,fn1){
return cljs.core.async.take_BANG_.call(null,port,fn1,true);
});

cljs.core.async.take_BANG_.cljs$core$IFn$_invoke$arity$3 = (function (port,fn1,on_caller_QMARK_){
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.fn_handler.call(null,fn1));
if(cljs.core.truth_(ret)){
var val_21250 = cljs.core.deref.call(null,ret);
if(cljs.core.truth_(on_caller_QMARK_)){
fn1.call(null,val_21250);
} else {
cljs.core.async.impl.dispatch.run.call(null,((function (val_21250,ret){
return (function (){
return fn1.call(null,val_21250);
});})(val_21250,ret))
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
var args21251 = [];
var len__19428__auto___21254 = arguments.length;
var i__19429__auto___21255 = (0);
while(true){
if((i__19429__auto___21255 < len__19428__auto___21254)){
args21251.push((arguments[i__19429__auto___21255]));

var G__21256 = (i__19429__auto___21255 + (1));
i__19429__auto___21255 = G__21256;
continue;
} else {
}
break;
}

var G__21253 = args21251.length;
switch (G__21253) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21251.length)].join('')));

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
var n__19273__auto___21258 = n;
var x_21259 = (0);
while(true){
if((x_21259 < n__19273__auto___21258)){
(a[x_21259] = (0));

var G__21260 = (x_21259 + (1));
x_21259 = G__21260;
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

var G__21261 = (i + (1));
i = G__21261;
continue;
}
break;
}
});
cljs.core.async.alt_flag = (function cljs$core$async$alt_flag(){
var flag = cljs.core.atom.call(null,true);
if(typeof cljs.core.async.t_cljs$core$async21265 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21265 = (function (alt_flag,flag,meta21266){
this.alt_flag = alt_flag;
this.flag = flag;
this.meta21266 = meta21266;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21265.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (flag){
return (function (_21267,meta21266__$1){
var self__ = this;
var _21267__$1 = this;
return (new cljs.core.async.t_cljs$core$async21265(self__.alt_flag,self__.flag,meta21266__$1));
});})(flag))
;

cljs.core.async.t_cljs$core$async21265.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (flag){
return (function (_21267){
var self__ = this;
var _21267__$1 = this;
return self__.meta21266;
});})(flag))
;

cljs.core.async.t_cljs$core$async21265.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21265.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.deref.call(null,self__.flag);
});})(flag))
;

cljs.core.async.t_cljs$core$async21265.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
return true;
});})(flag))
;

cljs.core.async.t_cljs$core$async21265.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = ((function (flag){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.flag,null);

return true;
});})(flag))
;

cljs.core.async.t_cljs$core$async21265.getBasis = ((function (flag){
return (function (){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"alt-flag","alt-flag",-1794972754,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"private","private",-558947994),true,new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(cljs.core.PersistentVector.EMPTY))], null)),new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"meta21266","meta21266",-1875060691,null)], null);
});})(flag))
;

cljs.core.async.t_cljs$core$async21265.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21265.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21265";

cljs.core.async.t_cljs$core$async21265.cljs$lang$ctorPrWriter = ((function (flag){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21265");
});})(flag))
;

cljs.core.async.__GT_t_cljs$core$async21265 = ((function (flag){
return (function cljs$core$async$alt_flag_$___GT_t_cljs$core$async21265(alt_flag__$1,flag__$1,meta21266){
return (new cljs.core.async.t_cljs$core$async21265(alt_flag__$1,flag__$1,meta21266));
});})(flag))
;

}

return (new cljs.core.async.t_cljs$core$async21265(cljs$core$async$alt_flag,flag,cljs.core.PersistentArrayMap.EMPTY));
});
cljs.core.async.alt_handler = (function cljs$core$async$alt_handler(flag,cb){
if(typeof cljs.core.async.t_cljs$core$async21271 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async21271 = (function (alt_handler,flag,cb,meta21272){
this.alt_handler = alt_handler;
this.flag = flag;
this.cb = cb;
this.meta21272 = meta21272;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async21271.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_21273,meta21272__$1){
var self__ = this;
var _21273__$1 = this;
return (new cljs.core.async.t_cljs$core$async21271(self__.alt_handler,self__.flag,self__.cb,meta21272__$1));
});

cljs.core.async.t_cljs$core$async21271.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_21273){
var self__ = this;
var _21273__$1 = this;
return self__.meta21272;
});

cljs.core.async.t_cljs$core$async21271.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async21271.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.active_QMARK_.call(null,self__.flag);
});

cljs.core.async.t_cljs$core$async21271.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return true;
});

cljs.core.async.t_cljs$core$async21271.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.async.impl.protocols.commit.call(null,self__.flag);

return self__.cb;
});

cljs.core.async.t_cljs$core$async21271.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"alt-handler","alt-handler",963786170,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"private","private",-558947994),true,new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"cb","cb",-2064487928,null)], null)))], null)),new cljs.core.Symbol(null,"flag","flag",-1565787888,null),new cljs.core.Symbol(null,"cb","cb",-2064487928,null),new cljs.core.Symbol(null,"meta21272","meta21272",-537891839,null)], null);
});

cljs.core.async.t_cljs$core$async21271.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async21271.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async21271";

cljs.core.async.t_cljs$core$async21271.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async21271");
});

cljs.core.async.__GT_t_cljs$core$async21271 = (function cljs$core$async$alt_handler_$___GT_t_cljs$core$async21271(alt_handler__$1,flag__$1,cb__$1,meta21272){
return (new cljs.core.async.t_cljs$core$async21271(alt_handler__$1,flag__$1,cb__$1,meta21272));
});

}

return (new cljs.core.async.t_cljs$core$async21271(cljs$core$async$alt_handler,flag,cb,cljs.core.PersistentArrayMap.EMPTY));
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
return (function (p1__21274_SHARP_){
return fret.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [p1__21274_SHARP_,wport], null));
});})(i,val,idx,port,wport,flag,n,idxs,priority))
));
})():cljs.core.async.impl.protocols.take_BANG_.call(null,port,cljs.core.async.alt_handler.call(null,flag,((function (i,idx,port,wport,flag,n,idxs,priority){
return (function (p1__21275_SHARP_){
return fret.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [p1__21275_SHARP_,port], null));
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
var G__21276 = (i + (1));
i = G__21276;
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
var len__19428__auto___21282 = arguments.length;
var i__19429__auto___21283 = (0);
while(true){
if((i__19429__auto___21283 < len__19428__auto___21282)){
args__19435__auto__.push((arguments[i__19429__auto___21283]));

var G__21284 = (i__19429__auto___21283 + (1));
i__19429__auto___21283 = G__21284;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ports,p__21279){
var map__21280 = p__21279;
var map__21280__$1 = ((((!((map__21280 == null)))?((((map__21280.cljs$lang$protocol_mask$partition0$ & (64))) || (map__21280.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__21280):map__21280);
var opts = map__21280__$1;
throw (new Error("alts! used not in (go ...) block"));
});

cljs.core.async.alts_BANG_.cljs$lang$maxFixedArity = (1);

cljs.core.async.alts_BANG_.cljs$lang$applyTo = (function (seq21277){
var G__21278 = cljs.core.first.call(null,seq21277);
var seq21277__$1 = cljs.core.next.call(null,seq21277);
return cljs.core.async.alts_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__21278,seq21277__$1);
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
var args21285 = [];
var len__19428__auto___21335 = arguments.length;
var i__19429__auto___21336 = (0);
while(true){
if((i__19429__auto___21336 < len__19428__auto___21335)){
args21285.push((arguments[i__19429__auto___21336]));

var G__21337 = (i__19429__auto___21336 + (1));
i__19429__auto___21336 = G__21337;
continue;
} else {
}
break;
}

var G__21287 = args21285.length;
switch (G__21287) {
case 2:
return cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21285.length)].join('')));

}
});

cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$2 = (function (from,to){
return cljs.core.async.pipe.call(null,from,to,true);
});

cljs.core.async.pipe.cljs$core$IFn$_invoke$arity$3 = (function (from,to,close_QMARK_){
var c__21172__auto___21339 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___21339){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___21339){
return (function (state_21311){
var state_val_21312 = (state_21311[(1)]);
if((state_val_21312 === (7))){
var inst_21307 = (state_21311[(2)]);
var state_21311__$1 = state_21311;
var statearr_21313_21340 = state_21311__$1;
(statearr_21313_21340[(2)] = inst_21307);

(statearr_21313_21340[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (1))){
var state_21311__$1 = state_21311;
var statearr_21314_21341 = state_21311__$1;
(statearr_21314_21341[(2)] = null);

(statearr_21314_21341[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (4))){
var inst_21290 = (state_21311[(7)]);
var inst_21290__$1 = (state_21311[(2)]);
var inst_21291 = (inst_21290__$1 == null);
var state_21311__$1 = (function (){var statearr_21315 = state_21311;
(statearr_21315[(7)] = inst_21290__$1);

return statearr_21315;
})();
if(cljs.core.truth_(inst_21291)){
var statearr_21316_21342 = state_21311__$1;
(statearr_21316_21342[(1)] = (5));

} else {
var statearr_21317_21343 = state_21311__$1;
(statearr_21317_21343[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (13))){
var state_21311__$1 = state_21311;
var statearr_21318_21344 = state_21311__$1;
(statearr_21318_21344[(2)] = null);

(statearr_21318_21344[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (6))){
var inst_21290 = (state_21311[(7)]);
var state_21311__$1 = state_21311;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21311__$1,(11),to,inst_21290);
} else {
if((state_val_21312 === (3))){
var inst_21309 = (state_21311[(2)]);
var state_21311__$1 = state_21311;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21311__$1,inst_21309);
} else {
if((state_val_21312 === (12))){
var state_21311__$1 = state_21311;
var statearr_21319_21345 = state_21311__$1;
(statearr_21319_21345[(2)] = null);

(statearr_21319_21345[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (2))){
var state_21311__$1 = state_21311;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21311__$1,(4),from);
} else {
if((state_val_21312 === (11))){
var inst_21300 = (state_21311[(2)]);
var state_21311__$1 = state_21311;
if(cljs.core.truth_(inst_21300)){
var statearr_21320_21346 = state_21311__$1;
(statearr_21320_21346[(1)] = (12));

} else {
var statearr_21321_21347 = state_21311__$1;
(statearr_21321_21347[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (9))){
var state_21311__$1 = state_21311;
var statearr_21322_21348 = state_21311__$1;
(statearr_21322_21348[(2)] = null);

(statearr_21322_21348[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (5))){
var state_21311__$1 = state_21311;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21323_21349 = state_21311__$1;
(statearr_21323_21349[(1)] = (8));

} else {
var statearr_21324_21350 = state_21311__$1;
(statearr_21324_21350[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (14))){
var inst_21305 = (state_21311[(2)]);
var state_21311__$1 = state_21311;
var statearr_21325_21351 = state_21311__$1;
(statearr_21325_21351[(2)] = inst_21305);

(statearr_21325_21351[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (10))){
var inst_21297 = (state_21311[(2)]);
var state_21311__$1 = state_21311;
var statearr_21326_21352 = state_21311__$1;
(statearr_21326_21352[(2)] = inst_21297);

(statearr_21326_21352[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21312 === (8))){
var inst_21294 = cljs.core.async.close_BANG_.call(null,to);
var state_21311__$1 = state_21311;
var statearr_21327_21353 = state_21311__$1;
(statearr_21327_21353[(2)] = inst_21294);

(statearr_21327_21353[(1)] = (10));


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
});})(c__21172__auto___21339))
;
return ((function (switch__21060__auto__,c__21172__auto___21339){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_21331 = [null,null,null,null,null,null,null,null];
(statearr_21331[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_21331[(1)] = (1));

return statearr_21331;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_21311){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21311);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21332){if((e21332 instanceof Object)){
var ex__21064__auto__ = e21332;
var statearr_21333_21354 = state_21311;
(statearr_21333_21354[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21311);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21332;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21355 = state_21311;
state_21311 = G__21355;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_21311){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_21311);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___21339))
})();
var state__21174__auto__ = (function (){var statearr_21334 = f__21173__auto__.call(null);
(statearr_21334[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___21339);

return statearr_21334;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___21339))
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
return (function (p__21539){
var vec__21540 = p__21539;
var v = cljs.core.nth.call(null,vec__21540,(0),null);
var p = cljs.core.nth.call(null,vec__21540,(1),null);
var job = vec__21540;
if((job == null)){
cljs.core.async.close_BANG_.call(null,results);

return null;
} else {
var res = cljs.core.async.chan.call(null,(1),xf,ex_handler);
var c__21172__auto___21722 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___21722,res,vec__21540,v,p,job,jobs,results){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___21722,res,vec__21540,v,p,job,jobs,results){
return (function (state_21545){
var state_val_21546 = (state_21545[(1)]);
if((state_val_21546 === (1))){
var state_21545__$1 = state_21545;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21545__$1,(2),res,v);
} else {
if((state_val_21546 === (2))){
var inst_21542 = (state_21545[(2)]);
var inst_21543 = cljs.core.async.close_BANG_.call(null,res);
var state_21545__$1 = (function (){var statearr_21547 = state_21545;
(statearr_21547[(7)] = inst_21542);

return statearr_21547;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21545__$1,inst_21543);
} else {
return null;
}
}
});})(c__21172__auto___21722,res,vec__21540,v,p,job,jobs,results))
;
return ((function (switch__21060__auto__,c__21172__auto___21722,res,vec__21540,v,p,job,jobs,results){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0 = (function (){
var statearr_21551 = [null,null,null,null,null,null,null,null];
(statearr_21551[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__);

(statearr_21551[(1)] = (1));

return statearr_21551;
});
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1 = (function (state_21545){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21545);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21552){if((e21552 instanceof Object)){
var ex__21064__auto__ = e21552;
var statearr_21553_21723 = state_21545;
(statearr_21553_21723[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21545);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21552;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21724 = state_21545;
state_21545 = G__21724;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = function(state_21545){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1.call(this,state_21545);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___21722,res,vec__21540,v,p,job,jobs,results))
})();
var state__21174__auto__ = (function (){var statearr_21554 = f__21173__auto__.call(null);
(statearr_21554[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___21722);

return statearr_21554;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___21722,res,vec__21540,v,p,job,jobs,results))
);


cljs.core.async.put_BANG_.call(null,p,res);

return true;
}
});})(jobs,results))
;
var async = ((function (jobs,results,process){
return (function (p__21555){
var vec__21556 = p__21555;
var v = cljs.core.nth.call(null,vec__21556,(0),null);
var p = cljs.core.nth.call(null,vec__21556,(1),null);
var job = vec__21556;
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
var n__19273__auto___21725 = n;
var __21726 = (0);
while(true){
if((__21726 < n__19273__auto___21725)){
var G__21557_21727 = (((type instanceof cljs.core.Keyword))?type.fqn:null);
switch (G__21557_21727) {
case "compute":
var c__21172__auto___21729 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (__21726,c__21172__auto___21729,G__21557_21727,n__19273__auto___21725,jobs,results,process,async){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (__21726,c__21172__auto___21729,G__21557_21727,n__19273__auto___21725,jobs,results,process,async){
return (function (state_21570){
var state_val_21571 = (state_21570[(1)]);
if((state_val_21571 === (1))){
var state_21570__$1 = state_21570;
var statearr_21572_21730 = state_21570__$1;
(statearr_21572_21730[(2)] = null);

(statearr_21572_21730[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21571 === (2))){
var state_21570__$1 = state_21570;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21570__$1,(4),jobs);
} else {
if((state_val_21571 === (3))){
var inst_21568 = (state_21570[(2)]);
var state_21570__$1 = state_21570;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21570__$1,inst_21568);
} else {
if((state_val_21571 === (4))){
var inst_21560 = (state_21570[(2)]);
var inst_21561 = process.call(null,inst_21560);
var state_21570__$1 = state_21570;
if(cljs.core.truth_(inst_21561)){
var statearr_21573_21731 = state_21570__$1;
(statearr_21573_21731[(1)] = (5));

} else {
var statearr_21574_21732 = state_21570__$1;
(statearr_21574_21732[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21571 === (5))){
var state_21570__$1 = state_21570;
var statearr_21575_21733 = state_21570__$1;
(statearr_21575_21733[(2)] = null);

(statearr_21575_21733[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21571 === (6))){
var state_21570__$1 = state_21570;
var statearr_21576_21734 = state_21570__$1;
(statearr_21576_21734[(2)] = null);

(statearr_21576_21734[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21571 === (7))){
var inst_21566 = (state_21570[(2)]);
var state_21570__$1 = state_21570;
var statearr_21577_21735 = state_21570__$1;
(statearr_21577_21735[(2)] = inst_21566);

(statearr_21577_21735[(1)] = (3));


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
});})(__21726,c__21172__auto___21729,G__21557_21727,n__19273__auto___21725,jobs,results,process,async))
;
return ((function (__21726,switch__21060__auto__,c__21172__auto___21729,G__21557_21727,n__19273__auto___21725,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0 = (function (){
var statearr_21581 = [null,null,null,null,null,null,null];
(statearr_21581[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__);

(statearr_21581[(1)] = (1));

return statearr_21581;
});
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1 = (function (state_21570){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21570);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21582){if((e21582 instanceof Object)){
var ex__21064__auto__ = e21582;
var statearr_21583_21736 = state_21570;
(statearr_21583_21736[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21570);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21582;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21737 = state_21570;
state_21570 = G__21737;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = function(state_21570){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1.call(this,state_21570);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__;
})()
;})(__21726,switch__21060__auto__,c__21172__auto___21729,G__21557_21727,n__19273__auto___21725,jobs,results,process,async))
})();
var state__21174__auto__ = (function (){var statearr_21584 = f__21173__auto__.call(null);
(statearr_21584[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___21729);

return statearr_21584;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(__21726,c__21172__auto___21729,G__21557_21727,n__19273__auto___21725,jobs,results,process,async))
);


break;
case "async":
var c__21172__auto___21738 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (__21726,c__21172__auto___21738,G__21557_21727,n__19273__auto___21725,jobs,results,process,async){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (__21726,c__21172__auto___21738,G__21557_21727,n__19273__auto___21725,jobs,results,process,async){
return (function (state_21597){
var state_val_21598 = (state_21597[(1)]);
if((state_val_21598 === (1))){
var state_21597__$1 = state_21597;
var statearr_21599_21739 = state_21597__$1;
(statearr_21599_21739[(2)] = null);

(statearr_21599_21739[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21598 === (2))){
var state_21597__$1 = state_21597;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21597__$1,(4),jobs);
} else {
if((state_val_21598 === (3))){
var inst_21595 = (state_21597[(2)]);
var state_21597__$1 = state_21597;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21597__$1,inst_21595);
} else {
if((state_val_21598 === (4))){
var inst_21587 = (state_21597[(2)]);
var inst_21588 = async.call(null,inst_21587);
var state_21597__$1 = state_21597;
if(cljs.core.truth_(inst_21588)){
var statearr_21600_21740 = state_21597__$1;
(statearr_21600_21740[(1)] = (5));

} else {
var statearr_21601_21741 = state_21597__$1;
(statearr_21601_21741[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21598 === (5))){
var state_21597__$1 = state_21597;
var statearr_21602_21742 = state_21597__$1;
(statearr_21602_21742[(2)] = null);

(statearr_21602_21742[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21598 === (6))){
var state_21597__$1 = state_21597;
var statearr_21603_21743 = state_21597__$1;
(statearr_21603_21743[(2)] = null);

(statearr_21603_21743[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21598 === (7))){
var inst_21593 = (state_21597[(2)]);
var state_21597__$1 = state_21597;
var statearr_21604_21744 = state_21597__$1;
(statearr_21604_21744[(2)] = inst_21593);

(statearr_21604_21744[(1)] = (3));


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
});})(__21726,c__21172__auto___21738,G__21557_21727,n__19273__auto___21725,jobs,results,process,async))
;
return ((function (__21726,switch__21060__auto__,c__21172__auto___21738,G__21557_21727,n__19273__auto___21725,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0 = (function (){
var statearr_21608 = [null,null,null,null,null,null,null];
(statearr_21608[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__);

(statearr_21608[(1)] = (1));

return statearr_21608;
});
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1 = (function (state_21597){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21597);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21609){if((e21609 instanceof Object)){
var ex__21064__auto__ = e21609;
var statearr_21610_21745 = state_21597;
(statearr_21610_21745[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21597);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21609;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21746 = state_21597;
state_21597 = G__21746;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = function(state_21597){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1.call(this,state_21597);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__;
})()
;})(__21726,switch__21060__auto__,c__21172__auto___21738,G__21557_21727,n__19273__auto___21725,jobs,results,process,async))
})();
var state__21174__auto__ = (function (){var statearr_21611 = f__21173__auto__.call(null);
(statearr_21611[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___21738);

return statearr_21611;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(__21726,c__21172__auto___21738,G__21557_21727,n__19273__auto___21725,jobs,results,process,async))
);


break;
default:
throw (new Error([cljs.core.str("No matching clause: "),cljs.core.str(type)].join('')));

}

var G__21747 = (__21726 + (1));
__21726 = G__21747;
continue;
} else {
}
break;
}

var c__21172__auto___21748 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___21748,jobs,results,process,async){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___21748,jobs,results,process,async){
return (function (state_21633){
var state_val_21634 = (state_21633[(1)]);
if((state_val_21634 === (1))){
var state_21633__$1 = state_21633;
var statearr_21635_21749 = state_21633__$1;
(statearr_21635_21749[(2)] = null);

(statearr_21635_21749[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21634 === (2))){
var state_21633__$1 = state_21633;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21633__$1,(4),from);
} else {
if((state_val_21634 === (3))){
var inst_21631 = (state_21633[(2)]);
var state_21633__$1 = state_21633;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21633__$1,inst_21631);
} else {
if((state_val_21634 === (4))){
var inst_21614 = (state_21633[(7)]);
var inst_21614__$1 = (state_21633[(2)]);
var inst_21615 = (inst_21614__$1 == null);
var state_21633__$1 = (function (){var statearr_21636 = state_21633;
(statearr_21636[(7)] = inst_21614__$1);

return statearr_21636;
})();
if(cljs.core.truth_(inst_21615)){
var statearr_21637_21750 = state_21633__$1;
(statearr_21637_21750[(1)] = (5));

} else {
var statearr_21638_21751 = state_21633__$1;
(statearr_21638_21751[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21634 === (5))){
var inst_21617 = cljs.core.async.close_BANG_.call(null,jobs);
var state_21633__$1 = state_21633;
var statearr_21639_21752 = state_21633__$1;
(statearr_21639_21752[(2)] = inst_21617);

(statearr_21639_21752[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21634 === (6))){
var inst_21619 = (state_21633[(8)]);
var inst_21614 = (state_21633[(7)]);
var inst_21619__$1 = cljs.core.async.chan.call(null,(1));
var inst_21620 = cljs.core.PersistentVector.EMPTY_NODE;
var inst_21621 = [inst_21614,inst_21619__$1];
var inst_21622 = (new cljs.core.PersistentVector(null,2,(5),inst_21620,inst_21621,null));
var state_21633__$1 = (function (){var statearr_21640 = state_21633;
(statearr_21640[(8)] = inst_21619__$1);

return statearr_21640;
})();
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21633__$1,(8),jobs,inst_21622);
} else {
if((state_val_21634 === (7))){
var inst_21629 = (state_21633[(2)]);
var state_21633__$1 = state_21633;
var statearr_21641_21753 = state_21633__$1;
(statearr_21641_21753[(2)] = inst_21629);

(statearr_21641_21753[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21634 === (8))){
var inst_21619 = (state_21633[(8)]);
var inst_21624 = (state_21633[(2)]);
var state_21633__$1 = (function (){var statearr_21642 = state_21633;
(statearr_21642[(9)] = inst_21624);

return statearr_21642;
})();
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21633__$1,(9),results,inst_21619);
} else {
if((state_val_21634 === (9))){
var inst_21626 = (state_21633[(2)]);
var state_21633__$1 = (function (){var statearr_21643 = state_21633;
(statearr_21643[(10)] = inst_21626);

return statearr_21643;
})();
var statearr_21644_21754 = state_21633__$1;
(statearr_21644_21754[(2)] = null);

(statearr_21644_21754[(1)] = (2));


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
});})(c__21172__auto___21748,jobs,results,process,async))
;
return ((function (switch__21060__auto__,c__21172__auto___21748,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0 = (function (){
var statearr_21648 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_21648[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__);

(statearr_21648[(1)] = (1));

return statearr_21648;
});
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1 = (function (state_21633){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21633);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21649){if((e21649 instanceof Object)){
var ex__21064__auto__ = e21649;
var statearr_21650_21755 = state_21633;
(statearr_21650_21755[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21633);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21649;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21756 = state_21633;
state_21633 = G__21756;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = function(state_21633){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1.call(this,state_21633);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___21748,jobs,results,process,async))
})();
var state__21174__auto__ = (function (){var statearr_21651 = f__21173__auto__.call(null);
(statearr_21651[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___21748);

return statearr_21651;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___21748,jobs,results,process,async))
);


var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__,jobs,results,process,async){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__,jobs,results,process,async){
return (function (state_21689){
var state_val_21690 = (state_21689[(1)]);
if((state_val_21690 === (7))){
var inst_21685 = (state_21689[(2)]);
var state_21689__$1 = state_21689;
var statearr_21691_21757 = state_21689__$1;
(statearr_21691_21757[(2)] = inst_21685);

(statearr_21691_21757[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (20))){
var state_21689__$1 = state_21689;
var statearr_21692_21758 = state_21689__$1;
(statearr_21692_21758[(2)] = null);

(statearr_21692_21758[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (1))){
var state_21689__$1 = state_21689;
var statearr_21693_21759 = state_21689__$1;
(statearr_21693_21759[(2)] = null);

(statearr_21693_21759[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (4))){
var inst_21654 = (state_21689[(7)]);
var inst_21654__$1 = (state_21689[(2)]);
var inst_21655 = (inst_21654__$1 == null);
var state_21689__$1 = (function (){var statearr_21694 = state_21689;
(statearr_21694[(7)] = inst_21654__$1);

return statearr_21694;
})();
if(cljs.core.truth_(inst_21655)){
var statearr_21695_21760 = state_21689__$1;
(statearr_21695_21760[(1)] = (5));

} else {
var statearr_21696_21761 = state_21689__$1;
(statearr_21696_21761[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (15))){
var inst_21667 = (state_21689[(8)]);
var state_21689__$1 = state_21689;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21689__$1,(18),to,inst_21667);
} else {
if((state_val_21690 === (21))){
var inst_21680 = (state_21689[(2)]);
var state_21689__$1 = state_21689;
var statearr_21697_21762 = state_21689__$1;
(statearr_21697_21762[(2)] = inst_21680);

(statearr_21697_21762[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (13))){
var inst_21682 = (state_21689[(2)]);
var state_21689__$1 = (function (){var statearr_21698 = state_21689;
(statearr_21698[(9)] = inst_21682);

return statearr_21698;
})();
var statearr_21699_21763 = state_21689__$1;
(statearr_21699_21763[(2)] = null);

(statearr_21699_21763[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (6))){
var inst_21654 = (state_21689[(7)]);
var state_21689__$1 = state_21689;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21689__$1,(11),inst_21654);
} else {
if((state_val_21690 === (17))){
var inst_21675 = (state_21689[(2)]);
var state_21689__$1 = state_21689;
if(cljs.core.truth_(inst_21675)){
var statearr_21700_21764 = state_21689__$1;
(statearr_21700_21764[(1)] = (19));

} else {
var statearr_21701_21765 = state_21689__$1;
(statearr_21701_21765[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (3))){
var inst_21687 = (state_21689[(2)]);
var state_21689__$1 = state_21689;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21689__$1,inst_21687);
} else {
if((state_val_21690 === (12))){
var inst_21664 = (state_21689[(10)]);
var state_21689__$1 = state_21689;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21689__$1,(14),inst_21664);
} else {
if((state_val_21690 === (2))){
var state_21689__$1 = state_21689;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21689__$1,(4),results);
} else {
if((state_val_21690 === (19))){
var state_21689__$1 = state_21689;
var statearr_21702_21766 = state_21689__$1;
(statearr_21702_21766[(2)] = null);

(statearr_21702_21766[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (11))){
var inst_21664 = (state_21689[(2)]);
var state_21689__$1 = (function (){var statearr_21703 = state_21689;
(statearr_21703[(10)] = inst_21664);

return statearr_21703;
})();
var statearr_21704_21767 = state_21689__$1;
(statearr_21704_21767[(2)] = null);

(statearr_21704_21767[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (9))){
var state_21689__$1 = state_21689;
var statearr_21705_21768 = state_21689__$1;
(statearr_21705_21768[(2)] = null);

(statearr_21705_21768[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (5))){
var state_21689__$1 = state_21689;
if(cljs.core.truth_(close_QMARK_)){
var statearr_21706_21769 = state_21689__$1;
(statearr_21706_21769[(1)] = (8));

} else {
var statearr_21707_21770 = state_21689__$1;
(statearr_21707_21770[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (14))){
var inst_21669 = (state_21689[(11)]);
var inst_21667 = (state_21689[(8)]);
var inst_21667__$1 = (state_21689[(2)]);
var inst_21668 = (inst_21667__$1 == null);
var inst_21669__$1 = cljs.core.not.call(null,inst_21668);
var state_21689__$1 = (function (){var statearr_21708 = state_21689;
(statearr_21708[(11)] = inst_21669__$1);

(statearr_21708[(8)] = inst_21667__$1);

return statearr_21708;
})();
if(inst_21669__$1){
var statearr_21709_21771 = state_21689__$1;
(statearr_21709_21771[(1)] = (15));

} else {
var statearr_21710_21772 = state_21689__$1;
(statearr_21710_21772[(1)] = (16));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (16))){
var inst_21669 = (state_21689[(11)]);
var state_21689__$1 = state_21689;
var statearr_21711_21773 = state_21689__$1;
(statearr_21711_21773[(2)] = inst_21669);

(statearr_21711_21773[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (10))){
var inst_21661 = (state_21689[(2)]);
var state_21689__$1 = state_21689;
var statearr_21712_21774 = state_21689__$1;
(statearr_21712_21774[(2)] = inst_21661);

(statearr_21712_21774[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (18))){
var inst_21672 = (state_21689[(2)]);
var state_21689__$1 = state_21689;
var statearr_21713_21775 = state_21689__$1;
(statearr_21713_21775[(2)] = inst_21672);

(statearr_21713_21775[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21690 === (8))){
var inst_21658 = cljs.core.async.close_BANG_.call(null,to);
var state_21689__$1 = state_21689;
var statearr_21714_21776 = state_21689__$1;
(statearr_21714_21776[(2)] = inst_21658);

(statearr_21714_21776[(1)] = (10));


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
});})(c__21172__auto__,jobs,results,process,async))
;
return ((function (switch__21060__auto__,c__21172__auto__,jobs,results,process,async){
return (function() {
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = null;
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0 = (function (){
var statearr_21718 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_21718[(0)] = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__);

(statearr_21718[(1)] = (1));

return statearr_21718;
});
var cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1 = (function (state_21689){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21689);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21719){if((e21719 instanceof Object)){
var ex__21064__auto__ = e21719;
var statearr_21720_21777 = state_21689;
(statearr_21720_21777[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21689);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21719;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21778 = state_21689;
state_21689 = G__21778;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__ = function(state_21689){
switch(arguments.length){
case 0:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1.call(this,state_21689);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____0;
cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$pipeline_STAR__$_state_machine__21061__auto____1;
return cljs$core$async$pipeline_STAR__$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__,jobs,results,process,async))
})();
var state__21174__auto__ = (function (){var statearr_21721 = f__21173__auto__.call(null);
(statearr_21721[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_21721;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__,jobs,results,process,async))
);

return c__21172__auto__;
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
var args21779 = [];
var len__19428__auto___21782 = arguments.length;
var i__19429__auto___21783 = (0);
while(true){
if((i__19429__auto___21783 < len__19428__auto___21782)){
args21779.push((arguments[i__19429__auto___21783]));

var G__21784 = (i__19429__auto___21783 + (1));
i__19429__auto___21783 = G__21784;
continue;
} else {
}
break;
}

var G__21781 = args21779.length;
switch (G__21781) {
case 4:
return cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
case 5:
return cljs.core.async.pipeline_async.cljs$core$IFn$_invoke$arity$5((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]),(arguments[(4)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21779.length)].join('')));

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
var args21786 = [];
var len__19428__auto___21789 = arguments.length;
var i__19429__auto___21790 = (0);
while(true){
if((i__19429__auto___21790 < len__19428__auto___21789)){
args21786.push((arguments[i__19429__auto___21790]));

var G__21791 = (i__19429__auto___21790 + (1));
i__19429__auto___21790 = G__21791;
continue;
} else {
}
break;
}

var G__21788 = args21786.length;
switch (G__21788) {
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
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21786.length)].join('')));

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
var args21793 = [];
var len__19428__auto___21846 = arguments.length;
var i__19429__auto___21847 = (0);
while(true){
if((i__19429__auto___21847 < len__19428__auto___21846)){
args21793.push((arguments[i__19429__auto___21847]));

var G__21848 = (i__19429__auto___21847 + (1));
i__19429__auto___21847 = G__21848;
continue;
} else {
}
break;
}

var G__21795 = args21793.length;
switch (G__21795) {
case 2:
return cljs.core.async.split.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 4:
return cljs.core.async.split.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21793.length)].join('')));

}
});

cljs.core.async.split.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.split.call(null,p,ch,null,null);
});

cljs.core.async.split.cljs$core$IFn$_invoke$arity$4 = (function (p,ch,t_buf_or_n,f_buf_or_n){
var tc = cljs.core.async.chan.call(null,t_buf_or_n);
var fc = cljs.core.async.chan.call(null,f_buf_or_n);
var c__21172__auto___21850 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___21850,tc,fc){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___21850,tc,fc){
return (function (state_21821){
var state_val_21822 = (state_21821[(1)]);
if((state_val_21822 === (7))){
var inst_21817 = (state_21821[(2)]);
var state_21821__$1 = state_21821;
var statearr_21823_21851 = state_21821__$1;
(statearr_21823_21851[(2)] = inst_21817);

(statearr_21823_21851[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (1))){
var state_21821__$1 = state_21821;
var statearr_21824_21852 = state_21821__$1;
(statearr_21824_21852[(2)] = null);

(statearr_21824_21852[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (4))){
var inst_21798 = (state_21821[(7)]);
var inst_21798__$1 = (state_21821[(2)]);
var inst_21799 = (inst_21798__$1 == null);
var state_21821__$1 = (function (){var statearr_21825 = state_21821;
(statearr_21825[(7)] = inst_21798__$1);

return statearr_21825;
})();
if(cljs.core.truth_(inst_21799)){
var statearr_21826_21853 = state_21821__$1;
(statearr_21826_21853[(1)] = (5));

} else {
var statearr_21827_21854 = state_21821__$1;
(statearr_21827_21854[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (13))){
var state_21821__$1 = state_21821;
var statearr_21828_21855 = state_21821__$1;
(statearr_21828_21855[(2)] = null);

(statearr_21828_21855[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (6))){
var inst_21798 = (state_21821[(7)]);
var inst_21804 = p.call(null,inst_21798);
var state_21821__$1 = state_21821;
if(cljs.core.truth_(inst_21804)){
var statearr_21829_21856 = state_21821__$1;
(statearr_21829_21856[(1)] = (9));

} else {
var statearr_21830_21857 = state_21821__$1;
(statearr_21830_21857[(1)] = (10));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (3))){
var inst_21819 = (state_21821[(2)]);
var state_21821__$1 = state_21821;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21821__$1,inst_21819);
} else {
if((state_val_21822 === (12))){
var state_21821__$1 = state_21821;
var statearr_21831_21858 = state_21821__$1;
(statearr_21831_21858[(2)] = null);

(statearr_21831_21858[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (2))){
var state_21821__$1 = state_21821;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21821__$1,(4),ch);
} else {
if((state_val_21822 === (11))){
var inst_21798 = (state_21821[(7)]);
var inst_21808 = (state_21821[(2)]);
var state_21821__$1 = state_21821;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21821__$1,(8),inst_21808,inst_21798);
} else {
if((state_val_21822 === (9))){
var state_21821__$1 = state_21821;
var statearr_21832_21859 = state_21821__$1;
(statearr_21832_21859[(2)] = tc);

(statearr_21832_21859[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (5))){
var inst_21801 = cljs.core.async.close_BANG_.call(null,tc);
var inst_21802 = cljs.core.async.close_BANG_.call(null,fc);
var state_21821__$1 = (function (){var statearr_21833 = state_21821;
(statearr_21833[(8)] = inst_21801);

return statearr_21833;
})();
var statearr_21834_21860 = state_21821__$1;
(statearr_21834_21860[(2)] = inst_21802);

(statearr_21834_21860[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (14))){
var inst_21815 = (state_21821[(2)]);
var state_21821__$1 = state_21821;
var statearr_21835_21861 = state_21821__$1;
(statearr_21835_21861[(2)] = inst_21815);

(statearr_21835_21861[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (10))){
var state_21821__$1 = state_21821;
var statearr_21836_21862 = state_21821__$1;
(statearr_21836_21862[(2)] = fc);

(statearr_21836_21862[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21822 === (8))){
var inst_21810 = (state_21821[(2)]);
var state_21821__$1 = state_21821;
if(cljs.core.truth_(inst_21810)){
var statearr_21837_21863 = state_21821__$1;
(statearr_21837_21863[(1)] = (12));

} else {
var statearr_21838_21864 = state_21821__$1;
(statearr_21838_21864[(1)] = (13));

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
});})(c__21172__auto___21850,tc,fc))
;
return ((function (switch__21060__auto__,c__21172__auto___21850,tc,fc){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_21842 = [null,null,null,null,null,null,null,null,null];
(statearr_21842[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_21842[(1)] = (1));

return statearr_21842;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_21821){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21821);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21843){if((e21843 instanceof Object)){
var ex__21064__auto__ = e21843;
var statearr_21844_21865 = state_21821;
(statearr_21844_21865[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21821);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21843;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21866 = state_21821;
state_21821 = G__21866;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_21821){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_21821);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___21850,tc,fc))
})();
var state__21174__auto__ = (function (){var statearr_21845 = f__21173__auto__.call(null);
(statearr_21845[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___21850);

return statearr_21845;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___21850,tc,fc))
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
var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__){
return (function (state_21930){
var state_val_21931 = (state_21930[(1)]);
if((state_val_21931 === (7))){
var inst_21926 = (state_21930[(2)]);
var state_21930__$1 = state_21930;
var statearr_21932_21953 = state_21930__$1;
(statearr_21932_21953[(2)] = inst_21926);

(statearr_21932_21953[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (1))){
var inst_21910 = init;
var state_21930__$1 = (function (){var statearr_21933 = state_21930;
(statearr_21933[(7)] = inst_21910);

return statearr_21933;
})();
var statearr_21934_21954 = state_21930__$1;
(statearr_21934_21954[(2)] = null);

(statearr_21934_21954[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (4))){
var inst_21913 = (state_21930[(8)]);
var inst_21913__$1 = (state_21930[(2)]);
var inst_21914 = (inst_21913__$1 == null);
var state_21930__$1 = (function (){var statearr_21935 = state_21930;
(statearr_21935[(8)] = inst_21913__$1);

return statearr_21935;
})();
if(cljs.core.truth_(inst_21914)){
var statearr_21936_21955 = state_21930__$1;
(statearr_21936_21955[(1)] = (5));

} else {
var statearr_21937_21956 = state_21930__$1;
(statearr_21937_21956[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (6))){
var inst_21910 = (state_21930[(7)]);
var inst_21913 = (state_21930[(8)]);
var inst_21917 = (state_21930[(9)]);
var inst_21917__$1 = f.call(null,inst_21910,inst_21913);
var inst_21918 = cljs.core.reduced_QMARK_.call(null,inst_21917__$1);
var state_21930__$1 = (function (){var statearr_21938 = state_21930;
(statearr_21938[(9)] = inst_21917__$1);

return statearr_21938;
})();
if(inst_21918){
var statearr_21939_21957 = state_21930__$1;
(statearr_21939_21957[(1)] = (8));

} else {
var statearr_21940_21958 = state_21930__$1;
(statearr_21940_21958[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (3))){
var inst_21928 = (state_21930[(2)]);
var state_21930__$1 = state_21930;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21930__$1,inst_21928);
} else {
if((state_val_21931 === (2))){
var state_21930__$1 = state_21930;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_21930__$1,(4),ch);
} else {
if((state_val_21931 === (9))){
var inst_21917 = (state_21930[(9)]);
var inst_21910 = inst_21917;
var state_21930__$1 = (function (){var statearr_21941 = state_21930;
(statearr_21941[(7)] = inst_21910);

return statearr_21941;
})();
var statearr_21942_21959 = state_21930__$1;
(statearr_21942_21959[(2)] = null);

(statearr_21942_21959[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (5))){
var inst_21910 = (state_21930[(7)]);
var state_21930__$1 = state_21930;
var statearr_21943_21960 = state_21930__$1;
(statearr_21943_21960[(2)] = inst_21910);

(statearr_21943_21960[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (10))){
var inst_21924 = (state_21930[(2)]);
var state_21930__$1 = state_21930;
var statearr_21944_21961 = state_21930__$1;
(statearr_21944_21961[(2)] = inst_21924);

(statearr_21944_21961[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21931 === (8))){
var inst_21917 = (state_21930[(9)]);
var inst_21920 = cljs.core.deref.call(null,inst_21917);
var state_21930__$1 = state_21930;
var statearr_21945_21962 = state_21930__$1;
(statearr_21945_21962[(2)] = inst_21920);

(statearr_21945_21962[(1)] = (10));


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
});})(c__21172__auto__))
;
return ((function (switch__21060__auto__,c__21172__auto__){
return (function() {
var cljs$core$async$reduce_$_state_machine__21061__auto__ = null;
var cljs$core$async$reduce_$_state_machine__21061__auto____0 = (function (){
var statearr_21949 = [null,null,null,null,null,null,null,null,null,null];
(statearr_21949[(0)] = cljs$core$async$reduce_$_state_machine__21061__auto__);

(statearr_21949[(1)] = (1));

return statearr_21949;
});
var cljs$core$async$reduce_$_state_machine__21061__auto____1 = (function (state_21930){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21930);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e21950){if((e21950 instanceof Object)){
var ex__21064__auto__ = e21950;
var statearr_21951_21963 = state_21930;
(statearr_21951_21963[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21930);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e21950;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__21964 = state_21930;
state_21930 = G__21964;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$reduce_$_state_machine__21061__auto__ = function(state_21930){
switch(arguments.length){
case 0:
return cljs$core$async$reduce_$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$reduce_$_state_machine__21061__auto____1.call(this,state_21930);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$reduce_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$reduce_$_state_machine__21061__auto____0;
cljs$core$async$reduce_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$reduce_$_state_machine__21061__auto____1;
return cljs$core$async$reduce_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__))
})();
var state__21174__auto__ = (function (){var statearr_21952 = f__21173__auto__.call(null);
(statearr_21952[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_21952;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__))
);

return c__21172__auto__;
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
var args21965 = [];
var len__19428__auto___22017 = arguments.length;
var i__19429__auto___22018 = (0);
while(true){
if((i__19429__auto___22018 < len__19428__auto___22017)){
args21965.push((arguments[i__19429__auto___22018]));

var G__22019 = (i__19429__auto___22018 + (1));
i__19429__auto___22018 = G__22019;
continue;
} else {
}
break;
}

var G__21967 = args21965.length;
switch (G__21967) {
case 2:
return cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args21965.length)].join('')));

}
});

cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$2 = (function (ch,coll){
return cljs.core.async.onto_chan.call(null,ch,coll,true);
});

cljs.core.async.onto_chan.cljs$core$IFn$_invoke$arity$3 = (function (ch,coll,close_QMARK_){
var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__){
return (function (state_21992){
var state_val_21993 = (state_21992[(1)]);
if((state_val_21993 === (7))){
var inst_21974 = (state_21992[(2)]);
var state_21992__$1 = state_21992;
var statearr_21994_22021 = state_21992__$1;
(statearr_21994_22021[(2)] = inst_21974);

(statearr_21994_22021[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (1))){
var inst_21968 = cljs.core.seq.call(null,coll);
var inst_21969 = inst_21968;
var state_21992__$1 = (function (){var statearr_21995 = state_21992;
(statearr_21995[(7)] = inst_21969);

return statearr_21995;
})();
var statearr_21996_22022 = state_21992__$1;
(statearr_21996_22022[(2)] = null);

(statearr_21996_22022[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (4))){
var inst_21969 = (state_21992[(7)]);
var inst_21972 = cljs.core.first.call(null,inst_21969);
var state_21992__$1 = state_21992;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_21992__$1,(7),ch,inst_21972);
} else {
if((state_val_21993 === (13))){
var inst_21986 = (state_21992[(2)]);
var state_21992__$1 = state_21992;
var statearr_21997_22023 = state_21992__$1;
(statearr_21997_22023[(2)] = inst_21986);

(statearr_21997_22023[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (6))){
var inst_21977 = (state_21992[(2)]);
var state_21992__$1 = state_21992;
if(cljs.core.truth_(inst_21977)){
var statearr_21998_22024 = state_21992__$1;
(statearr_21998_22024[(1)] = (8));

} else {
var statearr_21999_22025 = state_21992__$1;
(statearr_21999_22025[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (3))){
var inst_21990 = (state_21992[(2)]);
var state_21992__$1 = state_21992;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_21992__$1,inst_21990);
} else {
if((state_val_21993 === (12))){
var state_21992__$1 = state_21992;
var statearr_22000_22026 = state_21992__$1;
(statearr_22000_22026[(2)] = null);

(statearr_22000_22026[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (2))){
var inst_21969 = (state_21992[(7)]);
var state_21992__$1 = state_21992;
if(cljs.core.truth_(inst_21969)){
var statearr_22001_22027 = state_21992__$1;
(statearr_22001_22027[(1)] = (4));

} else {
var statearr_22002_22028 = state_21992__$1;
(statearr_22002_22028[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (11))){
var inst_21983 = cljs.core.async.close_BANG_.call(null,ch);
var state_21992__$1 = state_21992;
var statearr_22003_22029 = state_21992__$1;
(statearr_22003_22029[(2)] = inst_21983);

(statearr_22003_22029[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (9))){
var state_21992__$1 = state_21992;
if(cljs.core.truth_(close_QMARK_)){
var statearr_22004_22030 = state_21992__$1;
(statearr_22004_22030[(1)] = (11));

} else {
var statearr_22005_22031 = state_21992__$1;
(statearr_22005_22031[(1)] = (12));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (5))){
var inst_21969 = (state_21992[(7)]);
var state_21992__$1 = state_21992;
var statearr_22006_22032 = state_21992__$1;
(statearr_22006_22032[(2)] = inst_21969);

(statearr_22006_22032[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (10))){
var inst_21988 = (state_21992[(2)]);
var state_21992__$1 = state_21992;
var statearr_22007_22033 = state_21992__$1;
(statearr_22007_22033[(2)] = inst_21988);

(statearr_22007_22033[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_21993 === (8))){
var inst_21969 = (state_21992[(7)]);
var inst_21979 = cljs.core.next.call(null,inst_21969);
var inst_21969__$1 = inst_21979;
var state_21992__$1 = (function (){var statearr_22008 = state_21992;
(statearr_22008[(7)] = inst_21969__$1);

return statearr_22008;
})();
var statearr_22009_22034 = state_21992__$1;
(statearr_22009_22034[(2)] = null);

(statearr_22009_22034[(1)] = (2));


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
});})(c__21172__auto__))
;
return ((function (switch__21060__auto__,c__21172__auto__){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_22013 = [null,null,null,null,null,null,null,null];
(statearr_22013[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_22013[(1)] = (1));

return statearr_22013;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_21992){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_21992);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e22014){if((e22014 instanceof Object)){
var ex__21064__auto__ = e22014;
var statearr_22015_22035 = state_21992;
(statearr_22015_22035[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_21992);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22014;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22036 = state_21992;
state_21992 = G__22036;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_21992){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_21992);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__))
})();
var state__21174__auto__ = (function (){var statearr_22016 = f__21173__auto__.call(null);
(statearr_22016[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_22016;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__))
);

return c__21172__auto__;
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
if(typeof cljs.core.async.t_cljs$core$async22258 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.Mult}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22258 = (function (mult,ch,cs,meta22259){
this.mult = mult;
this.ch = ch;
this.cs = cs;
this.meta22259 = meta22259;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (cs){
return (function (_22260,meta22259__$1){
var self__ = this;
var _22260__$1 = this;
return (new cljs.core.async.t_cljs$core$async22258(self__.mult,self__.ch,self__.cs,meta22259__$1));
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (cs){
return (function (_22260){
var self__ = this;
var _22260__$1 = this;
return self__.meta22259;
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (cs){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.ch;
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$async$Mult$ = true;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$async$Mult$tap_STAR_$arity$3 = ((function (cs){
return (function (_,ch__$1,close_QMARK_){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.assoc,ch__$1,close_QMARK_);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$async$Mult$untap_STAR_$arity$2 = ((function (cs){
return (function (_,ch__$1){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.dissoc,ch__$1);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.prototype.cljs$core$async$Mult$untap_all_STAR_$arity$1 = ((function (cs){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.cs,cljs.core.PersistentArrayMap.EMPTY);

return null;
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.getBasis = ((function (cs){
return (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"mult","mult",-1187640995,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Creates and returns a mult(iple) of the supplied channel. Channels\n  containing copies of the channel can be created with 'tap', and\n  detached with 'untap'.\n\n  Each item is distributed to all taps in parallel and synchronously,\n  i.e. each tap must accept before the next item is distributed. Use\n  buffering/windowing to prevent slow taps from holding up the mult.\n\n  Items received when there are no taps get dropped.\n\n  If a tap puts to a closed channel, it will be removed from the mult."], null)),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"cs","cs",-117024463,null),new cljs.core.Symbol(null,"meta22259","meta22259",880094220,null)], null);
});})(cs))
;

cljs.core.async.t_cljs$core$async22258.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22258.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22258";

cljs.core.async.t_cljs$core$async22258.cljs$lang$ctorPrWriter = ((function (cs){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22258");
});})(cs))
;

cljs.core.async.__GT_t_cljs$core$async22258 = ((function (cs){
return (function cljs$core$async$mult_$___GT_t_cljs$core$async22258(mult__$1,ch__$1,cs__$1,meta22259){
return (new cljs.core.async.t_cljs$core$async22258(mult__$1,ch__$1,cs__$1,meta22259));
});})(cs))
;

}

return (new cljs.core.async.t_cljs$core$async22258(cljs$core$async$mult,ch,cs,cljs.core.PersistentArrayMap.EMPTY));
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
var c__21172__auto___22479 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___22479,cs,m,dchan,dctr,done){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___22479,cs,m,dchan,dctr,done){
return (function (state_22391){
var state_val_22392 = (state_22391[(1)]);
if((state_val_22392 === (7))){
var inst_22387 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22393_22480 = state_22391__$1;
(statearr_22393_22480[(2)] = inst_22387);

(statearr_22393_22480[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (20))){
var inst_22292 = (state_22391[(7)]);
var inst_22302 = cljs.core.first.call(null,inst_22292);
var inst_22303 = cljs.core.nth.call(null,inst_22302,(0),null);
var inst_22304 = cljs.core.nth.call(null,inst_22302,(1),null);
var state_22391__$1 = (function (){var statearr_22394 = state_22391;
(statearr_22394[(8)] = inst_22303);

return statearr_22394;
})();
if(cljs.core.truth_(inst_22304)){
var statearr_22395_22481 = state_22391__$1;
(statearr_22395_22481[(1)] = (22));

} else {
var statearr_22396_22482 = state_22391__$1;
(statearr_22396_22482[(1)] = (23));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (27))){
var inst_22339 = (state_22391[(9)]);
var inst_22334 = (state_22391[(10)]);
var inst_22263 = (state_22391[(11)]);
var inst_22332 = (state_22391[(12)]);
var inst_22339__$1 = cljs.core._nth.call(null,inst_22332,inst_22334);
var inst_22340 = cljs.core.async.put_BANG_.call(null,inst_22339__$1,inst_22263,done);
var state_22391__$1 = (function (){var statearr_22397 = state_22391;
(statearr_22397[(9)] = inst_22339__$1);

return statearr_22397;
})();
if(cljs.core.truth_(inst_22340)){
var statearr_22398_22483 = state_22391__$1;
(statearr_22398_22483[(1)] = (30));

} else {
var statearr_22399_22484 = state_22391__$1;
(statearr_22399_22484[(1)] = (31));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (1))){
var state_22391__$1 = state_22391;
var statearr_22400_22485 = state_22391__$1;
(statearr_22400_22485[(2)] = null);

(statearr_22400_22485[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (24))){
var inst_22292 = (state_22391[(7)]);
var inst_22309 = (state_22391[(2)]);
var inst_22310 = cljs.core.next.call(null,inst_22292);
var inst_22272 = inst_22310;
var inst_22273 = null;
var inst_22274 = (0);
var inst_22275 = (0);
var state_22391__$1 = (function (){var statearr_22401 = state_22391;
(statearr_22401[(13)] = inst_22309);

(statearr_22401[(14)] = inst_22274);

(statearr_22401[(15)] = inst_22275);

(statearr_22401[(16)] = inst_22273);

(statearr_22401[(17)] = inst_22272);

return statearr_22401;
})();
var statearr_22402_22486 = state_22391__$1;
(statearr_22402_22486[(2)] = null);

(statearr_22402_22486[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (39))){
var state_22391__$1 = state_22391;
var statearr_22406_22487 = state_22391__$1;
(statearr_22406_22487[(2)] = null);

(statearr_22406_22487[(1)] = (41));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (4))){
var inst_22263 = (state_22391[(11)]);
var inst_22263__$1 = (state_22391[(2)]);
var inst_22264 = (inst_22263__$1 == null);
var state_22391__$1 = (function (){var statearr_22407 = state_22391;
(statearr_22407[(11)] = inst_22263__$1);

return statearr_22407;
})();
if(cljs.core.truth_(inst_22264)){
var statearr_22408_22488 = state_22391__$1;
(statearr_22408_22488[(1)] = (5));

} else {
var statearr_22409_22489 = state_22391__$1;
(statearr_22409_22489[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (15))){
var inst_22274 = (state_22391[(14)]);
var inst_22275 = (state_22391[(15)]);
var inst_22273 = (state_22391[(16)]);
var inst_22272 = (state_22391[(17)]);
var inst_22288 = (state_22391[(2)]);
var inst_22289 = (inst_22275 + (1));
var tmp22403 = inst_22274;
var tmp22404 = inst_22273;
var tmp22405 = inst_22272;
var inst_22272__$1 = tmp22405;
var inst_22273__$1 = tmp22404;
var inst_22274__$1 = tmp22403;
var inst_22275__$1 = inst_22289;
var state_22391__$1 = (function (){var statearr_22410 = state_22391;
(statearr_22410[(14)] = inst_22274__$1);

(statearr_22410[(15)] = inst_22275__$1);

(statearr_22410[(18)] = inst_22288);

(statearr_22410[(16)] = inst_22273__$1);

(statearr_22410[(17)] = inst_22272__$1);

return statearr_22410;
})();
var statearr_22411_22490 = state_22391__$1;
(statearr_22411_22490[(2)] = null);

(statearr_22411_22490[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (21))){
var inst_22313 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22415_22491 = state_22391__$1;
(statearr_22415_22491[(2)] = inst_22313);

(statearr_22415_22491[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (31))){
var inst_22339 = (state_22391[(9)]);
var inst_22343 = done.call(null,null);
var inst_22344 = cljs.core.async.untap_STAR_.call(null,m,inst_22339);
var state_22391__$1 = (function (){var statearr_22416 = state_22391;
(statearr_22416[(19)] = inst_22343);

return statearr_22416;
})();
var statearr_22417_22492 = state_22391__$1;
(statearr_22417_22492[(2)] = inst_22344);

(statearr_22417_22492[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (32))){
var inst_22334 = (state_22391[(10)]);
var inst_22331 = (state_22391[(20)]);
var inst_22333 = (state_22391[(21)]);
var inst_22332 = (state_22391[(12)]);
var inst_22346 = (state_22391[(2)]);
var inst_22347 = (inst_22334 + (1));
var tmp22412 = inst_22331;
var tmp22413 = inst_22333;
var tmp22414 = inst_22332;
var inst_22331__$1 = tmp22412;
var inst_22332__$1 = tmp22414;
var inst_22333__$1 = tmp22413;
var inst_22334__$1 = inst_22347;
var state_22391__$1 = (function (){var statearr_22418 = state_22391;
(statearr_22418[(10)] = inst_22334__$1);

(statearr_22418[(20)] = inst_22331__$1);

(statearr_22418[(21)] = inst_22333__$1);

(statearr_22418[(22)] = inst_22346);

(statearr_22418[(12)] = inst_22332__$1);

return statearr_22418;
})();
var statearr_22419_22493 = state_22391__$1;
(statearr_22419_22493[(2)] = null);

(statearr_22419_22493[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (40))){
var inst_22359 = (state_22391[(23)]);
var inst_22363 = done.call(null,null);
var inst_22364 = cljs.core.async.untap_STAR_.call(null,m,inst_22359);
var state_22391__$1 = (function (){var statearr_22420 = state_22391;
(statearr_22420[(24)] = inst_22363);

return statearr_22420;
})();
var statearr_22421_22494 = state_22391__$1;
(statearr_22421_22494[(2)] = inst_22364);

(statearr_22421_22494[(1)] = (41));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (33))){
var inst_22350 = (state_22391[(25)]);
var inst_22352 = cljs.core.chunked_seq_QMARK_.call(null,inst_22350);
var state_22391__$1 = state_22391;
if(inst_22352){
var statearr_22422_22495 = state_22391__$1;
(statearr_22422_22495[(1)] = (36));

} else {
var statearr_22423_22496 = state_22391__$1;
(statearr_22423_22496[(1)] = (37));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (13))){
var inst_22282 = (state_22391[(26)]);
var inst_22285 = cljs.core.async.close_BANG_.call(null,inst_22282);
var state_22391__$1 = state_22391;
var statearr_22424_22497 = state_22391__$1;
(statearr_22424_22497[(2)] = inst_22285);

(statearr_22424_22497[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (22))){
var inst_22303 = (state_22391[(8)]);
var inst_22306 = cljs.core.async.close_BANG_.call(null,inst_22303);
var state_22391__$1 = state_22391;
var statearr_22425_22498 = state_22391__$1;
(statearr_22425_22498[(2)] = inst_22306);

(statearr_22425_22498[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (36))){
var inst_22350 = (state_22391[(25)]);
var inst_22354 = cljs.core.chunk_first.call(null,inst_22350);
var inst_22355 = cljs.core.chunk_rest.call(null,inst_22350);
var inst_22356 = cljs.core.count.call(null,inst_22354);
var inst_22331 = inst_22355;
var inst_22332 = inst_22354;
var inst_22333 = inst_22356;
var inst_22334 = (0);
var state_22391__$1 = (function (){var statearr_22426 = state_22391;
(statearr_22426[(10)] = inst_22334);

(statearr_22426[(20)] = inst_22331);

(statearr_22426[(21)] = inst_22333);

(statearr_22426[(12)] = inst_22332);

return statearr_22426;
})();
var statearr_22427_22499 = state_22391__$1;
(statearr_22427_22499[(2)] = null);

(statearr_22427_22499[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (41))){
var inst_22350 = (state_22391[(25)]);
var inst_22366 = (state_22391[(2)]);
var inst_22367 = cljs.core.next.call(null,inst_22350);
var inst_22331 = inst_22367;
var inst_22332 = null;
var inst_22333 = (0);
var inst_22334 = (0);
var state_22391__$1 = (function (){var statearr_22428 = state_22391;
(statearr_22428[(10)] = inst_22334);

(statearr_22428[(20)] = inst_22331);

(statearr_22428[(21)] = inst_22333);

(statearr_22428[(27)] = inst_22366);

(statearr_22428[(12)] = inst_22332);

return statearr_22428;
})();
var statearr_22429_22500 = state_22391__$1;
(statearr_22429_22500[(2)] = null);

(statearr_22429_22500[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (43))){
var state_22391__$1 = state_22391;
var statearr_22430_22501 = state_22391__$1;
(statearr_22430_22501[(2)] = null);

(statearr_22430_22501[(1)] = (44));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (29))){
var inst_22375 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22431_22502 = state_22391__$1;
(statearr_22431_22502[(2)] = inst_22375);

(statearr_22431_22502[(1)] = (26));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (44))){
var inst_22384 = (state_22391[(2)]);
var state_22391__$1 = (function (){var statearr_22432 = state_22391;
(statearr_22432[(28)] = inst_22384);

return statearr_22432;
})();
var statearr_22433_22503 = state_22391__$1;
(statearr_22433_22503[(2)] = null);

(statearr_22433_22503[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (6))){
var inst_22323 = (state_22391[(29)]);
var inst_22322 = cljs.core.deref.call(null,cs);
var inst_22323__$1 = cljs.core.keys.call(null,inst_22322);
var inst_22324 = cljs.core.count.call(null,inst_22323__$1);
var inst_22325 = cljs.core.reset_BANG_.call(null,dctr,inst_22324);
var inst_22330 = cljs.core.seq.call(null,inst_22323__$1);
var inst_22331 = inst_22330;
var inst_22332 = null;
var inst_22333 = (0);
var inst_22334 = (0);
var state_22391__$1 = (function (){var statearr_22434 = state_22391;
(statearr_22434[(10)] = inst_22334);

(statearr_22434[(20)] = inst_22331);

(statearr_22434[(30)] = inst_22325);

(statearr_22434[(21)] = inst_22333);

(statearr_22434[(12)] = inst_22332);

(statearr_22434[(29)] = inst_22323__$1);

return statearr_22434;
})();
var statearr_22435_22504 = state_22391__$1;
(statearr_22435_22504[(2)] = null);

(statearr_22435_22504[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (28))){
var inst_22350 = (state_22391[(25)]);
var inst_22331 = (state_22391[(20)]);
var inst_22350__$1 = cljs.core.seq.call(null,inst_22331);
var state_22391__$1 = (function (){var statearr_22436 = state_22391;
(statearr_22436[(25)] = inst_22350__$1);

return statearr_22436;
})();
if(inst_22350__$1){
var statearr_22437_22505 = state_22391__$1;
(statearr_22437_22505[(1)] = (33));

} else {
var statearr_22438_22506 = state_22391__$1;
(statearr_22438_22506[(1)] = (34));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (25))){
var inst_22334 = (state_22391[(10)]);
var inst_22333 = (state_22391[(21)]);
var inst_22336 = (inst_22334 < inst_22333);
var inst_22337 = inst_22336;
var state_22391__$1 = state_22391;
if(cljs.core.truth_(inst_22337)){
var statearr_22439_22507 = state_22391__$1;
(statearr_22439_22507[(1)] = (27));

} else {
var statearr_22440_22508 = state_22391__$1;
(statearr_22440_22508[(1)] = (28));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (34))){
var state_22391__$1 = state_22391;
var statearr_22441_22509 = state_22391__$1;
(statearr_22441_22509[(2)] = null);

(statearr_22441_22509[(1)] = (35));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (17))){
var state_22391__$1 = state_22391;
var statearr_22442_22510 = state_22391__$1;
(statearr_22442_22510[(2)] = null);

(statearr_22442_22510[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (3))){
var inst_22389 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22391__$1,inst_22389);
} else {
if((state_val_22392 === (12))){
var inst_22318 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22443_22511 = state_22391__$1;
(statearr_22443_22511[(2)] = inst_22318);

(statearr_22443_22511[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (2))){
var state_22391__$1 = state_22391;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22391__$1,(4),ch);
} else {
if((state_val_22392 === (23))){
var state_22391__$1 = state_22391;
var statearr_22444_22512 = state_22391__$1;
(statearr_22444_22512[(2)] = null);

(statearr_22444_22512[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (35))){
var inst_22373 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22445_22513 = state_22391__$1;
(statearr_22445_22513[(2)] = inst_22373);

(statearr_22445_22513[(1)] = (29));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (19))){
var inst_22292 = (state_22391[(7)]);
var inst_22296 = cljs.core.chunk_first.call(null,inst_22292);
var inst_22297 = cljs.core.chunk_rest.call(null,inst_22292);
var inst_22298 = cljs.core.count.call(null,inst_22296);
var inst_22272 = inst_22297;
var inst_22273 = inst_22296;
var inst_22274 = inst_22298;
var inst_22275 = (0);
var state_22391__$1 = (function (){var statearr_22446 = state_22391;
(statearr_22446[(14)] = inst_22274);

(statearr_22446[(15)] = inst_22275);

(statearr_22446[(16)] = inst_22273);

(statearr_22446[(17)] = inst_22272);

return statearr_22446;
})();
var statearr_22447_22514 = state_22391__$1;
(statearr_22447_22514[(2)] = null);

(statearr_22447_22514[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (11))){
var inst_22272 = (state_22391[(17)]);
var inst_22292 = (state_22391[(7)]);
var inst_22292__$1 = cljs.core.seq.call(null,inst_22272);
var state_22391__$1 = (function (){var statearr_22448 = state_22391;
(statearr_22448[(7)] = inst_22292__$1);

return statearr_22448;
})();
if(inst_22292__$1){
var statearr_22449_22515 = state_22391__$1;
(statearr_22449_22515[(1)] = (16));

} else {
var statearr_22450_22516 = state_22391__$1;
(statearr_22450_22516[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (9))){
var inst_22320 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22451_22517 = state_22391__$1;
(statearr_22451_22517[(2)] = inst_22320);

(statearr_22451_22517[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (5))){
var inst_22270 = cljs.core.deref.call(null,cs);
var inst_22271 = cljs.core.seq.call(null,inst_22270);
var inst_22272 = inst_22271;
var inst_22273 = null;
var inst_22274 = (0);
var inst_22275 = (0);
var state_22391__$1 = (function (){var statearr_22452 = state_22391;
(statearr_22452[(14)] = inst_22274);

(statearr_22452[(15)] = inst_22275);

(statearr_22452[(16)] = inst_22273);

(statearr_22452[(17)] = inst_22272);

return statearr_22452;
})();
var statearr_22453_22518 = state_22391__$1;
(statearr_22453_22518[(2)] = null);

(statearr_22453_22518[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (14))){
var state_22391__$1 = state_22391;
var statearr_22454_22519 = state_22391__$1;
(statearr_22454_22519[(2)] = null);

(statearr_22454_22519[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (45))){
var inst_22381 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22455_22520 = state_22391__$1;
(statearr_22455_22520[(2)] = inst_22381);

(statearr_22455_22520[(1)] = (44));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (26))){
var inst_22323 = (state_22391[(29)]);
var inst_22377 = (state_22391[(2)]);
var inst_22378 = cljs.core.seq.call(null,inst_22323);
var state_22391__$1 = (function (){var statearr_22456 = state_22391;
(statearr_22456[(31)] = inst_22377);

return statearr_22456;
})();
if(inst_22378){
var statearr_22457_22521 = state_22391__$1;
(statearr_22457_22521[(1)] = (42));

} else {
var statearr_22458_22522 = state_22391__$1;
(statearr_22458_22522[(1)] = (43));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (16))){
var inst_22292 = (state_22391[(7)]);
var inst_22294 = cljs.core.chunked_seq_QMARK_.call(null,inst_22292);
var state_22391__$1 = state_22391;
if(inst_22294){
var statearr_22459_22523 = state_22391__$1;
(statearr_22459_22523[(1)] = (19));

} else {
var statearr_22460_22524 = state_22391__$1;
(statearr_22460_22524[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (38))){
var inst_22370 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22461_22525 = state_22391__$1;
(statearr_22461_22525[(2)] = inst_22370);

(statearr_22461_22525[(1)] = (35));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (30))){
var state_22391__$1 = state_22391;
var statearr_22462_22526 = state_22391__$1;
(statearr_22462_22526[(2)] = null);

(statearr_22462_22526[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (10))){
var inst_22275 = (state_22391[(15)]);
var inst_22273 = (state_22391[(16)]);
var inst_22281 = cljs.core._nth.call(null,inst_22273,inst_22275);
var inst_22282 = cljs.core.nth.call(null,inst_22281,(0),null);
var inst_22283 = cljs.core.nth.call(null,inst_22281,(1),null);
var state_22391__$1 = (function (){var statearr_22463 = state_22391;
(statearr_22463[(26)] = inst_22282);

return statearr_22463;
})();
if(cljs.core.truth_(inst_22283)){
var statearr_22464_22527 = state_22391__$1;
(statearr_22464_22527[(1)] = (13));

} else {
var statearr_22465_22528 = state_22391__$1;
(statearr_22465_22528[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (18))){
var inst_22316 = (state_22391[(2)]);
var state_22391__$1 = state_22391;
var statearr_22466_22529 = state_22391__$1;
(statearr_22466_22529[(2)] = inst_22316);

(statearr_22466_22529[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (42))){
var state_22391__$1 = state_22391;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_22391__$1,(45),dchan);
} else {
if((state_val_22392 === (37))){
var inst_22263 = (state_22391[(11)]);
var inst_22350 = (state_22391[(25)]);
var inst_22359 = (state_22391[(23)]);
var inst_22359__$1 = cljs.core.first.call(null,inst_22350);
var inst_22360 = cljs.core.async.put_BANG_.call(null,inst_22359__$1,inst_22263,done);
var state_22391__$1 = (function (){var statearr_22467 = state_22391;
(statearr_22467[(23)] = inst_22359__$1);

return statearr_22467;
})();
if(cljs.core.truth_(inst_22360)){
var statearr_22468_22530 = state_22391__$1;
(statearr_22468_22530[(1)] = (39));

} else {
var statearr_22469_22531 = state_22391__$1;
(statearr_22469_22531[(1)] = (40));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22392 === (8))){
var inst_22274 = (state_22391[(14)]);
var inst_22275 = (state_22391[(15)]);
var inst_22277 = (inst_22275 < inst_22274);
var inst_22278 = inst_22277;
var state_22391__$1 = state_22391;
if(cljs.core.truth_(inst_22278)){
var statearr_22470_22532 = state_22391__$1;
(statearr_22470_22532[(1)] = (10));

} else {
var statearr_22471_22533 = state_22391__$1;
(statearr_22471_22533[(1)] = (11));

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
});})(c__21172__auto___22479,cs,m,dchan,dctr,done))
;
return ((function (switch__21060__auto__,c__21172__auto___22479,cs,m,dchan,dctr,done){
return (function() {
var cljs$core$async$mult_$_state_machine__21061__auto__ = null;
var cljs$core$async$mult_$_state_machine__21061__auto____0 = (function (){
var statearr_22475 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22475[(0)] = cljs$core$async$mult_$_state_machine__21061__auto__);

(statearr_22475[(1)] = (1));

return statearr_22475;
});
var cljs$core$async$mult_$_state_machine__21061__auto____1 = (function (state_22391){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_22391);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e22476){if((e22476 instanceof Object)){
var ex__21064__auto__ = e22476;
var statearr_22477_22534 = state_22391;
(statearr_22477_22534[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22391);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22476;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22535 = state_22391;
state_22391 = G__22535;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$mult_$_state_machine__21061__auto__ = function(state_22391){
switch(arguments.length){
case 0:
return cljs$core$async$mult_$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$mult_$_state_machine__21061__auto____1.call(this,state_22391);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mult_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mult_$_state_machine__21061__auto____0;
cljs$core$async$mult_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mult_$_state_machine__21061__auto____1;
return cljs$core$async$mult_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___22479,cs,m,dchan,dctr,done))
})();
var state__21174__auto__ = (function (){var statearr_22478 = f__21173__auto__.call(null);
(statearr_22478[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___22479);

return statearr_22478;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___22479,cs,m,dchan,dctr,done))
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
var args22536 = [];
var len__19428__auto___22539 = arguments.length;
var i__19429__auto___22540 = (0);
while(true){
if((i__19429__auto___22540 < len__19428__auto___22539)){
args22536.push((arguments[i__19429__auto___22540]));

var G__22541 = (i__19429__auto___22540 + (1));
i__19429__auto___22540 = G__22541;
continue;
} else {
}
break;
}

var G__22538 = args22536.length;
switch (G__22538) {
case 2:
return cljs.core.async.tap.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.tap.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22536.length)].join('')));

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
var len__19428__auto___22553 = arguments.length;
var i__19429__auto___22554 = (0);
while(true){
if((i__19429__auto___22554 < len__19428__auto___22553)){
args__19435__auto__.push((arguments[i__19429__auto___22554]));

var G__22555 = (i__19429__auto___22554 + (1));
i__19429__auto___22554 = G__22555;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((3) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((3)),(0))):null);
return cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),argseq__19436__auto__);
});

cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (state,cont_block,ports,p__22547){
var map__22548 = p__22547;
var map__22548__$1 = ((((!((map__22548 == null)))?((((map__22548.cljs$lang$protocol_mask$partition0$ & (64))) || (map__22548.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__22548):map__22548);
var opts = map__22548__$1;
var statearr_22550_22556 = state;
(statearr_22550_22556[cljs.core.async.impl.ioc_helpers.STATE_IDX] = cont_block);


var temp__4657__auto__ = cljs.core.async.do_alts.call(null,((function (map__22548,map__22548__$1,opts){
return (function (val){
var statearr_22551_22557 = state;
(statearr_22551_22557[cljs.core.async.impl.ioc_helpers.VALUE_IDX] = val);


return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state);
});})(map__22548,map__22548__$1,opts))
,ports,opts);
if(cljs.core.truth_(temp__4657__auto__)){
var cb = temp__4657__auto__;
var statearr_22552_22558 = state;
(statearr_22552_22558[cljs.core.async.impl.ioc_helpers.VALUE_IDX] = cljs.core.deref.call(null,cb));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
return null;
}
});

cljs.core.async.ioc_alts_BANG_.cljs$lang$maxFixedArity = (3);

cljs.core.async.ioc_alts_BANG_.cljs$lang$applyTo = (function (seq22543){
var G__22544 = cljs.core.first.call(null,seq22543);
var seq22543__$1 = cljs.core.next.call(null,seq22543);
var G__22545 = cljs.core.first.call(null,seq22543__$1);
var seq22543__$2 = cljs.core.next.call(null,seq22543__$1);
var G__22546 = cljs.core.first.call(null,seq22543__$2);
var seq22543__$3 = cljs.core.next.call(null,seq22543__$2);
return cljs.core.async.ioc_alts_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__22544,G__22545,G__22546,seq22543__$3);
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
if(typeof cljs.core.async.t_cljs$core$async22722 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mix}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22722 = (function (change,mix,solo_mode,pick,cs,calc_state,out,changed,solo_modes,attrs,meta22723){
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
this.meta22723 = meta22723;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_22724,meta22723__$1){
var self__ = this;
var _22724__$1 = this;
return (new cljs.core.async.t_cljs$core$async22722(self__.change,self__.mix,self__.solo_mode,self__.pick,self__.cs,self__.calc_state,self__.out,self__.changed,self__.solo_modes,self__.attrs,meta22723__$1));
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_22724){
var self__ = this;
var _22724__$1 = this;
return self__.meta22723;
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.out;
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mix$ = true;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mix$admix_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,ch){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.assoc,ch,cljs.core.PersistentArrayMap.EMPTY);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mix$unmix_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,ch){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.dissoc,ch);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mix$unmix_all_STAR_$arity$1 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_){
var self__ = this;
var ___$1 = this;
cljs.core.reset_BANG_.call(null,self__.cs,cljs.core.PersistentArrayMap.EMPTY);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mix$toggle_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (_,state_map){
var self__ = this;
var ___$1 = this;
cljs.core.swap_BANG_.call(null,self__.cs,cljs.core.partial.call(null,cljs.core.merge_with,cljs.core.merge),state_map);

return self__.changed.call(null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.prototype.cljs$core$async$Mix$solo_mode_STAR_$arity$2 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
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

cljs.core.async.t_cljs$core$async22722.getBasis = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (){
return new cljs.core.PersistentVector(null, 11, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"change","change",477485025,null),cljs.core.with_meta(new cljs.core.Symbol(null,"mix","mix",2121373763,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"out","out",729986010,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Creates and returns a mix of one or more input channels which will\n  be put on the supplied out channel. Input sources can be added to\n  the mix with 'admix', and removed with 'unmix'. A mix supports\n  soloing, muting and pausing multiple inputs atomically using\n  'toggle', and can solo using either muting or pausing as determined\n  by 'solo-mode'.\n\n  Each channel can have zero or more boolean modes set via 'toggle':\n\n  :solo - when true, only this (ond other soloed) channel(s) will appear\n          in the mix output channel. :mute and :pause states of soloed\n          channels are ignored. If solo-mode is :mute, non-soloed\n          channels are muted, if :pause, non-soloed channels are\n          paused.\n\n  :mute - muted channels will have their contents consumed but not included in the mix\n  :pause - paused channels will not have their contents consumed (and thus also not included in the mix)\n"], null)),new cljs.core.Symbol(null,"solo-mode","solo-mode",2031788074,null),new cljs.core.Symbol(null,"pick","pick",1300068175,null),new cljs.core.Symbol(null,"cs","cs",-117024463,null),new cljs.core.Symbol(null,"calc-state","calc-state",-349968968,null),new cljs.core.Symbol(null,"out","out",729986010,null),new cljs.core.Symbol(null,"changed","changed",-2083710852,null),new cljs.core.Symbol(null,"solo-modes","solo-modes",882180540,null),new cljs.core.Symbol(null,"attrs","attrs",-450137186,null),new cljs.core.Symbol(null,"meta22723","meta22723",1180465950,null)], null);
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.t_cljs$core$async22722.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22722.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22722";

cljs.core.async.t_cljs$core$async22722.cljs$lang$ctorPrWriter = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22722");
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

cljs.core.async.__GT_t_cljs$core$async22722 = ((function (cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state){
return (function cljs$core$async$mix_$___GT_t_cljs$core$async22722(change__$1,mix__$1,solo_mode__$1,pick__$1,cs__$1,calc_state__$1,out__$1,changed__$1,solo_modes__$1,attrs__$1,meta22723){
return (new cljs.core.async.t_cljs$core$async22722(change__$1,mix__$1,solo_mode__$1,pick__$1,cs__$1,calc_state__$1,out__$1,changed__$1,solo_modes__$1,attrs__$1,meta22723));
});})(cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state))
;

}

return (new cljs.core.async.t_cljs$core$async22722(change,cljs$core$async$mix,solo_mode,pick,cs,calc_state,out,changed,solo_modes,attrs,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var c__21172__auto___22885 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___22885,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___22885,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function (state_22822){
var state_val_22823 = (state_22822[(1)]);
if((state_val_22823 === (7))){
var inst_22740 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
var statearr_22824_22886 = state_22822__$1;
(statearr_22824_22886[(2)] = inst_22740);

(statearr_22824_22886[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (20))){
var inst_22752 = (state_22822[(7)]);
var state_22822__$1 = state_22822;
var statearr_22825_22887 = state_22822__$1;
(statearr_22825_22887[(2)] = inst_22752);

(statearr_22825_22887[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (27))){
var state_22822__$1 = state_22822;
var statearr_22826_22888 = state_22822__$1;
(statearr_22826_22888[(2)] = null);

(statearr_22826_22888[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (1))){
var inst_22728 = (state_22822[(8)]);
var inst_22728__$1 = calc_state.call(null);
var inst_22730 = (inst_22728__$1 == null);
var inst_22731 = cljs.core.not.call(null,inst_22730);
var state_22822__$1 = (function (){var statearr_22827 = state_22822;
(statearr_22827[(8)] = inst_22728__$1);

return statearr_22827;
})();
if(inst_22731){
var statearr_22828_22889 = state_22822__$1;
(statearr_22828_22889[(1)] = (2));

} else {
var statearr_22829_22890 = state_22822__$1;
(statearr_22829_22890[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (24))){
var inst_22782 = (state_22822[(9)]);
var inst_22775 = (state_22822[(10)]);
var inst_22796 = (state_22822[(11)]);
var inst_22796__$1 = inst_22775.call(null,inst_22782);
var state_22822__$1 = (function (){var statearr_22830 = state_22822;
(statearr_22830[(11)] = inst_22796__$1);

return statearr_22830;
})();
if(cljs.core.truth_(inst_22796__$1)){
var statearr_22831_22891 = state_22822__$1;
(statearr_22831_22891[(1)] = (29));

} else {
var statearr_22832_22892 = state_22822__$1;
(statearr_22832_22892[(1)] = (30));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (4))){
var inst_22743 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22743)){
var statearr_22833_22893 = state_22822__$1;
(statearr_22833_22893[(1)] = (8));

} else {
var statearr_22834_22894 = state_22822__$1;
(statearr_22834_22894[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (15))){
var inst_22769 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22769)){
var statearr_22835_22895 = state_22822__$1;
(statearr_22835_22895[(1)] = (19));

} else {
var statearr_22836_22896 = state_22822__$1;
(statearr_22836_22896[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (21))){
var inst_22774 = (state_22822[(12)]);
var inst_22774__$1 = (state_22822[(2)]);
var inst_22775 = cljs.core.get.call(null,inst_22774__$1,new cljs.core.Keyword(null,"solos","solos",1441458643));
var inst_22776 = cljs.core.get.call(null,inst_22774__$1,new cljs.core.Keyword(null,"mutes","mutes",1068806309));
var inst_22777 = cljs.core.get.call(null,inst_22774__$1,new cljs.core.Keyword(null,"reads","reads",-1215067361));
var state_22822__$1 = (function (){var statearr_22837 = state_22822;
(statearr_22837[(10)] = inst_22775);

(statearr_22837[(12)] = inst_22774__$1);

(statearr_22837[(13)] = inst_22776);

return statearr_22837;
})();
return cljs.core.async.ioc_alts_BANG_.call(null,state_22822__$1,(22),inst_22777);
} else {
if((state_val_22823 === (31))){
var inst_22804 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22804)){
var statearr_22838_22897 = state_22822__$1;
(statearr_22838_22897[(1)] = (32));

} else {
var statearr_22839_22898 = state_22822__$1;
(statearr_22839_22898[(1)] = (33));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (32))){
var inst_22781 = (state_22822[(14)]);
var state_22822__$1 = state_22822;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_22822__$1,(35),out,inst_22781);
} else {
if((state_val_22823 === (33))){
var inst_22774 = (state_22822[(12)]);
var inst_22752 = inst_22774;
var state_22822__$1 = (function (){var statearr_22840 = state_22822;
(statearr_22840[(7)] = inst_22752);

return statearr_22840;
})();
var statearr_22841_22899 = state_22822__$1;
(statearr_22841_22899[(2)] = null);

(statearr_22841_22899[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (13))){
var inst_22752 = (state_22822[(7)]);
var inst_22759 = inst_22752.cljs$lang$protocol_mask$partition0$;
var inst_22760 = (inst_22759 & (64));
var inst_22761 = inst_22752.cljs$core$ISeq$;
var inst_22762 = (inst_22760) || (inst_22761);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22762)){
var statearr_22842_22900 = state_22822__$1;
(statearr_22842_22900[(1)] = (16));

} else {
var statearr_22843_22901 = state_22822__$1;
(statearr_22843_22901[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (22))){
var inst_22782 = (state_22822[(9)]);
var inst_22781 = (state_22822[(14)]);
var inst_22780 = (state_22822[(2)]);
var inst_22781__$1 = cljs.core.nth.call(null,inst_22780,(0),null);
var inst_22782__$1 = cljs.core.nth.call(null,inst_22780,(1),null);
var inst_22783 = (inst_22781__$1 == null);
var inst_22784 = cljs.core._EQ_.call(null,inst_22782__$1,change);
var inst_22785 = (inst_22783) || (inst_22784);
var state_22822__$1 = (function (){var statearr_22844 = state_22822;
(statearr_22844[(9)] = inst_22782__$1);

(statearr_22844[(14)] = inst_22781__$1);

return statearr_22844;
})();
if(cljs.core.truth_(inst_22785)){
var statearr_22845_22902 = state_22822__$1;
(statearr_22845_22902[(1)] = (23));

} else {
var statearr_22846_22903 = state_22822__$1;
(statearr_22846_22903[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (36))){
var inst_22774 = (state_22822[(12)]);
var inst_22752 = inst_22774;
var state_22822__$1 = (function (){var statearr_22847 = state_22822;
(statearr_22847[(7)] = inst_22752);

return statearr_22847;
})();
var statearr_22848_22904 = state_22822__$1;
(statearr_22848_22904[(2)] = null);

(statearr_22848_22904[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (29))){
var inst_22796 = (state_22822[(11)]);
var state_22822__$1 = state_22822;
var statearr_22849_22905 = state_22822__$1;
(statearr_22849_22905[(2)] = inst_22796);

(statearr_22849_22905[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (6))){
var state_22822__$1 = state_22822;
var statearr_22850_22906 = state_22822__$1;
(statearr_22850_22906[(2)] = false);

(statearr_22850_22906[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (28))){
var inst_22792 = (state_22822[(2)]);
var inst_22793 = calc_state.call(null);
var inst_22752 = inst_22793;
var state_22822__$1 = (function (){var statearr_22851 = state_22822;
(statearr_22851[(7)] = inst_22752);

(statearr_22851[(15)] = inst_22792);

return statearr_22851;
})();
var statearr_22852_22907 = state_22822__$1;
(statearr_22852_22907[(2)] = null);

(statearr_22852_22907[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (25))){
var inst_22818 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
var statearr_22853_22908 = state_22822__$1;
(statearr_22853_22908[(2)] = inst_22818);

(statearr_22853_22908[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (34))){
var inst_22816 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
var statearr_22854_22909 = state_22822__$1;
(statearr_22854_22909[(2)] = inst_22816);

(statearr_22854_22909[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (17))){
var state_22822__$1 = state_22822;
var statearr_22855_22910 = state_22822__$1;
(statearr_22855_22910[(2)] = false);

(statearr_22855_22910[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (3))){
var state_22822__$1 = state_22822;
var statearr_22856_22911 = state_22822__$1;
(statearr_22856_22911[(2)] = false);

(statearr_22856_22911[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (12))){
var inst_22820 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_22822__$1,inst_22820);
} else {
if((state_val_22823 === (2))){
var inst_22728 = (state_22822[(8)]);
var inst_22733 = inst_22728.cljs$lang$protocol_mask$partition0$;
var inst_22734 = (inst_22733 & (64));
var inst_22735 = inst_22728.cljs$core$ISeq$;
var inst_22736 = (inst_22734) || (inst_22735);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22736)){
var statearr_22857_22912 = state_22822__$1;
(statearr_22857_22912[(1)] = (5));

} else {
var statearr_22858_22913 = state_22822__$1;
(statearr_22858_22913[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (23))){
var inst_22781 = (state_22822[(14)]);
var inst_22787 = (inst_22781 == null);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22787)){
var statearr_22859_22914 = state_22822__$1;
(statearr_22859_22914[(1)] = (26));

} else {
var statearr_22860_22915 = state_22822__$1;
(statearr_22860_22915[(1)] = (27));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (35))){
var inst_22807 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
if(cljs.core.truth_(inst_22807)){
var statearr_22861_22916 = state_22822__$1;
(statearr_22861_22916[(1)] = (36));

} else {
var statearr_22862_22917 = state_22822__$1;
(statearr_22862_22917[(1)] = (37));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (19))){
var inst_22752 = (state_22822[(7)]);
var inst_22771 = cljs.core.apply.call(null,cljs.core.hash_map,inst_22752);
var state_22822__$1 = state_22822;
var statearr_22863_22918 = state_22822__$1;
(statearr_22863_22918[(2)] = inst_22771);

(statearr_22863_22918[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (11))){
var inst_22752 = (state_22822[(7)]);
var inst_22756 = (inst_22752 == null);
var inst_22757 = cljs.core.not.call(null,inst_22756);
var state_22822__$1 = state_22822;
if(inst_22757){
var statearr_22864_22919 = state_22822__$1;
(statearr_22864_22919[(1)] = (13));

} else {
var statearr_22865_22920 = state_22822__$1;
(statearr_22865_22920[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (9))){
var inst_22728 = (state_22822[(8)]);
var state_22822__$1 = state_22822;
var statearr_22866_22921 = state_22822__$1;
(statearr_22866_22921[(2)] = inst_22728);

(statearr_22866_22921[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (5))){
var state_22822__$1 = state_22822;
var statearr_22867_22922 = state_22822__$1;
(statearr_22867_22922[(2)] = true);

(statearr_22867_22922[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (14))){
var state_22822__$1 = state_22822;
var statearr_22868_22923 = state_22822__$1;
(statearr_22868_22923[(2)] = false);

(statearr_22868_22923[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (26))){
var inst_22782 = (state_22822[(9)]);
var inst_22789 = cljs.core.swap_BANG_.call(null,cs,cljs.core.dissoc,inst_22782);
var state_22822__$1 = state_22822;
var statearr_22869_22924 = state_22822__$1;
(statearr_22869_22924[(2)] = inst_22789);

(statearr_22869_22924[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (16))){
var state_22822__$1 = state_22822;
var statearr_22870_22925 = state_22822__$1;
(statearr_22870_22925[(2)] = true);

(statearr_22870_22925[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (38))){
var inst_22812 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
var statearr_22871_22926 = state_22822__$1;
(statearr_22871_22926[(2)] = inst_22812);

(statearr_22871_22926[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (30))){
var inst_22782 = (state_22822[(9)]);
var inst_22775 = (state_22822[(10)]);
var inst_22776 = (state_22822[(13)]);
var inst_22799 = cljs.core.empty_QMARK_.call(null,inst_22775);
var inst_22800 = inst_22776.call(null,inst_22782);
var inst_22801 = cljs.core.not.call(null,inst_22800);
var inst_22802 = (inst_22799) && (inst_22801);
var state_22822__$1 = state_22822;
var statearr_22872_22927 = state_22822__$1;
(statearr_22872_22927[(2)] = inst_22802);

(statearr_22872_22927[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (10))){
var inst_22728 = (state_22822[(8)]);
var inst_22748 = (state_22822[(2)]);
var inst_22749 = cljs.core.get.call(null,inst_22748,new cljs.core.Keyword(null,"solos","solos",1441458643));
var inst_22750 = cljs.core.get.call(null,inst_22748,new cljs.core.Keyword(null,"mutes","mutes",1068806309));
var inst_22751 = cljs.core.get.call(null,inst_22748,new cljs.core.Keyword(null,"reads","reads",-1215067361));
var inst_22752 = inst_22728;
var state_22822__$1 = (function (){var statearr_22873 = state_22822;
(statearr_22873[(7)] = inst_22752);

(statearr_22873[(16)] = inst_22750);

(statearr_22873[(17)] = inst_22749);

(statearr_22873[(18)] = inst_22751);

return statearr_22873;
})();
var statearr_22874_22928 = state_22822__$1;
(statearr_22874_22928[(2)] = null);

(statearr_22874_22928[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (18))){
var inst_22766 = (state_22822[(2)]);
var state_22822__$1 = state_22822;
var statearr_22875_22929 = state_22822__$1;
(statearr_22875_22929[(2)] = inst_22766);

(statearr_22875_22929[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (37))){
var state_22822__$1 = state_22822;
var statearr_22876_22930 = state_22822__$1;
(statearr_22876_22930[(2)] = null);

(statearr_22876_22930[(1)] = (38));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_22823 === (8))){
var inst_22728 = (state_22822[(8)]);
var inst_22745 = cljs.core.apply.call(null,cljs.core.hash_map,inst_22728);
var state_22822__$1 = state_22822;
var statearr_22877_22931 = state_22822__$1;
(statearr_22877_22931[(2)] = inst_22745);

(statearr_22877_22931[(1)] = (10));


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
});})(c__21172__auto___22885,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
;
return ((function (switch__21060__auto__,c__21172__auto___22885,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m){
return (function() {
var cljs$core$async$mix_$_state_machine__21061__auto__ = null;
var cljs$core$async$mix_$_state_machine__21061__auto____0 = (function (){
var statearr_22881 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_22881[(0)] = cljs$core$async$mix_$_state_machine__21061__auto__);

(statearr_22881[(1)] = (1));

return statearr_22881;
});
var cljs$core$async$mix_$_state_machine__21061__auto____1 = (function (state_22822){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_22822);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e22882){if((e22882 instanceof Object)){
var ex__21064__auto__ = e22882;
var statearr_22883_22932 = state_22822;
(statearr_22883_22932[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_22822);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e22882;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__22933 = state_22822;
state_22822 = G__22933;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$mix_$_state_machine__21061__auto__ = function(state_22822){
switch(arguments.length){
case 0:
return cljs$core$async$mix_$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$mix_$_state_machine__21061__auto____1.call(this,state_22822);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mix_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mix_$_state_machine__21061__auto____0;
cljs$core$async$mix_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mix_$_state_machine__21061__auto____1;
return cljs$core$async$mix_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___22885,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
})();
var state__21174__auto__ = (function (){var statearr_22884 = f__21173__auto__.call(null);
(statearr_22884[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___22885);

return statearr_22884;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___22885,cs,solo_modes,attrs,solo_mode,change,changed,pick,calc_state,m))
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
var args22934 = [];
var len__19428__auto___22937 = arguments.length;
var i__19429__auto___22938 = (0);
while(true){
if((i__19429__auto___22938 < len__19428__auto___22937)){
args22934.push((arguments[i__19429__auto___22938]));

var G__22939 = (i__19429__auto___22938 + (1));
i__19429__auto___22938 = G__22939;
continue;
} else {
}
break;
}

var G__22936 = args22934.length;
switch (G__22936) {
case 1:
return cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unsub_all_STAR_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22934.length)].join('')));

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
var args22942 = [];
var len__19428__auto___23067 = arguments.length;
var i__19429__auto___23068 = (0);
while(true){
if((i__19429__auto___23068 < len__19428__auto___23067)){
args22942.push((arguments[i__19429__auto___23068]));

var G__23069 = (i__19429__auto___23068 + (1));
i__19429__auto___23068 = G__23069;
continue;
} else {
}
break;
}

var G__22944 = args22942.length;
switch (G__22944) {
case 2:
return cljs.core.async.pub.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.pub.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args22942.length)].join('')));

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
return (function (p1__22941_SHARP_){
if(cljs.core.truth_(p1__22941_SHARP_.call(null,topic))){
return p1__22941_SHARP_;
} else {
return cljs.core.assoc.call(null,p1__22941_SHARP_,topic,cljs.core.async.mult.call(null,cljs.core.async.chan.call(null,buf_fn.call(null,topic))));
}
});})(or__18370__auto__,mults))
),topic);
}
});})(mults))
;
var p = (function (){
if(typeof cljs.core.async.t_cljs$core$async22945 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.Pub}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.async.Mux}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async22945 = (function (ch,topic_fn,buf_fn,mults,ensure_mult,meta22946){
this.ch = ch;
this.topic_fn = topic_fn;
this.buf_fn = buf_fn;
this.mults = mults;
this.ensure_mult = ensure_mult;
this.meta22946 = meta22946;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (mults,ensure_mult){
return (function (_22947,meta22946__$1){
var self__ = this;
var _22947__$1 = this;
return (new cljs.core.async.t_cljs$core$async22945(self__.ch,self__.topic_fn,self__.buf_fn,self__.mults,self__.ensure_mult,meta22946__$1));
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (mults,ensure_mult){
return (function (_22947){
var self__ = this;
var _22947__$1 = this;
return self__.meta22946;
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Mux$ = true;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Mux$muxch_STAR_$arity$1 = ((function (mults,ensure_mult){
return (function (_){
var self__ = this;
var ___$1 = this;
return self__.ch;
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Pub$ = true;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Pub$sub_STAR_$arity$4 = ((function (mults,ensure_mult){
return (function (p,topic,ch__$1,close_QMARK_){
var self__ = this;
var p__$1 = this;
var m = self__.ensure_mult.call(null,topic);
return cljs.core.async.tap.call(null,m,ch__$1,close_QMARK_);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Pub$unsub_STAR_$arity$3 = ((function (mults,ensure_mult){
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

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Pub$unsub_all_STAR_$arity$1 = ((function (mults,ensure_mult){
return (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.reset_BANG_.call(null,self__.mults,cljs.core.PersistentArrayMap.EMPTY);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.prototype.cljs$core$async$Pub$unsub_all_STAR_$arity$2 = ((function (mults,ensure_mult){
return (function (_,topic){
var self__ = this;
var ___$1 = this;
return cljs.core.swap_BANG_.call(null,self__.mults,cljs.core.dissoc,topic);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.getBasis = ((function (mults,ensure_mult){
return (function (){
return new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"topic-fn","topic-fn",-862449736,null),new cljs.core.Symbol(null,"buf-fn","buf-fn",-1200281591,null),new cljs.core.Symbol(null,"mults","mults",-461114485,null),new cljs.core.Symbol(null,"ensure-mult","ensure-mult",1796584816,null),new cljs.core.Symbol(null,"meta22946","meta22946",-590605859,null)], null);
});})(mults,ensure_mult))
;

cljs.core.async.t_cljs$core$async22945.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async22945.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async22945";

cljs.core.async.t_cljs$core$async22945.cljs$lang$ctorPrWriter = ((function (mults,ensure_mult){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async22945");
});})(mults,ensure_mult))
;

cljs.core.async.__GT_t_cljs$core$async22945 = ((function (mults,ensure_mult){
return (function cljs$core$async$__GT_t_cljs$core$async22945(ch__$1,topic_fn__$1,buf_fn__$1,mults__$1,ensure_mult__$1,meta22946){
return (new cljs.core.async.t_cljs$core$async22945(ch__$1,topic_fn__$1,buf_fn__$1,mults__$1,ensure_mult__$1,meta22946));
});})(mults,ensure_mult))
;

}

return (new cljs.core.async.t_cljs$core$async22945(ch,topic_fn,buf_fn,mults,ensure_mult,cljs.core.PersistentArrayMap.EMPTY));
})()
;
var c__21172__auto___23071 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23071,mults,ensure_mult,p){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23071,mults,ensure_mult,p){
return (function (state_23019){
var state_val_23020 = (state_23019[(1)]);
if((state_val_23020 === (7))){
var inst_23015 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
var statearr_23021_23072 = state_23019__$1;
(statearr_23021_23072[(2)] = inst_23015);

(statearr_23021_23072[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (20))){
var state_23019__$1 = state_23019;
var statearr_23022_23073 = state_23019__$1;
(statearr_23022_23073[(2)] = null);

(statearr_23022_23073[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (1))){
var state_23019__$1 = state_23019;
var statearr_23023_23074 = state_23019__$1;
(statearr_23023_23074[(2)] = null);

(statearr_23023_23074[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (24))){
var inst_22998 = (state_23019[(7)]);
var inst_23007 = cljs.core.swap_BANG_.call(null,mults,cljs.core.dissoc,inst_22998);
var state_23019__$1 = state_23019;
var statearr_23024_23075 = state_23019__$1;
(statearr_23024_23075[(2)] = inst_23007);

(statearr_23024_23075[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (4))){
var inst_22950 = (state_23019[(8)]);
var inst_22950__$1 = (state_23019[(2)]);
var inst_22951 = (inst_22950__$1 == null);
var state_23019__$1 = (function (){var statearr_23025 = state_23019;
(statearr_23025[(8)] = inst_22950__$1);

return statearr_23025;
})();
if(cljs.core.truth_(inst_22951)){
var statearr_23026_23076 = state_23019__$1;
(statearr_23026_23076[(1)] = (5));

} else {
var statearr_23027_23077 = state_23019__$1;
(statearr_23027_23077[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (15))){
var inst_22992 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
var statearr_23028_23078 = state_23019__$1;
(statearr_23028_23078[(2)] = inst_22992);

(statearr_23028_23078[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (21))){
var inst_23012 = (state_23019[(2)]);
var state_23019__$1 = (function (){var statearr_23029 = state_23019;
(statearr_23029[(9)] = inst_23012);

return statearr_23029;
})();
var statearr_23030_23079 = state_23019__$1;
(statearr_23030_23079[(2)] = null);

(statearr_23030_23079[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (13))){
var inst_22974 = (state_23019[(10)]);
var inst_22976 = cljs.core.chunked_seq_QMARK_.call(null,inst_22974);
var state_23019__$1 = state_23019;
if(inst_22976){
var statearr_23031_23080 = state_23019__$1;
(statearr_23031_23080[(1)] = (16));

} else {
var statearr_23032_23081 = state_23019__$1;
(statearr_23032_23081[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (22))){
var inst_23004 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
if(cljs.core.truth_(inst_23004)){
var statearr_23033_23082 = state_23019__$1;
(statearr_23033_23082[(1)] = (23));

} else {
var statearr_23034_23083 = state_23019__$1;
(statearr_23034_23083[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (6))){
var inst_23000 = (state_23019[(11)]);
var inst_22950 = (state_23019[(8)]);
var inst_22998 = (state_23019[(7)]);
var inst_22998__$1 = topic_fn.call(null,inst_22950);
var inst_22999 = cljs.core.deref.call(null,mults);
var inst_23000__$1 = cljs.core.get.call(null,inst_22999,inst_22998__$1);
var state_23019__$1 = (function (){var statearr_23035 = state_23019;
(statearr_23035[(11)] = inst_23000__$1);

(statearr_23035[(7)] = inst_22998__$1);

return statearr_23035;
})();
if(cljs.core.truth_(inst_23000__$1)){
var statearr_23036_23084 = state_23019__$1;
(statearr_23036_23084[(1)] = (19));

} else {
var statearr_23037_23085 = state_23019__$1;
(statearr_23037_23085[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (25))){
var inst_23009 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
var statearr_23038_23086 = state_23019__$1;
(statearr_23038_23086[(2)] = inst_23009);

(statearr_23038_23086[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (17))){
var inst_22974 = (state_23019[(10)]);
var inst_22983 = cljs.core.first.call(null,inst_22974);
var inst_22984 = cljs.core.async.muxch_STAR_.call(null,inst_22983);
var inst_22985 = cljs.core.async.close_BANG_.call(null,inst_22984);
var inst_22986 = cljs.core.next.call(null,inst_22974);
var inst_22960 = inst_22986;
var inst_22961 = null;
var inst_22962 = (0);
var inst_22963 = (0);
var state_23019__$1 = (function (){var statearr_23039 = state_23019;
(statearr_23039[(12)] = inst_22961);

(statearr_23039[(13)] = inst_22963);

(statearr_23039[(14)] = inst_22962);

(statearr_23039[(15)] = inst_22960);

(statearr_23039[(16)] = inst_22985);

return statearr_23039;
})();
var statearr_23040_23087 = state_23019__$1;
(statearr_23040_23087[(2)] = null);

(statearr_23040_23087[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (3))){
var inst_23017 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23019__$1,inst_23017);
} else {
if((state_val_23020 === (12))){
var inst_22994 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
var statearr_23041_23088 = state_23019__$1;
(statearr_23041_23088[(2)] = inst_22994);

(statearr_23041_23088[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (2))){
var state_23019__$1 = state_23019;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23019__$1,(4),ch);
} else {
if((state_val_23020 === (23))){
var state_23019__$1 = state_23019;
var statearr_23042_23089 = state_23019__$1;
(statearr_23042_23089[(2)] = null);

(statearr_23042_23089[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (19))){
var inst_23000 = (state_23019[(11)]);
var inst_22950 = (state_23019[(8)]);
var inst_23002 = cljs.core.async.muxch_STAR_.call(null,inst_23000);
var state_23019__$1 = state_23019;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23019__$1,(22),inst_23002,inst_22950);
} else {
if((state_val_23020 === (11))){
var inst_22974 = (state_23019[(10)]);
var inst_22960 = (state_23019[(15)]);
var inst_22974__$1 = cljs.core.seq.call(null,inst_22960);
var state_23019__$1 = (function (){var statearr_23043 = state_23019;
(statearr_23043[(10)] = inst_22974__$1);

return statearr_23043;
})();
if(inst_22974__$1){
var statearr_23044_23090 = state_23019__$1;
(statearr_23044_23090[(1)] = (13));

} else {
var statearr_23045_23091 = state_23019__$1;
(statearr_23045_23091[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (9))){
var inst_22996 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
var statearr_23046_23092 = state_23019__$1;
(statearr_23046_23092[(2)] = inst_22996);

(statearr_23046_23092[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (5))){
var inst_22957 = cljs.core.deref.call(null,mults);
var inst_22958 = cljs.core.vals.call(null,inst_22957);
var inst_22959 = cljs.core.seq.call(null,inst_22958);
var inst_22960 = inst_22959;
var inst_22961 = null;
var inst_22962 = (0);
var inst_22963 = (0);
var state_23019__$1 = (function (){var statearr_23047 = state_23019;
(statearr_23047[(12)] = inst_22961);

(statearr_23047[(13)] = inst_22963);

(statearr_23047[(14)] = inst_22962);

(statearr_23047[(15)] = inst_22960);

return statearr_23047;
})();
var statearr_23048_23093 = state_23019__$1;
(statearr_23048_23093[(2)] = null);

(statearr_23048_23093[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (14))){
var state_23019__$1 = state_23019;
var statearr_23052_23094 = state_23019__$1;
(statearr_23052_23094[(2)] = null);

(statearr_23052_23094[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (16))){
var inst_22974 = (state_23019[(10)]);
var inst_22978 = cljs.core.chunk_first.call(null,inst_22974);
var inst_22979 = cljs.core.chunk_rest.call(null,inst_22974);
var inst_22980 = cljs.core.count.call(null,inst_22978);
var inst_22960 = inst_22979;
var inst_22961 = inst_22978;
var inst_22962 = inst_22980;
var inst_22963 = (0);
var state_23019__$1 = (function (){var statearr_23053 = state_23019;
(statearr_23053[(12)] = inst_22961);

(statearr_23053[(13)] = inst_22963);

(statearr_23053[(14)] = inst_22962);

(statearr_23053[(15)] = inst_22960);

return statearr_23053;
})();
var statearr_23054_23095 = state_23019__$1;
(statearr_23054_23095[(2)] = null);

(statearr_23054_23095[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (10))){
var inst_22961 = (state_23019[(12)]);
var inst_22963 = (state_23019[(13)]);
var inst_22962 = (state_23019[(14)]);
var inst_22960 = (state_23019[(15)]);
var inst_22968 = cljs.core._nth.call(null,inst_22961,inst_22963);
var inst_22969 = cljs.core.async.muxch_STAR_.call(null,inst_22968);
var inst_22970 = cljs.core.async.close_BANG_.call(null,inst_22969);
var inst_22971 = (inst_22963 + (1));
var tmp23049 = inst_22961;
var tmp23050 = inst_22962;
var tmp23051 = inst_22960;
var inst_22960__$1 = tmp23051;
var inst_22961__$1 = tmp23049;
var inst_22962__$1 = tmp23050;
var inst_22963__$1 = inst_22971;
var state_23019__$1 = (function (){var statearr_23055 = state_23019;
(statearr_23055[(12)] = inst_22961__$1);

(statearr_23055[(13)] = inst_22963__$1);

(statearr_23055[(17)] = inst_22970);

(statearr_23055[(14)] = inst_22962__$1);

(statearr_23055[(15)] = inst_22960__$1);

return statearr_23055;
})();
var statearr_23056_23096 = state_23019__$1;
(statearr_23056_23096[(2)] = null);

(statearr_23056_23096[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (18))){
var inst_22989 = (state_23019[(2)]);
var state_23019__$1 = state_23019;
var statearr_23057_23097 = state_23019__$1;
(statearr_23057_23097[(2)] = inst_22989);

(statearr_23057_23097[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23020 === (8))){
var inst_22963 = (state_23019[(13)]);
var inst_22962 = (state_23019[(14)]);
var inst_22965 = (inst_22963 < inst_22962);
var inst_22966 = inst_22965;
var state_23019__$1 = state_23019;
if(cljs.core.truth_(inst_22966)){
var statearr_23058_23098 = state_23019__$1;
(statearr_23058_23098[(1)] = (10));

} else {
var statearr_23059_23099 = state_23019__$1;
(statearr_23059_23099[(1)] = (11));

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
});})(c__21172__auto___23071,mults,ensure_mult,p))
;
return ((function (switch__21060__auto__,c__21172__auto___23071,mults,ensure_mult,p){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23063 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23063[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23063[(1)] = (1));

return statearr_23063;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23019){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23019);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23064){if((e23064 instanceof Object)){
var ex__21064__auto__ = e23064;
var statearr_23065_23100 = state_23019;
(statearr_23065_23100[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23019);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23064;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23101 = state_23019;
state_23019 = G__23101;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23019){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23019);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23071,mults,ensure_mult,p))
})();
var state__21174__auto__ = (function (){var statearr_23066 = f__21173__auto__.call(null);
(statearr_23066[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23071);

return statearr_23066;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23071,mults,ensure_mult,p))
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
var args23102 = [];
var len__19428__auto___23105 = arguments.length;
var i__19429__auto___23106 = (0);
while(true){
if((i__19429__auto___23106 < len__19428__auto___23105)){
args23102.push((arguments[i__19429__auto___23106]));

var G__23107 = (i__19429__auto___23106 + (1));
i__19429__auto___23106 = G__23107;
continue;
} else {
}
break;
}

var G__23104 = args23102.length;
switch (G__23104) {
case 3:
return cljs.core.async.sub.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
case 4:
return cljs.core.async.sub.cljs$core$IFn$_invoke$arity$4((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),(arguments[(3)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23102.length)].join('')));

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
var args23109 = [];
var len__19428__auto___23112 = arguments.length;
var i__19429__auto___23113 = (0);
while(true){
if((i__19429__auto___23113 < len__19428__auto___23112)){
args23109.push((arguments[i__19429__auto___23113]));

var G__23114 = (i__19429__auto___23113 + (1));
i__19429__auto___23113 = G__23114;
continue;
} else {
}
break;
}

var G__23111 = args23109.length;
switch (G__23111) {
case 1:
return cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unsub_all.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23109.length)].join('')));

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
var args23116 = [];
var len__19428__auto___23187 = arguments.length;
var i__19429__auto___23188 = (0);
while(true){
if((i__19429__auto___23188 < len__19428__auto___23187)){
args23116.push((arguments[i__19429__auto___23188]));

var G__23189 = (i__19429__auto___23188 + (1));
i__19429__auto___23188 = G__23189;
continue;
} else {
}
break;
}

var G__23118 = args23116.length;
switch (G__23118) {
case 2:
return cljs.core.async.map.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.map.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23116.length)].join('')));

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
var c__21172__auto___23191 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23191,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23191,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function (state_23157){
var state_val_23158 = (state_23157[(1)]);
if((state_val_23158 === (7))){
var state_23157__$1 = state_23157;
var statearr_23159_23192 = state_23157__$1;
(statearr_23159_23192[(2)] = null);

(statearr_23159_23192[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (1))){
var state_23157__$1 = state_23157;
var statearr_23160_23193 = state_23157__$1;
(statearr_23160_23193[(2)] = null);

(statearr_23160_23193[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (4))){
var inst_23121 = (state_23157[(7)]);
var inst_23123 = (inst_23121 < cnt);
var state_23157__$1 = state_23157;
if(cljs.core.truth_(inst_23123)){
var statearr_23161_23194 = state_23157__$1;
(statearr_23161_23194[(1)] = (6));

} else {
var statearr_23162_23195 = state_23157__$1;
(statearr_23162_23195[(1)] = (7));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (15))){
var inst_23153 = (state_23157[(2)]);
var state_23157__$1 = state_23157;
var statearr_23163_23196 = state_23157__$1;
(statearr_23163_23196[(2)] = inst_23153);

(statearr_23163_23196[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (13))){
var inst_23146 = cljs.core.async.close_BANG_.call(null,out);
var state_23157__$1 = state_23157;
var statearr_23164_23197 = state_23157__$1;
(statearr_23164_23197[(2)] = inst_23146);

(statearr_23164_23197[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (6))){
var state_23157__$1 = state_23157;
var statearr_23165_23198 = state_23157__$1;
(statearr_23165_23198[(2)] = null);

(statearr_23165_23198[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (3))){
var inst_23155 = (state_23157[(2)]);
var state_23157__$1 = state_23157;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23157__$1,inst_23155);
} else {
if((state_val_23158 === (12))){
var inst_23143 = (state_23157[(8)]);
var inst_23143__$1 = (state_23157[(2)]);
var inst_23144 = cljs.core.some.call(null,cljs.core.nil_QMARK_,inst_23143__$1);
var state_23157__$1 = (function (){var statearr_23166 = state_23157;
(statearr_23166[(8)] = inst_23143__$1);

return statearr_23166;
})();
if(cljs.core.truth_(inst_23144)){
var statearr_23167_23199 = state_23157__$1;
(statearr_23167_23199[(1)] = (13));

} else {
var statearr_23168_23200 = state_23157__$1;
(statearr_23168_23200[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (2))){
var inst_23120 = cljs.core.reset_BANG_.call(null,dctr,cnt);
var inst_23121 = (0);
var state_23157__$1 = (function (){var statearr_23169 = state_23157;
(statearr_23169[(7)] = inst_23121);

(statearr_23169[(9)] = inst_23120);

return statearr_23169;
})();
var statearr_23170_23201 = state_23157__$1;
(statearr_23170_23201[(2)] = null);

(statearr_23170_23201[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (11))){
var inst_23121 = (state_23157[(7)]);
var _ = cljs.core.async.impl.ioc_helpers.add_exception_frame.call(null,state_23157,(10),Object,null,(9));
var inst_23130 = chs__$1.call(null,inst_23121);
var inst_23131 = done.call(null,inst_23121);
var inst_23132 = cljs.core.async.take_BANG_.call(null,inst_23130,inst_23131);
var state_23157__$1 = state_23157;
var statearr_23171_23202 = state_23157__$1;
(statearr_23171_23202[(2)] = inst_23132);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23157__$1);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (9))){
var inst_23121 = (state_23157[(7)]);
var inst_23134 = (state_23157[(2)]);
var inst_23135 = (inst_23121 + (1));
var inst_23121__$1 = inst_23135;
var state_23157__$1 = (function (){var statearr_23172 = state_23157;
(statearr_23172[(7)] = inst_23121__$1);

(statearr_23172[(10)] = inst_23134);

return statearr_23172;
})();
var statearr_23173_23203 = state_23157__$1;
(statearr_23173_23203[(2)] = null);

(statearr_23173_23203[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (5))){
var inst_23141 = (state_23157[(2)]);
var state_23157__$1 = (function (){var statearr_23174 = state_23157;
(statearr_23174[(11)] = inst_23141);

return statearr_23174;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23157__$1,(12),dchan);
} else {
if((state_val_23158 === (14))){
var inst_23143 = (state_23157[(8)]);
var inst_23148 = cljs.core.apply.call(null,f,inst_23143);
var state_23157__$1 = state_23157;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23157__$1,(16),out,inst_23148);
} else {
if((state_val_23158 === (16))){
var inst_23150 = (state_23157[(2)]);
var state_23157__$1 = (function (){var statearr_23175 = state_23157;
(statearr_23175[(12)] = inst_23150);

return statearr_23175;
})();
var statearr_23176_23204 = state_23157__$1;
(statearr_23176_23204[(2)] = null);

(statearr_23176_23204[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (10))){
var inst_23125 = (state_23157[(2)]);
var inst_23126 = cljs.core.swap_BANG_.call(null,dctr,cljs.core.dec);
var state_23157__$1 = (function (){var statearr_23177 = state_23157;
(statearr_23177[(13)] = inst_23125);

return statearr_23177;
})();
var statearr_23178_23205 = state_23157__$1;
(statearr_23178_23205[(2)] = inst_23126);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23157__$1);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23158 === (8))){
var inst_23139 = (state_23157[(2)]);
var state_23157__$1 = state_23157;
var statearr_23179_23206 = state_23157__$1;
(statearr_23179_23206[(2)] = inst_23139);

(statearr_23179_23206[(1)] = (5));


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
});})(c__21172__auto___23191,chs__$1,out,cnt,rets,dchan,dctr,done))
;
return ((function (switch__21060__auto__,c__21172__auto___23191,chs__$1,out,cnt,rets,dchan,dctr,done){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23183 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23183[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23183[(1)] = (1));

return statearr_23183;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23157){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23157);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23184){if((e23184 instanceof Object)){
var ex__21064__auto__ = e23184;
var statearr_23185_23207 = state_23157;
(statearr_23185_23207[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23157);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23184;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23208 = state_23157;
state_23157 = G__23208;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23157){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23157);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23191,chs__$1,out,cnt,rets,dchan,dctr,done))
})();
var state__21174__auto__ = (function (){var statearr_23186 = f__21173__auto__.call(null);
(statearr_23186[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23191);

return statearr_23186;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23191,chs__$1,out,cnt,rets,dchan,dctr,done))
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
var args23210 = [];
var len__19428__auto___23266 = arguments.length;
var i__19429__auto___23267 = (0);
while(true){
if((i__19429__auto___23267 < len__19428__auto___23266)){
args23210.push((arguments[i__19429__auto___23267]));

var G__23268 = (i__19429__auto___23267 + (1));
i__19429__auto___23267 = G__23268;
continue;
} else {
}
break;
}

var G__23212 = args23210.length;
switch (G__23212) {
case 1:
return cljs.core.async.merge.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.merge.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23210.length)].join('')));

}
});

cljs.core.async.merge.cljs$core$IFn$_invoke$arity$1 = (function (chs){
return cljs.core.async.merge.call(null,chs,null);
});

cljs.core.async.merge.cljs$core$IFn$_invoke$arity$2 = (function (chs,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21172__auto___23270 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23270,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23270,out){
return (function (state_23242){
var state_val_23243 = (state_23242[(1)]);
if((state_val_23243 === (7))){
var inst_23222 = (state_23242[(7)]);
var inst_23221 = (state_23242[(8)]);
var inst_23221__$1 = (state_23242[(2)]);
var inst_23222__$1 = cljs.core.nth.call(null,inst_23221__$1,(0),null);
var inst_23223 = cljs.core.nth.call(null,inst_23221__$1,(1),null);
var inst_23224 = (inst_23222__$1 == null);
var state_23242__$1 = (function (){var statearr_23244 = state_23242;
(statearr_23244[(9)] = inst_23223);

(statearr_23244[(7)] = inst_23222__$1);

(statearr_23244[(8)] = inst_23221__$1);

return statearr_23244;
})();
if(cljs.core.truth_(inst_23224)){
var statearr_23245_23271 = state_23242__$1;
(statearr_23245_23271[(1)] = (8));

} else {
var statearr_23246_23272 = state_23242__$1;
(statearr_23246_23272[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (1))){
var inst_23213 = cljs.core.vec.call(null,chs);
var inst_23214 = inst_23213;
var state_23242__$1 = (function (){var statearr_23247 = state_23242;
(statearr_23247[(10)] = inst_23214);

return statearr_23247;
})();
var statearr_23248_23273 = state_23242__$1;
(statearr_23248_23273[(2)] = null);

(statearr_23248_23273[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (4))){
var inst_23214 = (state_23242[(10)]);
var state_23242__$1 = state_23242;
return cljs.core.async.ioc_alts_BANG_.call(null,state_23242__$1,(7),inst_23214);
} else {
if((state_val_23243 === (6))){
var inst_23238 = (state_23242[(2)]);
var state_23242__$1 = state_23242;
var statearr_23249_23274 = state_23242__$1;
(statearr_23249_23274[(2)] = inst_23238);

(statearr_23249_23274[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (3))){
var inst_23240 = (state_23242[(2)]);
var state_23242__$1 = state_23242;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23242__$1,inst_23240);
} else {
if((state_val_23243 === (2))){
var inst_23214 = (state_23242[(10)]);
var inst_23216 = cljs.core.count.call(null,inst_23214);
var inst_23217 = (inst_23216 > (0));
var state_23242__$1 = state_23242;
if(cljs.core.truth_(inst_23217)){
var statearr_23251_23275 = state_23242__$1;
(statearr_23251_23275[(1)] = (4));

} else {
var statearr_23252_23276 = state_23242__$1;
(statearr_23252_23276[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (11))){
var inst_23214 = (state_23242[(10)]);
var inst_23231 = (state_23242[(2)]);
var tmp23250 = inst_23214;
var inst_23214__$1 = tmp23250;
var state_23242__$1 = (function (){var statearr_23253 = state_23242;
(statearr_23253[(11)] = inst_23231);

(statearr_23253[(10)] = inst_23214__$1);

return statearr_23253;
})();
var statearr_23254_23277 = state_23242__$1;
(statearr_23254_23277[(2)] = null);

(statearr_23254_23277[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (9))){
var inst_23222 = (state_23242[(7)]);
var state_23242__$1 = state_23242;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23242__$1,(11),out,inst_23222);
} else {
if((state_val_23243 === (5))){
var inst_23236 = cljs.core.async.close_BANG_.call(null,out);
var state_23242__$1 = state_23242;
var statearr_23255_23278 = state_23242__$1;
(statearr_23255_23278[(2)] = inst_23236);

(statearr_23255_23278[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (10))){
var inst_23234 = (state_23242[(2)]);
var state_23242__$1 = state_23242;
var statearr_23256_23279 = state_23242__$1;
(statearr_23256_23279[(2)] = inst_23234);

(statearr_23256_23279[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23243 === (8))){
var inst_23223 = (state_23242[(9)]);
var inst_23222 = (state_23242[(7)]);
var inst_23221 = (state_23242[(8)]);
var inst_23214 = (state_23242[(10)]);
var inst_23226 = (function (){var cs = inst_23214;
var vec__23219 = inst_23221;
var v = inst_23222;
var c = inst_23223;
return ((function (cs,vec__23219,v,c,inst_23223,inst_23222,inst_23221,inst_23214,state_val_23243,c__21172__auto___23270,out){
return (function (p1__23209_SHARP_){
return cljs.core.not_EQ_.call(null,c,p1__23209_SHARP_);
});
;})(cs,vec__23219,v,c,inst_23223,inst_23222,inst_23221,inst_23214,state_val_23243,c__21172__auto___23270,out))
})();
var inst_23227 = cljs.core.filterv.call(null,inst_23226,inst_23214);
var inst_23214__$1 = inst_23227;
var state_23242__$1 = (function (){var statearr_23257 = state_23242;
(statearr_23257[(10)] = inst_23214__$1);

return statearr_23257;
})();
var statearr_23258_23280 = state_23242__$1;
(statearr_23258_23280[(2)] = null);

(statearr_23258_23280[(1)] = (2));


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
});})(c__21172__auto___23270,out))
;
return ((function (switch__21060__auto__,c__21172__auto___23270,out){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23262 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23262[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23262[(1)] = (1));

return statearr_23262;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23242){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23242);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23263){if((e23263 instanceof Object)){
var ex__21064__auto__ = e23263;
var statearr_23264_23281 = state_23242;
(statearr_23264_23281[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23242);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23263;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23282 = state_23242;
state_23242 = G__23282;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23242){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23242);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23270,out))
})();
var state__21174__auto__ = (function (){var statearr_23265 = f__21173__auto__.call(null);
(statearr_23265[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23270);

return statearr_23265;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23270,out))
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
var args23283 = [];
var len__19428__auto___23332 = arguments.length;
var i__19429__auto___23333 = (0);
while(true){
if((i__19429__auto___23333 < len__19428__auto___23332)){
args23283.push((arguments[i__19429__auto___23333]));

var G__23334 = (i__19429__auto___23333 + (1));
i__19429__auto___23333 = G__23334;
continue;
} else {
}
break;
}

var G__23285 = args23283.length;
switch (G__23285) {
case 2:
return cljs.core.async.take.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.take.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23283.length)].join('')));

}
});

cljs.core.async.take.cljs$core$IFn$_invoke$arity$2 = (function (n,ch){
return cljs.core.async.take.call(null,n,ch,null);
});

cljs.core.async.take.cljs$core$IFn$_invoke$arity$3 = (function (n,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21172__auto___23336 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23336,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23336,out){
return (function (state_23309){
var state_val_23310 = (state_23309[(1)]);
if((state_val_23310 === (7))){
var inst_23291 = (state_23309[(7)]);
var inst_23291__$1 = (state_23309[(2)]);
var inst_23292 = (inst_23291__$1 == null);
var inst_23293 = cljs.core.not.call(null,inst_23292);
var state_23309__$1 = (function (){var statearr_23311 = state_23309;
(statearr_23311[(7)] = inst_23291__$1);

return statearr_23311;
})();
if(inst_23293){
var statearr_23312_23337 = state_23309__$1;
(statearr_23312_23337[(1)] = (8));

} else {
var statearr_23313_23338 = state_23309__$1;
(statearr_23313_23338[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (1))){
var inst_23286 = (0);
var state_23309__$1 = (function (){var statearr_23314 = state_23309;
(statearr_23314[(8)] = inst_23286);

return statearr_23314;
})();
var statearr_23315_23339 = state_23309__$1;
(statearr_23315_23339[(2)] = null);

(statearr_23315_23339[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (4))){
var state_23309__$1 = state_23309;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23309__$1,(7),ch);
} else {
if((state_val_23310 === (6))){
var inst_23304 = (state_23309[(2)]);
var state_23309__$1 = state_23309;
var statearr_23316_23340 = state_23309__$1;
(statearr_23316_23340[(2)] = inst_23304);

(statearr_23316_23340[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (3))){
var inst_23306 = (state_23309[(2)]);
var inst_23307 = cljs.core.async.close_BANG_.call(null,out);
var state_23309__$1 = (function (){var statearr_23317 = state_23309;
(statearr_23317[(9)] = inst_23306);

return statearr_23317;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23309__$1,inst_23307);
} else {
if((state_val_23310 === (2))){
var inst_23286 = (state_23309[(8)]);
var inst_23288 = (inst_23286 < n);
var state_23309__$1 = state_23309;
if(cljs.core.truth_(inst_23288)){
var statearr_23318_23341 = state_23309__$1;
(statearr_23318_23341[(1)] = (4));

} else {
var statearr_23319_23342 = state_23309__$1;
(statearr_23319_23342[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (11))){
var inst_23286 = (state_23309[(8)]);
var inst_23296 = (state_23309[(2)]);
var inst_23297 = (inst_23286 + (1));
var inst_23286__$1 = inst_23297;
var state_23309__$1 = (function (){var statearr_23320 = state_23309;
(statearr_23320[(10)] = inst_23296);

(statearr_23320[(8)] = inst_23286__$1);

return statearr_23320;
})();
var statearr_23321_23343 = state_23309__$1;
(statearr_23321_23343[(2)] = null);

(statearr_23321_23343[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (9))){
var state_23309__$1 = state_23309;
var statearr_23322_23344 = state_23309__$1;
(statearr_23322_23344[(2)] = null);

(statearr_23322_23344[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (5))){
var state_23309__$1 = state_23309;
var statearr_23323_23345 = state_23309__$1;
(statearr_23323_23345[(2)] = null);

(statearr_23323_23345[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (10))){
var inst_23301 = (state_23309[(2)]);
var state_23309__$1 = state_23309;
var statearr_23324_23346 = state_23309__$1;
(statearr_23324_23346[(2)] = inst_23301);

(statearr_23324_23346[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23310 === (8))){
var inst_23291 = (state_23309[(7)]);
var state_23309__$1 = state_23309;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23309__$1,(11),out,inst_23291);
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
});})(c__21172__auto___23336,out))
;
return ((function (switch__21060__auto__,c__21172__auto___23336,out){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23328 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_23328[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23328[(1)] = (1));

return statearr_23328;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23309){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23309);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23329){if((e23329 instanceof Object)){
var ex__21064__auto__ = e23329;
var statearr_23330_23347 = state_23309;
(statearr_23330_23347[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23309);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23329;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23348 = state_23309;
state_23309 = G__23348;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23309){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23309);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23336,out))
})();
var state__21174__auto__ = (function (){var statearr_23331 = f__21173__auto__.call(null);
(statearr_23331[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23336);

return statearr_23331;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23336,out))
);


return out;
});

cljs.core.async.take.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.map_LT_ = (function cljs$core$async$map_LT_(f,ch){
if(typeof cljs.core.async.t_cljs$core$async23356 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23356 = (function (map_LT_,f,ch,meta23357){
this.map_LT_ = map_LT_;
this.f = f;
this.ch = ch;
this.meta23357 = meta23357;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23358,meta23357__$1){
var self__ = this;
var _23358__$1 = this;
return (new cljs.core.async.t_cljs$core$async23356(self__.map_LT_,self__.f,self__.ch,meta23357__$1));
});

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23358){
var self__ = this;
var _23358__$1 = this;
return self__.meta23357;
});

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$Channel$closed_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
var ret = cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,(function (){
if(typeof cljs.core.async.t_cljs$core$async23359 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Handler}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23359 = (function (map_LT_,f,ch,meta23357,_,fn1,meta23360){
this.map_LT_ = map_LT_;
this.f = f;
this.ch = ch;
this.meta23357 = meta23357;
this._ = _;
this.fn1 = fn1;
this.meta23360 = meta23360;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23359.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = ((function (___$1){
return (function (_23361,meta23360__$1){
var self__ = this;
var _23361__$1 = this;
return (new cljs.core.async.t_cljs$core$async23359(self__.map_LT_,self__.f,self__.ch,self__.meta23357,self__._,self__.fn1,meta23360__$1));
});})(___$1))
;

cljs.core.async.t_cljs$core$async23359.prototype.cljs$core$IMeta$_meta$arity$1 = ((function (___$1){
return (function (_23361){
var self__ = this;
var _23361__$1 = this;
return self__.meta23360;
});})(___$1))
;

cljs.core.async.t_cljs$core$async23359.prototype.cljs$core$async$impl$protocols$Handler$ = true;

cljs.core.async.t_cljs$core$async23359.prototype.cljs$core$async$impl$protocols$Handler$active_QMARK_$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
return cljs.core.async.impl.protocols.active_QMARK_.call(null,self__.fn1);
});})(___$1))
;

cljs.core.async.t_cljs$core$async23359.prototype.cljs$core$async$impl$protocols$Handler$blockable_QMARK_$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
return true;
});})(___$1))
;

cljs.core.async.t_cljs$core$async23359.prototype.cljs$core$async$impl$protocols$Handler$commit$arity$1 = ((function (___$1){
return (function (___$1){
var self__ = this;
var ___$2 = this;
var f1 = cljs.core.async.impl.protocols.commit.call(null,self__.fn1);
return ((function (f1,___$2,___$1){
return (function (p1__23349_SHARP_){
return f1.call(null,(((p1__23349_SHARP_ == null))?null:self__.f.call(null,p1__23349_SHARP_)));
});
;})(f1,___$2,___$1))
});})(___$1))
;

cljs.core.async.t_cljs$core$async23359.getBasis = ((function (___$1){
return (function (){
return new cljs.core.PersistentVector(null, 7, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map<","map<",-1235808357,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23357","meta23357",-623074436,null),cljs.core.with_meta(new cljs.core.Symbol(null,"_","_",-1201019570,null),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"tag","tag",-1290361223),new cljs.core.Symbol("cljs.core.async","t_cljs$core$async23356","cljs.core.async/t_cljs$core$async23356",2147241610,null)], null)),new cljs.core.Symbol(null,"fn1","fn1",895834444,null),new cljs.core.Symbol(null,"meta23360","meta23360",-1159235346,null)], null);
});})(___$1))
;

cljs.core.async.t_cljs$core$async23359.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23359.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23359";

cljs.core.async.t_cljs$core$async23359.cljs$lang$ctorPrWriter = ((function (___$1){
return (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23359");
});})(___$1))
;

cljs.core.async.__GT_t_cljs$core$async23359 = ((function (___$1){
return (function cljs$core$async$map_LT__$___GT_t_cljs$core$async23359(map_LT___$1,f__$1,ch__$1,meta23357__$1,___$2,fn1__$1,meta23360){
return (new cljs.core.async.t_cljs$core$async23359(map_LT___$1,f__$1,ch__$1,meta23357__$1,___$2,fn1__$1,meta23360));
});})(___$1))
;

}

return (new cljs.core.async.t_cljs$core$async23359(self__.map_LT_,self__.f,self__.ch,self__.meta23357,___$1,fn1,cljs.core.PersistentArrayMap.EMPTY));
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

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23356.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,val,fn1);
});

cljs.core.async.t_cljs$core$async23356.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map<","map<",-1235808357,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23357","meta23357",-623074436,null)], null);
});

cljs.core.async.t_cljs$core$async23356.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23356.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23356";

cljs.core.async.t_cljs$core$async23356.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23356");
});

cljs.core.async.__GT_t_cljs$core$async23356 = (function cljs$core$async$map_LT__$___GT_t_cljs$core$async23356(map_LT___$1,f__$1,ch__$1,meta23357){
return (new cljs.core.async.t_cljs$core$async23356(map_LT___$1,f__$1,ch__$1,meta23357));
});

}

return (new cljs.core.async.t_cljs$core$async23356(cljs$core$async$map_LT_,f,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.map_GT_ = (function cljs$core$async$map_GT_(f,ch){
if(typeof cljs.core.async.t_cljs$core$async23365 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23365 = (function (map_GT_,f,ch,meta23366){
this.map_GT_ = map_GT_;
this.f = f;
this.ch = ch;
this.meta23366 = meta23366;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23367,meta23366__$1){
var self__ = this;
var _23367__$1 = this;
return (new cljs.core.async.t_cljs$core$async23365(self__.map_GT_,self__.f,self__.ch,meta23366__$1));
});

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23367){
var self__ = this;
var _23367__$1 = this;
return self__.meta23366;
});

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,fn1);
});

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23365.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,self__.f.call(null,val),fn1);
});

cljs.core.async.t_cljs$core$async23365.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"map>","map>",1676369295,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"f","f",43394975,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23366","meta23366",-734022749,null)], null);
});

cljs.core.async.t_cljs$core$async23365.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23365.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23365";

cljs.core.async.t_cljs$core$async23365.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23365");
});

cljs.core.async.__GT_t_cljs$core$async23365 = (function cljs$core$async$map_GT__$___GT_t_cljs$core$async23365(map_GT___$1,f__$1,ch__$1,meta23366){
return (new cljs.core.async.t_cljs$core$async23365(map_GT___$1,f__$1,ch__$1,meta23366));
});

}

return (new cljs.core.async.t_cljs$core$async23365(cljs$core$async$map_GT_,f,ch,cljs.core.PersistentArrayMap.EMPTY));
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.filter_GT_ = (function cljs$core$async$filter_GT_(p,ch){
if(typeof cljs.core.async.t_cljs$core$async23371 !== 'undefined'){
} else {

/**
* @constructor
 * @implements {cljs.core.async.impl.protocols.Channel}
 * @implements {cljs.core.async.impl.protocols.WritePort}
 * @implements {cljs.core.async.impl.protocols.ReadPort}
 * @implements {cljs.core.IMeta}
 * @implements {cljs.core.IWithMeta}
*/
cljs.core.async.t_cljs$core$async23371 = (function (filter_GT_,p,ch,meta23372){
this.filter_GT_ = filter_GT_;
this.p = p;
this.ch = ch;
this.meta23372 = meta23372;
this.cljs$lang$protocol_mask$partition0$ = 393216;
this.cljs$lang$protocol_mask$partition1$ = 0;
})
cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$IWithMeta$_with_meta$arity$2 = (function (_23373,meta23372__$1){
var self__ = this;
var _23373__$1 = this;
return (new cljs.core.async.t_cljs$core$async23371(self__.filter_GT_,self__.p,self__.ch,meta23372__$1));
});

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$IMeta$_meta$arity$1 = (function (_23373){
var self__ = this;
var _23373__$1 = this;
return self__.meta23372;
});

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$Channel$ = true;

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$Channel$close_BANG_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.close_BANG_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$Channel$closed_QMARK_$arity$1 = (function (_){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch);
});

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$ReadPort$ = true;

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$ReadPort$take_BANG_$arity$2 = (function (_,fn1){
var self__ = this;
var ___$1 = this;
return cljs.core.async.impl.protocols.take_BANG_.call(null,self__.ch,fn1);
});

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$WritePort$ = true;

cljs.core.async.t_cljs$core$async23371.prototype.cljs$core$async$impl$protocols$WritePort$put_BANG_$arity$3 = (function (_,val,fn1){
var self__ = this;
var ___$1 = this;
if(cljs.core.truth_(self__.p.call(null,val))){
return cljs.core.async.impl.protocols.put_BANG_.call(null,self__.ch,val,fn1);
} else {
return cljs.core.async.impl.channels.box.call(null,cljs.core.not.call(null,cljs.core.async.impl.protocols.closed_QMARK_.call(null,self__.ch)));
}
});

cljs.core.async.t_cljs$core$async23371.getBasis = (function (){
return new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.with_meta(new cljs.core.Symbol(null,"filter>","filter>",-37644455,null),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"arglists","arglists",1661989754),cljs.core.list(new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.list(new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Symbol(null,"p","p",1791580836,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null)], null))),new cljs.core.Keyword(null,"doc","doc",1913296891),"Deprecated - this function will be removed. Use transducer instead"], null)),new cljs.core.Symbol(null,"p","p",1791580836,null),new cljs.core.Symbol(null,"ch","ch",1085813622,null),new cljs.core.Symbol(null,"meta23372","meta23372",-2073255450,null)], null);
});

cljs.core.async.t_cljs$core$async23371.cljs$lang$type = true;

cljs.core.async.t_cljs$core$async23371.cljs$lang$ctorStr = "cljs.core.async/t_cljs$core$async23371";

cljs.core.async.t_cljs$core$async23371.cljs$lang$ctorPrWriter = (function (this__18968__auto__,writer__18969__auto__,opt__18970__auto__){
return cljs.core._write.call(null,writer__18969__auto__,"cljs.core.async/t_cljs$core$async23371");
});

cljs.core.async.__GT_t_cljs$core$async23371 = (function cljs$core$async$filter_GT__$___GT_t_cljs$core$async23371(filter_GT___$1,p__$1,ch__$1,meta23372){
return (new cljs.core.async.t_cljs$core$async23371(filter_GT___$1,p__$1,ch__$1,meta23372));
});

}

return (new cljs.core.async.t_cljs$core$async23371(cljs$core$async$filter_GT_,p,ch,cljs.core.PersistentArrayMap.EMPTY));
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
var args23374 = [];
var len__19428__auto___23418 = arguments.length;
var i__19429__auto___23419 = (0);
while(true){
if((i__19429__auto___23419 < len__19428__auto___23418)){
args23374.push((arguments[i__19429__auto___23419]));

var G__23420 = (i__19429__auto___23419 + (1));
i__19429__auto___23419 = G__23420;
continue;
} else {
}
break;
}

var G__23376 = args23374.length;
switch (G__23376) {
case 2:
return cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23374.length)].join('')));

}
});

cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$2 = (function (p,ch){
return cljs.core.async.filter_LT_.call(null,p,ch,null);
});

cljs.core.async.filter_LT_.cljs$core$IFn$_invoke$arity$3 = (function (p,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21172__auto___23422 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23422,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23422,out){
return (function (state_23397){
var state_val_23398 = (state_23397[(1)]);
if((state_val_23398 === (7))){
var inst_23393 = (state_23397[(2)]);
var state_23397__$1 = state_23397;
var statearr_23399_23423 = state_23397__$1;
(statearr_23399_23423[(2)] = inst_23393);

(statearr_23399_23423[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (1))){
var state_23397__$1 = state_23397;
var statearr_23400_23424 = state_23397__$1;
(statearr_23400_23424[(2)] = null);

(statearr_23400_23424[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (4))){
var inst_23379 = (state_23397[(7)]);
var inst_23379__$1 = (state_23397[(2)]);
var inst_23380 = (inst_23379__$1 == null);
var state_23397__$1 = (function (){var statearr_23401 = state_23397;
(statearr_23401[(7)] = inst_23379__$1);

return statearr_23401;
})();
if(cljs.core.truth_(inst_23380)){
var statearr_23402_23425 = state_23397__$1;
(statearr_23402_23425[(1)] = (5));

} else {
var statearr_23403_23426 = state_23397__$1;
(statearr_23403_23426[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (6))){
var inst_23379 = (state_23397[(7)]);
var inst_23384 = p.call(null,inst_23379);
var state_23397__$1 = state_23397;
if(cljs.core.truth_(inst_23384)){
var statearr_23404_23427 = state_23397__$1;
(statearr_23404_23427[(1)] = (8));

} else {
var statearr_23405_23428 = state_23397__$1;
(statearr_23405_23428[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (3))){
var inst_23395 = (state_23397[(2)]);
var state_23397__$1 = state_23397;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23397__$1,inst_23395);
} else {
if((state_val_23398 === (2))){
var state_23397__$1 = state_23397;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23397__$1,(4),ch);
} else {
if((state_val_23398 === (11))){
var inst_23387 = (state_23397[(2)]);
var state_23397__$1 = state_23397;
var statearr_23406_23429 = state_23397__$1;
(statearr_23406_23429[(2)] = inst_23387);

(statearr_23406_23429[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (9))){
var state_23397__$1 = state_23397;
var statearr_23407_23430 = state_23397__$1;
(statearr_23407_23430[(2)] = null);

(statearr_23407_23430[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (5))){
var inst_23382 = cljs.core.async.close_BANG_.call(null,out);
var state_23397__$1 = state_23397;
var statearr_23408_23431 = state_23397__$1;
(statearr_23408_23431[(2)] = inst_23382);

(statearr_23408_23431[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (10))){
var inst_23390 = (state_23397[(2)]);
var state_23397__$1 = (function (){var statearr_23409 = state_23397;
(statearr_23409[(8)] = inst_23390);

return statearr_23409;
})();
var statearr_23410_23432 = state_23397__$1;
(statearr_23410_23432[(2)] = null);

(statearr_23410_23432[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23398 === (8))){
var inst_23379 = (state_23397[(7)]);
var state_23397__$1 = state_23397;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23397__$1,(11),out,inst_23379);
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
});})(c__21172__auto___23422,out))
;
return ((function (switch__21060__auto__,c__21172__auto___23422,out){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23414 = [null,null,null,null,null,null,null,null,null];
(statearr_23414[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23414[(1)] = (1));

return statearr_23414;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23397){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23397);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23415){if((e23415 instanceof Object)){
var ex__21064__auto__ = e23415;
var statearr_23416_23433 = state_23397;
(statearr_23416_23433[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23397);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23415;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23434 = state_23397;
state_23397 = G__23434;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23397){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23397);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23422,out))
})();
var state__21174__auto__ = (function (){var statearr_23417 = f__21173__auto__.call(null);
(statearr_23417[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23422);

return statearr_23417;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23422,out))
);


return out;
});

cljs.core.async.filter_LT_.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.remove_LT_ = (function cljs$core$async$remove_LT_(var_args){
var args23435 = [];
var len__19428__auto___23438 = arguments.length;
var i__19429__auto___23439 = (0);
while(true){
if((i__19429__auto___23439 < len__19428__auto___23438)){
args23435.push((arguments[i__19429__auto___23439]));

var G__23440 = (i__19429__auto___23439 + (1));
i__19429__auto___23439 = G__23440;
continue;
} else {
}
break;
}

var G__23437 = args23435.length;
switch (G__23437) {
case 2:
return cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.remove_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23435.length)].join('')));

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
var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__){
return (function (state_23607){
var state_val_23608 = (state_23607[(1)]);
if((state_val_23608 === (7))){
var inst_23603 = (state_23607[(2)]);
var state_23607__$1 = state_23607;
var statearr_23609_23650 = state_23607__$1;
(statearr_23609_23650[(2)] = inst_23603);

(statearr_23609_23650[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (20))){
var inst_23573 = (state_23607[(7)]);
var inst_23584 = (state_23607[(2)]);
var inst_23585 = cljs.core.next.call(null,inst_23573);
var inst_23559 = inst_23585;
var inst_23560 = null;
var inst_23561 = (0);
var inst_23562 = (0);
var state_23607__$1 = (function (){var statearr_23610 = state_23607;
(statearr_23610[(8)] = inst_23560);

(statearr_23610[(9)] = inst_23562);

(statearr_23610[(10)] = inst_23561);

(statearr_23610[(11)] = inst_23584);

(statearr_23610[(12)] = inst_23559);

return statearr_23610;
})();
var statearr_23611_23651 = state_23607__$1;
(statearr_23611_23651[(2)] = null);

(statearr_23611_23651[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (1))){
var state_23607__$1 = state_23607;
var statearr_23612_23652 = state_23607__$1;
(statearr_23612_23652[(2)] = null);

(statearr_23612_23652[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (4))){
var inst_23548 = (state_23607[(13)]);
var inst_23548__$1 = (state_23607[(2)]);
var inst_23549 = (inst_23548__$1 == null);
var state_23607__$1 = (function (){var statearr_23613 = state_23607;
(statearr_23613[(13)] = inst_23548__$1);

return statearr_23613;
})();
if(cljs.core.truth_(inst_23549)){
var statearr_23614_23653 = state_23607__$1;
(statearr_23614_23653[(1)] = (5));

} else {
var statearr_23615_23654 = state_23607__$1;
(statearr_23615_23654[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (15))){
var state_23607__$1 = state_23607;
var statearr_23619_23655 = state_23607__$1;
(statearr_23619_23655[(2)] = null);

(statearr_23619_23655[(1)] = (16));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (21))){
var state_23607__$1 = state_23607;
var statearr_23620_23656 = state_23607__$1;
(statearr_23620_23656[(2)] = null);

(statearr_23620_23656[(1)] = (23));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (13))){
var inst_23560 = (state_23607[(8)]);
var inst_23562 = (state_23607[(9)]);
var inst_23561 = (state_23607[(10)]);
var inst_23559 = (state_23607[(12)]);
var inst_23569 = (state_23607[(2)]);
var inst_23570 = (inst_23562 + (1));
var tmp23616 = inst_23560;
var tmp23617 = inst_23561;
var tmp23618 = inst_23559;
var inst_23559__$1 = tmp23618;
var inst_23560__$1 = tmp23616;
var inst_23561__$1 = tmp23617;
var inst_23562__$1 = inst_23570;
var state_23607__$1 = (function (){var statearr_23621 = state_23607;
(statearr_23621[(8)] = inst_23560__$1);

(statearr_23621[(9)] = inst_23562__$1);

(statearr_23621[(14)] = inst_23569);

(statearr_23621[(10)] = inst_23561__$1);

(statearr_23621[(12)] = inst_23559__$1);

return statearr_23621;
})();
var statearr_23622_23657 = state_23607__$1;
(statearr_23622_23657[(2)] = null);

(statearr_23622_23657[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (22))){
var state_23607__$1 = state_23607;
var statearr_23623_23658 = state_23607__$1;
(statearr_23623_23658[(2)] = null);

(statearr_23623_23658[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (6))){
var inst_23548 = (state_23607[(13)]);
var inst_23557 = f.call(null,inst_23548);
var inst_23558 = cljs.core.seq.call(null,inst_23557);
var inst_23559 = inst_23558;
var inst_23560 = null;
var inst_23561 = (0);
var inst_23562 = (0);
var state_23607__$1 = (function (){var statearr_23624 = state_23607;
(statearr_23624[(8)] = inst_23560);

(statearr_23624[(9)] = inst_23562);

(statearr_23624[(10)] = inst_23561);

(statearr_23624[(12)] = inst_23559);

return statearr_23624;
})();
var statearr_23625_23659 = state_23607__$1;
(statearr_23625_23659[(2)] = null);

(statearr_23625_23659[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (17))){
var inst_23573 = (state_23607[(7)]);
var inst_23577 = cljs.core.chunk_first.call(null,inst_23573);
var inst_23578 = cljs.core.chunk_rest.call(null,inst_23573);
var inst_23579 = cljs.core.count.call(null,inst_23577);
var inst_23559 = inst_23578;
var inst_23560 = inst_23577;
var inst_23561 = inst_23579;
var inst_23562 = (0);
var state_23607__$1 = (function (){var statearr_23626 = state_23607;
(statearr_23626[(8)] = inst_23560);

(statearr_23626[(9)] = inst_23562);

(statearr_23626[(10)] = inst_23561);

(statearr_23626[(12)] = inst_23559);

return statearr_23626;
})();
var statearr_23627_23660 = state_23607__$1;
(statearr_23627_23660[(2)] = null);

(statearr_23627_23660[(1)] = (8));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (3))){
var inst_23605 = (state_23607[(2)]);
var state_23607__$1 = state_23607;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23607__$1,inst_23605);
} else {
if((state_val_23608 === (12))){
var inst_23593 = (state_23607[(2)]);
var state_23607__$1 = state_23607;
var statearr_23628_23661 = state_23607__$1;
(statearr_23628_23661[(2)] = inst_23593);

(statearr_23628_23661[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (2))){
var state_23607__$1 = state_23607;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23607__$1,(4),in$);
} else {
if((state_val_23608 === (23))){
var inst_23601 = (state_23607[(2)]);
var state_23607__$1 = state_23607;
var statearr_23629_23662 = state_23607__$1;
(statearr_23629_23662[(2)] = inst_23601);

(statearr_23629_23662[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (19))){
var inst_23588 = (state_23607[(2)]);
var state_23607__$1 = state_23607;
var statearr_23630_23663 = state_23607__$1;
(statearr_23630_23663[(2)] = inst_23588);

(statearr_23630_23663[(1)] = (16));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (11))){
var inst_23573 = (state_23607[(7)]);
var inst_23559 = (state_23607[(12)]);
var inst_23573__$1 = cljs.core.seq.call(null,inst_23559);
var state_23607__$1 = (function (){var statearr_23631 = state_23607;
(statearr_23631[(7)] = inst_23573__$1);

return statearr_23631;
})();
if(inst_23573__$1){
var statearr_23632_23664 = state_23607__$1;
(statearr_23632_23664[(1)] = (14));

} else {
var statearr_23633_23665 = state_23607__$1;
(statearr_23633_23665[(1)] = (15));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (9))){
var inst_23595 = (state_23607[(2)]);
var inst_23596 = cljs.core.async.impl.protocols.closed_QMARK_.call(null,out);
var state_23607__$1 = (function (){var statearr_23634 = state_23607;
(statearr_23634[(15)] = inst_23595);

return statearr_23634;
})();
if(cljs.core.truth_(inst_23596)){
var statearr_23635_23666 = state_23607__$1;
(statearr_23635_23666[(1)] = (21));

} else {
var statearr_23636_23667 = state_23607__$1;
(statearr_23636_23667[(1)] = (22));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (5))){
var inst_23551 = cljs.core.async.close_BANG_.call(null,out);
var state_23607__$1 = state_23607;
var statearr_23637_23668 = state_23607__$1;
(statearr_23637_23668[(2)] = inst_23551);

(statearr_23637_23668[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (14))){
var inst_23573 = (state_23607[(7)]);
var inst_23575 = cljs.core.chunked_seq_QMARK_.call(null,inst_23573);
var state_23607__$1 = state_23607;
if(inst_23575){
var statearr_23638_23669 = state_23607__$1;
(statearr_23638_23669[(1)] = (17));

} else {
var statearr_23639_23670 = state_23607__$1;
(statearr_23639_23670[(1)] = (18));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (16))){
var inst_23591 = (state_23607[(2)]);
var state_23607__$1 = state_23607;
var statearr_23640_23671 = state_23607__$1;
(statearr_23640_23671[(2)] = inst_23591);

(statearr_23640_23671[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23608 === (10))){
var inst_23560 = (state_23607[(8)]);
var inst_23562 = (state_23607[(9)]);
var inst_23567 = cljs.core._nth.call(null,inst_23560,inst_23562);
var state_23607__$1 = state_23607;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23607__$1,(13),out,inst_23567);
} else {
if((state_val_23608 === (18))){
var inst_23573 = (state_23607[(7)]);
var inst_23582 = cljs.core.first.call(null,inst_23573);
var state_23607__$1 = state_23607;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23607__$1,(20),out,inst_23582);
} else {
if((state_val_23608 === (8))){
var inst_23562 = (state_23607[(9)]);
var inst_23561 = (state_23607[(10)]);
var inst_23564 = (inst_23562 < inst_23561);
var inst_23565 = inst_23564;
var state_23607__$1 = state_23607;
if(cljs.core.truth_(inst_23565)){
var statearr_23641_23672 = state_23607__$1;
(statearr_23641_23672[(1)] = (10));

} else {
var statearr_23642_23673 = state_23607__$1;
(statearr_23642_23673[(1)] = (11));

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
});})(c__21172__auto__))
;
return ((function (switch__21060__auto__,c__21172__auto__){
return (function() {
var cljs$core$async$mapcat_STAR__$_state_machine__21061__auto__ = null;
var cljs$core$async$mapcat_STAR__$_state_machine__21061__auto____0 = (function (){
var statearr_23646 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23646[(0)] = cljs$core$async$mapcat_STAR__$_state_machine__21061__auto__);

(statearr_23646[(1)] = (1));

return statearr_23646;
});
var cljs$core$async$mapcat_STAR__$_state_machine__21061__auto____1 = (function (state_23607){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23607);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23647){if((e23647 instanceof Object)){
var ex__21064__auto__ = e23647;
var statearr_23648_23674 = state_23607;
(statearr_23648_23674[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23607);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23647;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23675 = state_23607;
state_23607 = G__23675;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$mapcat_STAR__$_state_machine__21061__auto__ = function(state_23607){
switch(arguments.length){
case 0:
return cljs$core$async$mapcat_STAR__$_state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$mapcat_STAR__$_state_machine__21061__auto____1.call(this,state_23607);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$mapcat_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$mapcat_STAR__$_state_machine__21061__auto____0;
cljs$core$async$mapcat_STAR__$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$mapcat_STAR__$_state_machine__21061__auto____1;
return cljs$core$async$mapcat_STAR__$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__))
})();
var state__21174__auto__ = (function (){var statearr_23649 = f__21173__auto__.call(null);
(statearr_23649[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_23649;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__))
);

return c__21172__auto__;
});
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.mapcat_LT_ = (function cljs$core$async$mapcat_LT_(var_args){
var args23676 = [];
var len__19428__auto___23679 = arguments.length;
var i__19429__auto___23680 = (0);
while(true){
if((i__19429__auto___23680 < len__19428__auto___23679)){
args23676.push((arguments[i__19429__auto___23680]));

var G__23681 = (i__19429__auto___23680 + (1));
i__19429__auto___23680 = G__23681;
continue;
} else {
}
break;
}

var G__23678 = args23676.length;
switch (G__23678) {
case 2:
return cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.mapcat_LT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23676.length)].join('')));

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
var args23683 = [];
var len__19428__auto___23686 = arguments.length;
var i__19429__auto___23687 = (0);
while(true){
if((i__19429__auto___23687 < len__19428__auto___23686)){
args23683.push((arguments[i__19429__auto___23687]));

var G__23688 = (i__19429__auto___23687 + (1));
i__19429__auto___23687 = G__23688;
continue;
} else {
}
break;
}

var G__23685 = args23683.length;
switch (G__23685) {
case 2:
return cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.mapcat_GT_.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23683.length)].join('')));

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
var args23690 = [];
var len__19428__auto___23741 = arguments.length;
var i__19429__auto___23742 = (0);
while(true){
if((i__19429__auto___23742 < len__19428__auto___23741)){
args23690.push((arguments[i__19429__auto___23742]));

var G__23743 = (i__19429__auto___23742 + (1));
i__19429__auto___23742 = G__23743;
continue;
} else {
}
break;
}

var G__23692 = args23690.length;
switch (G__23692) {
case 1:
return cljs.core.async.unique.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return cljs.core.async.unique.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23690.length)].join('')));

}
});

cljs.core.async.unique.cljs$core$IFn$_invoke$arity$1 = (function (ch){
return cljs.core.async.unique.call(null,ch,null);
});

cljs.core.async.unique.cljs$core$IFn$_invoke$arity$2 = (function (ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21172__auto___23745 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23745,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23745,out){
return (function (state_23716){
var state_val_23717 = (state_23716[(1)]);
if((state_val_23717 === (7))){
var inst_23711 = (state_23716[(2)]);
var state_23716__$1 = state_23716;
var statearr_23718_23746 = state_23716__$1;
(statearr_23718_23746[(2)] = inst_23711);

(statearr_23718_23746[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (1))){
var inst_23693 = null;
var state_23716__$1 = (function (){var statearr_23719 = state_23716;
(statearr_23719[(7)] = inst_23693);

return statearr_23719;
})();
var statearr_23720_23747 = state_23716__$1;
(statearr_23720_23747[(2)] = null);

(statearr_23720_23747[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (4))){
var inst_23696 = (state_23716[(8)]);
var inst_23696__$1 = (state_23716[(2)]);
var inst_23697 = (inst_23696__$1 == null);
var inst_23698 = cljs.core.not.call(null,inst_23697);
var state_23716__$1 = (function (){var statearr_23721 = state_23716;
(statearr_23721[(8)] = inst_23696__$1);

return statearr_23721;
})();
if(inst_23698){
var statearr_23722_23748 = state_23716__$1;
(statearr_23722_23748[(1)] = (5));

} else {
var statearr_23723_23749 = state_23716__$1;
(statearr_23723_23749[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (6))){
var state_23716__$1 = state_23716;
var statearr_23724_23750 = state_23716__$1;
(statearr_23724_23750[(2)] = null);

(statearr_23724_23750[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (3))){
var inst_23713 = (state_23716[(2)]);
var inst_23714 = cljs.core.async.close_BANG_.call(null,out);
var state_23716__$1 = (function (){var statearr_23725 = state_23716;
(statearr_23725[(9)] = inst_23713);

return statearr_23725;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23716__$1,inst_23714);
} else {
if((state_val_23717 === (2))){
var state_23716__$1 = state_23716;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23716__$1,(4),ch);
} else {
if((state_val_23717 === (11))){
var inst_23696 = (state_23716[(8)]);
var inst_23705 = (state_23716[(2)]);
var inst_23693 = inst_23696;
var state_23716__$1 = (function (){var statearr_23726 = state_23716;
(statearr_23726[(10)] = inst_23705);

(statearr_23726[(7)] = inst_23693);

return statearr_23726;
})();
var statearr_23727_23751 = state_23716__$1;
(statearr_23727_23751[(2)] = null);

(statearr_23727_23751[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (9))){
var inst_23696 = (state_23716[(8)]);
var state_23716__$1 = state_23716;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23716__$1,(11),out,inst_23696);
} else {
if((state_val_23717 === (5))){
var inst_23696 = (state_23716[(8)]);
var inst_23693 = (state_23716[(7)]);
var inst_23700 = cljs.core._EQ_.call(null,inst_23696,inst_23693);
var state_23716__$1 = state_23716;
if(inst_23700){
var statearr_23729_23752 = state_23716__$1;
(statearr_23729_23752[(1)] = (8));

} else {
var statearr_23730_23753 = state_23716__$1;
(statearr_23730_23753[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (10))){
var inst_23708 = (state_23716[(2)]);
var state_23716__$1 = state_23716;
var statearr_23731_23754 = state_23716__$1;
(statearr_23731_23754[(2)] = inst_23708);

(statearr_23731_23754[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23717 === (8))){
var inst_23693 = (state_23716[(7)]);
var tmp23728 = inst_23693;
var inst_23693__$1 = tmp23728;
var state_23716__$1 = (function (){var statearr_23732 = state_23716;
(statearr_23732[(7)] = inst_23693__$1);

return statearr_23732;
})();
var statearr_23733_23755 = state_23716__$1;
(statearr_23733_23755[(2)] = null);

(statearr_23733_23755[(1)] = (2));


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
});})(c__21172__auto___23745,out))
;
return ((function (switch__21060__auto__,c__21172__auto___23745,out){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23737 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_23737[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23737[(1)] = (1));

return statearr_23737;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23716){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23716);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23738){if((e23738 instanceof Object)){
var ex__21064__auto__ = e23738;
var statearr_23739_23756 = state_23716;
(statearr_23739_23756[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23716);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23738;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23757 = state_23716;
state_23716 = G__23757;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23716){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23716);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23745,out))
})();
var state__21174__auto__ = (function (){var statearr_23740 = f__21173__auto__.call(null);
(statearr_23740[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23745);

return statearr_23740;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23745,out))
);


return out;
});

cljs.core.async.unique.cljs$lang$maxFixedArity = 2;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.partition = (function cljs$core$async$partition(var_args){
var args23758 = [];
var len__19428__auto___23828 = arguments.length;
var i__19429__auto___23829 = (0);
while(true){
if((i__19429__auto___23829 < len__19428__auto___23828)){
args23758.push((arguments[i__19429__auto___23829]));

var G__23830 = (i__19429__auto___23829 + (1));
i__19429__auto___23829 = G__23830;
continue;
} else {
}
break;
}

var G__23760 = args23758.length;
switch (G__23760) {
case 2:
return cljs.core.async.partition.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.partition.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23758.length)].join('')));

}
});

cljs.core.async.partition.cljs$core$IFn$_invoke$arity$2 = (function (n,ch){
return cljs.core.async.partition.call(null,n,ch,null);
});

cljs.core.async.partition.cljs$core$IFn$_invoke$arity$3 = (function (n,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21172__auto___23832 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23832,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23832,out){
return (function (state_23798){
var state_val_23799 = (state_23798[(1)]);
if((state_val_23799 === (7))){
var inst_23794 = (state_23798[(2)]);
var state_23798__$1 = state_23798;
var statearr_23800_23833 = state_23798__$1;
(statearr_23800_23833[(2)] = inst_23794);

(statearr_23800_23833[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (1))){
var inst_23761 = (new Array(n));
var inst_23762 = inst_23761;
var inst_23763 = (0);
var state_23798__$1 = (function (){var statearr_23801 = state_23798;
(statearr_23801[(7)] = inst_23763);

(statearr_23801[(8)] = inst_23762);

return statearr_23801;
})();
var statearr_23802_23834 = state_23798__$1;
(statearr_23802_23834[(2)] = null);

(statearr_23802_23834[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (4))){
var inst_23766 = (state_23798[(9)]);
var inst_23766__$1 = (state_23798[(2)]);
var inst_23767 = (inst_23766__$1 == null);
var inst_23768 = cljs.core.not.call(null,inst_23767);
var state_23798__$1 = (function (){var statearr_23803 = state_23798;
(statearr_23803[(9)] = inst_23766__$1);

return statearr_23803;
})();
if(inst_23768){
var statearr_23804_23835 = state_23798__$1;
(statearr_23804_23835[(1)] = (5));

} else {
var statearr_23805_23836 = state_23798__$1;
(statearr_23805_23836[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (15))){
var inst_23788 = (state_23798[(2)]);
var state_23798__$1 = state_23798;
var statearr_23806_23837 = state_23798__$1;
(statearr_23806_23837[(2)] = inst_23788);

(statearr_23806_23837[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (13))){
var state_23798__$1 = state_23798;
var statearr_23807_23838 = state_23798__$1;
(statearr_23807_23838[(2)] = null);

(statearr_23807_23838[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (6))){
var inst_23763 = (state_23798[(7)]);
var inst_23784 = (inst_23763 > (0));
var state_23798__$1 = state_23798;
if(cljs.core.truth_(inst_23784)){
var statearr_23808_23839 = state_23798__$1;
(statearr_23808_23839[(1)] = (12));

} else {
var statearr_23809_23840 = state_23798__$1;
(statearr_23809_23840[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (3))){
var inst_23796 = (state_23798[(2)]);
var state_23798__$1 = state_23798;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23798__$1,inst_23796);
} else {
if((state_val_23799 === (12))){
var inst_23762 = (state_23798[(8)]);
var inst_23786 = cljs.core.vec.call(null,inst_23762);
var state_23798__$1 = state_23798;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23798__$1,(15),out,inst_23786);
} else {
if((state_val_23799 === (2))){
var state_23798__$1 = state_23798;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23798__$1,(4),ch);
} else {
if((state_val_23799 === (11))){
var inst_23778 = (state_23798[(2)]);
var inst_23779 = (new Array(n));
var inst_23762 = inst_23779;
var inst_23763 = (0);
var state_23798__$1 = (function (){var statearr_23810 = state_23798;
(statearr_23810[(7)] = inst_23763);

(statearr_23810[(10)] = inst_23778);

(statearr_23810[(8)] = inst_23762);

return statearr_23810;
})();
var statearr_23811_23841 = state_23798__$1;
(statearr_23811_23841[(2)] = null);

(statearr_23811_23841[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (9))){
var inst_23762 = (state_23798[(8)]);
var inst_23776 = cljs.core.vec.call(null,inst_23762);
var state_23798__$1 = state_23798;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23798__$1,(11),out,inst_23776);
} else {
if((state_val_23799 === (5))){
var inst_23766 = (state_23798[(9)]);
var inst_23763 = (state_23798[(7)]);
var inst_23771 = (state_23798[(11)]);
var inst_23762 = (state_23798[(8)]);
var inst_23770 = (inst_23762[inst_23763] = inst_23766);
var inst_23771__$1 = (inst_23763 + (1));
var inst_23772 = (inst_23771__$1 < n);
var state_23798__$1 = (function (){var statearr_23812 = state_23798;
(statearr_23812[(11)] = inst_23771__$1);

(statearr_23812[(12)] = inst_23770);

return statearr_23812;
})();
if(cljs.core.truth_(inst_23772)){
var statearr_23813_23842 = state_23798__$1;
(statearr_23813_23842[(1)] = (8));

} else {
var statearr_23814_23843 = state_23798__$1;
(statearr_23814_23843[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (14))){
var inst_23791 = (state_23798[(2)]);
var inst_23792 = cljs.core.async.close_BANG_.call(null,out);
var state_23798__$1 = (function (){var statearr_23816 = state_23798;
(statearr_23816[(13)] = inst_23791);

return statearr_23816;
})();
var statearr_23817_23844 = state_23798__$1;
(statearr_23817_23844[(2)] = inst_23792);

(statearr_23817_23844[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (10))){
var inst_23782 = (state_23798[(2)]);
var state_23798__$1 = state_23798;
var statearr_23818_23845 = state_23798__$1;
(statearr_23818_23845[(2)] = inst_23782);

(statearr_23818_23845[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23799 === (8))){
var inst_23771 = (state_23798[(11)]);
var inst_23762 = (state_23798[(8)]);
var tmp23815 = inst_23762;
var inst_23762__$1 = tmp23815;
var inst_23763 = inst_23771;
var state_23798__$1 = (function (){var statearr_23819 = state_23798;
(statearr_23819[(7)] = inst_23763);

(statearr_23819[(8)] = inst_23762__$1);

return statearr_23819;
})();
var statearr_23820_23846 = state_23798__$1;
(statearr_23820_23846[(2)] = null);

(statearr_23820_23846[(1)] = (2));


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
});})(c__21172__auto___23832,out))
;
return ((function (switch__21060__auto__,c__21172__auto___23832,out){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23824 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23824[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23824[(1)] = (1));

return statearr_23824;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23798){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23798);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23825){if((e23825 instanceof Object)){
var ex__21064__auto__ = e23825;
var statearr_23826_23847 = state_23798;
(statearr_23826_23847[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23798);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23825;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23848 = state_23798;
state_23798 = G__23848;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23798){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23798);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23832,out))
})();
var state__21174__auto__ = (function (){var statearr_23827 = f__21173__auto__.call(null);
(statearr_23827[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23832);

return statearr_23827;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23832,out))
);


return out;
});

cljs.core.async.partition.cljs$lang$maxFixedArity = 3;
/**
 * Deprecated - this function will be removed. Use transducer instead
 */
cljs.core.async.partition_by = (function cljs$core$async$partition_by(var_args){
var args23849 = [];
var len__19428__auto___23923 = arguments.length;
var i__19429__auto___23924 = (0);
while(true){
if((i__19429__auto___23924 < len__19428__auto___23923)){
args23849.push((arguments[i__19429__auto___23924]));

var G__23925 = (i__19429__auto___23924 + (1));
i__19429__auto___23924 = G__23925;
continue;
} else {
}
break;
}

var G__23851 = args23849.length;
switch (G__23851) {
case 2:
return cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args23849.length)].join('')));

}
});

cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$2 = (function (f,ch){
return cljs.core.async.partition_by.call(null,f,ch,null);
});

cljs.core.async.partition_by.cljs$core$IFn$_invoke$arity$3 = (function (f,ch,buf_or_n){
var out = cljs.core.async.chan.call(null,buf_or_n);
var c__21172__auto___23927 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___23927,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___23927,out){
return (function (state_23893){
var state_val_23894 = (state_23893[(1)]);
if((state_val_23894 === (7))){
var inst_23889 = (state_23893[(2)]);
var state_23893__$1 = state_23893;
var statearr_23895_23928 = state_23893__$1;
(statearr_23895_23928[(2)] = inst_23889);

(statearr_23895_23928[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (1))){
var inst_23852 = [];
var inst_23853 = inst_23852;
var inst_23854 = new cljs.core.Keyword("cljs.core.async","nothing","cljs.core.async/nothing",-69252123);
var state_23893__$1 = (function (){var statearr_23896 = state_23893;
(statearr_23896[(7)] = inst_23854);

(statearr_23896[(8)] = inst_23853);

return statearr_23896;
})();
var statearr_23897_23929 = state_23893__$1;
(statearr_23897_23929[(2)] = null);

(statearr_23897_23929[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (4))){
var inst_23857 = (state_23893[(9)]);
var inst_23857__$1 = (state_23893[(2)]);
var inst_23858 = (inst_23857__$1 == null);
var inst_23859 = cljs.core.not.call(null,inst_23858);
var state_23893__$1 = (function (){var statearr_23898 = state_23893;
(statearr_23898[(9)] = inst_23857__$1);

return statearr_23898;
})();
if(inst_23859){
var statearr_23899_23930 = state_23893__$1;
(statearr_23899_23930[(1)] = (5));

} else {
var statearr_23900_23931 = state_23893__$1;
(statearr_23900_23931[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (15))){
var inst_23883 = (state_23893[(2)]);
var state_23893__$1 = state_23893;
var statearr_23901_23932 = state_23893__$1;
(statearr_23901_23932[(2)] = inst_23883);

(statearr_23901_23932[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (13))){
var state_23893__$1 = state_23893;
var statearr_23902_23933 = state_23893__$1;
(statearr_23902_23933[(2)] = null);

(statearr_23902_23933[(1)] = (14));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (6))){
var inst_23853 = (state_23893[(8)]);
var inst_23878 = inst_23853.length;
var inst_23879 = (inst_23878 > (0));
var state_23893__$1 = state_23893;
if(cljs.core.truth_(inst_23879)){
var statearr_23903_23934 = state_23893__$1;
(statearr_23903_23934[(1)] = (12));

} else {
var statearr_23904_23935 = state_23893__$1;
(statearr_23904_23935[(1)] = (13));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (3))){
var inst_23891 = (state_23893[(2)]);
var state_23893__$1 = state_23893;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_23893__$1,inst_23891);
} else {
if((state_val_23894 === (12))){
var inst_23853 = (state_23893[(8)]);
var inst_23881 = cljs.core.vec.call(null,inst_23853);
var state_23893__$1 = state_23893;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23893__$1,(15),out,inst_23881);
} else {
if((state_val_23894 === (2))){
var state_23893__$1 = state_23893;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_23893__$1,(4),ch);
} else {
if((state_val_23894 === (11))){
var inst_23861 = (state_23893[(10)]);
var inst_23857 = (state_23893[(9)]);
var inst_23871 = (state_23893[(2)]);
var inst_23872 = [];
var inst_23873 = inst_23872.push(inst_23857);
var inst_23853 = inst_23872;
var inst_23854 = inst_23861;
var state_23893__$1 = (function (){var statearr_23905 = state_23893;
(statearr_23905[(11)] = inst_23873);

(statearr_23905[(12)] = inst_23871);

(statearr_23905[(7)] = inst_23854);

(statearr_23905[(8)] = inst_23853);

return statearr_23905;
})();
var statearr_23906_23936 = state_23893__$1;
(statearr_23906_23936[(2)] = null);

(statearr_23906_23936[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (9))){
var inst_23853 = (state_23893[(8)]);
var inst_23869 = cljs.core.vec.call(null,inst_23853);
var state_23893__$1 = state_23893;
return cljs.core.async.impl.ioc_helpers.put_BANG_.call(null,state_23893__$1,(11),out,inst_23869);
} else {
if((state_val_23894 === (5))){
var inst_23854 = (state_23893[(7)]);
var inst_23861 = (state_23893[(10)]);
var inst_23857 = (state_23893[(9)]);
var inst_23861__$1 = f.call(null,inst_23857);
var inst_23862 = cljs.core._EQ_.call(null,inst_23861__$1,inst_23854);
var inst_23863 = cljs.core.keyword_identical_QMARK_.call(null,inst_23854,new cljs.core.Keyword("cljs.core.async","nothing","cljs.core.async/nothing",-69252123));
var inst_23864 = (inst_23862) || (inst_23863);
var state_23893__$1 = (function (){var statearr_23907 = state_23893;
(statearr_23907[(10)] = inst_23861__$1);

return statearr_23907;
})();
if(cljs.core.truth_(inst_23864)){
var statearr_23908_23937 = state_23893__$1;
(statearr_23908_23937[(1)] = (8));

} else {
var statearr_23909_23938 = state_23893__$1;
(statearr_23909_23938[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (14))){
var inst_23886 = (state_23893[(2)]);
var inst_23887 = cljs.core.async.close_BANG_.call(null,out);
var state_23893__$1 = (function (){var statearr_23911 = state_23893;
(statearr_23911[(13)] = inst_23886);

return statearr_23911;
})();
var statearr_23912_23939 = state_23893__$1;
(statearr_23912_23939[(2)] = inst_23887);

(statearr_23912_23939[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (10))){
var inst_23876 = (state_23893[(2)]);
var state_23893__$1 = state_23893;
var statearr_23913_23940 = state_23893__$1;
(statearr_23913_23940[(2)] = inst_23876);

(statearr_23913_23940[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_23894 === (8))){
var inst_23861 = (state_23893[(10)]);
var inst_23857 = (state_23893[(9)]);
var inst_23853 = (state_23893[(8)]);
var inst_23866 = inst_23853.push(inst_23857);
var tmp23910 = inst_23853;
var inst_23853__$1 = tmp23910;
var inst_23854 = inst_23861;
var state_23893__$1 = (function (){var statearr_23914 = state_23893;
(statearr_23914[(7)] = inst_23854);

(statearr_23914[(14)] = inst_23866);

(statearr_23914[(8)] = inst_23853__$1);

return statearr_23914;
})();
var statearr_23915_23941 = state_23893__$1;
(statearr_23915_23941[(2)] = null);

(statearr_23915_23941[(1)] = (2));


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
});})(c__21172__auto___23927,out))
;
return ((function (switch__21060__auto__,c__21172__auto___23927,out){
return (function() {
var cljs$core$async$state_machine__21061__auto__ = null;
var cljs$core$async$state_machine__21061__auto____0 = (function (){
var statearr_23919 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_23919[(0)] = cljs$core$async$state_machine__21061__auto__);

(statearr_23919[(1)] = (1));

return statearr_23919;
});
var cljs$core$async$state_machine__21061__auto____1 = (function (state_23893){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_23893);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e23920){if((e23920 instanceof Object)){
var ex__21064__auto__ = e23920;
var statearr_23921_23942 = state_23893;
(statearr_23921_23942[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_23893);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e23920;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__23943 = state_23893;
state_23893 = G__23943;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
cljs$core$async$state_machine__21061__auto__ = function(state_23893){
switch(arguments.length){
case 0:
return cljs$core$async$state_machine__21061__auto____0.call(this);
case 1:
return cljs$core$async$state_machine__21061__auto____1.call(this,state_23893);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = cljs$core$async$state_machine__21061__auto____0;
cljs$core$async$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = cljs$core$async$state_machine__21061__auto____1;
return cljs$core$async$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___23927,out))
})();
var state__21174__auto__ = (function (){var statearr_23922 = f__21173__auto__.call(null);
(statearr_23922[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___23927);

return statearr_23922;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___23927,out))
);


return out;
});

cljs.core.async.partition_by.cljs$lang$maxFixedArity = 3;

//# sourceMappingURL=async.js.map