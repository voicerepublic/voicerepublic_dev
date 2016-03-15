// Compiled by ClojureScript 1.7.228 {}
goog.provide('cljs.repl');
goog.require('cljs.core');
cljs.repl.print_doc = (function cljs$repl$print_doc(m){
cljs.core.println.call(null,"-------------------------");

cljs.core.println.call(null,[cljs.core.str((function (){var temp__4657__auto__ = new cljs.core.Keyword(null,"ns","ns",441598760).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_(temp__4657__auto__)){
var ns = temp__4657__auto__;
return [cljs.core.str(ns),cljs.core.str("/")].join('');
} else {
return null;
}
})()),cljs.core.str(new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(m))].join(''));

if(cljs.core.truth_(new cljs.core.Keyword(null,"protocol","protocol",652470118).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"Protocol");
} else {
}

if(cljs.core.truth_(new cljs.core.Keyword(null,"forms","forms",2045992350).cljs$core$IFn$_invoke$arity$1(m))){
var seq__24955_24969 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"forms","forms",2045992350).cljs$core$IFn$_invoke$arity$1(m));
var chunk__24956_24970 = null;
var count__24957_24971 = (0);
var i__24958_24972 = (0);
while(true){
if((i__24958_24972 < count__24957_24971)){
var f_24973 = cljs.core._nth.call(null,chunk__24956_24970,i__24958_24972);
cljs.core.println.call(null,"  ",f_24973);

var G__24974 = seq__24955_24969;
var G__24975 = chunk__24956_24970;
var G__24976 = count__24957_24971;
var G__24977 = (i__24958_24972 + (1));
seq__24955_24969 = G__24974;
chunk__24956_24970 = G__24975;
count__24957_24971 = G__24976;
i__24958_24972 = G__24977;
continue;
} else {
var temp__4657__auto___24978 = cljs.core.seq.call(null,seq__24955_24969);
if(temp__4657__auto___24978){
var seq__24955_24979__$1 = temp__4657__auto___24978;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24955_24979__$1)){
var c__19173__auto___24980 = cljs.core.chunk_first.call(null,seq__24955_24979__$1);
var G__24981 = cljs.core.chunk_rest.call(null,seq__24955_24979__$1);
var G__24982 = c__19173__auto___24980;
var G__24983 = cljs.core.count.call(null,c__19173__auto___24980);
var G__24984 = (0);
seq__24955_24969 = G__24981;
chunk__24956_24970 = G__24982;
count__24957_24971 = G__24983;
i__24958_24972 = G__24984;
continue;
} else {
var f_24985 = cljs.core.first.call(null,seq__24955_24979__$1);
cljs.core.println.call(null,"  ",f_24985);

var G__24986 = cljs.core.next.call(null,seq__24955_24979__$1);
var G__24987 = null;
var G__24988 = (0);
var G__24989 = (0);
seq__24955_24969 = G__24986;
chunk__24956_24970 = G__24987;
count__24957_24971 = G__24988;
i__24958_24972 = G__24989;
continue;
}
} else {
}
}
break;
}
} else {
if(cljs.core.truth_(new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m))){
var arglists_24990 = new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_((function (){var or__18370__auto__ = new cljs.core.Keyword(null,"macro","macro",-867863404).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return new cljs.core.Keyword(null,"repl-special-function","repl-special-function",1262603725).cljs$core$IFn$_invoke$arity$1(m);
}
})())){
cljs.core.prn.call(null,arglists_24990);
} else {
cljs.core.prn.call(null,((cljs.core._EQ_.call(null,new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.first.call(null,arglists_24990)))?cljs.core.second.call(null,arglists_24990):arglists_24990));
}
} else {
}
}

if(cljs.core.truth_(new cljs.core.Keyword(null,"special-form","special-form",-1326536374).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"Special Form");

cljs.core.println.call(null," ",new cljs.core.Keyword(null,"doc","doc",1913296891).cljs$core$IFn$_invoke$arity$1(m));

if(cljs.core.contains_QMARK_.call(null,m,new cljs.core.Keyword(null,"url","url",276297046))){
if(cljs.core.truth_(new cljs.core.Keyword(null,"url","url",276297046).cljs$core$IFn$_invoke$arity$1(m))){
return cljs.core.println.call(null,[cljs.core.str("\n  Please see http://clojure.org/"),cljs.core.str(new cljs.core.Keyword(null,"url","url",276297046).cljs$core$IFn$_invoke$arity$1(m))].join(''));
} else {
return null;
}
} else {
return cljs.core.println.call(null,[cljs.core.str("\n  Please see http://clojure.org/special_forms#"),cljs.core.str(new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(m))].join(''));
}
} else {
if(cljs.core.truth_(new cljs.core.Keyword(null,"macro","macro",-867863404).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"Macro");
} else {
}

if(cljs.core.truth_(new cljs.core.Keyword(null,"repl-special-function","repl-special-function",1262603725).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"REPL Special Function");
} else {
}

cljs.core.println.call(null," ",new cljs.core.Keyword(null,"doc","doc",1913296891).cljs$core$IFn$_invoke$arity$1(m));

if(cljs.core.truth_(new cljs.core.Keyword(null,"protocol","protocol",652470118).cljs$core$IFn$_invoke$arity$1(m))){
var seq__24959 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"methods","methods",453930866).cljs$core$IFn$_invoke$arity$1(m));
var chunk__24960 = null;
var count__24961 = (0);
var i__24962 = (0);
while(true){
if((i__24962 < count__24961)){
var vec__24963 = cljs.core._nth.call(null,chunk__24960,i__24962);
var name = cljs.core.nth.call(null,vec__24963,(0),null);
var map__24964 = cljs.core.nth.call(null,vec__24963,(1),null);
var map__24964__$1 = ((((!((map__24964 == null)))?((((map__24964.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24964.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24964):map__24964);
var doc = cljs.core.get.call(null,map__24964__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__24964__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__24991 = seq__24959;
var G__24992 = chunk__24960;
var G__24993 = count__24961;
var G__24994 = (i__24962 + (1));
seq__24959 = G__24991;
chunk__24960 = G__24992;
count__24961 = G__24993;
i__24962 = G__24994;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__24959);
if(temp__4657__auto__){
var seq__24959__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24959__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__24959__$1);
var G__24995 = cljs.core.chunk_rest.call(null,seq__24959__$1);
var G__24996 = c__19173__auto__;
var G__24997 = cljs.core.count.call(null,c__19173__auto__);
var G__24998 = (0);
seq__24959 = G__24995;
chunk__24960 = G__24996;
count__24961 = G__24997;
i__24962 = G__24998;
continue;
} else {
var vec__24966 = cljs.core.first.call(null,seq__24959__$1);
var name = cljs.core.nth.call(null,vec__24966,(0),null);
var map__24967 = cljs.core.nth.call(null,vec__24966,(1),null);
var map__24967__$1 = ((((!((map__24967 == null)))?((((map__24967.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24967.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24967):map__24967);
var doc = cljs.core.get.call(null,map__24967__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__24967__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__24999 = cljs.core.next.call(null,seq__24959__$1);
var G__25000 = null;
var G__25001 = (0);
var G__25002 = (0);
seq__24959 = G__24999;
chunk__24960 = G__25000;
count__24961 = G__25001;
i__24962 = G__25002;
continue;
}
} else {
return null;
}
}
break;
}
} else {
return null;
}
}
});

//# sourceMappingURL=repl.js.map