// Compiled by ClojureScript 1.7.228 {}
goog.provide('reagent.session');
goog.require('cljs.core');
goog.require('reagent.core');
reagent.session.state = reagent.core.atom.call(null,cljs.core.PersistentArrayMap.EMPTY);
/**
 * Get the key's value from the session, returns nil if it doesn't exist.
 */
reagent.session.get = (function reagent$session$get(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20000 = arguments.length;
var i__19429__auto___20001 = (0);
while(true){
if((i__19429__auto___20001 < len__19428__auto___20000)){
args__19435__auto__.push((arguments[i__19429__auto___20001]));

var G__20002 = (i__19429__auto___20001 + (1));
i__19429__auto___20001 = G__20002;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get.cljs$core$IFn$_invoke$arity$variadic = (function (k,p__19998){
var vec__19999 = p__19998;
var default$ = cljs.core.nth.call(null,vec__19999,(0),null);
return cljs.core.get.call(null,cljs.core.deref.call(null,reagent.session.state),k,default$);
});

reagent.session.get.cljs$lang$maxFixedArity = (1);

reagent.session.get.cljs$lang$applyTo = (function (seq19996){
var G__19997 = cljs.core.first.call(null,seq19996);
var seq19996__$1 = cljs.core.next.call(null,seq19996);
return reagent.session.get.cljs$core$IFn$_invoke$arity$variadic(G__19997,seq19996__$1);
});
reagent.session.put_BANG_ = (function reagent$session$put_BANG_(k,v){
return cljs.core.swap_BANG_.call(null,reagent.session.state,cljs.core.assoc,k,v);
});
/**
 * Gets the value at the path specified by the vector ks from the session,
 *   returns nil if it doesn't exist.
 */
reagent.session.get_in = (function reagent$session$get_in(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20007 = arguments.length;
var i__19429__auto___20008 = (0);
while(true){
if((i__19429__auto___20008 < len__19428__auto___20007)){
args__19435__auto__.push((arguments[i__19429__auto___20008]));

var G__20009 = (i__19429__auto___20008 + (1));
i__19429__auto___20008 = G__20009;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic = (function (ks,p__20005){
var vec__20006 = p__20005;
var default$ = cljs.core.nth.call(null,vec__20006,(0),null);
return cljs.core.get_in.call(null,cljs.core.deref.call(null,reagent.session.state),ks,default$);
});

reagent.session.get_in.cljs$lang$maxFixedArity = (1);

reagent.session.get_in.cljs$lang$applyTo = (function (seq20003){
var G__20004 = cljs.core.first.call(null,seq20003);
var seq20003__$1 = cljs.core.next.call(null,seq20003);
return reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic(G__20004,seq20003__$1);
});
/**
 * Replace the current session's value with the result of executing f with
 *   the current value and args.
 */
reagent.session.swap_BANG_ = (function reagent$session$swap_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20012 = arguments.length;
var i__19429__auto___20013 = (0);
while(true){
if((i__19429__auto___20013 < len__19428__auto___20012)){
args__19435__auto__.push((arguments[i__19429__auto___20013]));

var G__20014 = (i__19429__auto___20013 + (1));
i__19429__auto___20013 = G__20014;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (f,args){
return cljs.core.apply.call(null,cljs.core.swap_BANG_,reagent.session.state,f,args);
});

reagent.session.swap_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.swap_BANG_.cljs$lang$applyTo = (function (seq20010){
var G__20011 = cljs.core.first.call(null,seq20010);
var seq20010__$1 = cljs.core.next.call(null,seq20010);
return reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20011,seq20010__$1);
});
/**
 * Remove all data from the session and start over cleanly.
 */
reagent.session.clear_BANG_ = (function reagent$session$clear_BANG_(){
return cljs.core.reset_BANG_.call(null,reagent.session.state,cljs.core.PersistentArrayMap.EMPTY);
});
reagent.session.reset_BANG_ = (function reagent$session$reset_BANG_(m){
return cljs.core.reset_BANG_.call(null,reagent.session.state,m);
});
/**
 * Remove a key from the session
 */
reagent.session.remove_BANG_ = (function reagent$session$remove_BANG_(k){
return cljs.core.swap_BANG_.call(null,reagent.session.state,cljs.core.dissoc,k);
});
/**
 * Associates a value in the session, where ks is a
 * sequence of keys and v is the new value and returns
 * a new nested structure. If any levels do not exist,
 * hash-maps will be created.
 */
reagent.session.assoc_in_BANG_ = (function reagent$session$assoc_in_BANG_(ks,v){
return cljs.core.swap_BANG_.call(null,reagent.session.state,(function (p1__20015_SHARP_){
return cljs.core.assoc_in.call(null,p1__20015_SHARP_,ks,v);
}));
});
/**
 * Destructive get from the session. This returns the current value of the key
 *   and then removes it from the session.
 */
reagent.session.get_BANG_ = (function reagent$session$get_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20020 = arguments.length;
var i__19429__auto___20021 = (0);
while(true){
if((i__19429__auto___20021 < len__19428__auto___20020)){
args__19435__auto__.push((arguments[i__19429__auto___20021]));

var G__20022 = (i__19429__auto___20021 + (1));
i__19429__auto___20021 = G__20022;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (k,p__20018){
var vec__20019 = p__20018;
var default$ = cljs.core.nth.call(null,vec__20019,(0),null);
var cur = reagent.session.get.call(null,k,default$);
reagent.session.remove_BANG_.call(null,k);

return cur;
});

reagent.session.get_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.get_BANG_.cljs$lang$applyTo = (function (seq20016){
var G__20017 = cljs.core.first.call(null,seq20016);
var seq20016__$1 = cljs.core.next.call(null,seq20016);
return reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20017,seq20016__$1);
});
/**
 * Destructive get from the session. This returns the current value of the path
 *   specified by the vector ks and then removes it from the session.
 */
reagent.session.get_in_BANG_ = (function reagent$session$get_in_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20027 = arguments.length;
var i__19429__auto___20028 = (0);
while(true){
if((i__19429__auto___20028 < len__19428__auto___20027)){
args__19435__auto__.push((arguments[i__19429__auto___20028]));

var G__20029 = (i__19429__auto___20028 + (1));
i__19429__auto___20028 = G__20029;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ks,p__20025){
var vec__20026 = p__20025;
var default$ = cljs.core.nth.call(null,vec__20026,(0),null);
var cur = cljs.core.get_in.call(null,cljs.core.deref.call(null,reagent.session.state),ks,default$);
reagent.session.assoc_in_BANG_.call(null,ks,null);

return cur;
});

reagent.session.get_in_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.get_in_BANG_.cljs$lang$applyTo = (function (seq20023){
var G__20024 = cljs.core.first.call(null,seq20023);
var seq20023__$1 = cljs.core.next.call(null,seq20023);
return reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20024,seq20023__$1);
});
/**
 * Updates a value in session where k is a key and f
 * is the function that takes the old value along with any
 * supplied args and return the new value. If key is not
 * present it will be added.
 */
reagent.session.update_BANG_ = (function reagent$session$update_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20034 = arguments.length;
var i__19429__auto___20035 = (0);
while(true){
if((i__19429__auto___20035 < len__19428__auto___20034)){
args__19435__auto__.push((arguments[i__19429__auto___20035]));

var G__20036 = (i__19429__auto___20035 + (1));
i__19429__auto___20035 = G__20036;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((2) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((2)),(0))):null);
return reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__19436__auto__);
});

reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (k,f,args){
return cljs.core.swap_BANG_.call(null,reagent.session.state,(function (p1__20030_SHARP_){
return cljs.core.apply.call(null,cljs.core.partial.call(null,cljs.core.update,p1__20030_SHARP_,k,f),args);
}));
});

reagent.session.update_BANG_.cljs$lang$maxFixedArity = (2);

reagent.session.update_BANG_.cljs$lang$applyTo = (function (seq20031){
var G__20032 = cljs.core.first.call(null,seq20031);
var seq20031__$1 = cljs.core.next.call(null,seq20031);
var G__20033 = cljs.core.first.call(null,seq20031__$1);
var seq20031__$2 = cljs.core.next.call(null,seq20031__$1);
return reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20032,G__20033,seq20031__$2);
});
/**
 * 'Updates a value in the session, where ks is a
 * sequence of keys and f is a function that will
 * take the old value along with any supplied args and return
 * the new value. If any levels do not exist, hash-maps
 * will be created.
 */
reagent.session.update_in_BANG_ = (function reagent$session$update_in_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20041 = arguments.length;
var i__19429__auto___20042 = (0);
while(true){
if((i__19429__auto___20042 < len__19428__auto___20041)){
args__19435__auto__.push((arguments[i__19429__auto___20042]));

var G__20043 = (i__19429__auto___20042 + (1));
i__19429__auto___20042 = G__20043;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((2) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((2)),(0))):null);
return reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__19436__auto__);
});

reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ks,f,args){
return cljs.core.swap_BANG_.call(null,reagent.session.state,(function (p1__20037_SHARP_){
return cljs.core.apply.call(null,cljs.core.partial.call(null,cljs.core.update_in,p1__20037_SHARP_,ks,f),args);
}));
});

reagent.session.update_in_BANG_.cljs$lang$maxFixedArity = (2);

reagent.session.update_in_BANG_.cljs$lang$applyTo = (function (seq20038){
var G__20039 = cljs.core.first.call(null,seq20038);
var seq20038__$1 = cljs.core.next.call(null,seq20038);
var G__20040 = cljs.core.first.call(null,seq20038__$1);
var seq20038__$2 = cljs.core.next.call(null,seq20038__$1);
return reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20039,G__20040,seq20038__$2);
});

//# sourceMappingURL=session.js.map