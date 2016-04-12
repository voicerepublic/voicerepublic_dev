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
var seq__25090_25104 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"forms","forms",2045992350).cljs$core$IFn$_invoke$arity$1(m));
var chunk__25091_25105 = null;
var count__25092_25106 = (0);
var i__25093_25107 = (0);
while(true){
if((i__25093_25107 < count__25092_25106)){
var f_25108 = cljs.core._nth.call(null,chunk__25091_25105,i__25093_25107);
cljs.core.println.call(null,"  ",f_25108);

var G__25109 = seq__25090_25104;
var G__25110 = chunk__25091_25105;
var G__25111 = count__25092_25106;
var G__25112 = (i__25093_25107 + (1));
seq__25090_25104 = G__25109;
chunk__25091_25105 = G__25110;
count__25092_25106 = G__25111;
i__25093_25107 = G__25112;
continue;
} else {
var temp__4657__auto___25113 = cljs.core.seq.call(null,seq__25090_25104);
if(temp__4657__auto___25113){
var seq__25090_25114__$1 = temp__4657__auto___25113;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__25090_25114__$1)){
var c__19173__auto___25115 = cljs.core.chunk_first.call(null,seq__25090_25114__$1);
var G__25116 = cljs.core.chunk_rest.call(null,seq__25090_25114__$1);
var G__25117 = c__19173__auto___25115;
var G__25118 = cljs.core.count.call(null,c__19173__auto___25115);
var G__25119 = (0);
seq__25090_25104 = G__25116;
chunk__25091_25105 = G__25117;
count__25092_25106 = G__25118;
i__25093_25107 = G__25119;
continue;
} else {
var f_25120 = cljs.core.first.call(null,seq__25090_25114__$1);
cljs.core.println.call(null,"  ",f_25120);

var G__25121 = cljs.core.next.call(null,seq__25090_25114__$1);
var G__25122 = null;
var G__25123 = (0);
var G__25124 = (0);
seq__25090_25104 = G__25121;
chunk__25091_25105 = G__25122;
count__25092_25106 = G__25123;
i__25093_25107 = G__25124;
continue;
}
} else {
}
}
break;
}
} else {
if(cljs.core.truth_(new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m))){
var arglists_25125 = new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_((function (){var or__18370__auto__ = new cljs.core.Keyword(null,"macro","macro",-867863404).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return new cljs.core.Keyword(null,"repl-special-function","repl-special-function",1262603725).cljs$core$IFn$_invoke$arity$1(m);
}
})())){
cljs.core.prn.call(null,arglists_25125);
} else {
cljs.core.prn.call(null,((cljs.core._EQ_.call(null,new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.first.call(null,arglists_25125)))?cljs.core.second.call(null,arglists_25125):arglists_25125));
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
var seq__25094 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"methods","methods",453930866).cljs$core$IFn$_invoke$arity$1(m));
var chunk__25095 = null;
var count__25096 = (0);
var i__25097 = (0);
while(true){
if((i__25097 < count__25096)){
var vec__25098 = cljs.core._nth.call(null,chunk__25095,i__25097);
var name = cljs.core.nth.call(null,vec__25098,(0),null);
var map__25099 = cljs.core.nth.call(null,vec__25098,(1),null);
var map__25099__$1 = ((((!((map__25099 == null)))?((((map__25099.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25099.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25099):map__25099);
var doc = cljs.core.get.call(null,map__25099__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__25099__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__25126 = seq__25094;
var G__25127 = chunk__25095;
var G__25128 = count__25096;
var G__25129 = (i__25097 + (1));
seq__25094 = G__25126;
chunk__25095 = G__25127;
count__25096 = G__25128;
i__25097 = G__25129;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__25094);
if(temp__4657__auto__){
var seq__25094__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__25094__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__25094__$1);
var G__25130 = cljs.core.chunk_rest.call(null,seq__25094__$1);
var G__25131 = c__19173__auto__;
var G__25132 = cljs.core.count.call(null,c__19173__auto__);
var G__25133 = (0);
seq__25094 = G__25130;
chunk__25095 = G__25131;
count__25096 = G__25132;
i__25097 = G__25133;
continue;
} else {
var vec__25101 = cljs.core.first.call(null,seq__25094__$1);
var name = cljs.core.nth.call(null,vec__25101,(0),null);
var map__25102 = cljs.core.nth.call(null,vec__25101,(1),null);
var map__25102__$1 = ((((!((map__25102 == null)))?((((map__25102.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25102.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25102):map__25102);
var doc = cljs.core.get.call(null,map__25102__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__25102__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__25134 = cljs.core.next.call(null,seq__25094__$1);
var G__25135 = null;
var G__25136 = (0);
var G__25137 = (0);
seq__25094 = G__25134;
chunk__25095 = G__25135;
count__25096 = G__25136;
i__25097 = G__25137;
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