// Compiled by ClojureScript 1.7.228 {}
goog.provide('reagent.impl.component');
goog.require('cljs.core');
goog.require('reagent.impl.util');
goog.require('reagent.impl.batching');
goog.require('reagent.ratom');
goog.require('reagent.interop');
goog.require('reagent.debug');
reagent.impl.component.state_atom = (function reagent$impl$component$state_atom(this$){
var sa = (this$["cljsState"]);
if(!((sa == null))){
return sa;
} else {
return (this$["cljsState"] = reagent.ratom.atom.call(null,null));
}
});
reagent.impl.component.as_element = (function reagent$impl$component$as_element(x){
return reagent.impl.template.as_element(x);
});
reagent.impl.component.reagent_class_QMARK_ = (function reagent$impl$component$reagent_class_QMARK_(c){
return (cljs.core.fn_QMARK_.call(null,c)) && (cljs.core.some_QMARK_.call(null,(c["cljsReactClass"])));
});
reagent.impl.component.do_render_sub = (function reagent$impl$component$do_render_sub(c){
while(true){
var f = (c["cljsRender"]);
var _ = ((cljs.core.ifn_QMARK_.call(null,f))?null:(function(){throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.call(null,cljs.core.list(new cljs.core.Symbol(null,"ifn?","ifn?",-2106461064,null),new cljs.core.Symbol(null,"f","f",43394975,null))))].join('')))})());
var p = (c["props"]);
var res = ((((c["reagentRender"]) == null))?f.call(null,c):(function (){var argv = (p["argv"]);
var n = cljs.core.count.call(null,argv);
var G__19856 = n;
switch (G__19856) {
case (1):
return f.call(null);

break;
case (2):
return f.call(null,cljs.core.nth.call(null,argv,(1)));

break;
case (3):
return f.call(null,cljs.core.nth.call(null,argv,(1)),cljs.core.nth.call(null,argv,(2)));

break;
case (4):
return f.call(null,cljs.core.nth.call(null,argv,(1)),cljs.core.nth.call(null,argv,(2)),cljs.core.nth.call(null,argv,(3)));

break;
case (5):
return f.call(null,cljs.core.nth.call(null,argv,(1)),cljs.core.nth.call(null,argv,(2)),cljs.core.nth.call(null,argv,(3)),cljs.core.nth.call(null,argv,(4)));

break;
default:
return cljs.core.apply.call(null,f,cljs.core.subvec.call(null,argv,(1)));

}
})());
if(cljs.core.vector_QMARK_.call(null,res)){
return reagent.impl.component.as_element.call(null,res);
} else {
if(cljs.core.ifn_QMARK_.call(null,res)){
var f__$1 = (cljs.core.truth_(reagent.impl.component.reagent_class_QMARK_.call(null,res))?((function (c,f,_,p,res){
return (function() { 
var G__19858__delegate = function (args){
return reagent.impl.component.as_element.call(null,cljs.core.apply.call(null,cljs.core.vector,res,args));
};
var G__19858 = function (var_args){
var args = null;
if (arguments.length > 0) {
var G__19859__i = 0, G__19859__a = new Array(arguments.length -  0);
while (G__19859__i < G__19859__a.length) {G__19859__a[G__19859__i] = arguments[G__19859__i + 0]; ++G__19859__i;}
  args = new cljs.core.IndexedSeq(G__19859__a,0);
} 
return G__19858__delegate.call(this,args);};
G__19858.cljs$lang$maxFixedArity = 0;
G__19858.cljs$lang$applyTo = (function (arglist__19860){
var args = cljs.core.seq(arglist__19860);
return G__19858__delegate(args);
});
G__19858.cljs$core$IFn$_invoke$arity$variadic = G__19858__delegate;
return G__19858;
})()
;})(c,f,_,p,res))
:res);
(c["cljsRender"] = f__$1);

var G__19861 = c;
c = G__19861;
continue;
} else {
return res;
}
}
break;
}
});
reagent.impl.component.do_render = (function reagent$impl$component$do_render(c){
var _STAR_current_component_STAR_19863 = reagent.impl.component._STAR_current_component_STAR_;
reagent.impl.component._STAR_current_component_STAR_ = c;

try{var ok = [false];
try{var res = reagent.impl.component.do_render_sub.call(null,c);
(ok[(0)] = true);

return res;
}finally {if(cljs.core.truth_((ok[(0)]))){
} else {
console.error([cljs.core.str("Error rendering component "),cljs.core.str(reagent.impl.component.comp_name.call(null))].join(''));
}
}
}finally {reagent.impl.component._STAR_current_component_STAR_ = _STAR_current_component_STAR_19863;
}});
reagent.impl.component.static_fns = new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"render","render",-1408033454),(function (){
var c = this;
if(cljs.core.not.call(null,reagent.impl.component._STAR_non_reactive_STAR_)){
return reagent.impl.batching.run_reactively.call(null,c,((function (c){
return (function (){
return reagent.impl.component.do_render.call(null,c);
});})(c))
);
} else {
return reagent.impl.component.do_render.call(null,c);
}
})], null);
reagent.impl.component.custom_wrapper = (function reagent$impl$component$custom_wrapper(key,f){
var G__19865 = (((key instanceof cljs.core.Keyword))?key.fqn:null);
switch (G__19865) {
case "getDefaultProps":
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str("getDefaultProps not supported yet"),cljs.core.str("\n"),cljs.core.str(cljs.core.pr_str.call(null,false))].join('')));


break;
case "getInitialState":
return ((function (G__19865){
return (function (){
var c = this;
return cljs.core.reset_BANG_.call(null,reagent.impl.component.state_atom.call(null,c),f.call(null,c));
});
;})(G__19865))

break;
case "componentWillReceiveProps":
return ((function (G__19865){
return (function (props){
var c = this;
return f.call(null,c,(props["argv"]));
});
;})(G__19865))

break;
case "shouldComponentUpdate":
return ((function (G__19865){
return (function (nextprops,nextstate){
var or__18370__auto__ = reagent.impl.util._STAR_always_update_STAR_;
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
var c = this;
var old_argv = (c["props"]["argv"]);
var new_argv = (nextprops["argv"]);
if((f == null)){
return ((old_argv == null)) || ((new_argv == null)) || (cljs.core.not_EQ_.call(null,old_argv,new_argv));
} else {
return f.call(null,c,old_argv,new_argv);
}
}
});
;})(G__19865))

break;
case "componentWillUpdate":
return ((function (G__19865){
return (function (nextprops){
var c = this;
return f.call(null,c,(nextprops["argv"]));
});
;})(G__19865))

break;
case "componentDidUpdate":
return ((function (G__19865){
return (function (oldprops){
var c = this;
return f.call(null,c,(oldprops["argv"]));
});
;})(G__19865))

break;
case "componentWillMount":
return ((function (G__19865){
return (function (){
var c = this;
(c["cljsMountOrder"] = reagent.impl.batching.next_mount_count.call(null));

if((f == null)){
return null;
} else {
return f.call(null,c);
}
});
;})(G__19865))

break;
case "componentWillUnmount":
return ((function (G__19865){
return (function (){
var c = this;
reagent.impl.batching.dispose.call(null,c);

if((f == null)){
return null;
} else {
return f.call(null,c);
}
});
;})(G__19865))

break;
default:
return null;

}
});
reagent.impl.component.default_wrapper = (function reagent$impl$component$default_wrapper(f){
if(cljs.core.ifn_QMARK_.call(null,f)){
return (function() { 
var G__19867__delegate = function (args){
var c = this;
return cljs.core.apply.call(null,f,c,args);
};
var G__19867 = function (var_args){
var args = null;
if (arguments.length > 0) {
var G__19868__i = 0, G__19868__a = new Array(arguments.length -  0);
while (G__19868__i < G__19868__a.length) {G__19868__a[G__19868__i] = arguments[G__19868__i + 0]; ++G__19868__i;}
  args = new cljs.core.IndexedSeq(G__19868__a,0);
} 
return G__19867__delegate.call(this,args);};
G__19867.cljs$lang$maxFixedArity = 0;
G__19867.cljs$lang$applyTo = (function (arglist__19869){
var args = cljs.core.seq(arglist__19869);
return G__19867__delegate(args);
});
G__19867.cljs$core$IFn$_invoke$arity$variadic = G__19867__delegate;
return G__19867;
})()
;
} else {
return f;
}
});
reagent.impl.component.dont_wrap = new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 4, [new cljs.core.Keyword(null,"cljsRender","cljsRender",247449928),null,new cljs.core.Keyword(null,"reagentRender","reagentRender",-358306383),null,new cljs.core.Keyword(null,"render","render",-1408033454),null,new cljs.core.Keyword(null,"cljsName","cljsName",999824949),null], null), null);
reagent.impl.component.dont_bind = (function reagent$impl$component$dont_bind(f){
if(cljs.core.fn_QMARK_.call(null,f)){
var G__19871 = f;
(G__19871["__reactDontBind"] = true);

return G__19871;
} else {
return f;
}
});
reagent.impl.component.get_wrapper = (function reagent$impl$component$get_wrapper(key,f,name){
if(cljs.core.truth_(reagent.impl.component.dont_wrap.call(null,key))){
return reagent.impl.component.dont_bind.call(null,f);
} else {
var wrap = reagent.impl.component.custom_wrapper.call(null,key,f);
if(cljs.core.truth_((function (){var and__18358__auto__ = wrap;
if(cljs.core.truth_(and__18358__auto__)){
return f;
} else {
return and__18358__auto__;
}
})())){
if(cljs.core.ifn_QMARK_.call(null,f)){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str([cljs.core.str("Expected function in "),cljs.core.str(name),cljs.core.str(key),cljs.core.str(" but got "),cljs.core.str(f)].join('')),cljs.core.str("\n"),cljs.core.str(cljs.core.pr_str.call(null,cljs.core.list(new cljs.core.Symbol(null,"ifn?","ifn?",-2106461064,null),new cljs.core.Symbol(null,"f","f",43394975,null))))].join('')));
}
} else {
}

var or__18370__auto__ = wrap;
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return reagent.impl.component.default_wrapper.call(null,f);
}
}
});
reagent.impl.component.obligatory = new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"shouldComponentUpdate","shouldComponentUpdate",1795750960),null,new cljs.core.Keyword(null,"componentWillMount","componentWillMount",-285327619),null,new cljs.core.Keyword(null,"componentWillUnmount","componentWillUnmount",1573788814),null], null);
reagent.impl.component.dash_to_camel = reagent.impl.util.memoize_1.call(null,reagent.impl.util.dash_to_camel);
reagent.impl.component.camelify_map_keys = (function reagent$impl$component$camelify_map_keys(fun_map){
return cljs.core.reduce_kv.call(null,(function (m,k,v){
return cljs.core.assoc.call(null,m,cljs.core.keyword.call(null,reagent.impl.component.dash_to_camel.call(null,k)),v);
}),cljs.core.PersistentArrayMap.EMPTY,fun_map);
});
reagent.impl.component.add_obligatory = (function reagent$impl$component$add_obligatory(fun_map){
return cljs.core.merge.call(null,reagent.impl.component.obligatory,fun_map);
});
reagent.impl.component.add_render = (function reagent$impl$component$add_render(fun_map,render_f,name){
var fm = cljs.core.assoc.call(null,fun_map,new cljs.core.Keyword(null,"cljsRender","cljsRender",247449928),render_f,new cljs.core.Keyword(null,"render","render",-1408033454),new cljs.core.Keyword(null,"render","render",-1408033454).cljs$core$IFn$_invoke$arity$1(reagent.impl.component.static_fns));
return cljs.core.assoc.call(null,fm,new cljs.core.Keyword(null,"cljsName","cljsName",999824949),((function (fm){
return (function (){
return name;
});})(fm))
);

});
reagent.impl.component.fun_name = (function reagent$impl$component$fun_name(f){
var or__18370__auto__ = (function (){var and__18358__auto__ = cljs.core.fn_QMARK_.call(null,f);
if(and__18358__auto__){
var or__18370__auto__ = (f["displayName"]);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return (f["name"]);
}
} else {
return and__18358__auto__;
}
})();
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
var or__18370__auto____$1 = (function (){var and__18358__auto__ = ((!((f == null)))?((((f.cljs$lang$protocol_mask$partition1$ & (4096))) || (f.cljs$core$INamed$))?true:false):false);
if(and__18358__auto__){
return cljs.core.name.call(null,f);
} else {
return and__18358__auto__;
}
})();
if(cljs.core.truth_(or__18370__auto____$1)){
return or__18370__auto____$1;
} else {
var m = cljs.core.meta.call(null,f);
if(cljs.core.map_QMARK_.call(null,m)){
return new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(m);
} else {
return null;
}
}
}
});
reagent.impl.component.wrap_funs = (function reagent$impl$component$wrap_funs(fmap){
var fun_map = (function (){var temp__4659__auto__ = new cljs.core.Keyword(null,"componentFunction","componentFunction",825866104).cljs$core$IFn$_invoke$arity$1(fmap);
if((temp__4659__auto__ == null)){
return fmap;
} else {
var cf = temp__4659__auto__;
return cljs.core.dissoc.call(null,cljs.core.assoc.call(null,fmap,new cljs.core.Keyword(null,"reagentRender","reagentRender",-358306383),cf),new cljs.core.Keyword(null,"componentFunction","componentFunction",825866104));
}
})();
var render_fun = (function (){var or__18370__auto__ = new cljs.core.Keyword(null,"reagentRender","reagentRender",-358306383).cljs$core$IFn$_invoke$arity$1(fun_map);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return new cljs.core.Keyword(null,"render","render",-1408033454).cljs$core$IFn$_invoke$arity$1(fun_map);
}
})();
var _ = ((cljs.core.ifn_QMARK_.call(null,render_fun))?null:(function(){throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str([cljs.core.str("Render must be a function, not "),cljs.core.str(cljs.core.pr_str.call(null,render_fun))].join('')),cljs.core.str("\n"),cljs.core.str(cljs.core.pr_str.call(null,cljs.core.list(new cljs.core.Symbol(null,"ifn?","ifn?",-2106461064,null),new cljs.core.Symbol(null,"render-fun","render-fun",-1209513086,null))))].join('')))})());
var name = [cljs.core.str((function (){var or__18370__auto__ = new cljs.core.Keyword(null,"displayName","displayName",-809144601).cljs$core$IFn$_invoke$arity$1(fun_map);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return reagent.impl.component.fun_name.call(null,render_fun);
}
})())].join('');
var name_SINGLEQUOTE_ = ((cljs.core.empty_QMARK_.call(null,name))?[cljs.core.str(cljs.core.gensym.call(null,"reagent"))].join(''):clojure.string.replace.call(null,name,/\$/,"."));
var fmap__$1 = reagent.impl.component.add_render.call(null,cljs.core.assoc.call(null,fun_map,new cljs.core.Keyword(null,"displayName","displayName",-809144601),name_SINGLEQUOTE_),render_fun,name_SINGLEQUOTE_);
return cljs.core.reduce_kv.call(null,((function (fun_map,render_fun,_,name,name_SINGLEQUOTE_,fmap__$1){
return (function (m,k,v){
return cljs.core.assoc.call(null,m,k,reagent.impl.component.get_wrapper.call(null,k,v,name_SINGLEQUOTE_));
});})(fun_map,render_fun,_,name,name_SINGLEQUOTE_,fmap__$1))
,cljs.core.PersistentArrayMap.EMPTY,fmap__$1);
});
reagent.impl.component.map_to_js = (function reagent$impl$component$map_to_js(m){
return cljs.core.reduce_kv.call(null,(function (o,k,v){
var G__19881 = o;
(G__19881[cljs.core.name.call(null,k)] = v);

return G__19881;
}),{},m);
});
reagent.impl.component.cljsify = (function reagent$impl$component$cljsify(body){
return reagent.impl.component.map_to_js.call(null,reagent.impl.component.wrap_funs.call(null,reagent.impl.component.add_obligatory.call(null,reagent.impl.component.camelify_map_keys.call(null,body))));
});
reagent.impl.component.create_class = (function reagent$impl$component$create_class(body){
if(cljs.core.map_QMARK_.call(null,body)){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.call(null,cljs.core.list(new cljs.core.Symbol(null,"map?","map?",-1780568534,null),new cljs.core.Symbol(null,"body","body",-408674142,null))))].join('')));
}

var spec = reagent.impl.component.cljsify.call(null,body);
var res = (React["createClass"])(spec);
var f = ((function (spec,res){
return (function() { 
var G__19882__delegate = function (args){
if(typeof console !== 'undefined'){
console.warn([cljs.core.str("Warning: "),cljs.core.str("Calling the result of create-class as a function is "),cljs.core.str("deprecated in "),cljs.core.str((res["displayName"])),cljs.core.str(". Use a vector "),cljs.core.str("instead.")].join(''));
} else {
}

return reagent.impl.component.as_element.call(null,cljs.core.apply.call(null,cljs.core.vector,res,args));
};
var G__19882 = function (var_args){
var args = null;
if (arguments.length > 0) {
var G__19883__i = 0, G__19883__a = new Array(arguments.length -  0);
while (G__19883__i < G__19883__a.length) {G__19883__a[G__19883__i] = arguments[G__19883__i + 0]; ++G__19883__i;}
  args = new cljs.core.IndexedSeq(G__19883__a,0);
} 
return G__19882__delegate.call(this,args);};
G__19882.cljs$lang$maxFixedArity = 0;
G__19882.cljs$lang$applyTo = (function (arglist__19884){
var args = cljs.core.seq(arglist__19884);
return G__19882__delegate(args);
});
G__19882.cljs$core$IFn$_invoke$arity$variadic = G__19882__delegate;
return G__19882;
})()
;})(spec,res))
;
reagent.impl.util.cache_react_class.call(null,f,res);

reagent.impl.util.cache_react_class.call(null,res,res);

return f;
});
reagent.impl.component.component_path = (function reagent$impl$component$component_path(c){
var elem = (function (){var G__19890 = (function (){var or__18370__auto__ = (function (){var G__19892 = c;
if((G__19892 == null)){
return null;
} else {
return (G__19892["_reactInternalInstance"]);
}
})();
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return c;
}
})();
if((G__19890 == null)){
return null;
} else {
return (G__19890["_currentElement"]);
}
})();
var name = (function (){var G__19893 = elem;
var G__19893__$1 = (((G__19893 == null))?null:(G__19893["type"]));
if((G__19893__$1 == null)){
return null;
} else {
return (G__19893__$1["displayName"]);
}
})();
var path = (function (){var G__19894 = elem;
var G__19894__$1 = (((G__19894 == null))?null:(G__19894["_owner"]));
var G__19894__$2 = (((G__19894__$1 == null))?null:reagent$impl$component$component_path.call(null,G__19894__$1));
if((G__19894__$2 == null)){
return null;
} else {
return [cljs.core.str(G__19894__$2),cljs.core.str(" > ")].join('');
}
})();
var res = [cljs.core.str(path),cljs.core.str(name)].join('');
if(cljs.core.empty_QMARK_.call(null,res)){
return null;
} else {
return res;
}
});
reagent.impl.component.comp_name = (function reagent$impl$component$comp_name(){
var c = reagent.impl.component._STAR_current_component_STAR_;
var n = (function (){var or__18370__auto__ = reagent.impl.component.component_path.call(null,c);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
var G__19896 = c;
if((G__19896 == null)){
return null;
} else {
return (G__19896["cljsName"])();
}
}
})();
if(!(cljs.core.empty_QMARK_.call(null,n))){
return [cljs.core.str(" (in "),cljs.core.str(n),cljs.core.str(")")].join('');
} else {
return "";
}

});
reagent.impl.component.shallow_obj_to_map = (function reagent$impl$component$shallow_obj_to_map(o){
return cljs.core.into.call(null,cljs.core.PersistentArrayMap.EMPTY,(function (){var iter__19142__auto__ = (function reagent$impl$component$shallow_obj_to_map_$_iter__19901(s__19902){
return (new cljs.core.LazySeq(null,(function (){
var s__19902__$1 = s__19902;
while(true){
var temp__4657__auto__ = cljs.core.seq.call(null,s__19902__$1);
if(temp__4657__auto__){
var s__19902__$2 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,s__19902__$2)){
var c__19140__auto__ = cljs.core.chunk_first.call(null,s__19902__$2);
var size__19141__auto__ = cljs.core.count.call(null,c__19140__auto__);
var b__19904 = cljs.core.chunk_buffer.call(null,size__19141__auto__);
if((function (){var i__19903 = (0);
while(true){
if((i__19903 < size__19141__auto__)){
var k = cljs.core._nth.call(null,c__19140__auto__,i__19903);
cljs.core.chunk_append.call(null,b__19904,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.keyword.call(null,k),(o[k])], null));

var G__19905 = (i__19903 + (1));
i__19903 = G__19905;
continue;
} else {
return true;
}
break;
}
})()){
return cljs.core.chunk_cons.call(null,cljs.core.chunk.call(null,b__19904),reagent$impl$component$shallow_obj_to_map_$_iter__19901.call(null,cljs.core.chunk_rest.call(null,s__19902__$2)));
} else {
return cljs.core.chunk_cons.call(null,cljs.core.chunk.call(null,b__19904),null);
}
} else {
var k = cljs.core.first.call(null,s__19902__$2);
return cljs.core.cons.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.keyword.call(null,k),(o[k])], null),reagent$impl$component$shallow_obj_to_map_$_iter__19901.call(null,cljs.core.rest.call(null,s__19902__$2)));
}
} else {
return null;
}
break;
}
}),null,null));
});
return iter__19142__auto__.call(null,cljs.core.js_keys.call(null,o));
})());
});
reagent.impl.component.elem_counter = (0);
reagent.impl.component.reactify_component = (function reagent$impl$component$reactify_component(comp){
return (React["createClass"])({"displayName": "react-wrapper", "render": (function (){
var this$ = this;
return reagent.impl.component.as_element.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [comp,cljs.core.assoc.call(null,reagent.impl.component.shallow_obj_to_map.call(null,(this$["props"])),new cljs.core.Keyword(null,"-elem-count","-elem-count",663797079),reagent.impl.component.elem_counter = (reagent.impl.component.elem_counter + (1)))], null));
})});
});

//# sourceMappingURL=component.js.map