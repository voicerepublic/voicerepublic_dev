// Compiled by ClojureScript 1.7.228 {}
goog.provide('vrng.venue');
goog.require('cljs.core');
goog.require('reagent.core');
goog.require('reagent.session');
goog.require('secretary.core');
goog.require('goog.string.format');
if(typeof vrng.venue.state !== 'undefined'){
} else {
vrng.venue.state = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.initialState,new cljs.core.Keyword(null,"keywordize-keys","keywordize-keys",1310784252),true));
}
if(typeof vrng.venue.translations !== 'undefined'){
} else {
vrng.venue.translations = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.translations));
}
vrng.venue.t = (function vrng$venue$t(var_args){
var args__19435__auto__ = [];
var len__19428__auto___26240 = arguments.length;
var i__19429__auto___26241 = (0);
while(true){
if((i__19429__auto___26241 < len__19428__auto___26240)){
args__19435__auto__.push((arguments[i__19429__auto___26241]));

var G__26242 = (i__19429__auto___26241 + (1));
i__19429__auto___26241 = G__26242;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return vrng.venue.t.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

vrng.venue.t.cljs$core$IFn$_invoke$arity$variadic = (function (key){
var keys = cljs.core.flatten.call(null,cljs.core.map.call(null,(function (p1__26238_SHARP_){
return clojure.string.split.call(null,p1__26238_SHARP_,".");
}),key));
return cljs.core.reduce.call(null,cljs.core.get,cljs.core.deref.call(null,vrng.venue.translations),keys);
});

vrng.venue.t.cljs$lang$maxFixedArity = (0);

vrng.venue.t.cljs$lang$applyTo = (function (seq26239){
return vrng.venue.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq26239));
});
vrng.venue.talks_by_state = (function vrng$venue$talks_by_state(talk_state){
return cljs.core.filter.call(null,(function (p1__26243_SHARP_){
return cljs.core._EQ_.call(null,talk_state,new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(p1__26243_SHARP_));
}),cljs.core.vals.call(null,new cljs.core.Keyword(null,"talks","talks",1628751880).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state))));
});
vrng.venue.next_talk = (function vrng$venue$next_talk(){
return cljs.core.last.call(null,cljs.core.sort.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595),vrng.venue.talks_by_state.call(null,"prelive")));
});
vrng.venue.millis = (function vrng$venue$millis(datetime){
return Date.parse(datetime);
});
vrng.venue.time_to_next_talk = (function vrng$venue$time_to_next_talk(){
return (vrng.venue.millis.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595).cljs$core$IFn$_invoke$arity$1(vrng.venue.next_talk.call(null))) - ((1000) * new cljs.core.Keyword(null,"now","now",-1650525531).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state))));
});
vrng.venue.format_countdown = (function vrng$venue$format_countdown(millis){
var base = (millis / (1000));
var minute = (60);
var hour = ((60) * minute);
var day = ((24) * hour);
var days = ((base / day) | (0));
var hours = ((base / hour) | (0));
var minutes = (((base / minute) | (0)) - (hours * minute));
var seconds = (((base | (0)) - (hours * hour)) - (minutes * minute));
if((millis < (0))){
return vrng.venue.t.call(null,"any_time_now");
} else {
if((hours > (48))){
return [cljs.core.str(days),cljs.core.str(" "),cljs.core.str(vrng.venue.t.call(null,"days"))].join('');
} else {
return goog.string.format("%02d:%02d:%02d",hours,minutes,seconds);

}
}
});
vrng.venue.format_datetime = (function vrng$venue$format_datetime(datetime){
return Date.parse(datetime);
});
vrng.venue.back_channel = clojure.string.join.call(null,"/",new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [null,"up","user",new cljs.core.Keyword(null,"id","id",-1388402092).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"user","user",1532431356).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state))),"venue",new cljs.core.Keyword(null,"id","id",-1388402092).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state)))], null));
vrng.venue.publish = (function vrng$venue$publish(message){
return fayeClient.publish(vrng.venue.back_channel,cljs.core.clj__GT_js.call(null,message));
});
vrng.venue.talk_button = (function vrng$venue$talk_button(event,talk_id){
return (function (){
return vrng.venue.publish.call(null,new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"event","event",301435442),event,new cljs.core.Keyword(null,"talk_id","talk_id",-1851279310),talk_id], null));
});
});
vrng.venue.venue_state = (function vrng$venue$venue_state(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),vrng.venue.t.call(null,"state",new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state))))], null);
});
vrng.venue.venue_name = (function vrng$venue$venue_name(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state)))], null);
});
vrng.venue.talk_comp = (function vrng$venue$talk_comp(talk){
return cljs.core.with_meta(new cljs.core.PersistentVector(null, 5, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"li","li",723558921),talk.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595)),talk.call(null,new cljs.core.Keyword(null,"title","title",636505583)),((cljs.core._EQ_.call(null,talk.call(null,new cljs.core.Keyword(null,"state","state",-1988618099)),"prelive"))?new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"button","button",1456579943),new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"type","type",1174270348),"button",new cljs.core.Keyword(null,"class","class",-2030961996),"button",new cljs.core.Keyword(null,"on-click","on-click",1632826543),vrng.venue.talk_button.call(null,"start",talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092)))], null),vrng.venue.t.call(null,"start")], null):null),((cljs.core._EQ_.call(null,talk.call(null,new cljs.core.Keyword(null,"state","state",-1988618099)),"live"))?new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"button","button",1456579943),new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"type","type",1174270348),"button",new cljs.core.Keyword(null,"class","class",-2030961996),"button alert",new cljs.core.Keyword(null,"on-click","on-click",1632826543),vrng.venue.talk_button.call(null,"stop",talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092)))], null),vrng.venue.t.call(null,"stop")], null):null)], null),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"key","key",-1516042587),talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092))], null));
});
vrng.venue.talk_listing = (function vrng$venue$talk_listing(talk_state){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"ul","ul",-1349521403),cljs.core.doall.call(null,cljs.core.map.call(null,vrng.venue.talk_comp,vrng.venue.talks_by_state.call(null,talk_state)))], null);
});
vrng.venue.talk_section = (function vrng$venue$talk_section(talk_state){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h3","h3",2067611163),vrng.venue.t.call(null,"talk_state",talk_state)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.talk_listing,talk_state], null)], null);
});
vrng.venue.countdown = (function vrng$venue$countdown(millis){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),vrng.venue.format_countdown.call(null,millis)], null);
});
vrng.venue.set_talk_state = (function vrng$venue$set_talk_state(talk_state,talk_id){
return cljs.core.swap_BANG_.call(null,vrng.venue.state,(function (p1__26244_SHARP_){
return cljs.core.assoc_in.call(null,p1__26244_SHARP_,new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"talks","talks",1628751880),cljs.core.keyword.call(null,talk_id),new cljs.core.Keyword(null,"state","state",-1988618099)], null),talk_state);
}));
});
vrng.venue.venue_message_handler = (function vrng$venue$venue_message_handler(msg){
cljs.core.print.call(null,msg);

if(cljs.core._EQ_.call(null,msg.call(null,new cljs.core.Keyword(null,"event","event",301435442)),"start_talk")){
return vrng.venue.set_talk_state.call(null,"live",msg.call(null,new cljs.core.Keyword(null,"talk_id","talk_id",-1851279310)));
} else {
return cljs.core.print.call(null,msg);

}
});
vrng.venue.container_classes = "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left";
vrng.venue.home_page = (function vrng$venue$home_page(){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"id","id",-1388402092),"claim",new cljs.core.Keyword(null,"class","class",-2030961996),"dark"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"header","header",119441134),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h1","h1",-1896887462),new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.venue_name], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.venue_state], null)], null)], null)], null)], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"light"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),vrng.venue.container_classes], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.countdown,vrng.venue.time_to_next_talk.call(null)], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.talk_section,"live"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.talk_section,"prelive"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.talk_section,"archived"], null)], null)], null)], null)], null);
});
vrng.venue.inc_now = (function vrng$venue$inc_now(state_map){
return cljs.core.update_in.call(null,state_map,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"now","now",-1650525531)], null),cljs.core.inc);
});
vrng.venue.start_timer = (function vrng$venue$start_timer(){
return setInterval((function (){
return cljs.core.swap_BANG_.call(null,vrng.venue.state,vrng.venue.inc_now);
}),(1000));
});
vrng.venue.venue_channel = clojure.string.join.call(null,"/",new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [null,"down","venue",new cljs.core.Keyword(null,"id","id",-1388402092).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.venue.state)))], null));
vrng.venue.setup_faye = (function vrng$venue$setup_faye(){
return fayeClient.subscribe(vrng.venue.venue_channel,(function (p1__26245_SHARP_){
return vrng.venue.venue_message_handler.call(null,cljs.core.js__GT_clj.call(null,p1__26245_SHARP_,new cljs.core.Keyword(null,"keywordize-keys","keywordize-keys",1310784252),true));
}));
});
vrng.venue.mount_root = (function vrng$venue$mount_root(){
return reagent.core.render.call(null,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.venue.home_page], null),document.getElementById("app"));
});
vrng.venue.init_BANG_ = (function vrng$venue$init_BANG_(){
vrng.venue.start_timer.call(null);

vrng.venue.setup_faye.call(null);

return vrng.venue.mount_root.call(null);
});

//# sourceMappingURL=venue.js.map