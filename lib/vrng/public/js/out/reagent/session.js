// Compiled by ClojureScript 1.7.228 {:static-fns true, :optimize-constants true}
goog.provide('reagent.session');
goog.require('cljs.core');
goog.require('reagent.core');
reagent.session.state = reagent.core.atom.cljs$core$IFn$_invoke$arity$1(cljs.core.PersistentArrayMap.EMPTY);
/**
 * Get the key's value from the session, returns nil if it doesn't exist.
 */
reagent.session.get = (function reagent$session$get(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9366 = arguments.length;
var i__7212__auto___9367 = (0);
while(true){
if((i__7212__auto___9367 < len__7211__auto___9366)){
args__7218__auto__.push((arguments[i__7212__auto___9367]));

var G__9368 = (i__7212__auto___9367 + (1));
i__7212__auto___9367 = G__9368;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((1) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((1)),(0))):null);
return reagent.session.get.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7219__auto__);
});

reagent.session.get.cljs$core$IFn$_invoke$arity$variadic = (function (k,p__9364){
var vec__9365 = p__9364;
var default$ = cljs.core.nth.cljs$core$IFn$_invoke$arity$3(vec__9365,(0),null);
return cljs.core.get.cljs$core$IFn$_invoke$arity$3((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(reagent.session.state) : cljs.core.deref.call(null,reagent.session.state)),k,default$);
});

reagent.session.get.cljs$lang$maxFixedArity = (1);

reagent.session.get.cljs$lang$applyTo = (function (seq9362){
var G__9363 = cljs.core.first(seq9362);
var seq9362__$1 = cljs.core.next(seq9362);
return reagent.session.get.cljs$core$IFn$_invoke$arity$variadic(G__9363,seq9362__$1);
});
reagent.session.put_BANG_ = (function reagent$session$put_BANG_(k,v){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$4(reagent.session.state,cljs.core.assoc,k,v);
});
/**
 * Gets the value at the path specified by the vector ks from the session,
 *   returns nil if it doesn't exist.
 */
reagent.session.get_in = (function reagent$session$get_in(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9373 = arguments.length;
var i__7212__auto___9374 = (0);
while(true){
if((i__7212__auto___9374 < len__7211__auto___9373)){
args__7218__auto__.push((arguments[i__7212__auto___9374]));

var G__9375 = (i__7212__auto___9374 + (1));
i__7212__auto___9374 = G__9375;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((1) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((1)),(0))):null);
return reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7219__auto__);
});

reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic = (function (ks,p__9371){
var vec__9372 = p__9371;
var default$ = cljs.core.nth.cljs$core$IFn$_invoke$arity$3(vec__9372,(0),null);
return cljs.core.get_in.cljs$core$IFn$_invoke$arity$3((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(reagent.session.state) : cljs.core.deref.call(null,reagent.session.state)),ks,default$);
});

reagent.session.get_in.cljs$lang$maxFixedArity = (1);

reagent.session.get_in.cljs$lang$applyTo = (function (seq9369){
var G__9370 = cljs.core.first(seq9369);
var seq9369__$1 = cljs.core.next(seq9369);
return reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic(G__9370,seq9369__$1);
});
/**
 * Replace the current session's value with the result of executing f with
 *   the current value and args.
 */
reagent.session.swap_BANG_ = (function reagent$session$swap_BANG_(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9378 = arguments.length;
var i__7212__auto___9379 = (0);
while(true){
if((i__7212__auto___9379 < len__7211__auto___9378)){
args__7218__auto__.push((arguments[i__7212__auto___9379]));

var G__9380 = (i__7212__auto___9379 + (1));
i__7212__auto___9379 = G__9380;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((1) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((1)),(0))):null);
return reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7219__auto__);
});

reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (f,args){
return cljs.core.apply.cljs$core$IFn$_invoke$arity$4(cljs.core.swap_BANG_,reagent.session.state,f,args);
});

reagent.session.swap_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.swap_BANG_.cljs$lang$applyTo = (function (seq9376){
var G__9377 = cljs.core.first(seq9376);
var seq9376__$1 = cljs.core.next(seq9376);
return reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__9377,seq9376__$1);
});
/**
 * Remove all data from the session and start over cleanly.
 */
reagent.session.clear_BANG_ = (function reagent$session$clear_BANG_(){
var G__9383 = reagent.session.state;
var G__9384 = cljs.core.PersistentArrayMap.EMPTY;
return (cljs.core.reset_BANG_.cljs$core$IFn$_invoke$arity$2 ? cljs.core.reset_BANG_.cljs$core$IFn$_invoke$arity$2(G__9383,G__9384) : cljs.core.reset_BANG_.call(null,G__9383,G__9384));
});
reagent.session.reset_BANG_ = (function reagent$session$reset_BANG_(m){
return (cljs.core.reset_BANG_.cljs$core$IFn$_invoke$arity$2 ? cljs.core.reset_BANG_.cljs$core$IFn$_invoke$arity$2(reagent.session.state,m) : cljs.core.reset_BANG_.call(null,reagent.session.state,m));
});
/**
 * Remove a key from the session
 */
reagent.session.remove_BANG_ = (function reagent$session$remove_BANG_(k){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$3(reagent.session.state,cljs.core.dissoc,k);
});
/**
 * Associates a value in the session, where ks is a
 * sequence of keys and v is the new value and returns
 * a new nested structure. If any levels do not exist,
 * hash-maps will be created.
 */
reagent.session.assoc_in_BANG_ = (function reagent$session$assoc_in_BANG_(ks,v){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$2(reagent.session.state,(function (p1__9385_SHARP_){
return cljs.core.assoc_in(p1__9385_SHARP_,ks,v);
}));
});
/**
 * Destructive get from the session. This returns the current value of the key
 *   and then removes it from the session.
 */
reagent.session.get_BANG_ = (function reagent$session$get_BANG_(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9390 = arguments.length;
var i__7212__auto___9391 = (0);
while(true){
if((i__7212__auto___9391 < len__7211__auto___9390)){
args__7218__auto__.push((arguments[i__7212__auto___9391]));

var G__9392 = (i__7212__auto___9391 + (1));
i__7212__auto___9391 = G__9392;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((1) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((1)),(0))):null);
return reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7219__auto__);
});

reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (k,p__9388){
var vec__9389 = p__9388;
var default$ = cljs.core.nth.cljs$core$IFn$_invoke$arity$3(vec__9389,(0),null);
var cur = reagent.session.get.cljs$core$IFn$_invoke$arity$variadic(k,cljs.core.array_seq([default$], 0));
reagent.session.remove_BANG_(k);

return cur;
});

reagent.session.get_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.get_BANG_.cljs$lang$applyTo = (function (seq9386){
var G__9387 = cljs.core.first(seq9386);
var seq9386__$1 = cljs.core.next(seq9386);
return reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__9387,seq9386__$1);
});
/**
 * Destructive get from the session. This returns the current value of the path
 *   specified by the vector ks and then removes it from the session.
 */
reagent.session.get_in_BANG_ = (function reagent$session$get_in_BANG_(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9397 = arguments.length;
var i__7212__auto___9398 = (0);
while(true){
if((i__7212__auto___9398 < len__7211__auto___9397)){
args__7218__auto__.push((arguments[i__7212__auto___9398]));

var G__9399 = (i__7212__auto___9398 + (1));
i__7212__auto___9398 = G__9399;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((1) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((1)),(0))):null);
return reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7219__auto__);
});

reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ks,p__9395){
var vec__9396 = p__9395;
var default$ = cljs.core.nth.cljs$core$IFn$_invoke$arity$3(vec__9396,(0),null);
var cur = cljs.core.get_in.cljs$core$IFn$_invoke$arity$3((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(reagent.session.state) : cljs.core.deref.call(null,reagent.session.state)),ks,default$);
reagent.session.assoc_in_BANG_(ks,null);

return cur;
});

reagent.session.get_in_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.get_in_BANG_.cljs$lang$applyTo = (function (seq9393){
var G__9394 = cljs.core.first(seq9393);
var seq9393__$1 = cljs.core.next(seq9393);
return reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__9394,seq9393__$1);
});
/**
 * Updates a value in session where k is a key and f
 * is the function that takes the old value along with any
 * supplied args and return the new value. If key is not
 * present it will be added.
 */
reagent.session.update_BANG_ = (function reagent$session$update_BANG_(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9404 = arguments.length;
var i__7212__auto___9405 = (0);
while(true){
if((i__7212__auto___9405 < len__7211__auto___9404)){
args__7218__auto__.push((arguments[i__7212__auto___9405]));

var G__9406 = (i__7212__auto___9405 + (1));
i__7212__auto___9405 = G__9406;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((2) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((2)),(0))):null);
return reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__7219__auto__);
});

reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (k,f,args){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$2(reagent.session.state,(function (p1__9400_SHARP_){
return cljs.core.apply.cljs$core$IFn$_invoke$arity$2(cljs.core.partial.cljs$core$IFn$_invoke$arity$4(cljs.core.update,p1__9400_SHARP_,k,f),args);
}));
});

reagent.session.update_BANG_.cljs$lang$maxFixedArity = (2);

reagent.session.update_BANG_.cljs$lang$applyTo = (function (seq9401){
var G__9402 = cljs.core.first(seq9401);
var seq9401__$1 = cljs.core.next(seq9401);
var G__9403 = cljs.core.first(seq9401__$1);
var seq9401__$2 = cljs.core.next(seq9401__$1);
return reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__9402,G__9403,seq9401__$2);
});
/**
 * 'Updates a value in the session, where ks is a
 * sequence of keys and f is a function that will
 * take the old value along with any supplied args and return
 * the new value. If any levels do not exist, hash-maps
 * will be created.
 */
reagent.session.update_in_BANG_ = (function reagent$session$update_in_BANG_(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9411 = arguments.length;
var i__7212__auto___9412 = (0);
while(true){
if((i__7212__auto___9412 < len__7211__auto___9411)){
args__7218__auto__.push((arguments[i__7212__auto___9412]));

var G__9413 = (i__7212__auto___9412 + (1));
i__7212__auto___9412 = G__9413;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((2) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((2)),(0))):null);
return reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__7219__auto__);
});

reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ks,f,args){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$2(reagent.session.state,(function (p1__9407_SHARP_){
return cljs.core.apply.cljs$core$IFn$_invoke$arity$2(cljs.core.partial.cljs$core$IFn$_invoke$arity$4(cljs.core.update_in,p1__9407_SHARP_,ks,f),args);
}));
});

reagent.session.update_in_BANG_.cljs$lang$maxFixedArity = (2);

reagent.session.update_in_BANG_.cljs$lang$applyTo = (function (seq9408){
var G__9409 = cljs.core.first(seq9408);
var seq9408__$1 = cljs.core.next(seq9408);
var G__9410 = cljs.core.first(seq9408__$1);
var seq9408__$2 = cljs.core.next(seq9408__$1);
return reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__9409,G__9410,seq9408__$2);
});
