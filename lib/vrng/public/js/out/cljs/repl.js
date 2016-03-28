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
var seq__24956_24970 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"forms","forms",2045992350).cljs$core$IFn$_invoke$arity$1(m));
var chunk__24957_24971 = null;
var count__24958_24972 = (0);
var i__24959_24973 = (0);
while(true){
if((i__24959_24973 < count__24958_24972)){
var f_24974 = cljs.core._nth.call(null,chunk__24957_24971,i__24959_24973);
cljs.core.println.call(null,"  ",f_24974);

var G__24975 = seq__24956_24970;
var G__24976 = chunk__24957_24971;
var G__24977 = count__24958_24972;
var G__24978 = (i__24959_24973 + (1));
seq__24956_24970 = G__24975;
chunk__24957_24971 = G__24976;
count__24958_24972 = G__24977;
i__24959_24973 = G__24978;
continue;
} else {
var temp__4657__auto___24979 = cljs.core.seq.call(null,seq__24956_24970);
if(temp__4657__auto___24979){
var seq__24956_24980__$1 = temp__4657__auto___24979;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24956_24980__$1)){
var c__19173__auto___24981 = cljs.core.chunk_first.call(null,seq__24956_24980__$1);
var G__24982 = cljs.core.chunk_rest.call(null,seq__24956_24980__$1);
var G__24983 = c__19173__auto___24981;
var G__24984 = cljs.core.count.call(null,c__19173__auto___24981);
var G__24985 = (0);
seq__24956_24970 = G__24982;
chunk__24957_24971 = G__24983;
count__24958_24972 = G__24984;
i__24959_24973 = G__24985;
continue;
} else {
var f_24986 = cljs.core.first.call(null,seq__24956_24980__$1);
cljs.core.println.call(null,"  ",f_24986);

var G__24987 = cljs.core.next.call(null,seq__24956_24980__$1);
var G__24988 = null;
var G__24989 = (0);
var G__24990 = (0);
seq__24956_24970 = G__24987;
chunk__24957_24971 = G__24988;
count__24958_24972 = G__24989;
i__24959_24973 = G__24990;
continue;
}
} else {
}
}
break;
}
} else {
if(cljs.core.truth_(new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m))){
var arglists_24991 = new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_((function (){var or__18370__auto__ = new cljs.core.Keyword(null,"macro","macro",-867863404).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return new cljs.core.Keyword(null,"repl-special-function","repl-special-function",1262603725).cljs$core$IFn$_invoke$arity$1(m);
}
})())){
cljs.core.prn.call(null,arglists_24991);
} else {
cljs.core.prn.call(null,((cljs.core._EQ_.call(null,new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.first.call(null,arglists_24991)))?cljs.core.second.call(null,arglists_24991):arglists_24991));
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
var seq__24960 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"methods","methods",453930866).cljs$core$IFn$_invoke$arity$1(m));
var chunk__24961 = null;
var count__24962 = (0);
var i__24963 = (0);
while(true){
if((i__24963 < count__24962)){
var vec__24964 = cljs.core._nth.call(null,chunk__24961,i__24963);
var name = cljs.core.nth.call(null,vec__24964,(0),null);
var map__24965 = cljs.core.nth.call(null,vec__24964,(1),null);
var map__24965__$1 = ((((!((map__24965 == null)))?((((map__24965.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24965.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24965):map__24965);
var doc = cljs.core.get.call(null,map__24965__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__24965__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__24992 = seq__24960;
var G__24993 = chunk__24961;
var G__24994 = count__24962;
var G__24995 = (i__24963 + (1));
seq__24960 = G__24992;
chunk__24961 = G__24993;
count__24962 = G__24994;
i__24963 = G__24995;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__24960);
if(temp__4657__auto__){
var seq__24960__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24960__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__24960__$1);
var G__24996 = cljs.core.chunk_rest.call(null,seq__24960__$1);
var G__24997 = c__19173__auto__;
var G__24998 = cljs.core.count.call(null,c__19173__auto__);
var G__24999 = (0);
seq__24960 = G__24996;
chunk__24961 = G__24997;
count__24962 = G__24998;
i__24963 = G__24999;
continue;
} else {
var vec__24967 = cljs.core.first.call(null,seq__24960__$1);
var name = cljs.core.nth.call(null,vec__24967,(0),null);
var map__24968 = cljs.core.nth.call(null,vec__24967,(1),null);
var map__24968__$1 = ((((!((map__24968 == null)))?((((map__24968.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24968.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24968):map__24968);
var doc = cljs.core.get.call(null,map__24968__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__24968__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__25000 = cljs.core.next.call(null,seq__24960__$1);
var G__25001 = null;
var G__25002 = (0);
var G__25003 = (0);
seq__24960 = G__25000;
chunk__24961 = G__25001;
count__24962 = G__25002;
i__24963 = G__25003;
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