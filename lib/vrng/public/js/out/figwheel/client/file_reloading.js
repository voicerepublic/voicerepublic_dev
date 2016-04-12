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
return cljs.core.set.call(null,cljs.core.filter.call(null,(function (p1__24066_SHARP_){
return cljs.core.not.call(null,figwheel.client.file_reloading.immutable_ns_QMARK_.call(null,p1__24066_SHARP_));
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
var seq__24071 = cljs.core.seq.call(null,figwheel.client.file_reloading.path__GT_name.call(null,k));
var chunk__24072 = null;
var count__24073 = (0);
var i__24074 = (0);
while(true){
if((i__24074 < count__24073)){
var n = cljs.core._nth.call(null,chunk__24072,i__24074);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,k_SINGLEQUOTE_,n);

var G__24075 = seq__24071;
var G__24076 = chunk__24072;
var G__24077 = count__24073;
var G__24078 = (i__24074 + (1));
seq__24071 = G__24075;
chunk__24072 = G__24076;
count__24073 = G__24077;
i__24074 = G__24078;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__24071);
if(temp__4657__auto__){
var seq__24071__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24071__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__24071__$1);
var G__24079 = cljs.core.chunk_rest.call(null,seq__24071__$1);
var G__24080 = c__19173__auto__;
var G__24081 = cljs.core.count.call(null,c__19173__auto__);
var G__24082 = (0);
seq__24071 = G__24079;
chunk__24072 = G__24080;
count__24073 = G__24081;
i__24074 = G__24082;
continue;
} else {
var n = cljs.core.first.call(null,seq__24071__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,k_SINGLEQUOTE_,n);

var G__24083 = cljs.core.next.call(null,seq__24071__$1);
var G__24084 = null;
var G__24085 = (0);
var G__24086 = (0);
seq__24071 = G__24083;
chunk__24072 = G__24084;
count__24073 = G__24085;
i__24074 = G__24086;
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

var seq__24125_24132 = cljs.core.seq.call(null,deps);
var chunk__24126_24133 = null;
var count__24127_24134 = (0);
var i__24128_24135 = (0);
while(true){
if((i__24128_24135 < count__24127_24134)){
var dep_24136 = cljs.core._nth.call(null,chunk__24126_24133,i__24128_24135);
topo_sort_helper_STAR_.call(null,dep_24136,(depth + (1)),state);

var G__24137 = seq__24125_24132;
var G__24138 = chunk__24126_24133;
var G__24139 = count__24127_24134;
var G__24140 = (i__24128_24135 + (1));
seq__24125_24132 = G__24137;
chunk__24126_24133 = G__24138;
count__24127_24134 = G__24139;
i__24128_24135 = G__24140;
continue;
} else {
var temp__4657__auto___24141 = cljs.core.seq.call(null,seq__24125_24132);
if(temp__4657__auto___24141){
var seq__24125_24142__$1 = temp__4657__auto___24141;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24125_24142__$1)){
var c__19173__auto___24143 = cljs.core.chunk_first.call(null,seq__24125_24142__$1);
var G__24144 = cljs.core.chunk_rest.call(null,seq__24125_24142__$1);
var G__24145 = c__19173__auto___24143;
var G__24146 = cljs.core.count.call(null,c__19173__auto___24143);
var G__24147 = (0);
seq__24125_24132 = G__24144;
chunk__24126_24133 = G__24145;
count__24127_24134 = G__24146;
i__24128_24135 = G__24147;
continue;
} else {
var dep_24148 = cljs.core.first.call(null,seq__24125_24142__$1);
topo_sort_helper_STAR_.call(null,dep_24148,(depth + (1)),state);

var G__24149 = cljs.core.next.call(null,seq__24125_24142__$1);
var G__24150 = null;
var G__24151 = (0);
var G__24152 = (0);
seq__24125_24132 = G__24149;
chunk__24126_24133 = G__24150;
count__24127_24134 = G__24151;
i__24128_24135 = G__24152;
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
return (function figwheel$client$file_reloading$build_topo_sort_$_elim_dups_STAR_(p__24129){
var vec__24131 = p__24129;
var x = cljs.core.nth.call(null,vec__24131,(0),null);
var xs = cljs.core.nthnext.call(null,vec__24131,(1));
if((x == null)){
return cljs.core.List.EMPTY;
} else {
return cljs.core.cons.call(null,x,figwheel$client$file_reloading$build_topo_sort_$_elim_dups_STAR_.call(null,cljs.core.map.call(null,((function (vec__24131,x,xs,get_deps__$1){
return (function (p1__24087_SHARP_){
return clojure.set.difference.call(null,p1__24087_SHARP_,x);
});})(vec__24131,x,xs,get_deps__$1))
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
var seq__24165 = cljs.core.seq.call(null,provides);
var chunk__24166 = null;
var count__24167 = (0);
var i__24168 = (0);
while(true){
if((i__24168 < count__24167)){
var prov = cljs.core._nth.call(null,chunk__24166,i__24168);
figwheel.client.file_reloading.path_to_name_BANG_.call(null,path,prov);

var seq__24169_24177 = cljs.core.seq.call(null,requires);
var chunk__24170_24178 = null;
var count__24171_24179 = (0);
var i__24172_24180 = (0);
while(true){
if((i__24172_24180 < count__24171_24179)){
var req_24181 = cljs.core._nth.call(null,chunk__24170_24178,i__24172_24180);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24181,prov);

var G__24182 = seq__24169_24177;
var G__24183 = chunk__24170_24178;
var G__24184 = count__24171_24179;
var G__24185 = (i__24172_24180 + (1));
seq__24169_24177 = G__24182;
chunk__24170_24178 = G__24183;
count__24171_24179 = G__24184;
i__24172_24180 = G__24185;
continue;
} else {
var temp__4657__auto___24186 = cljs.core.seq.call(null,seq__24169_24177);
if(temp__4657__auto___24186){
var seq__24169_24187__$1 = temp__4657__auto___24186;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24169_24187__$1)){
var c__19173__auto___24188 = cljs.core.chunk_first.call(null,seq__24169_24187__$1);
var G__24189 = cljs.core.chunk_rest.call(null,seq__24169_24187__$1);
var G__24190 = c__19173__auto___24188;
var G__24191 = cljs.core.count.call(null,c__19173__auto___24188);
var G__24192 = (0);
seq__24169_24177 = G__24189;
chunk__24170_24178 = G__24190;
count__24171_24179 = G__24191;
i__24172_24180 = G__24192;
continue;
} else {
var req_24193 = cljs.core.first.call(null,seq__24169_24187__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24193,prov);

var G__24194 = cljs.core.next.call(null,seq__24169_24187__$1);
var G__24195 = null;
var G__24196 = (0);
var G__24197 = (0);
seq__24169_24177 = G__24194;
chunk__24170_24178 = G__24195;
count__24171_24179 = G__24196;
i__24172_24180 = G__24197;
continue;
}
} else {
}
}
break;
}

var G__24198 = seq__24165;
var G__24199 = chunk__24166;
var G__24200 = count__24167;
var G__24201 = (i__24168 + (1));
seq__24165 = G__24198;
chunk__24166 = G__24199;
count__24167 = G__24200;
i__24168 = G__24201;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__24165);
if(temp__4657__auto__){
var seq__24165__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24165__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__24165__$1);
var G__24202 = cljs.core.chunk_rest.call(null,seq__24165__$1);
var G__24203 = c__19173__auto__;
var G__24204 = cljs.core.count.call(null,c__19173__auto__);
var G__24205 = (0);
seq__24165 = G__24202;
chunk__24166 = G__24203;
count__24167 = G__24204;
i__24168 = G__24205;
continue;
} else {
var prov = cljs.core.first.call(null,seq__24165__$1);
figwheel.client.file_reloading.path_to_name_BANG_.call(null,path,prov);

var seq__24173_24206 = cljs.core.seq.call(null,requires);
var chunk__24174_24207 = null;
var count__24175_24208 = (0);
var i__24176_24209 = (0);
while(true){
if((i__24176_24209 < count__24175_24208)){
var req_24210 = cljs.core._nth.call(null,chunk__24174_24207,i__24176_24209);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24210,prov);

var G__24211 = seq__24173_24206;
var G__24212 = chunk__24174_24207;
var G__24213 = count__24175_24208;
var G__24214 = (i__24176_24209 + (1));
seq__24173_24206 = G__24211;
chunk__24174_24207 = G__24212;
count__24175_24208 = G__24213;
i__24176_24209 = G__24214;
continue;
} else {
var temp__4657__auto___24215__$1 = cljs.core.seq.call(null,seq__24173_24206);
if(temp__4657__auto___24215__$1){
var seq__24173_24216__$1 = temp__4657__auto___24215__$1;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24173_24216__$1)){
var c__19173__auto___24217 = cljs.core.chunk_first.call(null,seq__24173_24216__$1);
var G__24218 = cljs.core.chunk_rest.call(null,seq__24173_24216__$1);
var G__24219 = c__19173__auto___24217;
var G__24220 = cljs.core.count.call(null,c__19173__auto___24217);
var G__24221 = (0);
seq__24173_24206 = G__24218;
chunk__24174_24207 = G__24219;
count__24175_24208 = G__24220;
i__24176_24209 = G__24221;
continue;
} else {
var req_24222 = cljs.core.first.call(null,seq__24173_24216__$1);
figwheel.client.file_reloading.name_to_parent_BANG_.call(null,req_24222,prov);

var G__24223 = cljs.core.next.call(null,seq__24173_24216__$1);
var G__24224 = null;
var G__24225 = (0);
var G__24226 = (0);
seq__24173_24206 = G__24223;
chunk__24174_24207 = G__24224;
count__24175_24208 = G__24225;
i__24176_24209 = G__24226;
continue;
}
} else {
}
}
break;
}

var G__24227 = cljs.core.next.call(null,seq__24165__$1);
var G__24228 = null;
var G__24229 = (0);
var G__24230 = (0);
seq__24165 = G__24227;
chunk__24166 = G__24228;
count__24167 = G__24229;
i__24168 = G__24230;
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
var seq__24235_24239 = cljs.core.seq.call(null,figwheel.client.file_reloading.get_all_dependencies.call(null,src));
var chunk__24236_24240 = null;
var count__24237_24241 = (0);
var i__24238_24242 = (0);
while(true){
if((i__24238_24242 < count__24237_24241)){
var ns_24243 = cljs.core._nth.call(null,chunk__24236_24240,i__24238_24242);
figwheel.client.file_reloading.unprovide_BANG_.call(null,ns_24243);

var G__24244 = seq__24235_24239;
var G__24245 = chunk__24236_24240;
var G__24246 = count__24237_24241;
var G__24247 = (i__24238_24242 + (1));
seq__24235_24239 = G__24244;
chunk__24236_24240 = G__24245;
count__24237_24241 = G__24246;
i__24238_24242 = G__24247;
continue;
} else {
var temp__4657__auto___24248 = cljs.core.seq.call(null,seq__24235_24239);
if(temp__4657__auto___24248){
var seq__24235_24249__$1 = temp__4657__auto___24248;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__24235_24249__$1)){
var c__19173__auto___24250 = cljs.core.chunk_first.call(null,seq__24235_24249__$1);
var G__24251 = cljs.core.chunk_rest.call(null,seq__24235_24249__$1);
var G__24252 = c__19173__auto___24250;
var G__24253 = cljs.core.count.call(null,c__19173__auto___24250);
var G__24254 = (0);
seq__24235_24239 = G__24251;
chunk__24236_24240 = G__24252;
count__24237_24241 = G__24253;
i__24238_24242 = G__24254;
continue;
} else {
var ns_24255 = cljs.core.first.call(null,seq__24235_24249__$1);
figwheel.client.file_reloading.unprovide_BANG_.call(null,ns_24255);

var G__24256 = cljs.core.next.call(null,seq__24235_24249__$1);
var G__24257 = null;
var G__24258 = (0);
var G__24259 = (0);
seq__24235_24239 = G__24256;
chunk__24236_24240 = G__24257;
count__24237_24241 = G__24258;
i__24238_24242 = G__24259;
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
var G__24260__delegate = function (args){
cljs.core.apply.call(null,figwheel.client.file_reloading.addDependency,args);

return cljs.core.apply.call(null,goog.addDependency_figwheel_backup_,args);
};
var G__24260 = function (var_args){
var args = null;
if (arguments.length > 0) {
var G__24261__i = 0, G__24261__a = new Array(arguments.length -  0);
while (G__24261__i < G__24261__a.length) {G__24261__a[G__24261__i] = arguments[G__24261__i + 0]; ++G__24261__i;}
  args = new cljs.core.IndexedSeq(G__24261__a,0);
} 
return G__24260__delegate.call(this,args);};
G__24260.cljs$lang$maxFixedArity = 0;
G__24260.cljs$lang$applyTo = (function (arglist__24262){
var args = cljs.core.seq(arglist__24262);
return G__24260__delegate(args);
});
G__24260.cljs$core$IFn$_invoke$arity$variadic = G__24260__delegate;
return G__24260;
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
figwheel.client.file_reloading.reload_file_STAR_ = (function (){var pred__24264 = cljs.core._EQ_;
var expr__24265 = figwheel.client.utils.host_env_QMARK_.call(null);
if(cljs.core.truth_(pred__24264.call(null,new cljs.core.Keyword(null,"node","node",581201198),expr__24265))){
var path_parts = ((function (pred__24264,expr__24265){
return (function (p1__24263_SHARP_){
return clojure.string.split.call(null,p1__24263_SHARP_,/[\/\\]/);
});})(pred__24264,expr__24265))
;
var sep = (cljs.core.truth_(cljs.core.re_matches.call(null,/win.*/,process.platform))?"\\":"/");
var root = clojure.string.join.call(null,sep,cljs.core.pop.call(null,cljs.core.pop.call(null,path_parts.call(null,__dirname))));
return ((function (path_parts,sep,root,pred__24264,expr__24265){
return (function (request_url,callback){

var cache_path = clojure.string.join.call(null,sep,cljs.core.cons.call(null,root,path_parts.call(null,figwheel.client.file_reloading.fix_node_request_url.call(null,request_url))));
(require.cache[cache_path] = null);

return callback.call(null,(function (){try{return require(cache_path);
}catch (e24267){if((e24267 instanceof Error)){
var e = e24267;
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Figwheel: Error loading file "),cljs.core.str(cache_path)].join(''));

figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),e.stack);

return false;
} else {
throw e24267;

}
}})());
});
;})(path_parts,sep,root,pred__24264,expr__24265))
} else {
if(cljs.core.truth_(pred__24264.call(null,new cljs.core.Keyword(null,"html","html",-998796897),expr__24265))){
return ((function (pred__24264,expr__24265){
return (function (request_url,callback){

var deferred = goog.net.jsloader.load(figwheel.client.file_reloading.add_cache_buster.call(null,request_url),{"cleanupWhenDone": true});
deferred.addCallback(((function (deferred,pred__24264,expr__24265){
return (function (){
return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [true], null));
});})(deferred,pred__24264,expr__24265))
);

return deferred.addErrback(((function (deferred,pred__24264,expr__24265){
return (function (){
return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [false], null));
});})(deferred,pred__24264,expr__24265))
);
});
;})(pred__24264,expr__24265))
} else {
return ((function (pred__24264,expr__24265){
return (function (a,b){
throw "Reload not defined for this platform";
});
;})(pred__24264,expr__24265))
}
}
})();
figwheel.client.file_reloading.reload_file = (function figwheel$client$file_reloading$reload_file(p__24268,callback){
var map__24271 = p__24268;
var map__24271__$1 = ((((!((map__24271 == null)))?((((map__24271.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24271.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24271):map__24271);
var file_msg = map__24271__$1;
var request_url = cljs.core.get.call(null,map__24271__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));

figwheel.client.utils.debug_prn.call(null,[cljs.core.str("FigWheel: Attempting to load "),cljs.core.str(request_url)].join(''));

return figwheel.client.file_reloading.reload_file_STAR_.call(null,request_url,((function (map__24271,map__24271__$1,file_msg,request_url){
return (function (success_QMARK_){
if(cljs.core.truth_(success_QMARK_)){
figwheel.client.utils.debug_prn.call(null,[cljs.core.str("FigWheel: Successfully loaded "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.assoc.call(null,file_msg,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),true)], null));
} else {
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"error","error",-978969032),[cljs.core.str("Figwheel: Error loading file "),cljs.core.str(request_url)].join(''));

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [file_msg], null));
}
});})(map__24271,map__24271__$1,file_msg,request_url))
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
figwheel.client.file_reloading.reloader_loop = (function (){var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__){
return (function (state_24295){
var state_val_24296 = (state_24295[(1)]);
if((state_val_24296 === (7))){
var inst_24291 = (state_24295[(2)]);
var state_24295__$1 = state_24295;
var statearr_24297_24317 = state_24295__$1;
(statearr_24297_24317[(2)] = inst_24291);

(statearr_24297_24317[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (1))){
var state_24295__$1 = state_24295;
var statearr_24298_24318 = state_24295__$1;
(statearr_24298_24318[(2)] = null);

(statearr_24298_24318[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (4))){
var inst_24275 = (state_24295[(7)]);
var inst_24275__$1 = (state_24295[(2)]);
var state_24295__$1 = (function (){var statearr_24299 = state_24295;
(statearr_24299[(7)] = inst_24275__$1);

return statearr_24299;
})();
if(cljs.core.truth_(inst_24275__$1)){
var statearr_24300_24319 = state_24295__$1;
(statearr_24300_24319[(1)] = (5));

} else {
var statearr_24301_24320 = state_24295__$1;
(statearr_24301_24320[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (6))){
var state_24295__$1 = state_24295;
var statearr_24302_24321 = state_24295__$1;
(statearr_24302_24321[(2)] = null);

(statearr_24302_24321[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (3))){
var inst_24293 = (state_24295[(2)]);
var state_24295__$1 = state_24295;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24295__$1,inst_24293);
} else {
if((state_val_24296 === (2))){
var state_24295__$1 = state_24295;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24295__$1,(4),figwheel.client.file_reloading.reload_chan);
} else {
if((state_val_24296 === (11))){
var inst_24287 = (state_24295[(2)]);
var state_24295__$1 = (function (){var statearr_24303 = state_24295;
(statearr_24303[(8)] = inst_24287);

return statearr_24303;
})();
var statearr_24304_24322 = state_24295__$1;
(statearr_24304_24322[(2)] = null);

(statearr_24304_24322[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (9))){
var inst_24281 = (state_24295[(9)]);
var inst_24279 = (state_24295[(10)]);
var inst_24283 = inst_24281.call(null,inst_24279);
var state_24295__$1 = state_24295;
var statearr_24305_24323 = state_24295__$1;
(statearr_24305_24323[(2)] = inst_24283);

(statearr_24305_24323[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (5))){
var inst_24275 = (state_24295[(7)]);
var inst_24277 = figwheel.client.file_reloading.blocking_load.call(null,inst_24275);
var state_24295__$1 = state_24295;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24295__$1,(8),inst_24277);
} else {
if((state_val_24296 === (10))){
var inst_24279 = (state_24295[(10)]);
var inst_24285 = cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.dependencies_loaded,cljs.core.conj,inst_24279);
var state_24295__$1 = state_24295;
var statearr_24306_24324 = state_24295__$1;
(statearr_24306_24324[(2)] = inst_24285);

(statearr_24306_24324[(1)] = (11));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24296 === (8))){
var inst_24275 = (state_24295[(7)]);
var inst_24281 = (state_24295[(9)]);
var inst_24279 = (state_24295[(2)]);
var inst_24280 = cljs.core.deref.call(null,figwheel.client.file_reloading.on_load_callbacks);
var inst_24281__$1 = cljs.core.get.call(null,inst_24280,inst_24275);
var state_24295__$1 = (function (){var statearr_24307 = state_24295;
(statearr_24307[(9)] = inst_24281__$1);

(statearr_24307[(10)] = inst_24279);

return statearr_24307;
})();
if(cljs.core.truth_(inst_24281__$1)){
var statearr_24308_24325 = state_24295__$1;
(statearr_24308_24325[(1)] = (9));

} else {
var statearr_24309_24326 = state_24295__$1;
(statearr_24309_24326[(1)] = (10));

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
});})(c__21172__auto__))
;
return ((function (switch__21060__auto__,c__21172__auto__){
return (function() {
var figwheel$client$file_reloading$state_machine__21061__auto__ = null;
var figwheel$client$file_reloading$state_machine__21061__auto____0 = (function (){
var statearr_24313 = [null,null,null,null,null,null,null,null,null,null,null];
(statearr_24313[(0)] = figwheel$client$file_reloading$state_machine__21061__auto__);

(statearr_24313[(1)] = (1));

return statearr_24313;
});
var figwheel$client$file_reloading$state_machine__21061__auto____1 = (function (state_24295){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_24295);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e24314){if((e24314 instanceof Object)){
var ex__21064__auto__ = e24314;
var statearr_24315_24327 = state_24295;
(statearr_24315_24327[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24295);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24314;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24328 = state_24295;
state_24295 = G__24328;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$file_reloading$state_machine__21061__auto__ = function(state_24295){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$state_machine__21061__auto____1.call(this,state_24295);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$state_machine__21061__auto____0;
figwheel$client$file_reloading$state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$state_machine__21061__auto____1;
return figwheel$client$file_reloading$state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__))
})();
var state__21174__auto__ = (function (){var statearr_24316 = f__21173__auto__.call(null);
(statearr_24316[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_24316;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__))
);

return c__21172__auto__;
})();
}
figwheel.client.file_reloading.queued_file_reload = (function figwheel$client$file_reloading$queued_file_reload(url){
return cljs.core.async.put_BANG_.call(null,figwheel.client.file_reloading.reload_chan,url);
});
figwheel.client.file_reloading.require_with_callback = (function figwheel$client$file_reloading$require_with_callback(p__24329,callback){
var map__24332 = p__24329;
var map__24332__$1 = ((((!((map__24332 == null)))?((((map__24332.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24332.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24332):map__24332);
var file_msg = map__24332__$1;
var namespace = cljs.core.get.call(null,map__24332__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var request_url = figwheel.client.file_reloading.resolve_ns.call(null,namespace);
cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.on_load_callbacks,cljs.core.assoc,request_url,((function (request_url,map__24332,map__24332__$1,file_msg,namespace){
return (function (file_msg_SINGLEQUOTE_){
cljs.core.swap_BANG_.call(null,figwheel.client.file_reloading.on_load_callbacks,cljs.core.dissoc,request_url);

return cljs.core.apply.call(null,callback,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.merge.call(null,file_msg,cljs.core.select_keys.call(null,file_msg_SINGLEQUOTE_,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375)], null)))], null));
});})(request_url,map__24332,map__24332__$1,file_msg,namespace))
);

return figwheel.client.file_reloading.figwheel_require.call(null,cljs.core.name.call(null,namespace),true);
});
figwheel.client.file_reloading.reload_file_QMARK_ = (function figwheel$client$file_reloading$reload_file_QMARK_(p__24334){
var map__24337 = p__24334;
var map__24337__$1 = ((((!((map__24337 == null)))?((((map__24337.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24337.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24337):map__24337);
var file_msg = map__24337__$1;
var namespace = cljs.core.get.call(null,map__24337__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));

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
figwheel.client.file_reloading.js_reload = (function figwheel$client$file_reloading$js_reload(p__24339,callback){
var map__24342 = p__24339;
var map__24342__$1 = ((((!((map__24342 == null)))?((((map__24342.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24342.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24342):map__24342);
var file_msg = map__24342__$1;
var request_url = cljs.core.get.call(null,map__24342__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));
var namespace = cljs.core.get.call(null,map__24342__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));

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
var c__21172__auto___24430 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___24430,out){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___24430,out){
return (function (state_24412){
var state_val_24413 = (state_24412[(1)]);
if((state_val_24413 === (1))){
var inst_24390 = cljs.core.nth.call(null,files,(0),null);
var inst_24391 = cljs.core.nthnext.call(null,files,(1));
var inst_24392 = files;
var state_24412__$1 = (function (){var statearr_24414 = state_24412;
(statearr_24414[(7)] = inst_24392);

(statearr_24414[(8)] = inst_24391);

(statearr_24414[(9)] = inst_24390);

return statearr_24414;
})();
var statearr_24415_24431 = state_24412__$1;
(statearr_24415_24431[(2)] = null);

(statearr_24415_24431[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24413 === (2))){
var inst_24392 = (state_24412[(7)]);
var inst_24395 = (state_24412[(10)]);
var inst_24395__$1 = cljs.core.nth.call(null,inst_24392,(0),null);
var inst_24396 = cljs.core.nthnext.call(null,inst_24392,(1));
var inst_24397 = (inst_24395__$1 == null);
var inst_24398 = cljs.core.not.call(null,inst_24397);
var state_24412__$1 = (function (){var statearr_24416 = state_24412;
(statearr_24416[(11)] = inst_24396);

(statearr_24416[(10)] = inst_24395__$1);

return statearr_24416;
})();
if(inst_24398){
var statearr_24417_24432 = state_24412__$1;
(statearr_24417_24432[(1)] = (4));

} else {
var statearr_24418_24433 = state_24412__$1;
(statearr_24418_24433[(1)] = (5));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24413 === (3))){
var inst_24410 = (state_24412[(2)]);
var state_24412__$1 = state_24412;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24412__$1,inst_24410);
} else {
if((state_val_24413 === (4))){
var inst_24395 = (state_24412[(10)]);
var inst_24400 = figwheel.client.file_reloading.reload_js_file.call(null,inst_24395);
var state_24412__$1 = state_24412;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24412__$1,(7),inst_24400);
} else {
if((state_val_24413 === (5))){
var inst_24406 = cljs.core.async.close_BANG_.call(null,out);
var state_24412__$1 = state_24412;
var statearr_24419_24434 = state_24412__$1;
(statearr_24419_24434[(2)] = inst_24406);

(statearr_24419_24434[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24413 === (6))){
var inst_24408 = (state_24412[(2)]);
var state_24412__$1 = state_24412;
var statearr_24420_24435 = state_24412__$1;
(statearr_24420_24435[(2)] = inst_24408);

(statearr_24420_24435[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24413 === (7))){
var inst_24396 = (state_24412[(11)]);
var inst_24402 = (state_24412[(2)]);
var inst_24403 = cljs.core.async.put_BANG_.call(null,out,inst_24402);
var inst_24392 = inst_24396;
var state_24412__$1 = (function (){var statearr_24421 = state_24412;
(statearr_24421[(7)] = inst_24392);

(statearr_24421[(12)] = inst_24403);

return statearr_24421;
})();
var statearr_24422_24436 = state_24412__$1;
(statearr_24422_24436[(2)] = null);

(statearr_24422_24436[(1)] = (2));


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
});})(c__21172__auto___24430,out))
;
return ((function (switch__21060__auto__,c__21172__auto___24430,out){
return (function() {
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto__ = null;
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto____0 = (function (){
var statearr_24426 = [null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_24426[(0)] = figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto__);

(statearr_24426[(1)] = (1));

return statearr_24426;
});
var figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto____1 = (function (state_24412){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_24412);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e24427){if((e24427 instanceof Object)){
var ex__21064__auto__ = e24427;
var statearr_24428_24437 = state_24412;
(statearr_24428_24437[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24412);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24427;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__24438 = state_24412;
state_24412 = G__24438;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto__ = function(state_24412){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto____1.call(this,state_24412);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto____0;
figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto____1;
return figwheel$client$file_reloading$load_all_js_files_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___24430,out))
})();
var state__21174__auto__ = (function (){var statearr_24429 = f__21173__auto__.call(null);
(statearr_24429[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___24430);

return statearr_24429;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___24430,out))
);


return cljs.core.async.into.call(null,cljs.core.PersistentVector.EMPTY,out);
});
figwheel.client.file_reloading.eval_body = (function figwheel$client$file_reloading$eval_body(p__24439,opts){
var map__24443 = p__24439;
var map__24443__$1 = ((((!((map__24443 == null)))?((((map__24443.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24443.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24443):map__24443);
var eval_body__$1 = cljs.core.get.call(null,map__24443__$1,new cljs.core.Keyword(null,"eval-body","eval-body",-907279883));
var file = cljs.core.get.call(null,map__24443__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
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
}catch (e24445){var e = e24445;
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
return (function (p1__24446_SHARP_){
return cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(p1__24446_SHARP_),n);
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
return cljs.core.map.call(null,(function (p__24451){
var vec__24452 = p__24451;
var k = cljs.core.nth.call(null,vec__24452,(0),null);
var v = cljs.core.nth.call(null,vec__24452,(1),null);
return new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"namespace","namespace",-377510372),k,new cljs.core.Keyword(null,"type","type",1174270348),new cljs.core.Keyword(null,"namespace","namespace",-377510372)], null);
}),cljs.core.filter.call(null,(function (p__24453){
var vec__24454 = p__24453;
var k = cljs.core.nth.call(null,vec__24454,(0),null);
var v = cljs.core.nth.call(null,vec__24454,(1),null);
return new cljs.core.Keyword(null,"figwheel-always","figwheel-always",799819691).cljs$core$IFn$_invoke$arity$1(v);
}),cljs.core.deref.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas)));
});
figwheel.client.file_reloading.reload_js_files = (function figwheel$client$file_reloading$reload_js_files(p__24458,p__24459){
var map__24706 = p__24458;
var map__24706__$1 = ((((!((map__24706 == null)))?((((map__24706.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24706.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24706):map__24706);
var opts = map__24706__$1;
var before_jsload = cljs.core.get.call(null,map__24706__$1,new cljs.core.Keyword(null,"before-jsload","before-jsload",-847513128));
var on_jsload = cljs.core.get.call(null,map__24706__$1,new cljs.core.Keyword(null,"on-jsload","on-jsload",-395756602));
var reload_dependents = cljs.core.get.call(null,map__24706__$1,new cljs.core.Keyword(null,"reload-dependents","reload-dependents",-956865430));
var map__24707 = p__24459;
var map__24707__$1 = ((((!((map__24707 == null)))?((((map__24707.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24707.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24707):map__24707);
var msg = map__24707__$1;
var files = cljs.core.get.call(null,map__24707__$1,new cljs.core.Keyword(null,"files","files",-472457450));
var figwheel_meta = cljs.core.get.call(null,map__24707__$1,new cljs.core.Keyword(null,"figwheel-meta","figwheel-meta",-225970237));
var recompile_dependents = cljs.core.get.call(null,map__24707__$1,new cljs.core.Keyword(null,"recompile-dependents","recompile-dependents",523804171));
if(cljs.core.empty_QMARK_.call(null,figwheel_meta)){
} else {
cljs.core.reset_BANG_.call(null,figwheel.client.file_reloading.figwheel_meta_pragmas,figwheel_meta);
}

var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (state_24860){
var state_val_24861 = (state_24860[(1)]);
if((state_val_24861 === (7))){
var inst_24724 = (state_24860[(7)]);
var inst_24722 = (state_24860[(8)]);
var inst_24721 = (state_24860[(9)]);
var inst_24723 = (state_24860[(10)]);
var inst_24729 = cljs.core._nth.call(null,inst_24722,inst_24724);
var inst_24730 = figwheel.client.file_reloading.eval_body.call(null,inst_24729,opts);
var inst_24731 = (inst_24724 + (1));
var tmp24862 = inst_24722;
var tmp24863 = inst_24721;
var tmp24864 = inst_24723;
var inst_24721__$1 = tmp24863;
var inst_24722__$1 = tmp24862;
var inst_24723__$1 = tmp24864;
var inst_24724__$1 = inst_24731;
var state_24860__$1 = (function (){var statearr_24865 = state_24860;
(statearr_24865[(7)] = inst_24724__$1);

(statearr_24865[(8)] = inst_24722__$1);

(statearr_24865[(9)] = inst_24721__$1);

(statearr_24865[(10)] = inst_24723__$1);

(statearr_24865[(11)] = inst_24730);

return statearr_24865;
})();
var statearr_24866_24952 = state_24860__$1;
(statearr_24866_24952[(2)] = null);

(statearr_24866_24952[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (20))){
var inst_24764 = (state_24860[(12)]);
var inst_24772 = figwheel.client.file_reloading.sort_files.call(null,inst_24764);
var state_24860__$1 = state_24860;
var statearr_24867_24953 = state_24860__$1;
(statearr_24867_24953[(2)] = inst_24772);

(statearr_24867_24953[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (27))){
var state_24860__$1 = state_24860;
var statearr_24868_24954 = state_24860__$1;
(statearr_24868_24954[(2)] = null);

(statearr_24868_24954[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (1))){
var inst_24713 = (state_24860[(13)]);
var inst_24710 = before_jsload.call(null,files);
var inst_24711 = figwheel.client.file_reloading.before_jsload_custom_event.call(null,files);
var inst_24712 = (function (){return ((function (inst_24713,inst_24710,inst_24711,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24455_SHARP_){
return new cljs.core.Keyword(null,"eval-body","eval-body",-907279883).cljs$core$IFn$_invoke$arity$1(p1__24455_SHARP_);
});
;})(inst_24713,inst_24710,inst_24711,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24713__$1 = cljs.core.filter.call(null,inst_24712,files);
var inst_24714 = cljs.core.not_empty.call(null,inst_24713__$1);
var state_24860__$1 = (function (){var statearr_24869 = state_24860;
(statearr_24869[(14)] = inst_24711);

(statearr_24869[(13)] = inst_24713__$1);

(statearr_24869[(15)] = inst_24710);

return statearr_24869;
})();
if(cljs.core.truth_(inst_24714)){
var statearr_24870_24955 = state_24860__$1;
(statearr_24870_24955[(1)] = (2));

} else {
var statearr_24871_24956 = state_24860__$1;
(statearr_24871_24956[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (24))){
var state_24860__$1 = state_24860;
var statearr_24872_24957 = state_24860__$1;
(statearr_24872_24957[(2)] = null);

(statearr_24872_24957[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (39))){
var inst_24814 = (state_24860[(16)]);
var state_24860__$1 = state_24860;
var statearr_24873_24958 = state_24860__$1;
(statearr_24873_24958[(2)] = inst_24814);

(statearr_24873_24958[(1)] = (40));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (46))){
var inst_24855 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
var statearr_24874_24959 = state_24860__$1;
(statearr_24874_24959[(2)] = inst_24855);

(statearr_24874_24959[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (4))){
var inst_24758 = (state_24860[(2)]);
var inst_24759 = cljs.core.List.EMPTY;
var inst_24760 = cljs.core.reset_BANG_.call(null,figwheel.client.file_reloading.dependencies_loaded,inst_24759);
var inst_24761 = (function (){return ((function (inst_24758,inst_24759,inst_24760,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24456_SHARP_){
var and__18358__auto__ = new cljs.core.Keyword(null,"namespace","namespace",-377510372).cljs$core$IFn$_invoke$arity$1(p1__24456_SHARP_);
if(cljs.core.truth_(and__18358__auto__)){
return cljs.core.not.call(null,new cljs.core.Keyword(null,"eval-body","eval-body",-907279883).cljs$core$IFn$_invoke$arity$1(p1__24456_SHARP_));
} else {
return and__18358__auto__;
}
});
;})(inst_24758,inst_24759,inst_24760,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24762 = cljs.core.filter.call(null,inst_24761,files);
var inst_24763 = figwheel.client.file_reloading.get_figwheel_always.call(null);
var inst_24764 = cljs.core.concat.call(null,inst_24762,inst_24763);
var state_24860__$1 = (function (){var statearr_24875 = state_24860;
(statearr_24875[(17)] = inst_24758);

(statearr_24875[(12)] = inst_24764);

(statearr_24875[(18)] = inst_24760);

return statearr_24875;
})();
if(cljs.core.truth_(reload_dependents)){
var statearr_24876_24960 = state_24860__$1;
(statearr_24876_24960[(1)] = (16));

} else {
var statearr_24877_24961 = state_24860__$1;
(statearr_24877_24961[(1)] = (17));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (15))){
var inst_24748 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
var statearr_24878_24962 = state_24860__$1;
(statearr_24878_24962[(2)] = inst_24748);

(statearr_24878_24962[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (21))){
var inst_24774 = (state_24860[(19)]);
var inst_24774__$1 = (state_24860[(2)]);
var inst_24775 = figwheel.client.file_reloading.load_all_js_files.call(null,inst_24774__$1);
var state_24860__$1 = (function (){var statearr_24879 = state_24860;
(statearr_24879[(19)] = inst_24774__$1);

return statearr_24879;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_24860__$1,(22),inst_24775);
} else {
if((state_val_24861 === (31))){
var inst_24858 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_24860__$1,inst_24858);
} else {
if((state_val_24861 === (32))){
var inst_24814 = (state_24860[(16)]);
var inst_24819 = inst_24814.cljs$lang$protocol_mask$partition0$;
var inst_24820 = (inst_24819 & (64));
var inst_24821 = inst_24814.cljs$core$ISeq$;
var inst_24822 = (inst_24820) || (inst_24821);
var state_24860__$1 = state_24860;
if(cljs.core.truth_(inst_24822)){
var statearr_24880_24963 = state_24860__$1;
(statearr_24880_24963[(1)] = (35));

} else {
var statearr_24881_24964 = state_24860__$1;
(statearr_24881_24964[(1)] = (36));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (40))){
var inst_24835 = (state_24860[(20)]);
var inst_24834 = (state_24860[(2)]);
var inst_24835__$1 = cljs.core.get.call(null,inst_24834,new cljs.core.Keyword(null,"figwheel-no-load","figwheel-no-load",-555840179));
var inst_24836 = cljs.core.get.call(null,inst_24834,new cljs.core.Keyword(null,"not-required","not-required",-950359114));
var inst_24837 = cljs.core.not_empty.call(null,inst_24835__$1);
var state_24860__$1 = (function (){var statearr_24882 = state_24860;
(statearr_24882[(20)] = inst_24835__$1);

(statearr_24882[(21)] = inst_24836);

return statearr_24882;
})();
if(cljs.core.truth_(inst_24837)){
var statearr_24883_24965 = state_24860__$1;
(statearr_24883_24965[(1)] = (41));

} else {
var statearr_24884_24966 = state_24860__$1;
(statearr_24884_24966[(1)] = (42));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (33))){
var state_24860__$1 = state_24860;
var statearr_24885_24967 = state_24860__$1;
(statearr_24885_24967[(2)] = false);

(statearr_24885_24967[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (13))){
var inst_24734 = (state_24860[(22)]);
var inst_24738 = cljs.core.chunk_first.call(null,inst_24734);
var inst_24739 = cljs.core.chunk_rest.call(null,inst_24734);
var inst_24740 = cljs.core.count.call(null,inst_24738);
var inst_24721 = inst_24739;
var inst_24722 = inst_24738;
var inst_24723 = inst_24740;
var inst_24724 = (0);
var state_24860__$1 = (function (){var statearr_24886 = state_24860;
(statearr_24886[(7)] = inst_24724);

(statearr_24886[(8)] = inst_24722);

(statearr_24886[(9)] = inst_24721);

(statearr_24886[(10)] = inst_24723);

return statearr_24886;
})();
var statearr_24887_24968 = state_24860__$1;
(statearr_24887_24968[(2)] = null);

(statearr_24887_24968[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (22))){
var inst_24782 = (state_24860[(23)]);
var inst_24778 = (state_24860[(24)]);
var inst_24777 = (state_24860[(25)]);
var inst_24774 = (state_24860[(19)]);
var inst_24777__$1 = (state_24860[(2)]);
var inst_24778__$1 = cljs.core.filter.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),inst_24777__$1);
var inst_24779 = (function (){var all_files = inst_24774;
var res_SINGLEQUOTE_ = inst_24777__$1;
var res = inst_24778__$1;
return ((function (all_files,res_SINGLEQUOTE_,res,inst_24782,inst_24778,inst_24777,inst_24774,inst_24777__$1,inst_24778__$1,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p1__24457_SHARP_){
return cljs.core.not.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375).cljs$core$IFn$_invoke$arity$1(p1__24457_SHARP_));
});
;})(all_files,res_SINGLEQUOTE_,res,inst_24782,inst_24778,inst_24777,inst_24774,inst_24777__$1,inst_24778__$1,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24780 = cljs.core.filter.call(null,inst_24779,inst_24777__$1);
var inst_24781 = cljs.core.deref.call(null,figwheel.client.file_reloading.dependencies_loaded);
var inst_24782__$1 = cljs.core.filter.call(null,new cljs.core.Keyword(null,"loaded-file","loaded-file",-168399375),inst_24781);
var inst_24783 = cljs.core.not_empty.call(null,inst_24782__$1);
var state_24860__$1 = (function (){var statearr_24888 = state_24860;
(statearr_24888[(23)] = inst_24782__$1);

(statearr_24888[(24)] = inst_24778__$1);

(statearr_24888[(26)] = inst_24780);

(statearr_24888[(25)] = inst_24777__$1);

return statearr_24888;
})();
if(cljs.core.truth_(inst_24783)){
var statearr_24889_24969 = state_24860__$1;
(statearr_24889_24969[(1)] = (23));

} else {
var statearr_24890_24970 = state_24860__$1;
(statearr_24890_24970[(1)] = (24));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (36))){
var state_24860__$1 = state_24860;
var statearr_24891_24971 = state_24860__$1;
(statearr_24891_24971[(2)] = false);

(statearr_24891_24971[(1)] = (37));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (41))){
var inst_24835 = (state_24860[(20)]);
var inst_24839 = cljs.core.comp.call(null,figwheel.client.file_reloading.name__GT_path,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var inst_24840 = cljs.core.map.call(null,inst_24839,inst_24835);
var inst_24841 = cljs.core.pr_str.call(null,inst_24840);
var inst_24842 = [cljs.core.str("figwheel-no-load meta-data: "),cljs.core.str(inst_24841)].join('');
var inst_24843 = figwheel.client.utils.log.call(null,inst_24842);
var state_24860__$1 = state_24860;
var statearr_24892_24972 = state_24860__$1;
(statearr_24892_24972[(2)] = inst_24843);

(statearr_24892_24972[(1)] = (43));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (43))){
var inst_24836 = (state_24860[(21)]);
var inst_24846 = (state_24860[(2)]);
var inst_24847 = cljs.core.not_empty.call(null,inst_24836);
var state_24860__$1 = (function (){var statearr_24893 = state_24860;
(statearr_24893[(27)] = inst_24846);

return statearr_24893;
})();
if(cljs.core.truth_(inst_24847)){
var statearr_24894_24973 = state_24860__$1;
(statearr_24894_24973[(1)] = (44));

} else {
var statearr_24895_24974 = state_24860__$1;
(statearr_24895_24974[(1)] = (45));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (29))){
var inst_24782 = (state_24860[(23)]);
var inst_24814 = (state_24860[(16)]);
var inst_24778 = (state_24860[(24)]);
var inst_24780 = (state_24860[(26)]);
var inst_24777 = (state_24860[(25)]);
var inst_24774 = (state_24860[(19)]);
var inst_24810 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: NOT loading these files ");
var inst_24813 = (function (){var all_files = inst_24774;
var res_SINGLEQUOTE_ = inst_24777;
var res = inst_24778;
var files_not_loaded = inst_24780;
var dependencies_that_loaded = inst_24782;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24814,inst_24778,inst_24780,inst_24777,inst_24774,inst_24810,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24812){
var map__24896 = p__24812;
var map__24896__$1 = ((((!((map__24896 == null)))?((((map__24896.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24896.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24896):map__24896);
var namespace = cljs.core.get.call(null,map__24896__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
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
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24814,inst_24778,inst_24780,inst_24777,inst_24774,inst_24810,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24814__$1 = cljs.core.group_by.call(null,inst_24813,inst_24780);
var inst_24816 = (inst_24814__$1 == null);
var inst_24817 = cljs.core.not.call(null,inst_24816);
var state_24860__$1 = (function (){var statearr_24898 = state_24860;
(statearr_24898[(16)] = inst_24814__$1);

(statearr_24898[(28)] = inst_24810);

return statearr_24898;
})();
if(inst_24817){
var statearr_24899_24975 = state_24860__$1;
(statearr_24899_24975[(1)] = (32));

} else {
var statearr_24900_24976 = state_24860__$1;
(statearr_24900_24976[(1)] = (33));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (44))){
var inst_24836 = (state_24860[(21)]);
var inst_24849 = cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),inst_24836);
var inst_24850 = cljs.core.pr_str.call(null,inst_24849);
var inst_24851 = [cljs.core.str("not required: "),cljs.core.str(inst_24850)].join('');
var inst_24852 = figwheel.client.utils.log.call(null,inst_24851);
var state_24860__$1 = state_24860;
var statearr_24901_24977 = state_24860__$1;
(statearr_24901_24977[(2)] = inst_24852);

(statearr_24901_24977[(1)] = (46));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (6))){
var inst_24755 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
var statearr_24902_24978 = state_24860__$1;
(statearr_24902_24978[(2)] = inst_24755);

(statearr_24902_24978[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (28))){
var inst_24780 = (state_24860[(26)]);
var inst_24807 = (state_24860[(2)]);
var inst_24808 = cljs.core.not_empty.call(null,inst_24780);
var state_24860__$1 = (function (){var statearr_24903 = state_24860;
(statearr_24903[(29)] = inst_24807);

return statearr_24903;
})();
if(cljs.core.truth_(inst_24808)){
var statearr_24904_24979 = state_24860__$1;
(statearr_24904_24979[(1)] = (29));

} else {
var statearr_24905_24980 = state_24860__$1;
(statearr_24905_24980[(1)] = (30));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (25))){
var inst_24778 = (state_24860[(24)]);
var inst_24794 = (state_24860[(2)]);
var inst_24795 = cljs.core.not_empty.call(null,inst_24778);
var state_24860__$1 = (function (){var statearr_24906 = state_24860;
(statearr_24906[(30)] = inst_24794);

return statearr_24906;
})();
if(cljs.core.truth_(inst_24795)){
var statearr_24907_24981 = state_24860__$1;
(statearr_24907_24981[(1)] = (26));

} else {
var statearr_24908_24982 = state_24860__$1;
(statearr_24908_24982[(1)] = (27));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (34))){
var inst_24829 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
if(cljs.core.truth_(inst_24829)){
var statearr_24909_24983 = state_24860__$1;
(statearr_24909_24983[(1)] = (38));

} else {
var statearr_24910_24984 = state_24860__$1;
(statearr_24910_24984[(1)] = (39));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (17))){
var state_24860__$1 = state_24860;
var statearr_24911_24985 = state_24860__$1;
(statearr_24911_24985[(2)] = recompile_dependents);

(statearr_24911_24985[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (3))){
var state_24860__$1 = state_24860;
var statearr_24912_24986 = state_24860__$1;
(statearr_24912_24986[(2)] = null);

(statearr_24912_24986[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (12))){
var inst_24751 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
var statearr_24913_24987 = state_24860__$1;
(statearr_24913_24987[(2)] = inst_24751);

(statearr_24913_24987[(1)] = (9));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (2))){
var inst_24713 = (state_24860[(13)]);
var inst_24720 = cljs.core.seq.call(null,inst_24713);
var inst_24721 = inst_24720;
var inst_24722 = null;
var inst_24723 = (0);
var inst_24724 = (0);
var state_24860__$1 = (function (){var statearr_24914 = state_24860;
(statearr_24914[(7)] = inst_24724);

(statearr_24914[(8)] = inst_24722);

(statearr_24914[(9)] = inst_24721);

(statearr_24914[(10)] = inst_24723);

return statearr_24914;
})();
var statearr_24915_24988 = state_24860__$1;
(statearr_24915_24988[(2)] = null);

(statearr_24915_24988[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (23))){
var inst_24782 = (state_24860[(23)]);
var inst_24778 = (state_24860[(24)]);
var inst_24780 = (state_24860[(26)]);
var inst_24777 = (state_24860[(25)]);
var inst_24774 = (state_24860[(19)]);
var inst_24785 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded these dependencies");
var inst_24787 = (function (){var all_files = inst_24774;
var res_SINGLEQUOTE_ = inst_24777;
var res = inst_24778;
var files_not_loaded = inst_24780;
var dependencies_that_loaded = inst_24782;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24778,inst_24780,inst_24777,inst_24774,inst_24785,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24786){
var map__24916 = p__24786;
var map__24916__$1 = ((((!((map__24916 == null)))?((((map__24916.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24916.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24916):map__24916);
var request_url = cljs.core.get.call(null,map__24916__$1,new cljs.core.Keyword(null,"request-url","request-url",2100346596));
return clojure.string.replace.call(null,request_url,goog.basePath,"");
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24778,inst_24780,inst_24777,inst_24774,inst_24785,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24788 = cljs.core.reverse.call(null,inst_24782);
var inst_24789 = cljs.core.map.call(null,inst_24787,inst_24788);
var inst_24790 = cljs.core.pr_str.call(null,inst_24789);
var inst_24791 = figwheel.client.utils.log.call(null,inst_24790);
var state_24860__$1 = (function (){var statearr_24918 = state_24860;
(statearr_24918[(31)] = inst_24785);

return statearr_24918;
})();
var statearr_24919_24989 = state_24860__$1;
(statearr_24919_24989[(2)] = inst_24791);

(statearr_24919_24989[(1)] = (25));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (35))){
var state_24860__$1 = state_24860;
var statearr_24920_24990 = state_24860__$1;
(statearr_24920_24990[(2)] = true);

(statearr_24920_24990[(1)] = (37));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (19))){
var inst_24764 = (state_24860[(12)]);
var inst_24770 = figwheel.client.file_reloading.expand_files.call(null,inst_24764);
var state_24860__$1 = state_24860;
var statearr_24921_24991 = state_24860__$1;
(statearr_24921_24991[(2)] = inst_24770);

(statearr_24921_24991[(1)] = (21));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (11))){
var state_24860__$1 = state_24860;
var statearr_24922_24992 = state_24860__$1;
(statearr_24922_24992[(2)] = null);

(statearr_24922_24992[(1)] = (12));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (9))){
var inst_24753 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
var statearr_24923_24993 = state_24860__$1;
(statearr_24923_24993[(2)] = inst_24753);

(statearr_24923_24993[(1)] = (6));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (5))){
var inst_24724 = (state_24860[(7)]);
var inst_24723 = (state_24860[(10)]);
var inst_24726 = (inst_24724 < inst_24723);
var inst_24727 = inst_24726;
var state_24860__$1 = state_24860;
if(cljs.core.truth_(inst_24727)){
var statearr_24924_24994 = state_24860__$1;
(statearr_24924_24994[(1)] = (7));

} else {
var statearr_24925_24995 = state_24860__$1;
(statearr_24925_24995[(1)] = (8));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (14))){
var inst_24734 = (state_24860[(22)]);
var inst_24743 = cljs.core.first.call(null,inst_24734);
var inst_24744 = figwheel.client.file_reloading.eval_body.call(null,inst_24743,opts);
var inst_24745 = cljs.core.next.call(null,inst_24734);
var inst_24721 = inst_24745;
var inst_24722 = null;
var inst_24723 = (0);
var inst_24724 = (0);
var state_24860__$1 = (function (){var statearr_24926 = state_24860;
(statearr_24926[(7)] = inst_24724);

(statearr_24926[(8)] = inst_24722);

(statearr_24926[(32)] = inst_24744);

(statearr_24926[(9)] = inst_24721);

(statearr_24926[(10)] = inst_24723);

return statearr_24926;
})();
var statearr_24927_24996 = state_24860__$1;
(statearr_24927_24996[(2)] = null);

(statearr_24927_24996[(1)] = (5));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (45))){
var state_24860__$1 = state_24860;
var statearr_24928_24997 = state_24860__$1;
(statearr_24928_24997[(2)] = null);

(statearr_24928_24997[(1)] = (46));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (26))){
var inst_24782 = (state_24860[(23)]);
var inst_24778 = (state_24860[(24)]);
var inst_24780 = (state_24860[(26)]);
var inst_24777 = (state_24860[(25)]);
var inst_24774 = (state_24860[(19)]);
var inst_24797 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded these files");
var inst_24799 = (function (){var all_files = inst_24774;
var res_SINGLEQUOTE_ = inst_24777;
var res = inst_24778;
var files_not_loaded = inst_24780;
var dependencies_that_loaded = inst_24782;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24778,inst_24780,inst_24777,inst_24774,inst_24797,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (p__24798){
var map__24929 = p__24798;
var map__24929__$1 = ((((!((map__24929 == null)))?((((map__24929.cljs$lang$protocol_mask$partition0$ & (64))) || (map__24929.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__24929):map__24929);
var namespace = cljs.core.get.call(null,map__24929__$1,new cljs.core.Keyword(null,"namespace","namespace",-377510372));
var file = cljs.core.get.call(null,map__24929__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
if(cljs.core.truth_(namespace)){
return figwheel.client.file_reloading.name__GT_path.call(null,cljs.core.name.call(null,namespace));
} else {
return file;
}
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24778,inst_24780,inst_24777,inst_24774,inst_24797,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24800 = cljs.core.map.call(null,inst_24799,inst_24778);
var inst_24801 = cljs.core.pr_str.call(null,inst_24800);
var inst_24802 = figwheel.client.utils.log.call(null,inst_24801);
var inst_24803 = (function (){var all_files = inst_24774;
var res_SINGLEQUOTE_ = inst_24777;
var res = inst_24778;
var files_not_loaded = inst_24780;
var dependencies_that_loaded = inst_24782;
return ((function (all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24778,inst_24780,inst_24777,inst_24774,inst_24797,inst_24799,inst_24800,inst_24801,inst_24802,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function (){
figwheel.client.file_reloading.on_jsload_custom_event.call(null,res);

return cljs.core.apply.call(null,on_jsload,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [res], null));
});
;})(all_files,res_SINGLEQUOTE_,res,files_not_loaded,dependencies_that_loaded,inst_24782,inst_24778,inst_24780,inst_24777,inst_24774,inst_24797,inst_24799,inst_24800,inst_24801,inst_24802,state_val_24861,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var inst_24804 = setTimeout(inst_24803,(10));
var state_24860__$1 = (function (){var statearr_24931 = state_24860;
(statearr_24931[(33)] = inst_24797);

(statearr_24931[(34)] = inst_24802);

return statearr_24931;
})();
var statearr_24932_24998 = state_24860__$1;
(statearr_24932_24998[(2)] = inst_24804);

(statearr_24932_24998[(1)] = (28));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (16))){
var state_24860__$1 = state_24860;
var statearr_24933_24999 = state_24860__$1;
(statearr_24933_24999[(2)] = reload_dependents);

(statearr_24933_24999[(1)] = (18));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (38))){
var inst_24814 = (state_24860[(16)]);
var inst_24831 = cljs.core.apply.call(null,cljs.core.hash_map,inst_24814);
var state_24860__$1 = state_24860;
var statearr_24934_25000 = state_24860__$1;
(statearr_24934_25000[(2)] = inst_24831);

(statearr_24934_25000[(1)] = (40));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (30))){
var state_24860__$1 = state_24860;
var statearr_24935_25001 = state_24860__$1;
(statearr_24935_25001[(2)] = null);

(statearr_24935_25001[(1)] = (31));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (10))){
var inst_24734 = (state_24860[(22)]);
var inst_24736 = cljs.core.chunked_seq_QMARK_.call(null,inst_24734);
var state_24860__$1 = state_24860;
if(inst_24736){
var statearr_24936_25002 = state_24860__$1;
(statearr_24936_25002[(1)] = (13));

} else {
var statearr_24937_25003 = state_24860__$1;
(statearr_24937_25003[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (18))){
var inst_24768 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
if(cljs.core.truth_(inst_24768)){
var statearr_24938_25004 = state_24860__$1;
(statearr_24938_25004[(1)] = (19));

} else {
var statearr_24939_25005 = state_24860__$1;
(statearr_24939_25005[(1)] = (20));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (42))){
var state_24860__$1 = state_24860;
var statearr_24940_25006 = state_24860__$1;
(statearr_24940_25006[(2)] = null);

(statearr_24940_25006[(1)] = (43));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (37))){
var inst_24826 = (state_24860[(2)]);
var state_24860__$1 = state_24860;
var statearr_24941_25007 = state_24860__$1;
(statearr_24941_25007[(2)] = inst_24826);

(statearr_24941_25007[(1)] = (34));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_24861 === (8))){
var inst_24734 = (state_24860[(22)]);
var inst_24721 = (state_24860[(9)]);
var inst_24734__$1 = cljs.core.seq.call(null,inst_24721);
var state_24860__$1 = (function (){var statearr_24942 = state_24860;
(statearr_24942[(22)] = inst_24734__$1);

return statearr_24942;
})();
if(inst_24734__$1){
var statearr_24943_25008 = state_24860__$1;
(statearr_24943_25008[(1)] = (10));

} else {
var statearr_24944_25009 = state_24860__$1;
(statearr_24944_25009[(1)] = (11));

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
});})(c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
;
return ((function (switch__21060__auto__,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents){
return (function() {
var figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto__ = null;
var figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto____0 = (function (){
var statearr_24948 = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_24948[(0)] = figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto__);

(statearr_24948[(1)] = (1));

return statearr_24948;
});
var figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto____1 = (function (state_24860){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_24860);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e24949){if((e24949 instanceof Object)){
var ex__21064__auto__ = e24949;
var statearr_24950_25010 = state_24860;
(statearr_24950_25010[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_24860);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e24949;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25011 = state_24860;
state_24860 = G__25011;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto__ = function(state_24860){
switch(arguments.length){
case 0:
return figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto____1.call(this,state_24860);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto____0;
figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto____1;
return figwheel$client$file_reloading$reload_js_files_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
})();
var state__21174__auto__ = (function (){var statearr_24951 = f__21173__auto__.call(null);
(statearr_24951[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_24951;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__,map__24706,map__24706__$1,opts,before_jsload,on_jsload,reload_dependents,map__24707,map__24707__$1,msg,files,figwheel_meta,recompile_dependents))
);

return c__21172__auto__;
});
figwheel.client.file_reloading.current_links = (function figwheel$client$file_reloading$current_links(){
return Array.prototype.slice.call(document.getElementsByTagName("link"));
});
figwheel.client.file_reloading.truncate_url = (function figwheel$client$file_reloading$truncate_url(url){
return clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,clojure.string.replace_first.call(null,cljs.core.first.call(null,clojure.string.split.call(null,url,/\?/)),[cljs.core.str(location.protocol),cljs.core.str("//")].join(''),""),".*://",""),/^\/\//,""),/[^\\/]*/,"");
});
figwheel.client.file_reloading.matches_file_QMARK_ = (function figwheel$client$file_reloading$matches_file_QMARK_(p__25014,link){
var map__25017 = p__25014;
var map__25017__$1 = ((((!((map__25017 == null)))?((((map__25017.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25017.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25017):map__25017);
var file = cljs.core.get.call(null,map__25017__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
var temp__4657__auto__ = link.href;
if(cljs.core.truth_(temp__4657__auto__)){
var link_href = temp__4657__auto__;
var match = clojure.string.join.call(null,"/",cljs.core.take_while.call(null,cljs.core.identity,cljs.core.map.call(null,((function (link_href,temp__4657__auto__,map__25017,map__25017__$1,file){
return (function (p1__25012_SHARP_,p2__25013_SHARP_){
if(cljs.core._EQ_.call(null,p1__25012_SHARP_,p2__25013_SHARP_)){
return p1__25012_SHARP_;
} else {
return false;
}
});})(link_href,temp__4657__auto__,map__25017,map__25017__$1,file))
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
var temp__4657__auto__ = cljs.core.first.call(null,cljs.core.sort_by.call(null,(function (p__25023){
var map__25024 = p__25023;
var map__25024__$1 = ((((!((map__25024 == null)))?((((map__25024.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25024.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25024):map__25024);
var match_length = cljs.core.get.call(null,map__25024__$1,new cljs.core.Keyword(null,"match-length","match-length",1101537310));
var current_url_length = cljs.core.get.call(null,map__25024__$1,new cljs.core.Keyword(null,"current-url-length","current-url-length",380404083));
return (current_url_length - match_length);
}),cljs.core.keep.call(null,(function (p1__25019_SHARP_){
return figwheel.client.file_reloading.matches_file_QMARK_.call(null,f_data,p1__25019_SHARP_);
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
var args25026 = [];
var len__19428__auto___25029 = arguments.length;
var i__19429__auto___25030 = (0);
while(true){
if((i__19429__auto___25030 < len__19428__auto___25029)){
args25026.push((arguments[i__19429__auto___25030]));

var G__25031 = (i__19429__auto___25030 + (1));
i__19429__auto___25030 = G__25031;
continue;
} else {
}
break;
}

var G__25028 = args25026.length;
switch (G__25028) {
case 1:
return figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return figwheel.client.file_reloading.add_link_to_doc.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args25026.length)].join('')));

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
return cljs.core.vals.call(null,cljs.core.reduce.call(null,(function (p1__25033_SHARP_,p2__25034_SHARP_){
return cljs.core.assoc.call(null,p1__25033_SHARP_,cljs.core.get.call(null,p2__25034_SHARP_,key),p2__25034_SHARP_);
}),cljs.core.PersistentArrayMap.EMPTY,seqq));
});
figwheel.client.file_reloading.reload_css_file = (function figwheel$client$file_reloading$reload_css_file(p__25035){
var map__25038 = p__25035;
var map__25038__$1 = ((((!((map__25038 == null)))?((((map__25038.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25038.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25038):map__25038);
var f_data = map__25038__$1;
var file = cljs.core.get.call(null,map__25038__$1,new cljs.core.Keyword(null,"file","file",-1269645878));
var temp__4657__auto__ = figwheel.client.file_reloading.get_correct_link.call(null,f_data);
if(cljs.core.truth_(temp__4657__auto__)){
var link = temp__4657__auto__;
return figwheel.client.file_reloading.add_link_to_doc.call(null,link,figwheel.client.file_reloading.clone_link.call(null,link,link.href));
} else {
return null;
}
});
figwheel.client.file_reloading.reload_css_files = (function figwheel$client$file_reloading$reload_css_files(p__25040,files_msg){
var map__25047 = p__25040;
var map__25047__$1 = ((((!((map__25047 == null)))?((((map__25047.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25047.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25047):map__25047);
var opts = map__25047__$1;
var on_cssload = cljs.core.get.call(null,map__25047__$1,new cljs.core.Keyword(null,"on-cssload","on-cssload",1825432318));
if(cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))){
var seq__25049_25053 = cljs.core.seq.call(null,figwheel.client.file_reloading.distictify.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(files_msg)));
var chunk__25050_25054 = null;
var count__25051_25055 = (0);
var i__25052_25056 = (0);
while(true){
if((i__25052_25056 < count__25051_25055)){
var f_25057 = cljs.core._nth.call(null,chunk__25050_25054,i__25052_25056);
figwheel.client.file_reloading.reload_css_file.call(null,f_25057);

var G__25058 = seq__25049_25053;
var G__25059 = chunk__25050_25054;
var G__25060 = count__25051_25055;
var G__25061 = (i__25052_25056 + (1));
seq__25049_25053 = G__25058;
chunk__25050_25054 = G__25059;
count__25051_25055 = G__25060;
i__25052_25056 = G__25061;
continue;
} else {
var temp__4657__auto___25062 = cljs.core.seq.call(null,seq__25049_25053);
if(temp__4657__auto___25062){
var seq__25049_25063__$1 = temp__4657__auto___25062;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__25049_25063__$1)){
var c__19173__auto___25064 = cljs.core.chunk_first.call(null,seq__25049_25063__$1);
var G__25065 = cljs.core.chunk_rest.call(null,seq__25049_25063__$1);
var G__25066 = c__19173__auto___25064;
var G__25067 = cljs.core.count.call(null,c__19173__auto___25064);
var G__25068 = (0);
seq__25049_25053 = G__25065;
chunk__25050_25054 = G__25066;
count__25051_25055 = G__25067;
i__25052_25056 = G__25068;
continue;
} else {
var f_25069 = cljs.core.first.call(null,seq__25049_25063__$1);
figwheel.client.file_reloading.reload_css_file.call(null,f_25069);

var G__25070 = cljs.core.next.call(null,seq__25049_25063__$1);
var G__25071 = null;
var G__25072 = (0);
var G__25073 = (0);
seq__25049_25053 = G__25070;
chunk__25050_25054 = G__25071;
count__25051_25055 = G__25072;
i__25052_25056 = G__25073;
continue;
}
} else {
}
}
break;
}

return setTimeout(((function (map__25047,map__25047__$1,opts,on_cssload){
return (function (){
return on_cssload.call(null,new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(files_msg));
});})(map__25047,map__25047__$1,opts,on_cssload))
,(100));
} else {
return null;
}
});

//# sourceMappingURL=file_reloading.js.map