// Compiled by ClojureScript 1.7.228 {:static-fns true, :optimize-constants true}
goog.provide('reagent.core');
goog.require('cljs.core');
goog.require('reagent.impl.util');
goog.require('reagent.impl.component');
goog.require('reagent.interop');
goog.require('reagent.ratom');
goog.require('reagent.impl.template');
goog.require('reagent.impl.batching');
goog.require('reagent.debug');
reagent.core.is_client = reagent.impl.util.is_client;
/**
 * Create a native React element, by calling React.createElement directly.
 * 
 * That means the second argument must be a javascript object (or nil), and
 * that any Reagent hiccup forms must be processed with as-element. For example
 * like this:
 * 
 * (r/create-element "div" #js{:className "foo"}
 *    "Hi " (r/as-element [:strong "world!"])
 * 
 * which is equivalent to
 * 
 * [:div.foo "Hi" [:strong "world!"]]
 */
reagent.core.create_element = (function reagent$core$create_element(var_args){
var args9305 = [];
var len__7211__auto___9312 = arguments.length;
var i__7212__auto___9313 = (0);
while(true){
if((i__7212__auto___9313 < len__7211__auto___9312)){
args9305.push((arguments[i__7212__auto___9313]));

var G__9314 = (i__7212__auto___9313 + (1));
i__7212__auto___9313 = G__9314;
continue;
} else {
}
break;
}

var G__9311 = args9305.length;
switch (G__9311) {
case 1:
return reagent.core.create_element.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return reagent.core.create_element.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return reagent.core.create_element.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
var argseq__7230__auto__ = (new cljs.core.IndexedSeq(args9305.slice((3)),(0)));
return reagent.core.create_element.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),(arguments[(2)]),argseq__7230__auto__);

}
});

reagent.core.create_element.cljs$core$IFn$_invoke$arity$1 = (function (type){
return reagent.core.create_element.cljs$core$IFn$_invoke$arity$2(type,null);
});

reagent.core.create_element.cljs$core$IFn$_invoke$arity$2 = (function (type,props){
if(!(cljs.core.map_QMARK_(props))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$not,cljs.core.list(cljs.core.cst$sym$map_QMARK_,cljs.core.cst$sym$props))], 0)))].join('')));
}

return React.createElement(type,props);
});

reagent.core.create_element.cljs$core$IFn$_invoke$arity$3 = (function (type,props,child){
if(!(cljs.core.map_QMARK_(props))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$not,cljs.core.list(cljs.core.cst$sym$map_QMARK_,cljs.core.cst$sym$props))], 0)))].join('')));
}

return React.createElement(type,props,child);
});

reagent.core.create_element.cljs$core$IFn$_invoke$arity$variadic = (function (type,props,child,children){
if(!(cljs.core.map_QMARK_(props))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$not,cljs.core.list(cljs.core.cst$sym$map_QMARK_,cljs.core.cst$sym$props))], 0)))].join('')));
}

return cljs.core.apply.cljs$core$IFn$_invoke$arity$5(React.createElement,type,props,child,children);
});

reagent.core.create_element.cljs$lang$applyTo = (function (seq9306){
var G__9307 = cljs.core.first(seq9306);
var seq9306__$1 = cljs.core.next(seq9306);
var G__9308 = cljs.core.first(seq9306__$1);
var seq9306__$2 = cljs.core.next(seq9306__$1);
var G__9309 = cljs.core.first(seq9306__$2);
var seq9306__$3 = cljs.core.next(seq9306__$2);
return reagent.core.create_element.cljs$core$IFn$_invoke$arity$variadic(G__9307,G__9308,G__9309,seq9306__$3);
});

reagent.core.create_element.cljs$lang$maxFixedArity = (3);
/**
 * Turns a vector of Hiccup syntax into a React element. Returns form unchanged if it is not a vector.
 */
reagent.core.as_element = (function reagent$core$as_element(form){
return reagent.impl.template.as_element(form);
});
/**
 * Returns an adapter for a native React class, that may be used
 * just like a Reagent component function or class in Hiccup forms.
 */
reagent.core.adapt_react_class = (function reagent$core$adapt_react_class(c){
if(cljs.core.truth_(c)){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.cst$sym$c], 0)))].join('')));
}

return reagent.impl.template.adapt_react_class(c);
});
/**
 * Returns an adapter for a Reagent component, that may be used from
 *   React, for example in JSX. A single argument, props, is passed to
 *   the component, converted to a map.
 */
reagent.core.reactify_component = (function reagent$core$reactify_component(c){
if(cljs.core.truth_(c)){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.cst$sym$c], 0)))].join('')));
}

return reagent.impl.component.reactify_component(c);
});
/**
 * Render a Reagent component into the DOM. The first argument may be 
 * either a vector (using Reagent's Hiccup syntax), or a React element. The second argument should be a DOM node.
 * 
 * Optionally takes a callback that is called when the component is in place.
 * 
 * Returns the mounted component instance.
 */
reagent.core.render = (function reagent$core$render(var_args){
var args9316 = [];
var len__7211__auto___9319 = arguments.length;
var i__7212__auto___9320 = (0);
while(true){
if((i__7212__auto___9320 < len__7211__auto___9319)){
args9316.push((arguments[i__7212__auto___9320]));

var G__9321 = (i__7212__auto___9320 + (1));
i__7212__auto___9320 = G__9321;
continue;
} else {
}
break;
}

var G__9318 = args9316.length;
switch (G__9318) {
case 2:
return reagent.core.render.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
case 3:
return reagent.core.render.cljs$core$IFn$_invoke$arity$3((arguments[(0)]),(arguments[(1)]),(arguments[(2)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args9316.length)].join('')));

}
});

reagent.core.render.cljs$core$IFn$_invoke$arity$2 = (function (comp,container){
return reagent.core.render.cljs$core$IFn$_invoke$arity$3(comp,container,null);
});

reagent.core.render.cljs$core$IFn$_invoke$arity$3 = (function (comp,container,callback){
var f = (function (){
return reagent.core.as_element(((cljs.core.fn_QMARK_(comp))?(comp.cljs$core$IFn$_invoke$arity$0 ? comp.cljs$core$IFn$_invoke$arity$0() : comp.call(null)):comp));
});
return reagent.impl.util.render_component(f,container,callback);
});

reagent.core.render.cljs$lang$maxFixedArity = 3;
/**
 * Remove a component from the given DOM node.
 */
reagent.core.unmount_component_at_node = (function reagent$core$unmount_component_at_node(container){
return reagent.impl.util.unmount_component_at_node(container);
});
/**
 * Turns a component into an HTML string.
 */
reagent.core.render_to_string = (function reagent$core$render_to_string(component){
var _STAR_non_reactive_STAR_9324 = reagent.impl.component._STAR_non_reactive_STAR_;
reagent.impl.component._STAR_non_reactive_STAR_ = true;

try{return (React["renderToString"])(reagent.core.as_element(component));
}finally {reagent.impl.component._STAR_non_reactive_STAR_ = _STAR_non_reactive_STAR_9324;
}});
reagent.core.as_component = reagent.core.as_element;
reagent.core.render_component = reagent.core.render;
reagent.core.render_component_to_string = reagent.core.render_to_string;
/**
 * Turns a component into an HTML string, without data-react-id attributes, etc.
 */
reagent.core.render_to_static_markup = (function reagent$core$render_to_static_markup(component){
var _STAR_non_reactive_STAR_9326 = reagent.impl.component._STAR_non_reactive_STAR_;
reagent.impl.component._STAR_non_reactive_STAR_ = true;

try{return (React["renderToStaticMarkup"])(reagent.core.as_element(component));
}finally {reagent.impl.component._STAR_non_reactive_STAR_ = _STAR_non_reactive_STAR_9326;
}});
/**
 * Force re-rendering of all mounted Reagent components. This is
 *   probably only useful in a development environment, when you want to
 *   update components in response to some dynamic changes to code.
 * 
 *   Note that force-update-all may not update root components. This
 *   happens if a component 'foo' is mounted with `(render [foo])` (since
 *   functions are passed by value, and not by reference, in
 *   ClojureScript). To get around this you'll have to introduce a layer
 *   of indirection, for example by using `(render [#'foo])` instead.
 */
reagent.core.force_update_all = (function reagent$core$force_update_all(){
return reagent.impl.util.force_update_all();
});
goog.exportSymbol('reagent.core.force_update_all', reagent.core.force_update_all);
/**
 * Create a component, React style. Should be called with a map,
 * looking like this:
 * {:get-initial-state (fn [this])
 * :component-will-receive-props (fn [this new-argv])
 * :should-component-update (fn [this old-argv new-argv])
 * :component-will-mount (fn [this])
 * :component-did-mount (fn [this])
 * :component-will-update (fn [this new-argv])
 * :component-did-update (fn [this old-argv])
 * :component-will-unmount (fn [this])
 * :reagent-render (fn [args....])   ;; or :render (fn [this])
 * }
 * 
 * Everything is optional, except either :reagent-render or :render.
 */
reagent.core.create_class = (function reagent$core$create_class(spec){
return reagent.impl.component.create_class(spec);
});
/**
 * Returns the current React component (a.k.a this) in a component
 *   function.
 */
reagent.core.current_component = (function reagent$core$current_component(){
return reagent.impl.component._STAR_current_component_STAR_;
});
/**
 * Returns an atom containing a components state.
 */
reagent.core.state_atom = (function reagent$core$state_atom(this$){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

return reagent.impl.component.state_atom(this$);
});
/**
 * Returns the state of a component, as set with replace-state or set-state.
 * Equivalent to (deref (r/state-atom this))
 */
reagent.core.state = (function reagent$core$state(this$){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

var G__9328 = reagent.core.state_atom(this$);
return (cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(G__9328) : cljs.core.deref.call(null,G__9328));
});
/**
 * Set state of a component.
 * Equivalent to (reset! (state-atom this) new-state)
 */
reagent.core.replace_state = (function reagent$core$replace_state(this$,new_state){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

if(((new_state == null)) || (cljs.core.map_QMARK_(new_state))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$or,cljs.core.list(cljs.core.cst$sym$nil_QMARK_,cljs.core.cst$sym$new_DASH_state),cljs.core.list(cljs.core.cst$sym$map_QMARK_,cljs.core.cst$sym$new_DASH_state))], 0)))].join('')));
}

var G__9331 = reagent.core.state_atom(this$);
var G__9332 = new_state;
return (cljs.core.reset_BANG_.cljs$core$IFn$_invoke$arity$2 ? cljs.core.reset_BANG_.cljs$core$IFn$_invoke$arity$2(G__9331,G__9332) : cljs.core.reset_BANG_.call(null,G__9331,G__9332));
});
/**
 * Merge component state with new-state.
 * Equivalent to (swap! (state-atom this) merge new-state)
 */
reagent.core.set_state = (function reagent$core$set_state(this$,new_state){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

if(((new_state == null)) || (cljs.core.map_QMARK_(new_state))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$or,cljs.core.list(cljs.core.cst$sym$nil_QMARK_,cljs.core.cst$sym$new_DASH_state),cljs.core.list(cljs.core.cst$sym$map_QMARK_,cljs.core.cst$sym$new_DASH_state))], 0)))].join('')));
}

return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$3(reagent.core.state_atom(this$),cljs.core.merge,new_state);
});
/**
 * Force a component to re-render immediately.
 * 
 *   If the second argument is true, child components will also be
 *   re-rendered, even is their arguments have not changed.
 */
reagent.core.force_update = (function reagent$core$force_update(var_args){
var args9333 = [];
var len__7211__auto___9336 = arguments.length;
var i__7212__auto___9337 = (0);
while(true){
if((i__7212__auto___9337 < len__7211__auto___9336)){
args9333.push((arguments[i__7212__auto___9337]));

var G__9338 = (i__7212__auto___9337 + (1));
i__7212__auto___9337 = G__9338;
continue;
} else {
}
break;
}

var G__9335 = args9333.length;
switch (G__9335) {
case 1:
return reagent.core.force_update.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 2:
return reagent.core.force_update.cljs$core$IFn$_invoke$arity$2((arguments[(0)]),(arguments[(1)]));

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args9333.length)].join('')));

}
});

reagent.core.force_update.cljs$core$IFn$_invoke$arity$1 = (function (this$){
return reagent.core.force_update.cljs$core$IFn$_invoke$arity$2(this$,false);
});

reagent.core.force_update.cljs$core$IFn$_invoke$arity$2 = (function (this$,deep){
return reagent.impl.util.force_update(this$,deep);
});

reagent.core.force_update.cljs$lang$maxFixedArity = 2;
/**
 * Returns the props passed to a component.
 */
reagent.core.props = (function reagent$core$props(this$){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

return reagent.impl.util.get_props(this$);
});
/**
 * Returns the children passed to a component.
 */
reagent.core.children = (function reagent$core$children(this$){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

return reagent.impl.util.get_children(this$);
});
/**
 * Returns the entire Hiccup form passed to the component.
 */
reagent.core.argv = (function reagent$core$argv(this$){
if(cljs.core.truth_(reagent.impl.util.reagent_component_QMARK_(this$))){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$util_SLASH_reagent_DASH_component_QMARK_,cljs.core.cst$sym$this)], 0)))].join('')));
}

return reagent.impl.util.get_argv(this$);
});
/**
 * Returns the root DOM node of a mounted component.
 */
reagent.core.dom_node = (function reagent$core$dom_node(this$){
return (this$["getDOMNode"])();
});
/**
 * Utility function that merges two maps, handling :class and :style
 * specially, like React's transferPropsTo.
 */
reagent.core.merge_props = (function reagent$core$merge_props(defaults,props){
return reagent.impl.util.merge_props(defaults,props);
});
/**
 * Render dirty components immediately to the DOM.
 * 
 * Note that this may not work in event handlers, since React.js does
 * batching of updates there.
 */
reagent.core.flush = (function reagent$core$flush(){
return reagent.impl.batching.flush();
});
/**
 * Like clojure.core/atom, except that it keeps track of derefs.
 * Reagent components that derefs one of these are automatically
 * re-rendered.
 */
reagent.core.atom = (function reagent$core$atom(var_args){
var args9340 = [];
var len__7211__auto___9345 = arguments.length;
var i__7212__auto___9346 = (0);
while(true){
if((i__7212__auto___9346 < len__7211__auto___9345)){
args9340.push((arguments[i__7212__auto___9346]));

var G__9347 = (i__7212__auto___9346 + (1));
i__7212__auto___9346 = G__9347;
continue;
} else {
}
break;
}

var G__9344 = args9340.length;
switch (G__9344) {
case 1:
return reagent.core.atom.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
default:
var argseq__7230__auto__ = (new cljs.core.IndexedSeq(args9340.slice((1)),(0)));
return reagent.core.atom.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7230__auto__);

}
});

reagent.core.atom.cljs$core$IFn$_invoke$arity$1 = (function (x){
return reagent.ratom.atom.cljs$core$IFn$_invoke$arity$1(x);
});

reagent.core.atom.cljs$core$IFn$_invoke$arity$variadic = (function (x,rest){
return cljs.core.apply.cljs$core$IFn$_invoke$arity$3(reagent.ratom.atom,x,rest);
});

reagent.core.atom.cljs$lang$applyTo = (function (seq9341){
var G__9342 = cljs.core.first(seq9341);
var seq9341__$1 = cljs.core.next(seq9341);
return reagent.core.atom.cljs$core$IFn$_invoke$arity$variadic(G__9342,seq9341__$1);
});

reagent.core.atom.cljs$lang$maxFixedArity = (1);
/**
 * Provide a combination of value and callback, that looks like an atom.
 * 
 *   The first argument can be any value, that will be returned when the
 *   result is deref'ed.
 * 
 *   The second argument should be a function, that is called with the
 *   optional extra arguments provided to wrap, and the new value of the
 *   resulting 'atom'.
 * 
 *   Use for example like this:
 * 
 *   (wrap (:foo @state)
 *      swap! state assoc :foo)
 * 
 *   Probably useful only for passing to child components.
 */
reagent.core.wrap = (function reagent$core$wrap(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9352 = arguments.length;
var i__7212__auto___9353 = (0);
while(true){
if((i__7212__auto___9353 < len__7211__auto___9352)){
args__7218__auto__.push((arguments[i__7212__auto___9353]));

var G__9354 = (i__7212__auto___9353 + (1));
i__7212__auto___9353 = G__9354;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((2) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((2)),(0))):null);
return reagent.core.wrap.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),(arguments[(1)]),argseq__7219__auto__);
});

reagent.core.wrap.cljs$core$IFn$_invoke$arity$variadic = (function (value,reset_fn,args){
if(cljs.core.ifn_QMARK_(reset_fn)){
} else {
throw (new Error([cljs.core.str("Assert failed: "),cljs.core.str(cljs.core.pr_str.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([cljs.core.list(cljs.core.cst$sym$ifn_QMARK_,cljs.core.cst$sym$reset_DASH_fn)], 0)))].join('')));
}

return reagent.ratom.make_wrapper(value,reset_fn,args);
});

reagent.core.wrap.cljs$lang$maxFixedArity = (2);

reagent.core.wrap.cljs$lang$applyTo = (function (seq9349){
var G__9350 = cljs.core.first(seq9349);
var seq9349__$1 = cljs.core.next(seq9349);
var G__9351 = cljs.core.first(seq9349__$1);
var seq9349__$2 = cljs.core.next(seq9349__$1);
return reagent.core.wrap.cljs$core$IFn$_invoke$arity$variadic(G__9350,G__9351,seq9349__$2);
});
/**
 * Provide a cursor into a Reagent atom.
 * 
 * Behaves like a Reagent atom but focuses updates and derefs to
 * the specified path within the wrapped Reagent atom. e.g.,
 *   (let [c (cursor ra [:nested :content])]
 *  ... @c ;; equivalent to (get-in @ra [:nested :content])
 *  ... (reset! c 42) ;; equivalent to (swap! ra assoc-in [:nested :content] 42)
 *  ... (swap! c inc) ;; equivalence to (swap! ra update-in [:nested :content] inc)
 *  )
 * 
 * The first parameter can also be a function, that should look something
 * like this:
 * 
 * (defn set-get
 *   ([k] (get-in @state k))
 *   ([k v] (swap! state assoc-in k v)))
 * 
 * The function will be called with one argument – the path passed to
 * cursor – when the cursor is deref'ed, and two arguments (path and new
 * value) when the cursor is modified.
 * 
 * Given that set-get function, (and that state is a Reagent atom, or
 * another cursor) these cursors are equivalent:
 * (cursor state [:foo]) and (cursor set-get [:foo]).
 */
reagent.core.cursor = (function reagent$core$cursor(src,path){
return reagent.ratom.cursor(src,path);
});
/**
 * Run f using requestAnimationFrame or equivalent.
 */
reagent.core.next_tick = (function reagent$core$next_tick(f){
return (reagent.impl.batching.next_tick.cljs$core$IFn$_invoke$arity$1 ? reagent.impl.batching.next_tick.cljs$core$IFn$_invoke$arity$1(f) : reagent.impl.batching.next_tick.call(null,f));
});
/**
 * Works just like clojure.core/partial, except that it is an IFn, and
 * the result can be compared with =
 */
reagent.core.partial = (function reagent$core$partial(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9357 = arguments.length;
var i__7212__auto___9358 = (0);
while(true){
if((i__7212__auto___9358 < len__7211__auto___9357)){
args__7218__auto__.push((arguments[i__7212__auto___9358]));

var G__9359 = (i__7212__auto___9358 + (1));
i__7212__auto___9358 = G__9359;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((1) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((1)),(0))):null);
return reagent.core.partial.cljs$core$IFn$_invoke$arity$variadic((arguments[(0)]),argseq__7219__auto__);
});

reagent.core.partial.cljs$core$IFn$_invoke$arity$variadic = (function (f,args){
return (new reagent.impl.util.partial_ifn(f,args,null));
});

reagent.core.partial.cljs$lang$maxFixedArity = (1);

reagent.core.partial.cljs$lang$applyTo = (function (seq9355){
var G__9356 = cljs.core.first(seq9355);
var seq9355__$1 = cljs.core.next(seq9355);
return reagent.core.partial.cljs$core$IFn$_invoke$arity$variadic(G__9356,seq9355__$1);
});
reagent.core.component_path = (function reagent$core$component_path(c){
return reagent.impl.component.component_path(c);
});
