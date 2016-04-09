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
return cljs.core.set.call(null,cljs.core.filter.call(null,(function (p1__23931_SHARP_){
return cljs.core.not.call(null,figwheel.client.file_reloading.immutable_ns_QMARK_.call(null,p1__23931_SHARP_));
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
var seq__23936 = cljs.core.seq.call(null,figwheel.client.file_reloading.path__GT_name.call(null,k));
var chunk__23937 = null;
var count__23938 = (0);
var i__23939 = (0);
while(true){
if((i__23939 < count__23938)){
var n = cljs.core._nth.call(null,chunk__23937,i__23939);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,k_SINGLEQUOTE_,n);

var G__23940 = seq__23936;
var G__23941 = chunk__23937;
var G__23942 = count__23938;
var G__23943 = (i__23939 + (1));
seq__23936 = G__23940;
chunk__23937 = G__23941;
count__23938 = G__23942;
i__23939 = G__23943;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__23936);
if(temp__4657__auto__){
var seq__23936__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__23936__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__23936__$1);
var G__23944 = cljs.core.chunk_rest.call(null,seq__23936__$1);
var G__23945 = c__19173__auto__;
var G__23946 = cljs.core.count.call(null,c__19173__auto__);
var G__23947 = (0);
seq__23936 = G__23944;
chunk__23937 = G__23945;
count__23938 = G__23946;
i__23939 = G__23947;
continue;
} else {
var n = cljs.core.first.call(null,seq__23936__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,k_SINGLEQUOTE_,n);

var G__23948 = cljs.core.next.call(null,seq__23936__$1);
var G__23949 = null;
var G__23950 = (0);
var G__23951 = (0);
seq__23936 = G__23948;
chunk__23937 = G__23949;
count__23938 = G__23950;
i__23939 = G__23951;
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

var seq__23990_23997 = cljs.core.seq.call(null,deps);
var chunk__23991_23998 = null;
var count__23992_23999 = (0);
var i__23993_24000 = (0);
while(true){
if((i__23993_24000 < count__23992_23999)){
var dep_24001 = cljs.core._nth.call(null,chunk__23991_23998,i__23993_24000);
topo_sort_helper_STAR_.call(null,dep_24001,(depth + (1)),state);

var G__24002 = seq__23990_23997;
var G__24003 = chunk__23991_23998;
var G__24004 = count__23992_23999;
var G__24005 = (i__23993_24000 + (1));
seq__23990_23997 = G__24002;
chunk__23991_23998 = G__24003;
count__23992_23999 = G__24004;
i__23993_24000 = G__24005;
continue;
} else {
var temp__4657__auto___24006 = cljs.core.seq.call(null,seq__23990_23997);
if(temp__4657__auto___24006){
var seq__23990_24007__$1 = temp__4657__auto___24006;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__23990_24007__$1)){
var c__19173__auto___24008 = cljs.core.chunk_first.call(null,seq__23990_24007__$1);
var G__24009 = cljs.core.chunk_rest.call(null,seq__23990_24007__$1);
var G__24010 = c__19173__auto___24008;
var G__24011 = cljs.core.count.call(null,c__19173__auto___24008);
var G__24012 = (0);
seq__23990_23997 = G__24009;
chunk__23991_23998 = G__24010;
count__23992_23999 = G__24011;
i__23993_24000 = G__24012;
continue;
} else {
var dep_24013 = cljs.core.first.call(null,seq__23990_24007__$1);
topo_sort_helper_STAR_.call(null,dep_24013,(depth + (1)),state);

var G__24014 = cljs.core.next.call(null,seq__23990_24007__$1);
var G__24015 = null;
var G__24016 = (0);
var G__24017 = (0);
seq__23990_23997 = G__24014;
chunk__23991_23998 = G__24015;
count__23992_23999 = G__24016;
i__23993_24000 = G__24017;
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
return (function figwheel$client$file_reloading$build_topo_sort_$_elim_dups_STAR_(p__23994){
var vec__23996 = p__23994;
var x = cljs.core.nth.call(null,vec__23996,(0),null);
var xs = cljs.core.nthnext.call(null,vec__23996,(1));
if((x == null)){
return cljs.core.List.EMPTY;
} else {
return cljs.core.cons.call(null,x,figwheel$client$file_reloading$build_topo_sort_$_elim_dups_STAR_.call(null,cljs.core.map.call(null,((function (vec__23996,x,xs,get_deps__$1){
return (function (p1__23952_SHARP_){
return clojure.set.difference.call(null,p1__23952_SHARP_,x);
});})(vec__23996,x,xs,get_deps__$1))
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
var seq__24030 = cljs.core.seq.call(null,provides);
var chunk__24031 = null;
var count__24032 = (0);
var i__24033 = (0);
while(true){
if((i__24033 < count__24032)){
var prov = cljs.core._nth.call(null,chunk__24031,i__24033);
figwheel.client.file_reloading.path_to_name_BANG_.call(null,path,prov);

var seq__24034_24042 = cljs.core.seq.call(null,requires);
var chunk__24035_24043 = null;
var count__24036_24044 = (0);
var i__24037_24045 = (0);
while(true){
if((i__24037_24045 < count__24036_24044)){
var req_24046 = cljs.core._nth.call(null,chunk__24035_24043,i__24037_24045);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24046,prov);

var G__24047 = seq__24034_24042;
var G__24048 = chunk__24035_24043;
var G__24049 = count__24036_24044;
var G__24050 = (i__24037_24045 + (1));
seq__24034_24042 = G__24047;
chunk__24035_24043 = G__24048;
count__24036_24044 = G__24049;
i__24037_24045 = G__24050;
continue;
} else {
var temp__4657__auto___24051 = cljs.core.seq.call(null,seq__24034_24042);
if(temp__4657__auto___24051){
var seq__24034_24052__$1 = temp__4657__auto___24051;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24034_24052__$1)){
var c__19173__auto___24053 = cljs.core.chunk_first.call(null,seq__24034_24052__$1);
var G__24054 = cljs.core.chunk_rest.call(null,seq__24034_24052__$1);
var G__24055 = c__19173__auto___24053;
var G__24056 = cljs.core.count.call(null,c__19173__auto___24053);
var G__24057 = (0);
seq__24034_24042 = G__24054;
chunk__24035_24043 = G__24055;
count__24036_24044 = G__24056;
i__24037_24045 = G__24057;
continue;
} else {
var req_24058 = cljs.core.first.call(null,seq__24034_24052__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24058,prov);

var G__24059 = cljs.core.next.call(null,seq__24034_24052__$1);
var G__24060 = null;
var G__24061 = (0);
var G__24062 = (0);
seq__24034_24042 = G__24059;
chunk__24035_24043 = G__24060;
count__24036_24044 = G__24061;
i__24037_24045 = G__24062;
continue;
}
} else {
}
}
break;
}

var G__24063 = seq__24030;
var G__24064 = chunk__24031;
var G__24065 = count__24032;
var G__24066 = (i__24033 + (1));
seq__24030 = G__24063;
chunk__24031 = G__24064;
count__24032 = G__24065;
i__24033 = G__24066;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__24030);
if(temp__4657__auto__){
var seq__24030__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24030__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__24030__$1);
var G__24067 = cljs.core.chunk_rest.call(null,seq__24030__$1);
var G__24068 = c__19173__auto__;
var G__24069 = cljs.core.count.call(null,c__19173__auto__);
var G__24070 = (0);
seq__24030 = G__24067;
chunk__24031 = G__24068;
count__24032 = G__24069;
i__24033 = G__24070;
continue;
} else {
var prov = cljs.core.first.call(null,seq__24030__$1);
figwheel.client.file_reloading.path_to_name_BANG_.call(null,path,prov);

var seq__24038_24071 = cljs.core.seq.call(null,requires);
var chunk__24039_24072 = null;
var count__24040_24073 = (0);
var i__24041_24074 = (0);
while(true){
if((i__24041_24074 < count__24040_24073)){
var req_24075 = cljs.core._nth.call(null,chunk__24039_24072,i__24041_24074);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24075,prov);

var G__24076 = seq__24038_24071;
var G__24077 = chunk__24039_24072;
var G__24078 = count__24040_24073;
var G__24079 = (i__24041_24074 + (1));
seq__24038_24071 = G__24076;
chunk__24039_24072 = G__24077;
count__24040_24073 = G__24078;
i__24041_24074 = G__24079;
continue;
} else {
var temp__4657__auto___24080__$1 = cljs.core.seq.call(null,seq__24038_24071);
if(temp__4657__auto___24080__$1){
var seq__24038_24081__$1 = temp__4657__auto___24080__$1;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24038_24081__$1)){
var c__19173__auto___24082 = cljs.core.chunk_first.call(null,seq__24038_24081__$1);
var G__24083 = cljs.core.chunk_rest.call(null,seq__24038_24081__$1);
var G__24084 = c__19173__auto___24082;
var G__24085 = cljs.core.count.call(null,c__19173__auto___24082);
var G__24086 = (0);
seq__24038_24071 = G__24083;
chunk__24039_24072 = G__24084;
count__24040_24073 = G__24085;
i__24041_24074 = G__24086;
continue;
} else {
var req_24087 = cljs.core.first.call(null,seq__24038_24081__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24087,prov);

var G__24088 = cljs.core.next.call(null,seq__24038_24081__$1);
var G__24089 = null;
var G__24090 = (0);
var G__24091 = (0);
seq__24038_24071 = G__24088;
chunk__24039_24072 = G__24089;
count__24040_24073 = G__24090;
i__24041_24074 = G__24091;
continue;
}
} else {
}
}
break;
}

var G__24092 = cljs.core.next.call(null,seq__24030__$1);
var G__24093 = null;
var G__24094 = (0);
var G__24095 = (0);
seq__24030 = G__24092;
chunk__24031 = G__24093;
count__24032 = G__24094;
i__24033 = G__24095;
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
var seq__24100_24104 = cljs.core.seq.call(null,figwheel.client.file_reloading.get_all_dependencies.call(null,src));
var chunk__24101_24105 = null;
var count__24102_24106 = (0);
var i__24103_24107 = (0);
while(true){
if((i__24103_24107 < count__24102_24106)){
var ns_24108 = cljs.core._nth.call(null,chunk__24101_24105,i__24103_24107);
figwheel.client.file_reloading.unprovide_BANG_.call(null,ns_24108);

var G__24109 = seq__24100_24104;
var G__24110 = chunk__24101_24105;
var G__24111 = count__24102_24106;
var G__24112 = (i__24103_24107 + (1));
seq__24100_24104 = G__24109;
chunk__24101_24105 = G__24110;
count__24102_24106 = G__24111;
i__24103_24107 = G__24112;
continue;
} else {
var temp__4657__auto___24113 = cljs.core.seq.call(null,seq__24100_24104);
if(temp__4657__auto___24113){
var seq__24100_24114__$1 = temp__4657__auto___24113;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24100_24114__$1)){
var c__19173__auto___24115 = cljs.core.chunk_first.call(null,seq__24100_24114__$1);
var G__24116 = cljs.core.chunk_rest.call(null,seq__24100_24114__$1);
var G__24117 = c__19173__auto___24115;
var G__24118 = cljs.core.count.call(null,c__19173__auto___24115);
var G__24119 = (0);
seq__24100_24104 = G__24116;
chunk__24101_24105 = G__24117;
count__24102_24106 = G__24118;
i__24103_24107 = G__24119;
continue;
} else {
var ns_24120 = cljs.core.first.call(null,seq__24100_24114__$1);
figwheel.client.file_reloading.unprovide_BANG_.call(null,ns_24120);

var G__24121 = cljs.core.next.call(null,seq__24100_24114__$1);
var G__24122 = null;
var G__24123 = (0);
var G__24124 = (0);
seq__24100_24104 = G__24121;
chunk__24101_24105 = G__24122;
count__24102_24106 = G__24123;
i__24103_24107 = G__24124;
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
var G__24125__delegate = function (args){
cljs.core.apply.call(null,figwheel.client.file_reloading.addDependency,args);

return cljs.core.apply.call(null,goog.addDependency_figwheel_backup_,args);
};
var G__24125 = function (var_args){
var args = null;
if (arguments.length > 0) {
var G__24126__i = 0, G__24126__a = new Array(arguments.length -  0);
while (G__24126__i < G__24126__a.length) {G__24126__a[G__24126__i] = arguments[G__24126__i + 0]; ++G__24126__i;}
  args = new cljs.core.IndexedSeq(G__24126__a,0);
} 
return G__24125__delegate.call(this,args);};
G__24125.cljs$lang$maxFixedArity = 0;
G__24125.cljs$lang$applyTo = (function (arglist__24127){
var args = cljs.core.seq(arglist__24127);
return G__24125__delegate(args);
});
G__24125.cljs$core$IFn$_invoke$arity$variadic = G__24125__delegate;
return G__24125;
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
figwheel.client.file_reloading.reload_file_STAR_ = (function (){var pred__24129 = cljs.core._EQ_;
var expr__24130 = figwheel.client.utils.host_env_QMARK_.call(null);
if(cljs.core.truth_(pred__24129.call(null,new cljs.core.Keyword(null,"node","node",581201198),expr__24130))){
var path_parts = ((function (pred__24129,expr__24130){
return (function (p1__24128_SHARP_){
return clojure.string.split.call(null,p1__24128_SHARP_,/[\/\\]/);
});})(pred__24129,expr__24130))
;
var sep = (cljs.core.truth_(cljs.core.re_matches.call(null,/win.*/,process.platform))?"\\":"/");
var root = clojure.string.join.call(null,sep,cljs.core.pop.call(null,cljs.core.pop.call(null,path_parts.call(null,__dirname))));
return ((function (path_parts,sep,root,pred__24129,expr__24130){
return (function (request_url,callback){

var cache_path = clojure.string.join.call(null,sep,cljs.core.cons.call(null,root,path_parts.call(null,figwheel.client.file_reloading.fix_node_request_url.call(null,request_url))));
(require.cache[cache_path] = null);

return callback.call(null,(function (){try{return require(cache_path);
}catch (e24132){if((e24132 instanceof Error)){
var e = e24132;
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Figwheel: Error loading file "),cljs.core.str(cache_path)].join(''));

figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),e.stack);

return false;
} else {
throw e24132;

}
}})());
});
;})(path_parts,sep,root,pred__24129,expr__24130))
} else {
if(cljs.core.truth_(pred__24129.call(null,new cljs.core.Keyword(null,"html","html",-998796897),expr__24130))){
return ((function (pred__24129,expr__24130){
return (function (request_url,callback){

var deferred = goog.net.jsloader.load(figwheel.client.file_reloading.add_cache_buster.call(null,request_url),{"cleanupWhenDone": true});
deferred.addCallback(((function (deferred,pred__24129,expr__24130){
return (function (){
return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [true], null));
});})(deferred,pred__24129,expr__24130))
);

return deferred.addErrback(((function (deferred,pred__24129,expr__24130){
return (function (){
return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [false], null));
});})(deferred,pred__24129,expr__24130))
);
});
;})(pred__24129,expr__24130))
} else {
return ((function (pred__24129,expr__24130){
return (function (a,b){
throw "Reload not defined for this platform";
});
;})(pred__24129,expr__24130))
}
}
})();
figwheel.client.file_reloading.reload_file = (function figwheel$client$file_reloading$reload_file(p__24133,callback){
var map__24136 = p__24133;
var map__24136__$1 = ((((!((map__24136 == null)))?((((map__24136.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24136.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24136):map__24136);
var file_msg = map__24136__$1;
var request_url = cljs.core.get.call(null,map__24136__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));

figwheel.client.utils.debug_prn.call(null,[cljs.core.str("FigWheel: Attempting to load "),cljs.core.str(request_url)].join(''));

return figwheel.client.file_reloading.reload_file_STAR_.call(null,request_url,((function (map__24136,map__24136__$1,file_msg,request_url){
return (function (success_QMARK_){
if(cljs.core.truth_(success_QMARK_)){
figwheel.client.utils.debug_prn.call(null,[cljs.core.str("FigWheel: Successfully loaded "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.assoc.call(null,file_msg,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),true)], null));
} else {
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Figwheel: Error loading file "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [file_msg], null));
}
});})(map__24136,map__24136__$1,file_msg,request_url))
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
figwheel.client.file_reloading.reloader_loop = (function (){var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__){
return (function (state_24160){
var state_val_24161 = (state_24160[(1)]);
if((state_val_24161 === (7))){
var inst_24156 = (state_24160[(2)]);
var state_24160__$1 = state_24160;
var statearr_24162_24182 = state_24160__$1;
(statearr_24162_24182[(2)] = inst_24156);

(statearr_24162_24182[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (1))){
var state_24160__$1 = state_24160;
var statearr_24163_24183 = state_24160__$1;
(statearr_24163_24183[(2)] = null);

(statearr_24163_24183[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (4))){
var inst_24140 = (state_24160[(7)]);
var inst_24140__$1 = (state_24160[(2)]);
var state_24160__$1 = (function (){var statearr_24164 = state_24160;
(statearr_24164[(7)] = inst_24140__$1);

return statearr_24164;
})();
if(cljs.core.truth_(inst_24140__$1)){
var statearr_24165_24184 = state_24160__$1;
(statearr_24165_24184[(1)] = (5));

} else {
var statearr_24166_24185 = state_24160__$1;
(statearr_24166_24185[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (6))){
var state_24160__$1 = state_24160;
var statearr_24167_24186 = state_24160__$1;
(statearr_24167_24186[(2)] = null);

(statearr_24167_24186[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (3))){
var inst_24158 = (state_24160[(2)]);
var state_24160__$1 = state_24160;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24160__$1,inst_24158);
} else {
if((state_val_24161 === (2))){
var state_24160__$1 = state_24160;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24160__$1,(4),figwheel.client.file_reloading.reload_chan);
} else {
if((state_val_24161 === (11))){
var inst_24152 = (state_24160[(2)]);
var state_24160__$1 = (function (){var statearr_24168 = state_24160;
(statearr_24168[(8)] = inst_24152);

return statearr_24168;
})();
var statearr_24169_24187 = state_24160__$1;
(statearr_24169_24187[(2)] = null);

(statearr_24169_24187[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (9))){
var inst_24144 = (state_24160[(9)]);
var inst_24146 = (state_24160[(10)]);
var inst_24148 = inst_24146.call(null,inst_24144);
var state_24160__$1 = state_24160;
var statearr_24170_24188 = state_24160__$1;
(statearr_24170_24188[(2)] = inst_24148);

(statearr_24170_24188[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (5))){
var inst_24140 = (state_24160[(7)]);
var inst_24142 = figwheel.client.file_reloading.blocking_load.call(null,inst_24140);
var state_24160__$1 = state_24160;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24160__$1,(8),inst_24142);
} else {
if((state_val_24161 === (10))){
var inst_24144 = (state_24160[(9)]);
var inst_24150 = cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.dependencies_loaded,cljs.core.conj,inst_24144);
var state_24160__$1 = state_24160;
var statearr_24171_24189 = state_24160__$1;
(statearr_24171_24189[(2)] = inst_24150);

(statearr_24171_24189[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24161 === (8))){
var inst_24140 = (state_24160[(7)]);
var inst_24146 = (state_24160[(10)]);
var inst_24144 = (state_24160[(2)]);
var inst_24145 = cljs.core.deref.call(null,figwheel.client.file_reloading.on_load_callbacks);
var inst_24146__$1 = cljs.core.get.call(null,inst_24145,inst_24140);
var state_24160__$1 = (function (){var statearr_24172 = state_24160;
(statearr_24172[(9)] = inst_24144);

(statearr_24172[(10)] = inst_24146__$1);

return statearr_24172;
})();
if(cljs.core.truth_(inst_24146__$1)){
var statearr_24173_24190 = state_24160__$1;
(statearr_24173_24190[(1)] = (9));

} else {
var statearr_24174_24191 = state_24160__$1;
(statearr_24174_24191[(1)] = (10));

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
});})(c__21037__auto__))
;
return ((function (switch__20925__auto__,c__21037__auto__){
return (function() {
var figwheel$client$file_reloading$state_machine__20926__auto__ = null;
var figwheel$client$file_reloading$state_machine__20926__auto____0 = (function (){
var statearr_24178 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_24178[(0)] = figwheel$client$file_reloading$state_machine__20926__auto__);

(statearr_24178[(1)] = (1));

return statearr_24178;
});
var figwheel$client$file_reloading$state_machine__20926__auto____1 = (function (state_24160){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_24160);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e24179){if((e24179 instanceof Object)){
var ex__20929__auto__ = e24179;
var statearr_24180_24192 = state_24160;
(statearr_24180_24192[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24160);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24179;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24193 = state_24160;
state_24160 = G__24193;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$file_reloading$state_machine__20926__auto__ = function(state_24160){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$state_machine__20926__auto____1.call(this,state_24160);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$state_machine__20926__auto____0;
figwheel$client$file_reloading$state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$state_machine__20926__auto____1;
return figwheel$client$file_reloading$state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__))
})();
var state__21039__auto__ = (function (){var statearr_24181 = f__21038__auto__.call(null);
(statearr_24181[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_24181;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__))
);

return c__21037__auto__;
})();
}
figwheel.client.file_reloading.queued_file_reload = (function figwheel$client$file_reloading$queued_file_reload(url){
return cljs.core.async.put_BANG_.call(null,figwheel.client.file_reloading.reload_chan,url);
});
figwheel.client.file_reloading.require_with_callback = (function figwheel$client$file_reloading$require_with_callback(p__24194,callback){
var map__24197 = p__24194;
var map__24197__$1 = ((((!((map__24197 == null)))?((((map__24197.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24197.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24197):map__24197);
var file_msg = map__24197__$1;
var namespace = cljs.core.get.call(null,map__24197__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var request_url = figwheel.client.file_reloading.resolve_ns.call(null,namespace);
cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.on_load_callbacks,cljs.core.assoc,request_url,((function (request_url,map__24197,map__24197__$1,file_msg,namespace){
return (function (file_msg_SINGLEQUOTE_){
cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.on_load_callbacks,cljs.core.dissoc,request_url);

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.merge.call(null,file_msg,cljs.core.select_keys.call(null,file_msg_SINGLEQUOTE_,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375)], null)))], null));
});})(request_url,map__24197,map__24197__$1,file_msg,namespace))
);

return figwheel.client.file_reloading.figwheel_require.call(null,cljs.core.name.call(null,namespace),true);
});
figwheel.client.file_reloading.reload_file_QMARK_ = (function figwheel$client$file_reloading$reload_file_QMARK_(p__24199){
var map__24202 = p__24199;
var map__24202__$1 = ((((!((map__24202 == null)))?((((map__24202.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24202.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24202):map__24202);
var file_msg = map__24202__$1;
var namespace = cljs.core.get.call(null,map__24202__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));

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
figwheel.client.file_reloading.js_reload = (function figwheel$client$file_reloading$js_reload(p__24204,callback){
var map__24207 = p__24204;
var map__24207__$1 = ((((!((map__24207 == null)))?((((map__24207.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24207.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24207):map__24207);
var file_msg = map__24207__$1;
var request_url = cljs.core.get.call(null,map__24207__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));
var namespace = cljs.core.get.call(null,map__24207__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));

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
var c__21037__auto___24295 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___24295,out){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___24295,out){
return (function (state_24277){
var state_val_24278 = (state_24277[(1)]);
if((state_val_24278 === (1))){
var inst_24255 = cljs.core.nth.call(null,files,(0),null);
var inst_24256 = cljs.core.nthnext.call(null,files,(1));
var inst_24257 = files;
var state_24277__$1 = (function (){var statearr_24279 = state_24277;
(statearr_24279[(7)] = inst_24255);

(statearr_24279[(8)] = inst_24257);

(statearr_24279[(9)] = inst_24256);

return statearr_24279;
})();
var statearr_24280_24296 = state_24277__$1;
(statearr_24280_24296[(2)] = null);

(statearr_24280_24296[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24278 === (2))){
var inst_24260 = (state_24277[(10)]);
var inst_24257 = (state_24277[(8)]);
var inst_24260__$1 = cljs.core.nth.call(null,inst_24257,(0),null);
var inst_24261 = cljs.core.nthnext.call(null,inst_24257,(1));
var inst_24262 = (inst_24260__$1 == null);
var inst_24263 = cljs.core.not.call(null,inst_24262);
var state_24277__$1 = (function (){var statearr_24281 = state_24277;
(statearr_24281[(11)] = inst_24261);

(statearr_24281[(10)] = inst_24260__$1);

return statearr_24281;
})();
if(inst_24263){
var statearr_24282_24297 = state_24277__$1;
(statearr_24282_24297[(1)] = (4));

} else {
var statearr_24283_24298 = state_24277__$1;
(statearr_24283_24298[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24278 === (3))){
var inst_24275 = (state_24277[(2)]);
var state_24277__$1 = state_24277;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24277__$1,inst_24275);
} else {
if((state_val_24278 === (4))){
var inst_24260 = (state_24277[(10)]);
var inst_24265 = figwheel.client.file_reloading.reload_js_file.call(null,inst_24260);
var state_24277__$1 = state_24277;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24277__$1,(7),inst_24265);
} else {
if((state_val_24278 === (5))){
var inst_24271 = cljs.core.async.close_BANG_.call(null,out);
var state_24277__$1 = state_24277;
var statearr_24284_24299 = state_24277__$1;
(statearr_24284_24299[(2)] = inst_24271);

(statearr_24284_24299[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24278 === (6))){
var inst_24273 = (state_24277[(2)]);
var state_24277__$1 = state_24277;
var statearr_24285_24300 = state_24277__$1;
(statearr_24285_24300[(2)] = inst_24273);

(statearr_24285_24300[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24278 === (7))){
var inst_24261 = (state_24277[(11)]);
var inst_24267 = (state_24277[(2)]);
var inst_24268 = cljs.core.async.put_BANG_.call(null,out,inst_24267);
var inst_24257 = inst_24261;
var state_24277__$1 = (function (){var statearr_24286 = state_24277;
(statearr_24286[(12)] = inst_24268);

(statearr_24286[(8)] = inst_24257);

return statearr_24286;
})();
var statearr_24287_24301 = state_24277__$1;
(statearr_24287_24301[(2)] = null);

(statearr_24287_24301[(1)] = (2));


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
});})(c__21037__auto___24295,out))
;
return ((function (switch__20925__auto__,c__21037__auto___24295,out){
return (function() {
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto__ = null;
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto____0 = (function (){
var statearr_24291 = [null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_24291[(0)] = figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto__);

(statearr_24291[(1)] = (1));

return statearr_24291;
});
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto____1 = (function (state_24277){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_24277);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e24292){if((e24292 instanceof Object)){
var ex__20929__auto__ = e24292;
var statearr_24293_24302 = state_24277;
(statearr_24293_24302[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24277);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24292;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24303 = state_24277;
state_24277 = G__24303;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto__ = function(state_24277){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto____1.call(this,state_24277);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto____0;
figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto____1;
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___24295,out))
})();
var state__21039__auto__ = (function (){var statearr_24294 = f__21038__auto__.call(null);
(statearr_24294[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___24295);

return statearr_24294;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___24295,out))
);


return cljs.core.async.into.call(null,cljs.core.PersistentVector.EMPTY,out);
});
figwheel.client.file_reloading.eval_body = (function figwheel$client$file_reloading$eval_body(p__24304,opts){
var map__24308 = p__24304;
var map__24308__$1 = ((((!((map__24308 == null)))?((((map__24308.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24308.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24308):map__24308);
var eval_body__$1 = cljs.core.get.call(null,map__24308__$1,new cljs.core.Keyword(null,"eval-body","eval-body",-907279883));
var file = cljs.core.get.call(null,map__24308__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
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
}catch (e24310){var e = e24310;
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
return (function (p1__24311_SHARP_){
return cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(p1__24311_SHARP_),n);
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
return cljs.core.map.call(null,(function (p__24316){
var vec__24317 = p__24316;
var k = cljs.core.nth.call(null,vec__24317,(0),null);
var v = cljs.core.nth.call(null,vec__24317,(1),null);
return new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"namespace","namespace",-377510372),k,new cljs.core.Keyword(null,"type","type",1174270348),new cljs.core.Keyword(null,"namespace","namespace",-377510372)], null);
}),cljs.core.filter.call(null,(function (p__24318){
var vec__24319 = p__24318;
var k = cljs.core.nth.call(null,vec__24319,(0),null);
var v = cljs.core.nth.call(null,vec__24319,(1),null);
return new cljs.core.Keyword(null,"figwheel-always","figwheel-always",799819691).cljs$core$IFn$_invoke$arity$1(v);
}),cljs.core.deref.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas)));
});
figwheel.client.file_reloading.reload_js_files = (function figwheel$client$file_reloading$reload_js_files(p__24323,p__24324){
var map__24571 = p__24323;
var map__24571__$1 = ((((!((map__24571 == null)))?((((map__24571.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24571.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24571):map__24571);
var opts = map__24571__$1;
var before_jsload = cljs.core.get.call(null,map__24571__$1,new cljs.core.Keyword(null,"before-jsload","before-jsload",-847513128));
var on_jsload = cljs.core.get.call(null,map__24571__$1,new cljs.core.Keyword(null,"on-jsload","on-jsload",-395756602));
var reload_dependents = cljs.core.get.call(null,map__24571__$1,new cljs.core.Keyword(null,"reload-dependents","reload-dependents",-956865430));
var map__24572 = p__24324;
var map__24572__$1 = ((((!((map__24572 == null)))?((((map__24572.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24572.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24572):map__24572);
var msg = map__24572__$1;
var files = cljs.core.get.call(null,map__24572__$1,new cljs.core.Keyword(null,"files","files",-472457450));
var figwheel_meta = cljs.core.get.call(null,map__24572__$1,new cljs.core.Keyword(null,"figwheel-meta","figwheel-meta",-225970237));
var recompile_dependents = cljs.core.get.call(null,map__24572__$1,new cljs.core.Keyword(null,"recompile-dependents","recompile-dependents",523804171));
if(cljs.core.empty_QMARK_.call(null,figwheel_meta)){
} else {
cljs.core.reset_BANG_.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas,figwheel_meta);
}

var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (state_24725){
var state_val_24726 = (state_24725[(1)]);
if((state_val_24726 === (7))){
var inst_24589 = (state_24725[(7)]);
var inst_24586 = (state_24725[(8)]);
var inst_24588 = (state_24725[(9)]);
var inst_24587 = (state_24725[(10)]);
var inst_24594 = cljs.core._nth.call(null,inst_24587,inst_24589);
var inst_24595 = figwheel.client.file_reloading.eval_body.call(null,inst_24594,opts);
var inst_24596 = (inst_24589 + (1));
var tmp24727 = inst_24586;
var tmp24728 = inst_24588;
var tmp24729 = inst_24587;
var inst_24586__$1 = tmp24727;
var inst_24587__$1 = tmp24729;
var inst_24588__$1 = tmp24728;
var inst_24589__$1 = inst_24596;
var state_24725__$1 = (function (){var statearr_24730 = state_24725;
(statearr_24730[(7)] = inst_24589__$1);

(statearr_24730[(8)] = inst_24586__$1);

(statearr_24730[(9)] = inst_24588__$1);

(statearr_24730[(10)] = inst_24587__$1);

(statearr_24730[(11)] = inst_24595);

return statearr_24730;
})();
var statearr_24731_24817 = state_24725__$1;
(statearr_24731_24817[(2)] = null);

(statearr_24731_24817[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (20))){
var inst_24629 = (state_24725[(12)]);
var inst_24637 = figwheel.client.file_reloading.sort_files.call(null,inst_24629);
var state_24725__$1 = state_24725;
var statearr_24732_24818 = state_24725__$1;
(statearr_24732_24818[(2)] = inst_24637);

(statearr_24732_24818[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (27))){
var state_24725__$1 = state_24725;
var statearr_24733_24819 = state_24725__$1;
(statearr_24733_24819[(2)] = null);

(statearr_24733_24819[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (1))){
var inst_24578 = (state_24725[(13)]);
var inst_24575 = before_jsload.call(null,files);
var inst_24576 = figwheel.client.file_reloading.before_jsload_custom_event.call(null,files);
var inst_24577 = (function (){return ((function (inst_24578,inst_24575,inst_24576,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24320_SHARP_){
return new cljs.core.Keyword(null,"eval-body","eval-body",-907279883).cljs$core$IFn$_invoke$arity$1(p1__24320_SHARP_);
});
;})(inst_24578,inst_24575,inst_24576,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24578__$1 = cljs.core.filter.call(null,inst_24577,files);
var inst_24579 = cljs.core.not_empty.call(null,inst_24578__$1);
var state_24725__$1 = (function (){var statearr_24734 = state_24725;
(statearr_24734[(14)] = inst_24575);

(statearr_24734[(15)] = inst_24576);

(statearr_24734[(13)] = inst_24578__$1);

return statearr_24734;
})();
if(cljs.core.truth_(inst_24579)){
var statearr_24735_24820 = state_24725__$1;
(statearr_24735_24820[(1)] = (2));

} else {
var statearr_24736_24821 = state_24725__$1;
(statearr_24736_24821[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (24))){
var state_24725__$1 = state_24725;
var statearr_24737_24822 = state_24725__$1;
(statearr_24737_24822[(2)] = null);

(statearr_24737_24822[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (39))){
var inst_24679 = (state_24725[(16)]);
var state_24725__$1 = state_24725;
var statearr_24738_24823 = state_24725__$1;
(statearr_24738_24823[(2)] = inst_24679);

(statearr_24738_24823[(1)] = (40));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (46))){
var inst_24720 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
var statearr_24739_24824 = state_24725__$1;
(statearr_24739_24824[(2)] = inst_24720);

(statearr_24739_24824[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (4))){
var inst_24623 = (state_24725[(2)]);
var inst_24624 = cljs.core.List.EMPTY;
var inst_24625 = cljs.core.reset_BANG_.call(null,figwheel.client.file_reloading.dependencies_loaded,inst_24624);
var inst_24626 = (function (){return ((function (inst_24623,inst_24624,inst_24625,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24321_SHARP_){
var and__18358__auto__ = new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(p1__24321_SHARP_);
if(cljs.core.truth_(and__18358__auto__)){
return cljs.core.not.call(null,new cljs.core.Keyword(null,"eval-body","eval-body",-907279883).cljs$core$IFn$_invoke$arity$1(p1__24321_SHARP_));
} else {
return and__18358__auto__;
}
});
;})(inst_24623,inst_24624,inst_24625,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24627 = cljs.core.filter.call(null,inst_24626,files);
var inst_24628 = figwheel.client.file_reloading.get_figwheel_always.call(null);
var inst_24629 = cljs.core.concat.call(null,inst_24627,inst_24628);
var state_24725__$1 = (function (){var statearr_24740 = state_24725;
(statearr_24740[(17)] = inst_24623);

(statearr_24740[(12)] = inst_24629);

(statearr_24740[(18)] = inst_24625);

return statearr_24740;
})();
if(cljs.core.truth_(reload_dependents)){
var statearr_24741_24825 = state_24725__$1;
(statearr_24741_24825[(1)] = (16));

} else {
var statearr_24742_24826 = state_24725__$1;
(statearr_24742_24826[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (15))){
var inst_24613 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
var statearr_24743_24827 = state_24725__$1;
(statearr_24743_24827[(2)] = inst_24613);

(statearr_24743_24827[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (21))){
var inst_24639 = (state_24725[(19)]);
var inst_24639__$1 = (state_24725[(2)]);
var inst_24640 = figwheel.client.file_reloading.load_all_js_files.call(null,inst_24639__$1);
var state_24725__$1 = (function (){var statearr_24744 = state_24725;
(statearr_24744[(19)] = inst_24639__$1);

return statearr_24744;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24725__$1,(22),inst_24640);
} else {
if((state_val_24726 === (31))){
var inst_24723 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24725__$1,inst_24723);
} else {
if((state_val_24726 === (32))){
var inst_24679 = (state_24725[(16)]);
var inst_24684 = inst_24679.cljs$lang$protocol_mask$partition0$;
var inst_24685 = (inst_24684 & (64));
var inst_24686 = inst_24679.cljs$core$ISeq$;
var inst_24687 = (inst_24685) || (inst_24686);
var state_24725__$1 = state_24725;
if(cljs.core.truth_(inst_24687)){
var statearr_24745_24828 = state_24725__$1;
(statearr_24745_24828[(1)] = (35));

} else {
var statearr_24746_24829 = state_24725__$1;
(statearr_24746_24829[(1)] = (36));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (40))){
var inst_24700 = (state_24725[(20)]);
var inst_24699 = (state_24725[(2)]);
var inst_24700__$1 = cljs.core.get.call(null,inst_24699,new cljs.core.Keyword(null,"figwheel-no-load","figwheel-no-load",-555840179));
var inst_24701 = cljs.core.get.call(null,inst_24699,new cljs.core.Keyword(null,"not-required","not-required",-950359114));
var inst_24702 = cljs.core.not_empty.call(null,inst_24700__$1);
var state_24725__$1 = (function (){var statearr_24747 = state_24725;
(statearr_24747[(21)] = inst_24701);

(statearr_24747[(20)] = inst_24700__$1);

return statearr_24747;
})();
if(cljs.core.truth_(inst_24702)){
var statearr_24748_24830 = state_24725__$1;
(statearr_24748_24830[(1)] = (41));

} else {
var statearr_24749_24831 = state_24725__$1;
(statearr_24749_24831[(1)] = (42));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (33))){
var state_24725__$1 = state_24725;
var statearr_24750_24832 = state_24725__$1;
(statearr_24750_24832[(2)] = false);

(statearr_24750_24832[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (13))){
var inst_24599 = (state_24725[(22)]);
var inst_24603 = cljs.core.chunk_first.call(null,inst_24599);
var inst_24604 = cljs.core.chunk_rest.call(null,inst_24599);
var inst_24605 = cljs.core.count.call(null,inst_24603);
var inst_24586 = inst_24604;
var inst_24587 = inst_24603;
var inst_24588 = inst_24605;
var inst_24589 = (0);
var state_24725__$1 = (function (){var statearr_24751 = state_24725;
(statearr_24751[(7)] = inst_24589);

(statearr_24751[(8)] = inst_24586);

(statearr_24751[(9)] = inst_24588);

(statearr_24751[(10)] = inst_24587);

return statearr_24751;
})();
var statearr_24752_24833 = state_24725__$1;
(statearr_24752_24833[(2)] = null);

(statearr_24752_24833[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (22))){
var inst_24647 = (state_24725[(23)]);
var inst_24639 = (state_24725[(19)]);
var inst_24643 = (state_24725[(24)]);
var inst_24642 = (state_24725[(25)]);
var inst_24642__$1 = (state_24725[(2)]);
var inst_24643__$1 = cljs.core.filter.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),inst_24642__$1);
var inst_24644 = (function (){var all_files = inst_24639;
var res_SINGLEQUOTE_ = inst_24642__$1;
var res = inst_24643__$1;
return ((function (all_files,res_SINGLEQUOTE_,res,inst_24647,inst_24639,inst_24643,inst_24642,inst_24642__$1,inst_24643__$1,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24322_SHARP_){
return cljs.core.not.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375).cljs$core$IFn$_invoke$arity$1(p1__24322_SHARP_));
});
;})(all_files,res_SINGLEQUOTE_,res,inst_24647,inst_24639,inst_24643,inst_24642,inst_24642__$1,inst_24643__$1,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24645 = cljs.core.filter.call(null,inst_24644,inst_24642__$1);
var inst_24646 = cljs.core.deref.call(null,figwheel.client.file_reloading.dependencies_loaded);
var inst_24647__$1 = cljs.core.filter.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),inst_24646);
var inst_24648 = cljs.core.not_empty.call(null,inst_24647__$1);
var state_24725__$1 = (function (){var statearr_24753 = state_24725;
(statearr_24753[(26)] = inst_24645);

(statearr_24753[(23)] = inst_24647__$1);

(statearr_24753[(24)] = inst_24643__$1);

(statearr_24753[(25)] = inst_24642__$1);

return statearr_24753;
})();
if(cljs.core.truth_(inst_24648)){
var statearr_24754_24834 = state_24725__$1;
(statearr_24754_24834[(1)] = (23));

} else {
var statearr_24755_24835 = state_24725__$1;
(statearr_24755_24835[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (36))){
var state_24725__$1 = state_24725;
var statearr_24756_24836 = state_24725__$1;
(statearr_24756_24836[(2)] = false);

(statearr_24756_24836[(1)] = (37));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (41))){
var inst_24700 = (state_24725[(20)]);
var inst_24704 = cljs.core.comp.call(null,figwheel.client.file_reloading.name__GT_path,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var inst_24705 = cljs.core.map.call(null,inst_24704,inst_24700);
var inst_24706 = cljs.core.pr_str.call(null,inst_24705);
var inst_24707 = [cljs.core.str("figwheel-no-load meta-data: "),cljs.core.str(inst_24706)].join('');
var inst_24708 = figwheel.client.utils.log.call(null,inst_24707);
var state_24725__$1 = state_24725;
var statearr_24757_24837 = state_24725__$1;
(statearr_24757_24837[(2)] = inst_24708);

(statearr_24757_24837[(1)] = (43));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (43))){
var inst_24701 = (state_24725[(21)]);
var inst_24711 = (state_24725[(2)]);
var inst_24712 = cljs.core.not_empty.call(null,inst_24701);
var state_24725__$1 = (function (){var statearr_24758 = state_24725;
(statearr_24758[(27)] = inst_24711);

return statearr_24758;
})();
if(cljs.core.truth_(inst_24712)){
var statearr_24759_24838 = state_24725__$1;
(statearr_24759_24838[(1)] = (44));

} else {
var statearr_24760_24839 = state_24725__$1;
(statearr_24760_24839[(1)] = (45));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (29))){
var inst_24645 = (state_24725[(26)]);
var inst_24647 = (state_24725[(23)]);
var inst_24679 = (state_24725[(16)]);
var inst_24639 = (state_24725[(19)]);
var inst_24643 = (state_24725[(24)]);
var inst_24642 = (state_24725[(25)]);
var inst_24675 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: NOT loading these files ");
var inst_24678 = (function (){var all_files = inst_24639;
var res_SINGLEQUOTE_ = inst_24642;
var res = inst_24643;
var files_not_loaded = inst_24645;
var dependencies_that_loaded = inst_24647;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24679,inst_24639,inst_24643,inst_24642,inst_24675,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24677){
var map__24761 = p__24677;
var map__24761__$1 = ((((!((map__24761 == null)))?((((map__24761.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24761.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24761):map__24761);
var namespace = cljs.core.get.call(null,map__24761__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
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
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24679,inst_24639,inst_24643,inst_24642,inst_24675,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24679__$1 = cljs.core.group_by.call(null,inst_24678,inst_24645);
var inst_24681 = (inst_24679__$1 == null);
var inst_24682 = cljs.core.not.call(null,inst_24681);
var state_24725__$1 = (function (){var statearr_24763 = state_24725;
(statearr_24763[(28)] = inst_24675);

(statearr_24763[(16)] = inst_24679__$1);

return statearr_24763;
})();
if(inst_24682){
var statearr_24764_24840 = state_24725__$1;
(statearr_24764_24840[(1)] = (32));

} else {
var statearr_24765_24841 = state_24725__$1;
(statearr_24765_24841[(1)] = (33));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (44))){
var inst_24701 = (state_24725[(21)]);
var inst_24714 = cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),inst_24701);
var inst_24715 = cljs.core.pr_str.call(null,inst_24714);
var inst_24716 = [cljs.core.str("not required: "),cljs.core.str(inst_24715)].join('');
var inst_24717 = figwheel.client.utils.log.call(null,inst_24716);
var state_24725__$1 = state_24725;
var statearr_24766_24842 = state_24725__$1;
(statearr_24766_24842[(2)] = inst_24717);

(statearr_24766_24842[(1)] = (46));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (6))){
var inst_24620 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
var statearr_24767_24843 = state_24725__$1;
(statearr_24767_24843[(2)] = inst_24620);

(statearr_24767_24843[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (28))){
var inst_24645 = (state_24725[(26)]);
var inst_24672 = (state_24725[(2)]);
var inst_24673 = cljs.core.not_empty.call(null,inst_24645);
var state_24725__$1 = (function (){var statearr_24768 = state_24725;
(statearr_24768[(29)] = inst_24672);

return statearr_24768;
})();
if(cljs.core.truth_(inst_24673)){
var statearr_24769_24844 = state_24725__$1;
(statearr_24769_24844[(1)] = (29));

} else {
var statearr_24770_24845 = state_24725__$1;
(statearr_24770_24845[(1)] = (30));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (25))){
var inst_24643 = (state_24725[(24)]);
var inst_24659 = (state_24725[(2)]);
var inst_24660 = cljs.core.not_empty.call(null,inst_24643);
var state_24725__$1 = (function (){var statearr_24771 = state_24725;
(statearr_24771[(30)] = inst_24659);

return statearr_24771;
})();
if(cljs.core.truth_(inst_24660)){
var statearr_24772_24846 = state_24725__$1;
(statearr_24772_24846[(1)] = (26));

} else {
var statearr_24773_24847 = state_24725__$1;
(statearr_24773_24847[(1)] = (27));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (34))){
var inst_24694 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
if(cljs.core.truth_(inst_24694)){
var statearr_24774_24848 = state_24725__$1;
(statearr_24774_24848[(1)] = (38));

} else {
var statearr_24775_24849 = state_24725__$1;
(statearr_24775_24849[(1)] = (39));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (17))){
var state_24725__$1 = state_24725;
var statearr_24776_24850 = state_24725__$1;
(statearr_24776_24850[(2)] = recompile_dependents);

(statearr_24776_24850[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (3))){
var state_24725__$1 = state_24725;
var statearr_24777_24851 = state_24725__$1;
(statearr_24777_24851[(2)] = null);

(statearr_24777_24851[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (12))){
var inst_24616 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
var statearr_24778_24852 = state_24725__$1;
(statearr_24778_24852[(2)] = inst_24616);

(statearr_24778_24852[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (2))){
var inst_24578 = (state_24725[(13)]);
var inst_24585 = cljs.core.seq.call(null,inst_24578);
var inst_24586 = inst_24585;
var inst_24587 = null;
var inst_24588 = (0);
var inst_24589 = (0);
var state_24725__$1 = (function (){var statearr_24779 = state_24725;
(statearr_24779[(7)] = inst_24589);

(statearr_24779[(8)] = inst_24586);

(statearr_24779[(9)] = inst_24588);

(statearr_24779[(10)] = inst_24587);

return statearr_24779;
})();
var statearr_24780_24853 = state_24725__$1;
(statearr_24780_24853[(2)] = null);

(statearr_24780_24853[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (23))){
var inst_24645 = (state_24725[(26)]);
var inst_24647 = (state_24725[(23)]);
var inst_24639 = (state_24725[(19)]);
var inst_24643 = (state_24725[(24)]);
var inst_24642 = (state_24725[(25)]);
var inst_24650 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded these dependencies");
var inst_24652 = (function (){var all_files = inst_24639;
var res_SINGLEQUOTE_ = inst_24642;
var res = inst_24643;
var files_not_loaded = inst_24645;
var dependencies_that_loaded = inst_24647;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24639,inst_24643,inst_24642,inst_24650,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24651){
var map__24781 = p__24651;
var map__24781__$1 = ((((!((map__24781 == null)))?((((map__24781.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24781.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24781):map__24781);
var request_url = cljs.core.get.call(null,map__24781__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));
return clojure.string.replace.call(null,request_url,goog.basePath,"");
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24639,inst_24643,inst_24642,inst_24650,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24653 = cljs.core.reverse.call(null,inst_24647);
var inst_24654 = cljs.core.map.call(null,inst_24652,inst_24653);
var inst_24655 = cljs.core.pr_str.call(null,inst_24654);
var inst_24656 = figwheel.client.utils.log.call(null,inst_24655);
var state_24725__$1 = (function (){var statearr_24783 = state_24725;
(statearr_24783[(31)] = inst_24650);

return statearr_24783;
})();
var statearr_24784_24854 = state_24725__$1;
(statearr_24784_24854[(2)] = inst_24656);

(statearr_24784_24854[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (35))){
var state_24725__$1 = state_24725;
var statearr_24785_24855 = state_24725__$1;
(statearr_24785_24855[(2)] = true);

(statearr_24785_24855[(1)] = (37));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (19))){
var inst_24629 = (state_24725[(12)]);
var inst_24635 = figwheel.client.file_reloading.expand_files.call(null,inst_24629);
var state_24725__$1 = state_24725;
var statearr_24786_24856 = state_24725__$1;
(statearr_24786_24856[(2)] = inst_24635);

(statearr_24786_24856[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (11))){
var state_24725__$1 = state_24725;
var statearr_24787_24857 = state_24725__$1;
(statearr_24787_24857[(2)] = null);

(statearr_24787_24857[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (9))){
var inst_24618 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
var statearr_24788_24858 = state_24725__$1;
(statearr_24788_24858[(2)] = inst_24618);

(statearr_24788_24858[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (5))){
var inst_24589 = (state_24725[(7)]);
var inst_24588 = (state_24725[(9)]);
var inst_24591 = (inst_24589 < inst_24588);
var inst_24592 = inst_24591;
var state_24725__$1 = state_24725;
if(cljs.core.truth_(inst_24592)){
var statearr_24789_24859 = state_24725__$1;
(statearr_24789_24859[(1)] = (7));

} else {
var statearr_24790_24860 = state_24725__$1;
(statearr_24790_24860[(1)] = (8));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (14))){
var inst_24599 = (state_24725[(22)]);
var inst_24608 = cljs.core.first.call(null,inst_24599);
var inst_24609 = figwheel.client.file_reloading.eval_body.call(null,inst_24608,opts);
var inst_24610 = cljs.core.next.call(null,inst_24599);
var inst_24586 = inst_24610;
var inst_24587 = null;
var inst_24588 = (0);
var inst_24589 = (0);
var state_24725__$1 = (function (){var statearr_24791 = state_24725;
(statearr_24791[(7)] = inst_24589);

(statearr_24791[(8)] = inst_24586);

(statearr_24791[(32)] = inst_24609);

(statearr_24791[(9)] = inst_24588);

(statearr_24791[(10)] = inst_24587);

return statearr_24791;
})();
var statearr_24792_24861 = state_24725__$1;
(statearr_24792_24861[(2)] = null);

(statearr_24792_24861[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (45))){
var state_24725__$1 = state_24725;
var statearr_24793_24862 = state_24725__$1;
(statearr_24793_24862[(2)] = null);

(statearr_24793_24862[(1)] = (46));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (26))){
var inst_24645 = (state_24725[(26)]);
var inst_24647 = (state_24725[(23)]);
var inst_24639 = (state_24725[(19)]);
var inst_24643 = (state_24725[(24)]);
var inst_24642 = (state_24725[(25)]);
var inst_24662 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded these files");
var inst_24664 = (function (){var all_files = inst_24639;
var res_SINGLEQUOTE_ = inst_24642;
var res = inst_24643;
var files_not_loaded = inst_24645;
var dependencies_that_loaded = inst_24647;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24639,inst_24643,inst_24642,inst_24662,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24663){
var map__24794 = p__24663;
var map__24794__$1 = ((((!((map__24794 == null)))?((((map__24794.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24794.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24794):map__24794);
var namespace = cljs.core.get.call(null,map__24794__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var file = cljs.core.get.call(null,map__24794__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
if(cljs.core.truth_(namespace)){
return figwheel.client.file_reloading.name__GT_path.call(null,cljs.core.name.call(null,namespace));
} else {
return file;
}
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24639,inst_24643,inst_24642,inst_24662,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24665 = cljs.core.map.call(null,inst_24664,inst_24643);
var inst_24666 = cljs.core.pr_str.call(null,inst_24665);
var inst_24667 = figwheel.client.utils.log.call(null,inst_24666);
var inst_24668 = (function (){var all_files = inst_24639;
var res_SINGLEQUOTE_ = inst_24642;
var res = inst_24643;
var files_not_loaded = inst_24645;
var dependencies_that_loaded = inst_24647;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24639,inst_24643,inst_24642,inst_24662,inst_24664,inst_24665,inst_24666,inst_24667,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (){
figwheel.client.file_reloading.on_jsload_custom_event.call(null,res);

return cljs.core.apply.call(null,on_jsload,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [res], null));
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24645,inst_24647,inst_24639,inst_24643,inst_24642,inst_24662,inst_24664,inst_24665,inst_24666,inst_24667,state_val_24726,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24669 = setTimeout(inst_24668,(10));
var state_24725__$1 = (function (){var statearr_24796 = state_24725;
(statearr_24796[(33)] = inst_24667);

(statearr_24796[(34)] = inst_24662);

return statearr_24796;
})();
var statearr_24797_24863 = state_24725__$1;
(statearr_24797_24863[(2)] = inst_24669);

(statearr_24797_24863[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (16))){
var state_24725__$1 = state_24725;
var statearr_24798_24864 = state_24725__$1;
(statearr_24798_24864[(2)] = reload_dependents);

(statearr_24798_24864[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (38))){
var inst_24679 = (state_24725[(16)]);
var inst_24696 = cljs.core.apply.call(null,cljs.core.hash_map,inst_24679);
var state_24725__$1 = state_24725;
var statearr_24799_24865 = state_24725__$1;
(statearr_24799_24865[(2)] = inst_24696);

(statearr_24799_24865[(1)] = (40));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (30))){
var state_24725__$1 = state_24725;
var statearr_24800_24866 = state_24725__$1;
(statearr_24800_24866[(2)] = null);

(statearr_24800_24866[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (10))){
var inst_24599 = (state_24725[(22)]);
var inst_24601 = cljs.core.chunked_seq_QMARK_.call(null,inst_24599);
var state_24725__$1 = state_24725;
if(inst_24601){
var statearr_24801_24867 = state_24725__$1;
(statearr_24801_24867[(1)] = (13));

} else {
var statearr_24802_24868 = state_24725__$1;
(statearr_24802_24868[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (18))){
var inst_24633 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
if(cljs.core.truth_(inst_24633)){
var statearr_24803_24869 = state_24725__$1;
(statearr_24803_24869[(1)] = (19));

} else {
var statearr_24804_24870 = state_24725__$1;
(statearr_24804_24870[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (42))){
var state_24725__$1 = state_24725;
var statearr_24805_24871 = state_24725__$1;
(statearr_24805_24871[(2)] = null);

(statearr_24805_24871[(1)] = (43));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (37))){
var inst_24691 = (state_24725[(2)]);
var state_24725__$1 = state_24725;
var statearr_24806_24872 = state_24725__$1;
(statearr_24806_24872[(2)] = inst_24691);

(statearr_24806_24872[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24726 === (8))){
var inst_24586 = (state_24725[(8)]);
var inst_24599 = (state_24725[(22)]);
var inst_24599__$1 = cljs.core.seq.call(null,inst_24586);
var state_24725__$1 = (function (){var statearr_24807 = state_24725;
(statearr_24807[(22)] = inst_24599__$1);

return statearr_24807;
})();
if(inst_24599__$1){
var statearr_24808_24873 = state_24725__$1;
(statearr_24808_24873[(1)] = (10));

} else {
var statearr_24809_24874 = state_24725__$1;
(statearr_24809_24874[(1)] = (11));

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
});})(c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
;
return ((function (switch__20925__auto__,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents){
return (function() {
var figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto__ = null;
var figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto____0 = (function (){
var statearr_24813 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_24813[(0)] = figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto__);

(statearr_24813[(1)] = (1));

return statearr_24813;
});
var figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto____1 = (function (state_24725){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_24725);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e24814){if((e24814 instanceof Object)){
var ex__20929__auto__ = e24814;
var statearr_24815_24875 = state_24725;
(statearr_24815_24875[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24725);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24814;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24876 = state_24725;
state_24725 = G__24876;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto__ = function(state_24725){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto____1.call(this,state_24725);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto____0;
figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto____1;
return figwheel$client$file_reloading$reload_js_files_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var state__21039__auto__ = (function (){var statearr_24816 = f__21038__auto__.call(null);
(statearr_24816[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_24816;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__,map__24571,map__24571__$1,opts,before_jsload,on_jsload,reload_dependents,map__24572,map__24572__$1,msg,files,figwheel_meta,recompile_dependents))
);

return c__21037__auto__;
});
figwheel.client.file_reloading.current_links = (function figwheel$client$file_reloading$current_links(){
return Array.prototype.slice.call(document.getElementsByTagName("link"));
});
figwheel.client.file_reloading.truncate_url = (function figwheel$client$file_reloading$truncate_url(url){
return clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,cljs.core.first.call(null,clojure.string.split.call(null,url,/\?/)),[cljs.core.str(location.protocol),cljs.core.str("//")].join(''),""),".*://",""),/^\/\//,""),/[^\\/]*/,"");
});
figwheel.client.file_reloading.matches_file_QMARK_ = (function figwheel$client$file_reloading$matches_file_QMARK_(p__24879,link){
var map__24882 = p__24879;
var map__24882__$1 = ((((!((map__24882 == null)))?((((map__24882.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24882.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24882):map__24882);
var file = cljs.core.get.call(null,map__24882__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
var temp__4657__auto__ = link.href;
if(cljs.core.truth_(temp__4657__auto__)){
var link_href = temp__4657__auto__;
var match = clojure.string.join.call(null,"/",cljs.core.take_while.call(null,cljs.core.identity,cljs.core.map.call(null,((function (link_href,temp__4657__auto__,map__24882,map__24882__$1,file){
return (function (p1__24877_SHARP_,p2__24878_SHARP_){
if(cljs.core._EQ_.call(null,p1__24877_SHARP_,p2__24878_SHARP_)){
return p1__24877_SHARP_;
} else {
return false;
}
});})(link_href,temp__4657__auto__,map__24882,map__24882__$1,file))
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
var temp__4657__auto__ = cljs.core.first.call(null,cljs.core.sort_by.call(null,(function (p__24888){
var map__24889 = p__24888;
var map__24889__$1 = ((((!((map__24889 == null)))?((((map__24889.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24889.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24889):map__24889);
var match_length = cljs.core.get.call(null,map__24889__$1,new cljs.core.Keyword(null,"match-length","match-length",1101537310));
var current_url_length = cljs.core.get.call(null,map__24889__$1,new cljs.core.Keyword(null,"current-url-length","current-url-length",380404083));
return (current_url_length - match_length);
}),cljs.core.keep.call(null,(function (p1__24884_SHARP_){
return figwheel.client.file_reloading.matches_file_QMARK_.call(null,f_data,p1__24884_SHARP_);
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
var args24891 = [];
var len__19428__auto___24894 = arguments.length;
var i__19429__auto___24895 = (0);
while(true){
if((i__19429__auto___24895 < len__19428__auto___24894)){
args24891.push((arguments[i__19429__auto___24895]));

var G__24896 = (i__19429__auto___24895 + (1));
i__19429__auto___24895 = G__24896;
continue;
} else {
}
break;
}

var G__24893 = args24891.length;
switch (G__24893) {
case 1:
return figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args24891.length)].join('')));

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
return cljs.core.vals.call(null,cljs.core.reduce.call(null,(function (p1__24898_SHARP_,p2__24899_SHARP_){
return cljs.core.assoc.call(null,p1__24898_SHARP_,cljs.core.get.call(null,p2__24899_SHARP_,key),p2__24899_SHARP_);
}),cljs.core.PersistentArrayMap.EMPTY,seqq));
});
figwheel.client.file_reloading.reload_css_file = (function figwheel$client$file_reloading$reload_css_file(p__24900){
var map__24903 = p__24900;
var map__24903__$1 = ((((!((map__24903 == null)))?((((map__24903.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24903.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24903):map__24903);
var f_data = map__24903__$1;
var file = cljs.core.get.call(null,map__24903__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
var temp__4657__auto__ = figwheel.client.file_reloading.get_correct_link.call(null,f_data);
if(cljs.core.truth_(temp__4657__auto__)){
var link = temp__4657__auto__;
return figwheel.client.file_reloading.add_link_to_doc.call(null,link,figwheel.client.file_reloading.clone_link.call(null,link,link.href));
} else {
return null;
}
});
figwheel.client.file_reloading.reload_css_files = (function figwheel$client$file_reloading$reload_css_files(p__24905,files_msg){
var map__24912 = p__24905;
var map__24912__$1 = ((((!((map__24912 == null)))?((((map__24912.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24912.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24912):map__24912);
var opts = map__24912__$1;
var on_cssload = cljs.core.get.call(null,map__24912__$1,new cljs.core.Keyword(null,"on-cssload","on-cssload",1825432318));
if(cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))){
var seq__24914_24918 = cljs.core.seq.call(null,figwheel.client.file_reloading.distictify.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(files_msg)));
var chunk__24915_24919 = null;
var count__24916_24920 = (0);
var i__24917_24921 = (0);
while(true){
if((i__24917_24921 < count__24916_24920)){
var f_24922 = cljs.core._nth.call(null,chunk__24915_24919,i__24917_24921);
figwheel.client.file_reloading.reload_css_file.call(null,f_24922);

var G__24923 = seq__24914_24918;
var G__24924 = chunk__24915_24919;
var G__24925 = count__24916_24920;
var G__24926 = (i__24917_24921 + (1));
seq__24914_24918 = G__24923;
chunk__24915_24919 = G__24924;
count__24916_24920 = G__24925;
i__24917_24921 = G__24926;
continue;
} else {
var temp__4657__auto___24927 = cljs.core.seq.call(null,seq__24914_24918);
if(temp__4657__auto___24927){
var seq__24914_24928__$1 = temp__4657__auto___24927;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24914_24928__$1)){
var c__19173__auto___24929 = cljs.core.chunk_first.call(null,seq__24914_24928__$1);
var G__24930 = cljs.core.chunk_rest.call(null,seq__24914_24928__$1);
var G__24931 = c__19173__auto___24929;
var G__24932 = cljs.core.count.call(null,c__19173__auto___24929);
var G__24933 = (0);
seq__24914_24918 = G__24930;
chunk__24915_24919 = G__24931;
count__24916_24920 = G__24932;
i__24917_24921 = G__24933;
continue;
} else {
var f_24934 = cljs.core.first.call(null,seq__24914_24928__$1);
figwheel.client.file_reloading.reload_css_file.call(null,f_24934);

var G__24935 = cljs.core.next.call(null,seq__24914_24928__$1);
var G__24936 = null;
var G__24937 = (0);
var G__24938 = (0);
seq__24914_24918 = G__24935;
chunk__24915_24919 = G__24936;
count__24916_24920 = G__24937;
i__24917_24921 = G__24938;
continue;
}
} else {
}
}
break;
}

return setTimeout(((function (map__24912,map__24912__$1,opts,on_cssload){
return (function (){
return on_cssload.call(null,new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(files_msg));
});})(map__24912,map__24912__$1,opts,on_cssload))
,(100));
} else {
return null;
}
});

//# sourceMappingURL=file_reloading.js.map