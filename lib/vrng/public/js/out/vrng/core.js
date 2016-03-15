// Compiled by ClojureScript 1.7.228 {}
goog.provide('vrng.core');
goog.require('cljs.core');
goog.require('reagent.core');
goog.require('reagent.session');
goog.require('secretary.core');
if(typeof vrng.core.state !== 'undefined'){
} else {
vrng.core.state = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.initialState,new cljs.core.Keyword(null,"keywordize-keys","keywordize-keys",1310784252),true));
}
vrng.core.venue_state = new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state)));
vrng.core.venue_name = new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state)));
vrng.core.next_talk = (function vrng$core$next_talk(){
return new cljs.core.Keyword(null,"talks","talks",1628751880).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state));
});
vrng.core.home_page = (function vrng$core$home_page(){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"id","id",-1388402092),"claim",new cljs.core.Keyword(null,"class","class",-2030961996),"dark"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"header","header",119441134),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h1","h1",-1896887462),vrng.core.venue_name], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),vrng.core.venue_state], null)], null)], null)], null);
});
vrng.core.mount_root = (function vrng$core$mount_root(){
return reagent.core.render.call(null,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.home_page], null),document.getElementById("app"));
});
vrng.core.init_BANG_ = (function vrng$core$init_BANG_(){
return vrng.core.mount_root.call(null);
});

//# sourceMappingURL=core.js.map