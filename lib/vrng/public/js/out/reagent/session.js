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
var len__19428__auto___19999 = arguments.length;
var i__19429__auto___20000 = (0);
while(true){
if((i__19429__auto___20000 < len__19428__auto___19999)){
args__19435__auto__.push((arguments[i__19429__auto___20000]));

var G__20001 = (i__19429__auto___20000 + (1));
i__19429__auto___20000 = G__20001;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get.cljs$core$IFn$_invoke$arity$variadic = (function (k,p__19997){
var vec__19998 = p__19997;
var default$ = cljs.core.nth.call(null,vec__19998,(0),null);
return cljs.core.get.call(null,cljs.core.deref.call(null,reagent.session.state),k,default$);
});

reagent.session.get.cljs$lang$maxFixedArity = (1);

reagent.session.get.cljs$lang$applyTo = (function (seq19995){
var G__19996 = cljs.core.first.call(null,seq19995);
var seq19995__$1 = cljs.core.next.call(null,seq19995);
return reagent.session.get.cljs$core$IFn$_invoke$arity$variadic(G__19996,seq19995__$1);
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
var len__19428__auto___20006 = arguments.length;
var i__19429__auto___20007 = (0);
while(true){
if((i__19429__auto___20007 < len__19428__auto___20006)){
args__19435__auto__.push((arguments[i__19429__auto___20007]));

var G__20008 = (i__19429__auto___20007 + (1));
i__19429__auto___20007 = G__20008;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic = (function (ks,p__20004){
var vec__20005 = p__20004;
var default$ = cljs.core.nth.call(null,vec__20005,(0),null);
return cljs.core.get_in.call(null,cljs.core.deref.call(null,reagent.session.state),ks,default$);
});

reagent.session.get_in.cljs$lang$maxFixedArity = (1);

reagent.session.get_in.cljs$lang$applyTo = (function (seq20002){
var G__20003 = cljs.core.first.call(null,seq20002);
var seq20002__$1 = cljs.core.next.call(null,seq20002);
return reagent.session.get_in.cljs$core$IFn$_invoke$arity$variadic(G__20003,seq20002__$1);
});
/**
 * Replace the current session's value with the result of executing f with
 *   the current value and args.
 */
reagent.session.swap_BANG_ = (function reagent$session$swap_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20011 = arguments.length;
var i__19429__auto___20012 = (0);
while(true){
if((i__19429__auto___20012 < len__19428__auto___20011)){
args__19435__auto__.push((arguments[i__19429__auto___20012]));

var G__20013 = (i__19429__auto___20012 + (1));
i__19429__auto___20012 = G__20013;
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

reagent.session.swap_BANG_.cljs$lang$applyTo = (function (seq20009){
var G__20010 = cljs.core.first.call(null,seq20009);
var seq20009__$1 = cljs.core.next.call(null,seq20009);
return reagent.session.swap_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20010,seq20009__$1);
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
return cljs.core.swap_BANG_.call(null,reagent.session.state,(function (p1__20014_SHARP_){
return cljs.core.assoc_in.call(null,p1__20014_SHARP_,ks,v);
}));
});
/**
 * Destructive get from the session. This returns the current value of the key
 *   and then removes it from the session.
 */
reagent.session.get_BANG_ = (function reagent$session$get_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20019 = arguments.length;
var i__19429__auto___20020 = (0);
while(true){
if((i__19429__auto___20020 < len__19428__auto___20019)){
args__19435__auto__.push((arguments[i__19429__auto___20020]));

var G__20021 = (i__19429__auto___20020 + (1));
i__19429__auto___20020 = G__20021;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (k,p__20017){
var vec__20018 = p__20017;
var default$ = cljs.core.nth.call(null,vec__20018,(0),null);
var cur = reagent.session.get.call(null,k,default$);
reagent.session.remove_BANG_.call(null,k);

return cur;
});

reagent.session.get_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.get_BANG_.cljs$lang$applyTo = (function (seq20015){
var G__20016 = cljs.core.first.call(null,seq20015);
var seq20015__$1 = cljs.core.next.call(null,seq20015);
return reagent.session.get_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20016,seq20015__$1);
});
/**
 * Destructive get from the session. This returns the current value of the path
 *   specified by the vector ks and then removes it from the session.
 */
reagent.session.get_in_BANG_ = (function reagent$session$get_in_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20026 = arguments.length;
var i__19429__auto___20027 = (0);
while(true){
if((i__19429__auto___20027 < len__19428__auto___20026)){
args__19435__auto__.push((arguments[i__19429__auto___20027]));

var G__20028 = (i__19429__auto___20027 + (1));
i__19429__auto___20027 = G__20028;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((1) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((1)),(0))):null);
return reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__19436__auto__);
});

reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ks,p__20024){
var vec__20025 = p__20024;
var default$ = cljs.core.nth.call(null,vec__20025,(0),null);
var cur = cljs.core.get_in.call(null,cljs.core.deref.call(null,reagent.session.state),ks,default$);
reagent.session.assoc_in_BANG_.call(null,ks,null);

return cur;
});

reagent.session.get_in_BANG_.cljs$lang$maxFixedArity = (1);

reagent.session.get_in_BANG_.cljs$lang$applyTo = (function (seq20022){
var G__20023 = cljs.core.first.call(null,seq20022);
var seq20022__$1 = cljs.core.next.call(null,seq20022);
return reagent.session.get_in_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20023,seq20022__$1);
});
/**
 * Updates a value in session where k is a key and f
 * is the function that takes the old value along with any
 * supplied args and return the new value. If key is not
 * present it will be added.
 */
reagent.session.update_BANG_ = (function reagent$session$update_BANG_(var_args){
var args__19435__auto__ = [];
var len__19428__auto___20033 = arguments.length;
var i__19429__auto___20034 = (0);
while(true){
if((i__19429__auto___20034 < len__19428__auto___20033)){
args__19435__auto__.push((arguments[i__19429__auto___20034]));

var G__20035 = (i__19429__auto___20034 + (1));
i__19429__auto___20034 = G__20035;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((2) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((2)),(0))):null);
return reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__19436__auto__);
});

reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (k,f,args){
return cljs.core.swap_BANG_.call(null,reagent.session.state,(function (p1__20029_SHARP_){
return cljs.core.apply.call(null,cljs.core.partial.call(null,cljs.core.update,p1__20029_SHARP_,k,f),args);
}));
});

reagent.session.update_BANG_.cljs$lang$maxFixedArity = (2);

reagent.session.update_BANG_.cljs$lang$applyTo = (function (seq20030){
var G__20031 = cljs.core.first.call(null,seq20030);
var seq20030__$1 = cljs.core.next.call(null,seq20030);
var G__20032 = cljs.core.first.call(null,seq20030__$1);
var seq20030__$2 = cljs.core.next.call(null,seq20030__$1);
return reagent.session.update_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20031,G__20032,seq20030__$2);
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
var len__19428__auto___20040 = arguments.length;
var i__19429__auto___20041 = (0);
while(true){
if((i__19429__auto___20041 < len__19428__auto___20040)){
args__19435__auto__.push((arguments[i__19429__auto___20041]));

var G__20042 = (i__19429__auto___20041 + (1));
i__19429__auto___20041 = G__20042;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((2) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((2)),(0))):null);
return reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__19436__auto__);
});

reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic = (function (ks,f,args){
return cljs.core.swap_BANG_.call(null,reagent.session.state,(function (p1__20036_SHARP_){
return cljs.core.apply.call(null,cljs.core.partial.call(null,cljs.core.update_in,p1__20036_SHARP_,ks,f),args);
}));
});

reagent.session.update_in_BANG_.cljs$lang$maxFixedArity = (2);

reagent.session.update_in_BANG_.cljs$lang$applyTo = (function (seq20037){
var G__20038 = cljs.core.first.call(null,seq20037);
var seq20037__$1 = cljs.core.next.call(null,seq20037);
var G__20039 = cljs.core.first.call(null,seq20037__$1);
var seq20037__$2 = cljs.core.next.call(null,seq20037__$1);
return reagent.session.update_in_BANG_.cljs$core$IFn$_invoke$arity$variadic(G__20038,G__20039,seq20037__$2);
});

//# sourceMappingURL=session.js.map