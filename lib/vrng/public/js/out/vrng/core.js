// Compiled by ClojureScript 1.7.228 {}
goog.provide('vrng.core');
goog.require('cljs.core');
goog.require('reagent.core');
goog.require('reagent.session');
goog.require('secretary.core');
goog.require('goog.string.format');
if(typeof vrng.core.state !== 'undefined'){
} else {
vrng.core.state = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.initialState,new cljs.core.Keyword(null,"keywordize-keys","keywordize-keys",1310784252),true));
}
if(typeof vrng.core.translations !== 'undefined'){
} else {
vrng.core.translations = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.translations));
}
vrng.core.t = (function vrng$core$t(var_args){
var args__19435__auto__ = [];
var len__19428__auto___26255 = arguments.length;
var i__19429__auto___26256 = (0);
while(true){
if((i__19429__auto___26256 < len__19428__auto___26255)){
args__19435__auto__.push((arguments[i__19429__auto___26256]));

var G__26257 = (i__19429__auto___26256 + (1));
i__19429__auto___26256 = G__26257;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

vrng.core.t.cljs$core$IFn$_invoke$arity$variadic = (function (key){
var keys = cljs.core.flatten.call(null,cljs.core.map.call(null,(function (p1__26253_SHARP_){
return clojure.string.split.call(null,p1__26253_SHARP_,".");
}),key));
return cljs.core.reduce.call(null,cljs.core.get,cljs.core.deref.call(null,vrng.core.translations),keys);
});

vrng.core.t.cljs$lang$maxFixedArity = (0);

vrng.core.t.cljs$lang$applyTo = (function (seq26254){
return vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq26254));
});
vrng.core.talks_by_state = (function vrng$core$talks_by_state(talk_state){
return cljs.core.filter.call(null,(function (p1__26258_SHARP_){
return cljs.core._EQ_.call(null,talk_state,new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(p1__26258_SHARP_));
}),new cljs.core.Keyword(null,"talks","talks",1628751880).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state)));
});
vrng.core.next_talk = (function vrng$core$next_talk(){
return cljs.core.last.call(null,cljs.core.sort.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595),vrng.core.talks_by_state.call(null,"prelive")));
});
vrng.core.millis = (function vrng$core$millis(datetime){
return Date.parse(datetime);
});
vrng.core.time_to_next_talk = (function vrng$core$time_to_next_talk(){
return (vrng.core.millis.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595).cljs$core$IFn$_invoke$arity$1(vrng.core.next_talk.call(null))) - ((1000) * new cljs.core.Keyword(null,"now","now",-1650525531).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state))));
});
vrng.core.format_countdown = (function vrng$core$format_countdown(millis){
var base = (millis / (1000));
var minute = (60);
var hour = ((60) * minute);
var day = ((24) * hour);
var days = ((base / day) | (0));
var hours = ((base / hour) | (0));
var minutes = (((base / minute) | (0)) - (hours * minute));
var seconds = (((base | (0)) - (hours * hour)) - (minutes * minute));
if((millis < (0))){
return vrng.core.t.call(null,"any_time_now");
} else {
if((hours > (48))){
return [cljs.core.str(days),cljs.core.str(" "),cljs.core.str(vrng.core.t.call(null,"days"))].join('');
} else {
return goog.string.format("%02d:%02d:%02d",hours,minutes,seconds);

}
}
});
vrng.core.format_datetime = (function vrng$core$format_datetime(datetime){
return Date.parse(datetime);
});
vrng.core.venue_state = (function vrng$core$venue_state(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),vrng.core.t.call(null,"state",new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state))))], null);
});
vrng.core.venue_name = (function vrng$core$venue_name(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.core.state)))], null);
});
vrng.core.talk_comp = (function vrng$core$talk_comp(talk){
return cljs.core.with_meta(new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"li","li",723558921),talk.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595)),talk.call(null,new cljs.core.Keyword(null,"title","title",636505583))], null),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"key","key",-1516042587),talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092))], null));
});
vrng.core.talk_listing = (function vrng$core$talk_listing(talk_state){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"ul","ul",-1349521403),cljs.core.map.call(null,vrng.core.talk_comp,vrng.core.talks_by_state.call(null,talk_state))], null);
});
vrng.core.talk_section = (function vrng$core$talk_section(talk_state){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h3","h3",2067611163),vrng.core.t.call(null,"talk_state",talk_state)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_listing,talk_state], null)], null);
});
vrng.core.countdown = (function vrng$core$countdown(millis){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),vrng.core.format_countdown.call(null,millis)], null);
});
vrng.core.venue_channel = (function vrng$core$venue_channel(msg){
return cljs.core.print.call(null,msg);
});
vrng.core.container_classes = "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left";
vrng.core.home_page = (function vrng$core$home_page(){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"id","id",-1388402092),"claim",new cljs.core.Keyword(null,"class","class",-2030961996),"dark"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"header","header",119441134),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h1","h1",-1896887462),new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.venue_name], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.venue_state], null)], null)], null)], null)], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"light"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),vrng.core.container_classes], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.countdown,vrng.core.time_to_next_talk.call(null)], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_section,"live"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_section,"prelive"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_section,"archived"], null)], null)], null)], null)], null);
});
vrng.core.inc_now = (function vrng$core$inc_now(state_map){
return cljs.core.update_in.call(null,state_map,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"now","now",-1650525531)], null),cljs.core.inc);
});
vrng.core.start_timer = (function vrng$core$start_timer(){
return setInterval((function (){
return cljs.core.swap_BANG_.call(null,vrng.core.state,vrng.core.inc_now);
}),(1000));
});
vrng.core.setup_faye = (function vrng$core$setup_faye(){
return fayeClient.publish("/venue/channel",new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"text","text",-1790561697),"some message"], null));
});
vrng.core.mount_root = (function vrng$core$mount_root(){
return reagent.core.render.call(null,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.home_page], null),document.getElementById("app"));
});
vrng.core.init_BANG_ = (function vrng$core$init_BANG_(){
vrng.core.start_timer.call(null);

vrng.core.setup_faye.call(null);

return vrng.core.mount_root.call(null);
});

//# sourceMappingURL=core.js.map