// Compiled by ClojureScript 1.7.228 {}
goog.provide('figwheel.client.file_reloading');
goog.require('cljs.core');
goog.require('goog.string');
goog.require('goog.Uri');
goog.require('goog.net.jsloader');
goog.require('cljs.core.async');
goog.require('goog.object');
goog.require('clojure.set');
goog.require('clojure.string');
goog.require('figwheel.client.utils');
if(typeof figwheel.client.file_reloading.figwheel_meta_pragmas !== 'undefined'){
} else {
figwheel.client.file_reloading.figwheel_meta_pragmas = cljs.core.atom.call(null,cljs.core.PersistentArrayMap.EMPTY);
}
figwheel.client.file_reloading.on_jsload_custom_event = (function figwheel$client$file_reloading$on_jsload_custom_event(url){
return figwheel.client.utils.dispatch_custom_event.call(null,"figwheel.js-reload",url);
});
figwheel.client.file_reloading.before_jsload_custom_event = (function figwheel$client$file_reloading$before_jsload_custom_event(files){
return figwheel.client.utils.dispatch_custom_event.call(null,"figwheel.before-js-reload",files);
});
figwheel.client.file_reloading.namespace_file_map_QMARK_ = (function figwheel$client$file_reloading$namespace_file_map_QMARK_(m){
var or__18370__auto__ = (cljs.core.map_QMARK_.call(null,m)) && (typeof new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(m) === 'string') && (((new cljs.core.Keyword(null,"file","file",-1269645878).cljs$core$IFn$_invoke$arity$1(m) == null)) || (typeof new cljs.core.Keyword(null,"file","file",-1269645878).cljs$core$IFn$_invoke$arity$1(m) === 'string')) && (cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"type","type",1174270348).cljs$core$IFn$_invoke$arity$1(m),new cljs.core.Keyword(null,"namespace","namespace",-377510372)));
if(or__18370__auto__){
return or__18370__auto__;
} else {
cljs.core.println.call(null,"Error not namespace-file-map",cljs.core.pr_str.call(null,m));

return false;
}
});
figwheel.client.file_reloading.add_cache_buster = (function figwheel$client$file_reloading$add_cache_buster(url){

return goog.Uri.parse(url).makeUnique();
});
figwheel.client.file_reloading.name__GT_path = (function figwheel$client$file_reloading$name__GT_path(ns){

return (goog.dependencies_.nameToPath[ns]);
});
figwheel.client.file_reloading.provided_QMARK_ = (function figwheel$client$file_reloading$provided_QMARK_(ns){
return (goog.dependencies_.written[figwheel.client.file_reloading.name__GT_path.call(null,ns)]);
});
figwheel.client.file_reloading.fix_node_request_url = (function figwheel$client$file_reloading$fix_node_request_url(url){

if(cljs.core.truth_(goog.string.startsWith(url,"../"))){
return clojure.string.replace.call(null,url,"../","");
} else {
return [cljs.core.str("goog/"),cljs.core.str(url)].join('');
}
});
figwheel.client.file_reloading.immutable_ns_QMARK_ = (function figwheel$client$file_reloading$immutable_ns_QMARK_(name){
var or__18370__auto__ = new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 9, ["svgpan.SvgPan",null,"far.out",null,"testDep.bar",null,"someprotopackage.TestPackageTypes",null,"goog",null,"an.existing.path",null,"cljs.core",null,"ns",null,"dup.base",null], null), null).call(null,name);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return cljs.core.some.call(null,cljs.core.partial.call(null,goog.string.startsWith,name),new cljs.core.PersistentVector(null, 5, 5, cljs.core.PersistentVector.EMPTY_NODE, ["goog.","cljs.","clojure.","fake.","proto2."], null));
}
});
figwheel.client.file_reloading.get_requires = (function figwheel$client$file_reloading$get_requires(ns){
return cljs.core.set.call(null,cljs.core.filter.call(null,(function (p1__23932_SHARP_){
return cljs.core.not.call(null,figwheel.client.file_reloading.immutable_ns_QMARK_.call(null,p1__23932_SHARP_));
}),goog.object.getKeys((goog.dependencies_.requires[figwheel.client.file_reloading.name__GT_path.call(null,ns)]))));
});
if(typeof figwheel.client.file_reloading.dependency_data !== 'undefined'){
} else {
figwheel.client.file_reloading.dependency_data = cljs.core.atom.call(null,new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"pathToName","pathToName",-1236616181),cljs.core.PersistentArrayMap.EMPTY,new cljs.core.Keyword(null,"dependents","dependents",136812837),cljs.core.PersistentArrayMap.EMPTY], null));
}
figwheel.client.file_reloading.path_to_name_BANG_ = (function figwheel$client$file_reloading$path_to_name_BANG_(path,name){
return cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.dependency_data,cljs.core.update_in,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"pathToName","pathToName",-1236616181),path], null),cljs.core.fnil.call(null,clojure.set.union,cljs.core.PersistentHashSet.EMPTY),cljs.core.PersistentHashSet.fromArray([name], true));
});
/**
 * Setup a path to name dependencies map.
 * That goes from path -> #{ ns-names }
 */
figwheel.client.file_reloading.setup_path__GT_name_BANG_ = (function figwheel$client$file_reloading$setup_path__GT_name_BANG_(){
var nameToPath = goog.object.filter(goog.dependencies_.nameToPath,(function (v,k,o){
return goog.string.startsWith(v,"../");
}));
return goog.object.forEach(nameToPath,((function (nameToPath){
return (function (v,k,o){
return figwheel.client.file_reloading.path_to_name_BANG_.call(null,v,k);
});})(nameToPath))
);
});
/**
 * returns a set of namespaces defined by a path
 */
figwheel.client.file_reloading.path__GT_name = (function figwheel$client$file_reloading$path__GT_name(path){
return cljs.core.get_in.call(null,cljs.core.deref.call(null,figwheel.client.file_reloading.dependency_data),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"pathToName","pathToName",-1236616181),path], null));
});
figwheel.client.file_reloading.name_to_parent_BANG_ = (function figwheel$client$file_reloading$name_to_parent_BANG_(ns,parent_ns){
return cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.dependency_data,cljs.core.update_in,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"dependents","dependents",136812837),ns], null),cljs.core.fnil.call(null,clojure.set.union,cljs.core.PersistentHashSet.EMPTY),cljs.core.PersistentHashSet.fromArray([parent_ns], true));
});
/**
 * This reverses the goog.dependencies_.requires for looking up ns-dependents.
 */
figwheel.client.file_reloading.setup_ns__GT_dependents_BANG_ = (function figwheel$client$file_reloading$setup_ns__GT_dependents_BANG_(){
var requires = goog.object.filter(goog.dependencies_.requires,(function (v,k,o){
return goog.string.startsWith(k,"../");
}));
return goog.object.forEach(requires,((function (requires){
return (function (v,k,_){
return goog.object.forEach(v,((function (requires){
return (function (v_SINGLEQUOTE_,k_SINGLEQUOTE_,___$1){
var seq__23937 = cljs.core.seq.call(null,figwheel.client.file_reloading.path__GT_name.call(null,k));
var chunk__23938 = null;
var count__23939 = (0);
var i__23940 = (0);
while(true){
if((i__23940 < count__23939)){
var n = cljs.core._nth.call(null,chunk__23938,i__23940);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,k_SINGLEQUOTE_,n);

var G__23941 = seq__23937;
var G__23942 = chunk__23938;
var G__23943 = count__23939;
var G__23944 = (i__23940 + (1));
seq__23937 = G__23941;
chunk__23938 = G__23942;
count__23939 = G__23943;
i__23940 = G__23944;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__23937);
if(temp__4657__auto__){
var seq__23937__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__23937__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__23937__$1);
var G__23945 = cljs.core.chunk_rest.call(null,seq__23937__$1);
var G__23946 = c__19173__auto__;
var G__23947 = cljs.core.count.call(null,c__19173__auto__);
var G__23948 = (0);
seq__23937 = G__23945;
chunk__23938 = G__23946;
count__23939 = G__23947;
i__23940 = G__23948;
continue;
} else {
var n = cljs.core.first.call(null,seq__23937__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,k_SINGLEQUOTE_,n);

var G__23949 = cljs.core.next.call(null,seq__23937__$1);
var G__23950 = null;
var G__23951 = (0);
var G__23952 = (0);
seq__23937 = G__23949;
chunk__23938 = G__23950;
count__23939 = G__23951;
i__23940 = G__23952;
continue;
}
} else {
return null;
}
}
break;
}
});})(requires))
);
});})(requires))
);
});
figwheel.client.file_reloading.ns__GT_dependents = (function figwheel$client$file_reloading$ns__GT_dependents(ns){
return cljs.core.get_in.call(null,cljs.core.deref.call(null,figwheel.client.file_reloading.dependency_data),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"dependents","dependents",136812837),ns], null));
});
figwheel.client.file_reloading.build_topo_sort = (function figwheel$client$file_reloading$build_topo_sort(get_deps){
var get_deps__$1 = cljs.core.memoize.call(null,get_deps);
var topo_sort_helper_STAR_ = ((function (get_deps__$1){
return (function figwheel$client$file_reloading$build_topo_sort_$_topo_sort_helper_STAR_(x,depth,state){
var deps = get_deps__$1.call(null,x);
if(cljs.core.empty_QMARK_.call(null,deps)){
return null;
} else {
return topo_sort_STAR_.call(null,deps,depth,state);
}
});})(get_deps__$1))
;
var topo_sort_STAR_ = ((function (get_deps__$1){
return (function() {
var figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR_ = null;
var figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR___1 = (function (deps){
return figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR_.call(null,deps,(0),cljs.core.atom.call(null,cljs.core.sorted_map.call(null)));
});
var figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR___3 = (function (deps,depth,state){
cljs.core.swap_BANG_.call(null,state,cljs.core.update_in,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [depth], null),cljs.core.fnil.call(null,cljs.core.into,cljs.core.PersistentHashSet.EMPTY),deps);

var seq__23991_23998 = cljs.core.seq.call(null,deps);
var chunk__23992_23999 = null;
var count__23993_24000 = (0);
var i__23994_24001 = (0);
while(true){
if((i__23994_24001 < count__23993_24000)){
var dep_24002 = cljs.core._nth.call(null,chunk__23992_23999,i__23994_24001);
topo_sort_helper_STAR_.call(null,dep_24002,(depth + (1)),state);

var G__24003 = seq__23991_23998;
var G__24004 = chunk__23992_23999;
var G__24005 = count__23993_24000;
var G__24006 = (i__23994_24001 + (1));
seq__23991_23998 = G__24003;
chunk__23992_23999 = G__24004;
count__23993_24000 = G__24005;
i__23994_24001 = G__24006;
continue;
} else {
var temp__4657__auto___24007 = cljs.core.seq.call(null,seq__23991_23998);
if(temp__4657__auto___24007){
var seq__23991_24008__$1 = temp__4657__auto___24007;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__23991_24008__$1)){
var c__19173__auto___24009 = cljs.core.chunk_first.call(null,seq__23991_24008__$1);
var G__24010 = cljs.core.chunk_rest.call(null,seq__23991_24008__$1);
var G__24011 = c__19173__auto___24009;
var G__24012 = cljs.core.count.call(null,c__19173__auto___24009);
var G__24013 = (0);
seq__23991_23998 = G__24010;
chunk__23992_23999 = G__24011;
count__23993_24000 = G__24012;
i__23994_24001 = G__24013;
continue;
} else {
var dep_24014 = cljs.core.first.call(null,seq__23991_24008__$1);
topo_sort_helper_STAR_.call(null,dep_24014,(depth + (1)),state);

var G__24015 = cljs.core.next.call(null,seq__23991_24008__$1);
var G__24016 = null;
var G__24017 = (0);
var G__24018 = (0);
seq__23991_23998 = G__24015;
chunk__23992_23999 = G__24016;
count__23993_24000 = G__24017;
i__23994_24001 = G__24018;
continue;
}
} else {
}
}
break;
}

if(cljs.core._EQ_.call(null,depth,(0))){
return elim_dups_STAR_.call(null,cljs.core.reverse.call(null,cljs.core.vals.call(null,cljs.core.deref.call(null,state))));
} else {
return null;
}
});
figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR_ = function(deps,depth,state){
switch(arguments.length){
case 1:
return figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR___1.call(this,deps);
case 3:
return figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR___3.call(this,deps,depth,state);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR_.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR___1;
figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR_.cljs$core$IFn$_invoke$arity$3 = figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR___3;
return figwheel$client$file_reloading$build_topo_sort_$_topo_sort_STAR_;
})()
;})(get_deps__$1))
;
var elim_dups_STAR_ = ((function (get_deps__$1){
return (function figwheel$client$file_reloading$build_topo_sort_$_elim_dups_STAR_(p__23995){
var vec__23997 = p__23995;
var x = cljs.core.nth.call(null,vec__23997,(0),null);
var xs = cljs.core.nthnext.call(null,vec__23997,(1));
if((x == null)){
return cljs.core.List.EMPTY;
} else {
return cljs.core.cons.call(null,x,figwheel$client$file_reloading$build_topo_sort_$_elim_dups_STAR_.call(null,cljs.core.map.call(null,((function (vec__23997,x,xs,get_deps__$1){
return (function (p1__23953_SHARP_){
return clojure.set.difference.call(null,p1__23953_SHARP_,x);
});})(vec__23997,x,xs,get_deps__$1))
,xs)));
}
});})(get_deps__$1))
;
return topo_sort_STAR_;
});
figwheel.client.file_reloading.get_all_dependencies = (function figwheel$client$file_reloading$get_all_dependencies(ns){
var topo_sort_SINGLEQUOTE_ = figwheel.client.file_reloading.build_topo_sort.call(null,figwheel.client.file_reloading.get_requires);
return cljs.core.apply.call(null,cljs.core.concat,topo_sort_SINGLEQUOTE_.call(null,cljs.core.set.call(null,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [ns], null))));
});
figwheel.client.file_reloading.get_all_dependents = (function figwheel$client$file_reloading$get_all_dependents(nss){
var topo_sort_SINGLEQUOTE_ = figwheel.client.file_reloading.build_topo_sort.call(null,figwheel.client.file_reloading.ns__GT_dependents);
return cljs.core.reverse.call(null,cljs.core.apply.call(null,cljs.core.concat,topo_sort_SINGLEQUOTE_.call(null,cljs.core.set.call(null,nss))));
});
figwheel.client.file_reloading.unprovide_BANG_ = (function figwheel$client$file_reloading$unprovide_BANG_(ns){
var path = figwheel.client.file_reloading.name__GT_path.call(null,ns);
goog.object.remove(goog.dependencies_.visited,path);

goog.object.remove(goog.dependencies_.written,path);

return goog.object.remove(goog.dependencies_.written,[cljs.core.str(goog.basePath),cljs.core.str(path)].join(''));
});
figwheel.client.file_reloading.resolve_ns = (function figwheel$client$file_reloading$resolve_ns(ns){
return [cljs.core.str(goog.basePath),cljs.core.str(figwheel.client.file_reloading.name__GT_path.call(null,ns))].join('');
});
figwheel.client.file_reloading.addDependency = (function figwheel$client$file_reloading$addDependency(path,provides,requires){
var seq__24031 = cljs.core.seq.call(null,provides);
var chunk__24032 = null;
var count__24033 = (0);
var i__24034 = (0);
while(true){
if((i__24034 < count__24033)){
var prov = cljs.core._nth.call(null,chunk__24032,i__24034);
figwheel.client.file_reloading.path_to_name_BANG_.call(null,path,prov);

var seq__24035_24043 = cljs.core.seq.call(null,requires);
var chunk__24036_24044 = null;
var count__24037_24045 = (0);
var i__24038_24046 = (0);
while(true){
if((i__24038_24046 < count__24037_24045)){
var req_24047 = cljs.core._nth.call(null,chunk__24036_24044,i__24038_24046);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24047,prov);

var G__24048 = seq__24035_24043;
var G__24049 = chunk__24036_24044;
var G__24050 = count__24037_24045;
var G__24051 = (i__24038_24046 + (1));
seq__24035_24043 = G__24048;
chunk__24036_24044 = G__24049;
count__24037_24045 = G__24050;
i__24038_24046 = G__24051;
continue;
} else {
var temp__4657__auto___24052 = cljs.core.seq.call(null,seq__24035_24043);
if(temp__4657__auto___24052){
var seq__24035_24053__$1 = temp__4657__auto___24052;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24035_24053__$1)){
var c__19173__auto___24054 = cljs.core.chunk_first.call(null,seq__24035_24053__$1);
var G__24055 = cljs.core.chunk_rest.call(null,seq__24035_24053__$1);
var G__24056 = c__19173__auto___24054;
var G__24057 = cljs.core.count.call(null,c__19173__auto___24054);
var G__24058 = (0);
seq__24035_24043 = G__24055;
chunk__24036_24044 = G__24056;
count__24037_24045 = G__24057;
i__24038_24046 = G__24058;
continue;
} else {
var req_24059 = cljs.core.first.call(null,seq__24035_24053__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24059,prov);

var G__24060 = cljs.core.next.call(null,seq__24035_24053__$1);
var G__24061 = null;
var G__24062 = (0);
var G__24063 = (0);
seq__24035_24043 = G__24060;
chunk__24036_24044 = G__24061;
count__24037_24045 = G__24062;
i__24038_24046 = G__24063;
continue;
}
} else {
}
}
break;
}

var G__24064 = seq__24031;
var G__24065 = chunk__24032;
var G__24066 = count__24033;
var G__24067 = (i__24034 + (1));
seq__24031 = G__24064;
chunk__24032 = G__24065;
count__24033 = G__24066;
i__24034 = G__24067;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__24031);
if(temp__4657__auto__){
var seq__24031__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24031__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__24031__$1);
var G__24068 = cljs.core.chunk_rest.call(null,seq__24031__$1);
var G__24069 = c__19173__auto__;
var G__24070 = cljs.core.count.call(null,c__19173__auto__);
var G__24071 = (0);
seq__24031 = G__24068;
chunk__24032 = G__24069;
count__24033 = G__24070;
i__24034 = G__24071;
continue;
} else {
var prov = cljs.core.first.call(null,seq__24031__$1);
figwheel.client.file_reloading.path_to_name_BANG_.call(null,path,prov);

var seq__24039_24072 = cljs.core.seq.call(null,requires);
var chunk__24040_24073 = null;
var count__24041_24074 = (0);
var i__24042_24075 = (0);
while(true){
if((i__24042_24075 < count__24041_24074)){
var req_24076 = cljs.core._nth.call(null,chunk__24040_24073,i__24042_24075);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24076,prov);

var G__24077 = seq__24039_24072;
var G__24078 = chunk__24040_24073;
var G__24079 = count__24041_24074;
var G__24080 = (i__24042_24075 + (1));
seq__24039_24072 = G__24077;
chunk__24040_24073 = G__24078;
count__24041_24074 = G__24079;
i__24042_24075 = G__24080;
continue;
} else {
var temp__4657__auto___24081__$1 = cljs.core.seq.call(null,seq__24039_24072);
if(temp__4657__auto___24081__$1){
var seq__24039_24082__$1 = temp__4657__auto___24081__$1;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24039_24082__$1)){
var c__19173__auto___24083 = cljs.core.chunk_first.call(null,seq__24039_24082__$1);
var G__24084 = cljs.core.chunk_rest.call(null,seq__24039_24082__$1);
var G__24085 = c__19173__auto___24083;
var G__24086 = cljs.core.count.call(null,c__19173__auto___24083);
var G__24087 = (0);
seq__24039_24072 = G__24084;
chunk__24040_24073 = G__24085;
count__24041_24074 = G__24086;
i__24042_24075 = G__24087;
continue;
} else {
var req_24088 = cljs.core.first.call(null,seq__24039_24082__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24088,prov);

var G__24089 = cljs.core.next.call(null,seq__24039_24082__$1);
var G__24090 = null;
var G__24091 = (0);
var G__24092 = (0);
seq__24039_24072 = G__24089;
chunk__24040_24073 = G__24090;
count__24041_24074 = G__24091;
i__24042_24075 = G__24092;
continue;
}
} else {
}
}
break;
}

var G__24093 = cljs.core.next.call(null,seq__24031__$1);
var G__24094 = null;
var G__24095 = (0);
var G__24096 = (0);
seq__24031 = G__24093;
chunk__24032 = G__24094;
count__24033 = G__24095;
i__24034 = G__24096;
continue;
}
} else {
return null;
}
}
break;
}
});
figwheel.client.file_reloading.figwheel_require = (function figwheel$client$file_reloading$figwheel_require(src,reload){
goog.require = figwheel$client$file_reloading$figwheel_require;

if(cljs.core._EQ_.call(null,reload,"reload-all")){
var seq__24101_24105 = cljs.core.seq.call(null,figwheel.client.file_reloading.get_all_dependencies.call(null,src));
var chunk__24102_24106 = null;
var count__24103_24107 = (0);
var i__24104_24108 = (0);
while(true){
if((i__24104_24108 < count__24103_24107)){
var ns_24109 = cljs.core._nth.call(null,chunk__24102_24106,i__24104_24108);
figwheel.client.file_reloading.unprovide_BANG_.call(null,ns_24109);

var G__24110 = seq__24101_24105;
var G__24111 = chunk__24102_24106;
var G__24112 = count__24103_24107;
var G__24113 = (i__24104_24108 + (1));
seq__24101_24105 = G__24110;
chunk__24102_24106 = G__24111;
count__24103_24107 = G__24112;
i__24104_24108 = G__24113;
continue;
} else {
var temp__4657__auto___24114 = cljs.core.seq.call(null,seq__24101_24105);
if(temp__4657__auto___24114){
var seq__24101_24115__$1 = temp__4657__auto___24114;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24101_24115__$1)){
var c__19173__auto___24116 = cljs.core.chunk_first.call(null,seq__24101_24115__$1);
var G__24117 = cljs.core.chunk_rest.call(null,seq__24101_24115__$1);
var G__24118 = c__19173__auto___24116;
var G__24119 = cljs.core.count.call(null,c__19173__auto___24116);
var G__24120 = (0);
seq__24101_24105 = G__24117;
chunk__24102_24106 = G__24118;
count__24103_24107 = G__24119;
i__24104_24108 = G__24120;
continue;
} else {
var ns_24121 = cljs.core.first.call(null,seq__24101_24115__$1);
figwheel.client.file_reloading.unprovide_BANG_.call(null,ns_24121);

var G__24122 = cljs.core.next.call(null,seq__24101_24115__$1);
var G__24123 = null;
var G__24124 = (0);
var G__24125 = (0);
seq__24101_24105 = G__24122;
chunk__24102_24106 = G__24123;
count__24103_24107 = G__24124;
i__24104_24108 = G__24125;
continue;
}
} else {
}
}
break;
}
} else {
}

if(cljs.core.truth_(reload)){
figwheel.client.file_reloading.unprovide_BANG_.call(null,src);
} else {
}

return goog.require_figwheel_backup_(src);
});
/**
 * Reusable browser REPL bootstrapping. Patches the essential functions
 *   in goog.base to support re-loading of namespaces after page load.
 */
figwheel.client.file_reloading.bootstrap_goog_base = (function figwheel$client$file_reloading$bootstrap_goog_base(){
if(cljs.core.truth_(COMPILED)){
return null;
} else {
goog.require_figwheel_backup_ = (function (){var or__18370__auto__ = goog.require__;
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return goog.require;
}
})();

goog.isProvided_ = (function (name){
return false;
});

figwheel.client.file_reloading.setup_path__GT_name_BANG_.call(null);

figwheel.client.file_reloading.setup_ns__GT_dependents_BANG_.call(null);

goog.addDependency_figwheel_backup_ = goog.addDependency;

goog.addDependency = (function() { 
var G__24126__delegate = function (args){
cljs.core.apply.call(null,figwheel.client.file_reloading.addDependency,args);

return cljs.core.apply.call(null,goog.addDependency_figwheel_backup_,args);
};
var G__24126 = function (var_args){
var args = null;
if (arguments.length > 0) {
var G__24127__i = 0, G__24127__a = new Array(arguments.length -  0);
while (G__24127__i < G__24127__a.length) {G__24127__a[G__24127__i] = arguments[G__24127__i + 0]; ++G__24127__i;}
  args = new cljs.core.IndexedSeq(G__24127__a,0);
} 
return G__24126__delegate.call(this,args);};
G__24126.cljs$lang$maxFixedArity = 0;
G__24126.cljs$lang$applyTo = (function (arglist__24128){
var args = cljs.core.seq(arglist__24128);
return G__24126__delegate(args);
});
G__24126.cljs$core$IFn$_invoke$arity$variadic = G__24126__delegate;
return G__24126;
})()
;

goog.constructNamespace_("cljs.user");

goog.global.CLOSURE_IMPORT_SCRIPT = figwheel.client.file_reloading.queued_file_reload;

return goog.require = figwheel.client.file_reloading.figwheel_require;
}
});
figwheel.client.file_reloading.patch_goog_base = (function figwheel$client$file_reloading$patch_goog_base(){
if(typeof figwheel.client.file_reloading.bootstrapped_cljs !== 'undefined'){
return null;
} else {
figwheel.client.file_reloading.bootstrapped_cljs = (function (){
figwheel.client.file_reloading.bootstrap_goog_base.call(null);

return true;
})()
;
}
});
figwheel.client.file_reloading.reload_file_STAR_ = (function (){var pred__24130 = cljs.core._EQ_;
var expr__24131 = figwheel.client.utils.host_env_QMARK_.call(null);
if(cljs.core.truth_(pred__24130.call(null,new cljs.core.Keyword(null,"node","node",581201198),expr__24131))){
var path_parts = ((function (pred__24130,expr__24131){
return (function (p1__24129_SHARP_){
return clojure.string.split.call(null,p1__24129_SHARP_,/[\/\\]/);
});})(pred__24130,expr__24131))
;
var sep = (cljs.core.truth_(cljs.core.re_matches.call(null,/win.*/,process.platform))?"\\":"/");
var root = clojure.string.join.call(null,sep,cljs.core.pop.call(null,cljs.core.pop.call(null,path_parts.call(null,__dirname))));
return ((function (path_parts,sep,root,pred__24130,expr__24131){
return (function (request_url,callback){

var cache_path = clojure.string.join.call(null,sep,cljs.core.cons.call(null,root,path_parts.call(null,figwheel.client.file_reloading.fix_node_request_url.call(null,request_url))));
(require.cache[cache_path] = null);

return callback.call(null,(function (){try{return require(cache_path);
}catch (e24133){if((e24133 instanceof Error)){
var e = e24133;
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Figwheel: Error loading file "),cljs.core.str(cache_path)].join(''));

figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),e.stack);

return false;
} else {
throw e24133;

}
}})());
});
;})(path_parts,sep,root,pred__24130,expr__24131))
} else {
if(cljs.core.truth_(pred__24130.call(null,new cljs.core.Keyword(null,"html","html",-998796897),expr__24131))){
return ((function (pred__24130,expr__24131){
return (function (request_url,callback){

var deferred = goog.net.jsloader.load(figwheel.client.file_reloading.add_cache_buster.call(null,request_url),{"cleanupWhenDone": true});
deferred.addCallback(((function (deferred,pred__24130,expr__24131){
return (function (){
return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [true], null));
});})(deferred,pred__24130,expr__24131))
);

return deferred.addErrback(((function (deferred,pred__24130,expr__24131){
return (function (){
return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [false], null));
});})(deferred,pred__24130,expr__24131))
);
});
;})(pred__24130,expr__24131))
} else {
return ((function (pred__24130,expr__24131){
return (function (a,b){
throw "Reload not defined for this platform";
});
;})(pred__24130,expr__24131))
}
}
})();
figwheel.client.file_reloading.reload_file = (function figwheel$client$file_reloading$reload_file(p__24134,callback){
var map__24137 = p__24134;
var map__24137__$1 = ((((!((map__24137 == null)))?((((map__24137.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24137.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24137):map__24137);
var file_msg = map__24137__$1;
var request_url = cljs.core.get.call(null,map__24137__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));

figwheel.client.utils.debug_prn.call(null,[cljs.core.str("FigWheel: Attempting to load "),cljs.core.str(request_url)].join(''));

return figwheel.client.file_reloading.reload_file_STAR_.call(null,request_url,((function (map__24137,map__24137__$1,file_msg,request_url){
return (function (success_QMARK_){
if(cljs.core.truth_(success_QMARK_)){
figwheel.client.utils.debug_prn.call(null,[cljs.core.str("FigWheel: Successfully loaded "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.assoc.call(null,file_msg,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),true)], null));
} else {
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Figwheel: Error loading file "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [file_msg], null));
}
});})(map__24137,map__24137__$1,file_msg,request_url))
);
});
if(typeof figwheel.client.file_reloading.reload_chan !== 'undefined'){
} else {
figwheel.client.file_reloading.reload_chan = cljs.core.async.chan.call(null);
}
if(typeof figwheel.client.file_reloading.on_load_callbacks !== 'undefined'){
} else {
figwheel.client.file_reloading.on_load_callbacks = cljs.core.atom.call(null,cljs.core.PersistentArrayMap.EMPTY);
}
if(typeof figwheel.client.file_reloading.dependencies_loaded !== 'undefined'){
} else {
figwheel.client.file_reloading.dependencies_loaded = cljs.core.atom.call(null,cljs.core.PersistentVector.EMPTY);
}
figwheel.client.file_reloading.blocking_load = (function figwheel$client$file_reloading$blocking_load(url){
var out = cljs.core.async.chan.call(null);
figwheel.client.file_reloading.reload_file.call(null,new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"request-url","request-url",2100346596),url], null),((function (out){
return (function (file_msg){
cljs.core.async.put_BANG_.call(null,out,file_msg);

return cljs.core.async.close_BANG_.call(null,out);
});})(out))
);

return out;
});
if(typeof figwheel.client.file_reloading.reloader_loop !== 'undefined'){
} else {
figwheel.client.file_reloading.reloader_loop = (function (){var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__){
return (function (state_24161){
var state_val_24162 = (state_24161[(1)]);
if((state_val_24162 === (7))){
var inst_24157 = (state_24161[(2)]);
var state_24161__$1 = state_24161;
var statearr_24163_24183 = state_24161__$1;
(statearr_24163_24183[(2)] = inst_24157);

(statearr_24163_24183[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (1))){
var state_24161__$1 = state_24161;
var statearr_24164_24184 = state_24161__$1;
(statearr_24164_24184[(2)] = null);

(statearr_24164_24184[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (4))){
var inst_24141 = (state_24161[(7)]);
var inst_24141__$1 = (state_24161[(2)]);
var state_24161__$1 = (function (){var statearr_24165 = state_24161;
(statearr_24165[(7)] = inst_24141__$1);

return statearr_24165;
})();
if(cljs.core.truth_(inst_24141__$1)){
var statearr_24166_24185 = state_24161__$1;
(statearr_24166_24185[(1)] = (5));

} else {
var statearr_24167_24186 = state_24161__$1;
(statearr_24167_24186[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (6))){
var state_24161__$1 = state_24161;
var statearr_24168_24187 = state_24161__$1;
(statearr_24168_24187[(2)] = null);

(statearr_24168_24187[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (3))){
var inst_24159 = (state_24161[(2)]);
var state_24161__$1 = state_24161;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24161__$1,inst_24159);
} else {
if((state_val_24162 === (2))){
var state_24161__$1 = state_24161;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24161__$1,(4),figwheel.client.file_reloading.reload_chan);
} else {
if((state_val_24162 === (11))){
var inst_24153 = (state_24161[(2)]);
var state_24161__$1 = (function (){var statearr_24169 = state_24161;
(statearr_24169[(8)] = inst_24153);

return statearr_24169;
})();
var statearr_24170_24188 = state_24161__$1;
(statearr_24170_24188[(2)] = null);

(statearr_24170_24188[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (9))){
var inst_24145 = (state_24161[(9)]);
var inst_24147 = (state_24161[(10)]);
var inst_24149 = inst_24147.call(null,inst_24145);
var state_24161__$1 = state_24161;
var statearr_24171_24189 = state_24161__$1;
(statearr_24171_24189[(2)] = inst_24149);

(statearr_24171_24189[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (5))){
var inst_24141 = (state_24161[(7)]);
var inst_24143 = figwheel.client.file_reloading.blocking_load.call(null,inst_24141);
var state_24161__$1 = state_24161;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24161__$1,(8),inst_24143);
} else {
if((state_val_24162 === (10))){
var inst_24145 = (state_24161[(9)]);
var inst_24151 = cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.dependencies_loaded,cljs.core.conj,inst_24145);
var state_24161__$1 = state_24161;
var statearr_24172_24190 = state_24161__$1;
(statearr_24172_24190[(2)] = inst_24151);

(statearr_24172_24190[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24162 === (8))){
var inst_24141 = (state_24161[(7)]);
var inst_24147 = (state_24161[(10)]);
var inst_24145 = (state_24161[(2)]);
var inst_24146 = cljs.core.deref.call(null,figwheel.client.file_reloading.on_load_callbacks);
var inst_24147__$1 = cljs.core.get.call(null,inst_24146,inst_24141);
var state_24161__$1 = (function (){var statearr_24173 = state_24161;
(statearr_24173[(9)] = inst_24145);

(statearr_24173[(10)] = inst_24147__$1);

return statearr_24173;
})();
if(cljs.core.truth_(inst_24147__$1)){
var statearr_24174_24191 = state_24161__$1;
(statearr_24174_24191[(1)] = (9));

} else {
var statearr_24175_24192 = state_24161__$1;
(statearr_24175_24192[(1)] = (10));

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
});})(c__21038__auto__))
;
return ((function (switch__20926__auto__,c__21038__auto__){
return (function() {
var figwheel$client$file_reloading$state_machine__20927__auto__ = null;
var figwheel$client$file_reloading$state_machine__20927__auto____0 = (function (){
var statearr_24179 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_24179[(0)] = figwheel$client$file_reloading$state_machine__20927__auto__);

(statearr_24179[(1)] = (1));

return statearr_24179;
});
var figwheel$client$file_reloading$state_machine__20927__auto____1 = (function (state_24161){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_24161);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e24180){if((e24180 instanceof Object)){
var ex__20930__auto__ = e24180;
var statearr_24181_24193 = state_24161;
(statearr_24181_24193[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24161);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24180;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24194 = state_24161;
state_24161 = G__24194;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$file_reloading$state_machine__20927__auto__ = function(state_24161){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$state_machine__20927__auto____1.call(this,state_24161);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$state_machine__20927__auto____0;
figwheel$client$file_reloading$state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$state_machine__20927__auto____1;
return figwheel$client$file_reloading$state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__))
})();
var state__21040__auto__ = (function (){var statearr_24182 = f__21039__auto__.call(null);
(statearr_24182[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_24182;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__))
);

return c__21038__auto__;
})();
}
figwheel.client.file_reloading.queued_file_reload = (function figwheel$client$file_reloading$queued_file_reload(url){
return cljs.core.async.put_BANG_.call(null,figwheel.client.file_reloading.reload_chan,url);
});
figwheel.client.file_reloading.require_with_callback = (function figwheel$client$file_reloading$require_with_callback(p__24195,callback){
var map__24198 = p__24195;
var map__24198__$1 = ((((!((map__24198 == null)))?((((map__24198.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24198.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24198):map__24198);
var file_msg = map__24198__$1;
var namespace = cljs.core.get.call(null,map__24198__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var request_url = figwheel.client.file_reloading.resolve_ns.call(null,namespace);
cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.on_load_callbacks,cljs.core.assoc,request_url,((function (request_url,map__24198,map__24198__$1,file_msg,namespace){
return (function (file_msg_SINGLEQUOTE_){
cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.on_load_callbacks,cljs.core.dissoc,request_url);

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.merge.call(null,file_msg,cljs.core.select_keys.call(null,file_msg_SINGLEQUOTE_,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375)], null)))], null));
});})(request_url,map__24198,map__24198__$1,file_msg,namespace))
);

return figwheel.client.file_reloading.figwheel_require.call(null,cljs.core.name.call(null,namespace),true);
});
figwheel.client.file_reloading.reload_file_QMARK_ = (function figwheel$client$file_reloading$reload_file_QMARK_(p__24200){
var map__24203 = p__24200;
var map__24203__$1 = ((((!((map__24203 == null)))?((((map__24203.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24203.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24203):map__24203);
var file_msg = map__24203__$1;
var namespace = cljs.core.get.call(null,map__24203__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));

var meta_pragmas = cljs.core.get.call(null,cljs.core.deref.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas),cljs.core.name.call(null,namespace));
var and__18358__auto__ = cljs.core.not.call(null,new cljs.core.Keyword(null,"figwheel-no-load","figwheel-no-load",-555840179).cljs$core$IFn$_invoke$arity$1(meta_pragmas));
if(and__18358__auto__){
var or__18370__auto__ = new cljs.core.Keyword(null,"figwheel-always","figwheel-always",799819691).cljs$core$IFn$_invoke$arity$1(meta_pragmas);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
var or__18370__auto____$1 = new cljs.core.Keyword(null,"figwheel-load","figwheel-load",1316089175).cljs$core$IFn$_invoke$arity$1(meta_pragmas);
if(cljs.core.truth_(or__18370__auto____$1)){
return or__18370__auto____$1;
} else {
return figwheel.client.file_reloading.provided_QMARK_.call(null,cljs.core.name.call(null,namespace));
}
}
} else {
return and__18358__auto__;
}
});
figwheel.client.file_reloading.js_reload = (function figwheel$client$file_reloading$js_reload(p__24205,callback){
var map__24208 = p__24205;
var map__24208__$1 = ((((!((map__24208 == null)))?((((map__24208.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24208.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24208):map__24208);
var file_msg = map__24208__$1;
var request_url = cljs.core.get.call(null,map__24208__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));
var namespace = cljs.core.get.call(null,map__24208__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));

if(cljs.core.truth_(figwheel.client.file_reloading.reload_file_QMARK_.call(null,file_msg))){
return figwheel.client.file_reloading.require_with_callback.call(null,file_msg,callback);
} else {
figwheel.client.utils.debug_prn.call(null,[cljs.core.str("Figwheel: Not trying to load file "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [file_msg], null));
}
});
figwheel.client.file_reloading.reload_js_file = (function figwheel$client$file_reloading$reload_js_file(file_msg){
var out = cljs.core.async.chan.call(null);
figwheel.client.file_reloading.js_reload.call(null,file_msg,((function (out){
return (function (url){
cljs.core.async.put_BANG_.call(null,out,url);

return cljs.core.async.close_BANG_.call(null,out);
});})(out))
);

return out;
});
/**
 * Returns a chanel with one collection of loaded filenames on it.
 */
figwheel.client.file_reloading.load_all_js_files = (function figwheel$client$file_reloading$load_all_js_files(files){
var out = cljs.core.async.chan.call(null);
var c__21038__auto___24296 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___24296,out){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___24296,out){
return (function (state_24278){
var state_val_24279 = (state_24278[(1)]);
if((state_val_24279 === (1))){
var inst_24256 = cljs.core.nth.call(null,files,(0),null);
var inst_24257 = cljs.core.nthnext.call(null,files,(1));
var inst_24258 = files;
var state_24278__$1 = (function (){var statearr_24280 = state_24278;
(statearr_24280[(7)] = inst_24258);

(statearr_24280[(8)] = inst_24257);

(statearr_24280[(9)] = inst_24256);

return statearr_24280;
})();
var statearr_24281_24297 = state_24278__$1;
(statearr_24281_24297[(2)] = null);

(statearr_24281_24297[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24279 === (2))){
var inst_24261 = (state_24278[(10)]);
var inst_24258 = (state_24278[(7)]);
var inst_24261__$1 = cljs.core.nth.call(null,inst_24258,(0),null);
var inst_24262 = cljs.core.nthnext.call(null,inst_24258,(1));
var inst_24263 = (inst_24261__$1 == null);
var inst_24264 = cljs.core.not.call(null,inst_24263);
var state_24278__$1 = (function (){var statearr_24282 = state_24278;
(statearr_24282[(11)] = inst_24262);

(statearr_24282[(10)] = inst_24261__$1);

return statearr_24282;
})();
if(inst_24264){
var statearr_24283_24298 = state_24278__$1;
(statearr_24283_24298[(1)] = (4));

} else {
var statearr_24284_24299 = state_24278__$1;
(statearr_24284_24299[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24279 === (3))){
var inst_24276 = (state_24278[(2)]);
var state_24278__$1 = state_24278;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24278__$1,inst_24276);
} else {
if((state_val_24279 === (4))){
var inst_24261 = (state_24278[(10)]);
var inst_24266 = figwheel.client.file_reloading.reload_js_file.call(null,inst_24261);
var state_24278__$1 = state_24278;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24278__$1,(7),inst_24266);
} else {
if((state_val_24279 === (5))){
var inst_24272 = cljs.core.async.close_BANG_.call(null,out);
var state_24278__$1 = state_24278;
var statearr_24285_24300 = state_24278__$1;
(statearr_24285_24300[(2)] = inst_24272);

(statearr_24285_24300[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24279 === (6))){
var inst_24274 = (state_24278[(2)]);
var state_24278__$1 = state_24278;
var statearr_24286_24301 = state_24278__$1;
(statearr_24286_24301[(2)] = inst_24274);

(statearr_24286_24301[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24279 === (7))){
var inst_24262 = (state_24278[(11)]);
var inst_24268 = (state_24278[(2)]);
var inst_24269 = cljs.core.async.put_BANG_.call(null,out,inst_24268);
var inst_24258 = inst_24262;
var state_24278__$1 = (function (){var statearr_24287 = state_24278;
(statearr_24287[(12)] = inst_24269);

(statearr_24287[(7)] = inst_24258);

return statearr_24287;
})();
var statearr_24288_24302 = state_24278__$1;
(statearr_24288_24302[(2)] = null);

(statearr_24288_24302[(1)] = (2));


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
});})(c__21038__auto___24296,out))
;
return ((function (switch__20926__auto__,c__21038__auto___24296,out){
return (function() {
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto__ = null;
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto____0 = (function (){
var statearr_24292 = [null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_24292[(0)] = figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto__);

(statearr_24292[(1)] = (1));

return statearr_24292;
});
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto____1 = (function (state_24278){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_24278);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e24293){if((e24293 instanceof Object)){
var ex__20930__auto__ = e24293;
var statearr_24294_24303 = state_24278;
(statearr_24294_24303[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24278);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24293;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24304 = state_24278;
state_24278 = G__24304;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto__ = function(state_24278){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto____1.call(this,state_24278);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto____0;
figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto____1;
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___24296,out))
})();
var state__21040__auto__ = (function (){var statearr_24295 = f__21039__auto__.call(null);
(statearr_24295[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___24296);

return statearr_24295;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___24296,out))
);


return cljs.core.async.into.call(null,cljs.core.PersistentVector.EMPTY,out);
});
figwheel.client.file_reloading.eval_body = (function figwheel$client$file_reloading$eval_body(p__24305,opts){
var map__24309 = p__24305;
var map__24309__$1 = ((((!((map__24309 == null)))?((((map__24309.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24309.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24309):map__24309);
var eval_body__$1 = cljs.core.get.call(null,map__24309__$1,new cljs.core.Keyword(null,"eval-body","eval-body",-907279883));
var file = cljs.core.get.call(null,map__24309__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
if(cljs.core.truth_((function (){var and__18358__auto__ = eval_body__$1;
if(cljs.core.truth_(and__18358__auto__)){
return typeof eval_body__$1 === 'string';
} else {
return and__18358__auto__;
}
})())){
var code = eval_body__$1;
try{figwheel.client.utils.debug_prn.call(null,[cljs.core.str("Evaling file "),cljs.core.str(file)].join(''));

return figwheel.client.utils.eval_helper.call(null,code,opts);
}catch (e24311){var e = e24311;
return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Unable to evaluate "),cljs.core.str(file)].join(''));
}} else {
return null;
}
});
figwheel.client.file_reloading.expand_files = (function figwheel$client$file_reloading$expand_files(files){
var deps = figwheel.client.file_reloading.get_all_dependents.call(null,cljs.core.map.call(null,new cljs.core.Keyword(null,"namespace","namespace",-377510372),files));
return cljs.core.filter.call(null,cljs.core.comp.call(null,cljs.core.not,new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 1, ["figwheel.connect",null], null), null),new cljs.core.Keyword(null,"namespace","namespace",-377510372)),cljs.core.map.call(null,((function (deps){
return (function (n){
var temp__4655__auto__ = cljs.core.first.call(null,cljs.core.filter.call(null,((function (deps){
return (function (p1__24312_SHARP_){
return cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(p1__24312_SHARP_),n);
});})(deps))
,files));
if(cljs.core.truth_(temp__4655__auto__)){
var file_msg = temp__4655__auto__;
return file_msg;
} else {
return new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"type","type",1174270348),new cljs.core.Keyword(null,"namespace","namespace",-377510372),new cljs.core.Keyword(null,"namespace","namespace",-377510372),n], null);
}
});})(deps))
,deps));
});
figwheel.client.file_reloading.sort_files = (function figwheel$client$file_reloading$sort_files(files){
if((cljs.core.count.call(null,files) <= (1))){
return files;
} else {
var keep_files = cljs.core.set.call(null,cljs.core.keep.call(null,new cljs.core.Keyword(null,"namespace","namespace",-377510372),files));
return cljs.core.filter.call(null,cljs.core.comp.call(null,keep_files,new cljs.core.Keyword(null,"namespace","namespace",-377510372)),figwheel.client.file_reloading.expand_files.call(null,files));
}
});
figwheel.client.file_reloading.get_figwheel_always = (function figwheel$client$file_reloading$get_figwheel_always(){
return cljs.core.map.call(null,(function (p__24317){
var vec__24318 = p__24317;
var k = cljs.core.nth.call(null,vec__24318,(0),null);
var v = cljs.core.nth.call(null,vec__24318,(1),null);
return new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"namespace","namespace",-377510372),k,new cljs.core.Keyword(null,"type","type",1174270348),new cljs.core.Keyword(null,"namespace","namespace",-377510372)], null);
}),cljs.core.filter.call(null,(function (p__24319){
var vec__24320 = p__24319;
var k = cljs.core.nth.call(null,vec__24320,(0),null);
var v = cljs.core.nth.call(null,vec__24320,(1),null);
return new cljs.core.Keyword(null,"figwheel-always","figwheel-always",799819691).cljs$core$IFn$_invoke$arity$1(v);
}),cljs.core.deref.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas)));
});
figwheel.client.file_reloading.reload_js_files = (function figwheel$client$file_reloading$reload_js_files(p__24324,p__24325){
var map__24572 = p__24324;
var map__24572__$1 = ((((!((map__24572 == null)))?((((map__24572.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24572.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24572):map__24572);
var opts = map__24572__$1;
var before_jsload = cljs.core.get.call(null,map__24572__$1,new cljs.core.Keyword(null,"before-jsload","before-jsload",-847513128));
var on_jsload = cljs.core.get.call(null,map__24572__$1,new cljs.core.Keyword(null,"on-jsload","on-jsload",-395756602));
var reload_dependents = cljs.core.get.call(null,map__24572__$1,new cljs.core.Keyword(null,"reload-dependents","reload-dependents",-956865430));
var map__24573 = p__24325;
var map__24573__$1 = ((((!((map__24573 == null)))?((((map__24573.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24573.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24573):map__24573);
var msg = map__24573__$1;
var files = cljs.core.get.call(null,map__24573__$1,new cljs.core.Keyword(null,"files","files",-472457450));
var figwheel_meta = cljs.core.get.call(null,map__24573__$1,new cljs.core.Keyword(null,"figwheel-meta","figwheel-meta",-225970237));
var recompile_dependents = cljs.core.get.call(null,map__24573__$1,new cljs.core.Keyword(null,"recompile-dependents","recompile-dependents",523804171));
if(cljs.core.empty_QMARK_.call(null,figwheel_meta)){
} else {
cljs.core.reset_BANG_.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas,figwheel_meta);
}

var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (state_24726){
var state_val_24727 = (state_24726[(1)]);
if((state_val_24727 === (7))){
var inst_24589 = (state_24726[(7)]);
var inst_24590 = (state_24726[(8)]);
var inst_24588 = (state_24726[(9)]);
var inst_24587 = (state_24726[(10)]);
var inst_24595 = cljs.core._nth.call(null,inst_24588,inst_24590);
var inst_24596 = figwheel.client.file_reloading.eval_body.call(null,inst_24595,opts);
var inst_24597 = (inst_24590 + (1));
var tmp24728 = inst_24589;
var tmp24729 = inst_24588;
var tmp24730 = inst_24587;
var inst_24587__$1 = tmp24730;
var inst_24588__$1 = tmp24729;
var inst_24589__$1 = tmp24728;
var inst_24590__$1 = inst_24597;
var state_24726__$1 = (function (){var statearr_24731 = state_24726;
(statearr_24731[(7)] = inst_24589__$1);

(statearr_24731[(8)] = inst_24590__$1);

(statearr_24731[(11)] = inst_24596);

(statearr_24731[(9)] = inst_24588__$1);

(statearr_24731[(10)] = inst_24587__$1);

return statearr_24731;
})();
var statearr_24732_24818 = state_24726__$1;
(statearr_24732_24818[(2)] = null);

(statearr_24732_24818[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (20))){
var inst_24630 = (state_24726[(12)]);
var inst_24638 = figwheel.client.file_reloading.sort_files.call(null,inst_24630);
var state_24726__$1 = state_24726;
var statearr_24733_24819 = state_24726__$1;
(statearr_24733_24819[(2)] = inst_24638);

(statearr_24733_24819[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (27))){
var state_24726__$1 = state_24726;
var statearr_24734_24820 = state_24726__$1;
(statearr_24734_24820[(2)] = null);

(statearr_24734_24820[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (1))){
var inst_24579 = (state_24726[(13)]);
var inst_24576 = before_jsload.call(null,files);
var inst_24577 = figwheel.client.file_reloading.before_jsload_custom_event.call(null,files);
var inst_24578 = (function (){return ((function (inst_24579,inst_24576,inst_24577,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24321_SHARP_){
return new cljs.core.Keyword(null,"eval-body","eval-body",-907279883).cljs$core$IFn$_invoke$arity$1(p1__24321_SHARP_);
});
;})(inst_24579,inst_24576,inst_24577,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24579__$1 = cljs.core.filter.call(null,inst_24578,files);
var inst_24580 = cljs.core.not_empty.call(null,inst_24579__$1);
var state_24726__$1 = (function (){var statearr_24735 = state_24726;
(statearr_24735[(13)] = inst_24579__$1);

(statearr_24735[(14)] = inst_24577);

(statearr_24735[(15)] = inst_24576);

return statearr_24735;
})();
if(cljs.core.truth_(inst_24580)){
var statearr_24736_24821 = state_24726__$1;
(statearr_24736_24821[(1)] = (2));

} else {
var statearr_24737_24822 = state_24726__$1;
(statearr_24737_24822[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (24))){
var state_24726__$1 = state_24726;
var statearr_24738_24823 = state_24726__$1;
(statearr_24738_24823[(2)] = null);

(statearr_24738_24823[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (39))){
var inst_24680 = (state_24726[(16)]);
var state_24726__$1 = state_24726;
var statearr_24739_24824 = state_24726__$1;
(statearr_24739_24824[(2)] = inst_24680);

(statearr_24739_24824[(1)] = (40));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (46))){
var inst_24721 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
var statearr_24740_24825 = state_24726__$1;
(statearr_24740_24825[(2)] = inst_24721);

(statearr_24740_24825[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (4))){
var inst_24624 = (state_24726[(2)]);
var inst_24625 = cljs.core.List.EMPTY;
var inst_24626 = cljs.core.reset_BANG_.call(null,figwheel.client.file_reloading.dependencies_loaded,inst_24625);
var inst_24627 = (function (){return ((function (inst_24624,inst_24625,inst_24626,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24322_SHARP_){
var and__18358__auto__ = new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(p1__24322_SHARP_);
if(cljs.core.truth_(and__18358__auto__)){
return cljs.core.not.call(null,new cljs.core.Keyword(null,"eval-body","eval-body",-907279883).cljs$core$IFn$_invoke$arity$1(p1__24322_SHARP_));
} else {
return and__18358__auto__;
}
});
;})(inst_24624,inst_24625,inst_24626,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24628 = cljs.core.filter.call(null,inst_24627,files);
var inst_24629 = figwheel.client.file_reloading.get_figwheel_always.call(null);
var inst_24630 = cljs.core.concat.call(null,inst_24628,inst_24629);
var state_24726__$1 = (function (){var statearr_24741 = state_24726;
(statearr_24741[(12)] = inst_24630);

(statearr_24741[(17)] = inst_24626);

(statearr_24741[(18)] = inst_24624);

return statearr_24741;
})();
if(cljs.core.truth_(reload_dependents)){
var statearr_24742_24826 = state_24726__$1;
(statearr_24742_24826[(1)] = (16));

} else {
var statearr_24743_24827 = state_24726__$1;
(statearr_24743_24827[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (15))){
var inst_24614 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
var statearr_24744_24828 = state_24726__$1;
(statearr_24744_24828[(2)] = inst_24614);

(statearr_24744_24828[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (21))){
var inst_24640 = (state_24726[(19)]);
var inst_24640__$1 = (state_24726[(2)]);
var inst_24641 = figwheel.client.file_reloading.load_all_js_files.call(null,inst_24640__$1);
var state_24726__$1 = (function (){var statearr_24745 = state_24726;
(statearr_24745[(19)] = inst_24640__$1);

return statearr_24745;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24726__$1,(22),inst_24641);
} else {
if((state_val_24727 === (31))){
var inst_24724 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24726__$1,inst_24724);
} else {
if((state_val_24727 === (32))){
var inst_24680 = (state_24726[(16)]);
var inst_24685 = inst_24680.cljs$lang$protocol_mask$partition0$;
var inst_24686 = (inst_24685 & (64));
var inst_24687 = inst_24680.cljs$core$ISeq$;
var inst_24688 = (inst_24686) || (inst_24687);
var state_24726__$1 = state_24726;
if(cljs.core.truth_(inst_24688)){
var statearr_24746_24829 = state_24726__$1;
(statearr_24746_24829[(1)] = (35));

} else {
var statearr_24747_24830 = state_24726__$1;
(statearr_24747_24830[(1)] = (36));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (40))){
var inst_24701 = (state_24726[(20)]);
var inst_24700 = (state_24726[(2)]);
var inst_24701__$1 = cljs.core.get.call(null,inst_24700,new cljs.core.Keyword(null,"figwheel-no-load","figwheel-no-load",-555840179));
var inst_24702 = cljs.core.get.call(null,inst_24700,new cljs.core.Keyword(null,"not-required","not-required",-950359114));
var inst_24703 = cljs.core.not_empty.call(null,inst_24701__$1);
var state_24726__$1 = (function (){var statearr_24748 = state_24726;
(statearr_24748[(20)] = inst_24701__$1);

(statearr_24748[(21)] = inst_24702);

return statearr_24748;
})();
if(cljs.core.truth_(inst_24703)){
var statearr_24749_24831 = state_24726__$1;
(statearr_24749_24831[(1)] = (41));

} else {
var statearr_24750_24832 = state_24726__$1;
(statearr_24750_24832[(1)] = (42));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (33))){
var state_24726__$1 = state_24726;
var statearr_24751_24833 = state_24726__$1;
(statearr_24751_24833[(2)] = false);

(statearr_24751_24833[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (13))){
var inst_24600 = (state_24726[(22)]);
var inst_24604 = cljs.core.chunk_first.call(null,inst_24600);
var inst_24605 = cljs.core.chunk_rest.call(null,inst_24600);
var inst_24606 = cljs.core.count.call(null,inst_24604);
var inst_24587 = inst_24605;
var inst_24588 = inst_24604;
var inst_24589 = inst_24606;
var inst_24590 = (0);
var state_24726__$1 = (function (){var statearr_24752 = state_24726;
(statearr_24752[(7)] = inst_24589);

(statearr_24752[(8)] = inst_24590);

(statearr_24752[(9)] = inst_24588);

(statearr_24752[(10)] = inst_24587);

return statearr_24752;
})();
var statearr_24753_24834 = state_24726__$1;
(statearr_24753_24834[(2)] = null);

(statearr_24753_24834[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (22))){
var inst_24640 = (state_24726[(19)]);
var inst_24648 = (state_24726[(23)]);
var inst_24644 = (state_24726[(24)]);
var inst_24643 = (state_24726[(25)]);
var inst_24643__$1 = (state_24726[(2)]);
var inst_24644__$1 = cljs.core.filter.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),inst_24643__$1);
var inst_24645 = (function (){var all_files = inst_24640;
var res_SINGLEQUOTE_ = inst_24643__$1;
var res = inst_24644__$1;
return ((function (all_files,res_SINGLEQUOTE_,res,inst_24640,inst_24648,inst_24644,inst_24643,inst_24643__$1,inst_24644__$1,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24323_SHARP_){
return cljs.core.not.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375).cljs$core$IFn$_invoke$arity$1(p1__24323_SHARP_));
});
;})(all_files,res_SINGLEQUOTE_,res,inst_24640,inst_24648,inst_24644,inst_24643,inst_24643__$1,inst_24644__$1,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24646 = cljs.core.filter.call(null,inst_24645,inst_24643__$1);
var inst_24647 = cljs.core.deref.call(null,figwheel.client.file_reloading.dependencies_loaded);
var inst_24648__$1 = cljs.core.filter.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),inst_24647);
var inst_24649 = cljs.core.not_empty.call(null,inst_24648__$1);
var state_24726__$1 = (function (){var statearr_24754 = state_24726;
(statearr_24754[(23)] = inst_24648__$1);

(statearr_24754[(26)] = inst_24646);

(statearr_24754[(24)] = inst_24644__$1);

(statearr_24754[(25)] = inst_24643__$1);

return statearr_24754;
})();
if(cljs.core.truth_(inst_24649)){
var statearr_24755_24835 = state_24726__$1;
(statearr_24755_24835[(1)] = (23));

} else {
var statearr_24756_24836 = state_24726__$1;
(statearr_24756_24836[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (36))){
var state_24726__$1 = state_24726;
var statearr_24757_24837 = state_24726__$1;
(statearr_24757_24837[(2)] = false);

(statearr_24757_24837[(1)] = (37));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (41))){
var inst_24701 = (state_24726[(20)]);
var inst_24705 = cljs.core.comp.call(null,figwheel.client.file_reloading.name__GT_path,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var inst_24706 = cljs.core.map.call(null,inst_24705,inst_24701);
var inst_24707 = cljs.core.pr_str.call(null,inst_24706);
var inst_24708 = [cljs.core.str("figwheel-no-load meta-data: "),cljs.core.str(inst_24707)].join('');
var inst_24709 = figwheel.client.utils.log.call(null,inst_24708);
var state_24726__$1 = state_24726;
var statearr_24758_24838 = state_24726__$1;
(statearr_24758_24838[(2)] = inst_24709);

(statearr_24758_24838[(1)] = (43));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (43))){
var inst_24702 = (state_24726[(21)]);
var inst_24712 = (state_24726[(2)]);
var inst_24713 = cljs.core.not_empty.call(null,inst_24702);
var state_24726__$1 = (function (){var statearr_24759 = state_24726;
(statearr_24759[(27)] = inst_24712);

return statearr_24759;
})();
if(cljs.core.truth_(inst_24713)){
var statearr_24760_24839 = state_24726__$1;
(statearr_24760_24839[(1)] = (44));

} else {
var statearr_24761_24840 = state_24726__$1;
(statearr_24761_24840[(1)] = (45));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (29))){
var inst_24640 = (state_24726[(19)]);
var inst_24648 = (state_24726[(23)]);
var inst_24646 = (state_24726[(26)]);
var inst_24644 = (state_24726[(24)]);
var inst_24643 = (state_24726[(25)]);
var inst_24680 = (state_24726[(16)]);
var inst_24676 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: NOT loading these files ");
var inst_24679 = (function (){var all_files = inst_24640;
var res_SINGLEQUOTE_ = inst_24643;
var res = inst_24644;
var files_not_loaded = inst_24646;
var dependencies_that_loaded = inst_24648;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24680,inst_24676,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24678){
var map__24762 = p__24678;
var map__24762__$1 = ((((!((map__24762 == null)))?((((map__24762.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24762.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24762):map__24762);
var namespace = cljs.core.get.call(null,map__24762__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var meta_data = cljs.core.get.call(null,cljs.core.deref.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas),cljs.core.name.call(null,namespace));
if((meta_data == null)){
return new cljs.core.Keyword(null,"not-required","not-required",-950359114);
} else {
if(cljs.core.truth_(meta_data.call(null,new cljs.core.Keyword(null,"figwheel-no-load","figwheel-no-load",-555840179)))){
return new cljs.core.Keyword(null,"figwheel-no-load","figwheel-no-load",-555840179);
} else {
return new cljs.core.Keyword(null,"not-required","not-required",-950359114);

}
}
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24680,inst_24676,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24680__$1 = cljs.core.group_by.call(null,inst_24679,inst_24646);
var inst_24682 = (inst_24680__$1 == null);
var inst_24683 = cljs.core.not.call(null,inst_24682);
var state_24726__$1 = (function (){var statearr_24764 = state_24726;
(statearr_24764[(16)] = inst_24680__$1);

(statearr_24764[(28)] = inst_24676);

return statearr_24764;
})();
if(inst_24683){
var statearr_24765_24841 = state_24726__$1;
(statearr_24765_24841[(1)] = (32));

} else {
var statearr_24766_24842 = state_24726__$1;
(statearr_24766_24842[(1)] = (33));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (44))){
var inst_24702 = (state_24726[(21)]);
var inst_24715 = cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),inst_24702);
var inst_24716 = cljs.core.pr_str.call(null,inst_24715);
var inst_24717 = [cljs.core.str("not required: "),cljs.core.str(inst_24716)].join('');
var inst_24718 = figwheel.client.utils.log.call(null,inst_24717);
var state_24726__$1 = state_24726;
var statearr_24767_24843 = state_24726__$1;
(statearr_24767_24843[(2)] = inst_24718);

(statearr_24767_24843[(1)] = (46));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (6))){
var inst_24621 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
var statearr_24768_24844 = state_24726__$1;
(statearr_24768_24844[(2)] = inst_24621);

(statearr_24768_24844[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (28))){
var inst_24646 = (state_24726[(26)]);
var inst_24673 = (state_24726[(2)]);
var inst_24674 = cljs.core.not_empty.call(null,inst_24646);
var state_24726__$1 = (function (){var statearr_24769 = state_24726;
(statearr_24769[(29)] = inst_24673);

return statearr_24769;
})();
if(cljs.core.truth_(inst_24674)){
var statearr_24770_24845 = state_24726__$1;
(statearr_24770_24845[(1)] = (29));

} else {
var statearr_24771_24846 = state_24726__$1;
(statearr_24771_24846[(1)] = (30));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (25))){
var inst_24644 = (state_24726[(24)]);
var inst_24660 = (state_24726[(2)]);
var inst_24661 = cljs.core.not_empty.call(null,inst_24644);
var state_24726__$1 = (function (){var statearr_24772 = state_24726;
(statearr_24772[(30)] = inst_24660);

return statearr_24772;
})();
if(cljs.core.truth_(inst_24661)){
var statearr_24773_24847 = state_24726__$1;
(statearr_24773_24847[(1)] = (26));

} else {
var statearr_24774_24848 = state_24726__$1;
(statearr_24774_24848[(1)] = (27));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (34))){
var inst_24695 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
if(cljs.core.truth_(inst_24695)){
var statearr_24775_24849 = state_24726__$1;
(statearr_24775_24849[(1)] = (38));

} else {
var statearr_24776_24850 = state_24726__$1;
(statearr_24776_24850[(1)] = (39));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (17))){
var state_24726__$1 = state_24726;
var statearr_24777_24851 = state_24726__$1;
(statearr_24777_24851[(2)] = recompile_dependents);

(statearr_24777_24851[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (3))){
var state_24726__$1 = state_24726;
var statearr_24778_24852 = state_24726__$1;
(statearr_24778_24852[(2)] = null);

(statearr_24778_24852[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (12))){
var inst_24617 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
var statearr_24779_24853 = state_24726__$1;
(statearr_24779_24853[(2)] = inst_24617);

(statearr_24779_24853[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (2))){
var inst_24579 = (state_24726[(13)]);
var inst_24586 = cljs.core.seq.call(null,inst_24579);
var inst_24587 = inst_24586;
var inst_24588 = null;
var inst_24589 = (0);
var inst_24590 = (0);
var state_24726__$1 = (function (){var statearr_24780 = state_24726;
(statearr_24780[(7)] = inst_24589);

(statearr_24780[(8)] = inst_24590);

(statearr_24780[(9)] = inst_24588);

(statearr_24780[(10)] = inst_24587);

return statearr_24780;
})();
var statearr_24781_24854 = state_24726__$1;
(statearr_24781_24854[(2)] = null);

(statearr_24781_24854[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (23))){
var inst_24640 = (state_24726[(19)]);
var inst_24648 = (state_24726[(23)]);
var inst_24646 = (state_24726[(26)]);
var inst_24644 = (state_24726[(24)]);
var inst_24643 = (state_24726[(25)]);
var inst_24651 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded these dependencies");
var inst_24653 = (function (){var all_files = inst_24640;
var res_SINGLEQUOTE_ = inst_24643;
var res = inst_24644;
var files_not_loaded = inst_24646;
var dependencies_that_loaded = inst_24648;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24651,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24652){
var map__24782 = p__24652;
var map__24782__$1 = ((((!((map__24782 == null)))?((((map__24782.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24782.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24782):map__24782);
var request_url = cljs.core.get.call(null,map__24782__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));
return clojure.string.replace.call(null,request_url,goog.basePath,"");
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24651,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24654 = cljs.core.reverse.call(null,inst_24648);
var inst_24655 = cljs.core.map.call(null,inst_24653,inst_24654);
var inst_24656 = cljs.core.pr_str.call(null,inst_24655);
var inst_24657 = figwheel.client.utils.log.call(null,inst_24656);
var state_24726__$1 = (function (){var statearr_24784 = state_24726;
(statearr_24784[(31)] = inst_24651);

return statearr_24784;
})();
var statearr_24785_24855 = state_24726__$1;
(statearr_24785_24855[(2)] = inst_24657);

(statearr_24785_24855[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (35))){
var state_24726__$1 = state_24726;
var statearr_24786_24856 = state_24726__$1;
(statearr_24786_24856[(2)] = true);

(statearr_24786_24856[(1)] = (37));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (19))){
var inst_24630 = (state_24726[(12)]);
var inst_24636 = figwheel.client.file_reloading.expand_files.call(null,inst_24630);
var state_24726__$1 = state_24726;
var statearr_24787_24857 = state_24726__$1;
(statearr_24787_24857[(2)] = inst_24636);

(statearr_24787_24857[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (11))){
var state_24726__$1 = state_24726;
var statearr_24788_24858 = state_24726__$1;
(statearr_24788_24858[(2)] = null);

(statearr_24788_24858[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (9))){
var inst_24619 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
var statearr_24789_24859 = state_24726__$1;
(statearr_24789_24859[(2)] = inst_24619);

(statearr_24789_24859[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (5))){
var inst_24589 = (state_24726[(7)]);
var inst_24590 = (state_24726[(8)]);
var inst_24592 = (inst_24590 < inst_24589);
var inst_24593 = inst_24592;
var state_24726__$1 = state_24726;
if(cljs.core.truth_(inst_24593)){
var statearr_24790_24860 = state_24726__$1;
(statearr_24790_24860[(1)] = (7));

} else {
var statearr_24791_24861 = state_24726__$1;
(statearr_24791_24861[(1)] = (8));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (14))){
var inst_24600 = (state_24726[(22)]);
var inst_24609 = cljs.core.first.call(null,inst_24600);
var inst_24610 = figwheel.client.file_reloading.eval_body.call(null,inst_24609,opts);
var inst_24611 = cljs.core.next.call(null,inst_24600);
var inst_24587 = inst_24611;
var inst_24588 = null;
var inst_24589 = (0);
var inst_24590 = (0);
var state_24726__$1 = (function (){var statearr_24792 = state_24726;
(statearr_24792[(7)] = inst_24589);

(statearr_24792[(8)] = inst_24590);

(statearr_24792[(9)] = inst_24588);

(statearr_24792[(10)] = inst_24587);

(statearr_24792[(32)] = inst_24610);

return statearr_24792;
})();
var statearr_24793_24862 = state_24726__$1;
(statearr_24793_24862[(2)] = null);

(statearr_24793_24862[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (45))){
var state_24726__$1 = state_24726;
var statearr_24794_24863 = state_24726__$1;
(statearr_24794_24863[(2)] = null);

(statearr_24794_24863[(1)] = (46));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (26))){
var inst_24640 = (state_24726[(19)]);
var inst_24648 = (state_24726[(23)]);
var inst_24646 = (state_24726[(26)]);
var inst_24644 = (state_24726[(24)]);
var inst_24643 = (state_24726[(25)]);
var inst_24663 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded these files");
var inst_24665 = (function (){var all_files = inst_24640;
var res_SINGLEQUOTE_ = inst_24643;
var res = inst_24644;
var files_not_loaded = inst_24646;
var dependencies_that_loaded = inst_24648;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24663,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24664){
var map__24795 = p__24664;
var map__24795__$1 = ((((!((map__24795 == null)))?((((map__24795.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24795.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24795):map__24795);
var namespace = cljs.core.get.call(null,map__24795__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var file = cljs.core.get.call(null,map__24795__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
if(cljs.core.truth_(namespace)){
return figwheel.client.file_reloading.name__GT_path.call(null,cljs.core.name.call(null,namespace));
} else {
return file;
}
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24663,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24666 = cljs.core.map.call(null,inst_24665,inst_24644);
var inst_24667 = cljs.core.pr_str.call(null,inst_24666);
var inst_24668 = figwheel.client.utils.log.call(null,inst_24667);
var inst_24669 = (function (){var all_files = inst_24640;
var res_SINGLEQUOTE_ = inst_24643;
var res = inst_24644;
var files_not_loaded = inst_24646;
var dependencies_that_loaded = inst_24648;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24663,inst_24665,inst_24666,inst_24667,inst_24668,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (){
figwheel.client.file_reloading.on_jsload_custom_event.call(null,res);

return cljs.core.apply.call(null,on_jsload,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [res], null));
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24640,inst_24648,inst_24646,inst_24644,inst_24643,inst_24663,inst_24665,inst_24666,inst_24667,inst_24668,state_val_24727,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24670 = setTimeout(inst_24669,(10));
var state_24726__$1 = (function (){var statearr_24797 = state_24726;
(statearr_24797[(33)] = inst_24663);

(statearr_24797[(34)] = inst_24668);

return statearr_24797;
})();
var statearr_24798_24864 = state_24726__$1;
(statearr_24798_24864[(2)] = inst_24670);

(statearr_24798_24864[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (16))){
var state_24726__$1 = state_24726;
var statearr_24799_24865 = state_24726__$1;
(statearr_24799_24865[(2)] = reload_dependents);

(statearr_24799_24865[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (38))){
var inst_24680 = (state_24726[(16)]);
var inst_24697 = cljs.core.apply.call(null,cljs.core.hash_map,inst_24680);
var state_24726__$1 = state_24726;
var statearr_24800_24866 = state_24726__$1;
(statearr_24800_24866[(2)] = inst_24697);

(statearr_24800_24866[(1)] = (40));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (30))){
var state_24726__$1 = state_24726;
var statearr_24801_24867 = state_24726__$1;
(statearr_24801_24867[(2)] = null);

(statearr_24801_24867[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (10))){
var inst_24600 = (state_24726[(22)]);
var inst_24602 = cljs.core.chunked_seq_QMARK_.call(null,inst_24600);
var state_24726__$1 = state_24726;
if(inst_24602){
var statearr_24802_24868 = state_24726__$1;
(statearr_24802_24868[(1)] = (13));

} else {
var statearr_24803_24869 = state_24726__$1;
(statearr_24803_24869[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (18))){
var inst_24634 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
if(cljs.core.truth_(inst_24634)){
var statearr_24804_24870 = state_24726__$1;
(statearr_24804_24870[(1)] = (19));

} else {
var statearr_24805_24871 = state_24726__$1;
(statearr_24805_24871[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (42))){
var state_24726__$1 = state_24726;
var statearr_24806_24872 = state_24726__$1;
(statearr_24806_24872[(2)] = null);

(statearr_24806_24872[(1)] = (43));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (37))){
var inst_24692 = (state_24726[(2)]);
var state_24726__$1 = state_24726;
var statearr_24807_24873 = state_24726__$1;
(statearr_24807_24873[(2)] = inst_24692);

(statearr_24807_24873[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24727 === (8))){
var inst_24600 = (state_24726[(22)]);
var inst_24587 = (state_24726[(10)]);
var inst_24600__$1 = cljs.core.seq.call(null,inst_24587);
var state_24726__$1 = (function (){var statearr_24808 = state_24726;
(statearr_24808[(22)] = inst_24600__$1);

return statearr_24808;
})();
if(inst_24600__$1){
var statearr_24809_24874 = state_24726__$1;
(statearr_24809_24874[(1)] = (10));

} else {
var statearr_24810_24875 = state_24726__$1;
(statearr_24810_24875[(1)] = (11));

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
}
});})(c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
;
return ((function (switch__20926__auto__,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents){
return (function() {
var figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto__ = null;
var figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto____0 = (function (){
var statearr_24814 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_24814[(0)] = figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto__);

(statearr_24814[(1)] = (1));

return statearr_24814;
});
var figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto____1 = (function (state_24726){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_24726);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e24815){if((e24815 instanceof Object)){
var ex__20930__auto__ = e24815;
var statearr_24816_24876 = state_24726;
(statearr_24816_24876[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24726);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24815;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24877 = state_24726;
state_24726 = G__24877;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto__ = function(state_24726){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto____1.call(this,state_24726);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto____0;
figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto____1;
return figwheel$client$file_reloading$reload_js_files_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var state__21040__auto__ = (function (){var statearr_24817 = f__21039__auto__.call(null);
(statearr_24817[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_24817;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__,map__24572,map__24572__$1,opts,before_jsload,on_jsload,reload_dependents,map__24573,map__24573__$1,msg,files,figwheel_meta,recompile_dependents))
);

return c__21038__auto__;
});
figwheel.client.file_reloading.current_links = (function figwheel$client$file_reloading$current_links(){
return Array.prototype.slice.call(document.getElementsByTagName("link"));
});
figwheel.client.file_reloading.truncate_url = (function figwheel$client$file_reloading$truncate_url(url){
return clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,cljs.core.first.call(null,clojure.string.split.call(null,url,/\?/)),[cljs.core.str(location.protocol),cljs.core.str("//")].join(''),""),".*://",""),/^\/\//,""),/[^\\/]*/,"");
});
figwheel.client.file_reloading.matches_file_QMARK_ = (function figwheel$client$file_reloading$matches_file_QMARK_(p__24880,link){
var map__24883 = p__24880;
var map__24883__$1 = ((((!((map__24883 == null)))?((((map__24883.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24883.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24883):map__24883);
var file = cljs.core.get.call(null,map__24883__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
var temp__4657__auto__ = link.href;
if(cljs.core.truth_(temp__4657__auto__)){
var link_href = temp__4657__auto__;
var match = clojure.string.join.call(null,"/",cljs.core.take_while.call(null,cljs.core.identity,cljs.core.map.call(null,((function (link_href,temp__4657__auto__,map__24883,map__24883__$1,file){
return (function (p1__24878_SHARP_,p2__24879_SHARP_){
if(cljs.core._EQ_.call(null,p1__24878_SHARP_,p2__24879_SHARP_)){
return p1__24878_SHARP_;
} else {
return false;
}
});})(link_href,temp__4657__auto__,map__24883,map__24883__$1,file))
,cljs.core.reverse.call(null,clojure.string.split.call(null,file,"/")),cljs.core.reverse.call(null,clojure.string.split.call(null,figwheel.client.file_reloading.truncate_url.call(null,link_href),"/")))));
var match_length = cljs.core.count.call(null,match);
var file_name_length = cljs.core.count.call(null,cljs.core.last.call(null,clojure.string.split.call(null,file,"/")));
if((match_length >= file_name_length)){
return new cljs.core.PersistentArrayMap(null, 4, [new cljs.core.Keyword(null,"link","link",-1769163468),link,new cljs.core.Keyword(null,"link-href","link-href",-250644450),link_href,new cljs.core.Keyword(null,"match-length","match-length",1101537310),match_length,new cljs.core.Keyword(null,"current-url-length","current-url-length",380404083),cljs.core.count.call(null,figwheel.client.file_reloading.truncate_url.call(null,link_href))], null);
} else {
return null;
}
} else {
return null;
}
});
figwheel.client.file_reloading.get_correct_link = (function figwheel$client$file_reloading$get_correct_link(f_data){
var temp__4657__auto__ = cljs.core.first.call(null,cljs.core.sort_by.call(null,(function (p__24889){
var map__24890 = p__24889;
var map__24890__$1 = ((((!((map__24890 == null)))?((((map__24890.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24890.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24890):map__24890);
var match_length = cljs.core.get.call(null,map__24890__$1,new cljs.core.Keyword(null,"match-length","match-length",1101537310));
var current_url_length = cljs.core.get.call(null,map__24890__$1,new cljs.core.Keyword(null,"current-url-length","current-url-length",380404083));
return (current_url_length - match_length);
}),cljs.core.keep.call(null,(function (p1__24885_SHARP_){
return figwheel.client.file_reloading.matches_file_QMARK_.call(null,f_data,p1__24885_SHARP_);
}),figwheel.client.file_reloading.current_links.call(null))));
if(cljs.core.truth_(temp__4657__auto__)){
var res = temp__4657__auto__;
return new cljs.core.Keyword(null,"link","link",-1769163468).cljs$core$IFn$_invoke$arity$1(res);
} else {
return null;
}
});
figwheel.client.file_reloading.clone_link = (function figwheel$client$file_reloading$clone_link(link,url){
var clone = document.createElement("link");
clone.rel = "stylesheet";

clone.media = link.media;

clone.disabled = link.disabled;

clone.href = figwheel.client.file_reloading.add_cache_buster.call(null,url);

return clone;
});
figwheel.client.file_reloading.create_link = (function figwheel$client$file_reloading$create_link(url){
var link = document.createElement("link");
link.rel = "stylesheet";

link.href = figwheel.client.file_reloading.add_cache_buster.call(null,url);

return link;
});
figwheel.client.file_reloading.add_link_to_doc = (function figwheel$client$file_reloading$add_link_to_doc(var_args){
var args24892 = [];
var len__19428__auto___24895 = arguments.length;
var i__19429__auto___24896 = (0);
while(true){
if((i__19429__auto___24896 < len__19428__auto___24895)){
args24892.push((arguments[i__19429__auto___24896]));

var G__24897 = (i__19429__auto___24896 + (1));
i__19429__auto___24896 = G__24897;
continue;
} else {
}
break;
}

var G__24894 = args24892.length;
switch (G__24894) {
case 1:
return figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args24892.length)].join('')));

}
});

figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$1 = (function (new_link){
return (document.getElementsByTagName("head")[(0)]).appendChild(new_link);
});

figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$2 = (function (orig_link,klone){
var parent = orig_link.parentNode;
if(cljs.core._EQ_.call(null,orig_link,parent.lastChild)){
parent.appendChild(klone);
} else {
parent.insertBefore(klone,orig_link.nextSibling);
}

return setTimeout(((function (parent){
return (function (){
return parent.removeChild(orig_link);
});})(parent))
,(300));
});

figwheel.client.file_reloading.add_link_to_doc.cljs$lang$maxFixedArity = 2;
figwheel.client.file_reloading.distictify = (function figwheel$client$file_reloading$distictify(key,seqq){
return cljs.core.vals.call(null,cljs.core.reduce.call(null,(function (p1__24899_SHARP_,p2__24900_SHARP_){
return cljs.core.assoc.call(null,p1__24899_SHARP_,cljs.core.get.call(null,p2__24900_SHARP_,key),p2__24900_SHARP_);
}),cljs.core.PersistentArrayMap.EMPTY,seqq));
});
figwheel.client.file_reloading.reload_css_file = (function figwheel$client$file_reloading$reload_css_file(p__24901){
var map__24904 = p__24901;
var map__24904__$1 = ((((!((map__24904 == null)))?((((map__24904.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24904.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24904):map__24904);
var f_data = map__24904__$1;
var file = cljs.core.get.call(null,map__24904__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
var temp__4657__auto__ = figwheel.client.file_reloading.get_correct_link.call(null,f_data);
if(cljs.core.truth_(temp__4657__auto__)){
var link = temp__4657__auto__;
return figwheel.client.file_reloading.add_link_to_doc.call(null,link,figwheel.client.file_reloading.clone_link.call(null,link,link.href));
} else {
return null;
}
});
figwheel.client.file_reloading.reload_css_files = (function figwheel$client$file_reloading$reload_css_files(p__24906,files_msg){
var map__24913 = p__24906;
var map__24913__$1 = ((((!((map__24913 == null)))?((((map__24913.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24913.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24913):map__24913);
var opts = map__24913__$1;
var on_cssload = cljs.core.get.call(null,map__24913__$1,new cljs.core.Keyword(null,"on-cssload","on-cssload",1825432318));
if(cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))){
var seq__24915_24919 = cljs.core.seq.call(null,figwheel.client.file_reloading.distictify.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(files_msg)));
var chunk__24916_24920 = null;
var count__24917_24921 = (0);
var i__24918_24922 = (0);
while(true){
if((i__24918_24922 < count__24917_24921)){
var f_24923 = cljs.core._nth.call(null,chunk__24916_24920,i__24918_24922);
figwheel.client.file_reloading.reload_css_file.call(null,f_24923);

var G__24924 = seq__24915_24919;
var G__24925 = chunk__24916_24920;
var G__24926 = count__24917_24921;
var G__24927 = (i__24918_24922 + (1));
seq__24915_24919 = G__24924;
chunk__24916_24920 = G__24925;
count__24917_24921 = G__24926;
i__24918_24922 = G__24927;
continue;
} else {
var temp__4657__auto___24928 = cljs.core.seq.call(null,seq__24915_24919);
if(temp__4657__auto___24928){
var seq__24915_24929__$1 = temp__4657__auto___24928;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24915_24929__$1)){
var c__19173__auto___24930 = cljs.core.chunk_first.call(null,seq__24915_24929__$1);
var G__24931 = cljs.core.chunk_rest.call(null,seq__24915_24929__$1);
var G__24932 = c__19173__auto___24930;
var G__24933 = cljs.core.count.call(null,c__19173__auto___24930);
var G__24934 = (0);
seq__24915_24919 = G__24931;
chunk__24916_24920 = G__24932;
count__24917_24921 = G__24933;
i__24918_24922 = G__24934;
continue;
} else {
var f_24935 = cljs.core.first.call(null,seq__24915_24929__$1);
figwheel.client.file_reloading.reload_css_file.call(null,f_24935);

var G__24936 = cljs.core.next.call(null,seq__24915_24929__$1);
var G__24937 = null;
var G__24938 = (0);
var G__24939 = (0);
seq__24915_24919 = G__24936;
chunk__24916_24920 = G__24937;
count__24917_24921 = G__24938;
i__24918_24922 = G__24939;
continue;
}
} else {
}
}
break;
}

return setTimeout(((function (map__24913,map__24913__$1,opts,on_cssload){
return (function (){
return on_cssload.call(null,new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(files_msg));
});})(map__24913,map__24913__$1,opts,on_cssload))
,(100));
} else {
return null;
}
});

//# sourceMappingURL=file_reloading.js.map