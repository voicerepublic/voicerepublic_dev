// Compiled by ClojureScript 1.7.228 {}
goog.provide('vrng.talk');
goog.require('cljs.core');
goog.require('reagent.core');
goog.require('reagent.session');
goog.require('secretary.core');
goog.require('goog.string.format');
if(typeof vrng.talk.state !== 'undefined'){
} else {
vrng.talk.state = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.initialState,new cljs.core.Keyword(null,"keywordize-keys","keywordize-keys",1310784252),true));
}
if(typeof vrng.talk.translations !== 'undefined'){
} else {
vrng.talk.translations = reagent.core.atom.call(null,cljs.core.js__GT_clj.call(null,window.translations));
}
vrng.talk.t = (function vrng$talk$t(var_args){
var args__19435__auto__ = [];
var len__19428__auto___28439 = arguments.length;
var i__19429__auto___28440 = (0);
while(true){
if((i__19429__auto___28440 < len__19428__auto___28439)){
args__19435__auto__.push((arguments[i__19429__auto___28440]));

var G__28441 = (i__19429__auto___28440 + (1));
i__19429__auto___28440 = G__28441;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return vrng.talk.t.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

vrng.talk.t.cljs$core$IFn$_invoke$arity$variadic = (function (key){
var keys = cljs.core.flatten.call(null,cljs.core.map.call(null,(function (p1__28437_SHARP_){
return clojure.string.split.call(null,p1__28437_SHARP_,".");
}),key));
return cljs.core.reduce.call(null,cljs.core.get,cljs.core.deref.call(null,vrng.talk.translations),keys);
});

vrng.talk.t.cljs$lang$maxFixedArity = (0);

vrng.talk.t.cljs$lang$applyTo = (function (seq28438){
return vrng.talk.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq28438));
});
vrng.talk.talks_by_state = (function vrng$talk$talks_by_state(talk_state){
return cljs.core.filter.call(null,(function (p1__28442_SHARP_){
return cljs.core._EQ_.call(null,talk_state,new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(p1__28442_SHARP_));
}),cljs.core.vals.call(null,new cljs.core.Keyword(null,"talks","talks",1628751880).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state))));
});
vrng.talk.next_talk = (function vrng$talk$next_talk(){
return cljs.core.last.call(null,cljs.core.sort.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595),vrng.talk.talks_by_state.call(null,"prelive")));
});
vrng.talk.millis = (function vrng$talk$millis(datetime){
return Date.parse(datetime);
});
vrng.talk.time_to_next_talk = (function vrng$talk$time_to_next_talk(){
return (vrng.talk.millis.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595).cljs$core$IFn$_invoke$arity$1(vrng.talk.next_talk.call(null))) - ((1000) * new cljs.core.Keyword(null,"now","now",-1650525531).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state))));
});
vrng.talk.format_countdown = (function vrng$talk$format_countdown(millis){
var base = (millis / (1000));
var minute = (60);
var hour = ((60) * minute);
var day = ((24) * hour);
var days = ((base / day) | (0));
var hours = ((base / hour) | (0));
var minutes = (((base / minute) | (0)) - (hours * minute));
var seconds = (((base | (0)) - (hours * hour)) - (minutes * minute));
if((millis < (0))){
return vrng.talk.t.call(null,"any_time_now");
} else {
if((hours > (48))){
return [cljs.core.str(days),cljs.core.str(" "),cljs.core.str(vrng.talk.t.call(null,"days"))].join('');
} else {
return goog.string.format("%02dh %02dm %02ds",hours,minutes,seconds);

}
}
});
vrng.talk.format_datetime = (function vrng$talk$format_datetime(datetime){
return Date.parse(datetime);
});
vrng.talk.back_channel = clojure.string.join.call(null,"/",new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [null,"up","user",new cljs.core.Keyword(null,"id","id",-1388402092).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"user","user",1532431356).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state))),"venue",new cljs.core.Keyword(null,"id","id",-1388402092).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state)))], null));
vrng.talk.publish = (function vrng$talk$publish(message){
return fayeClient.publish(vrng.talk.back_channel,cljs.core.clj__GT_js.call(null,message));
});
vrng.talk.talk_button = (function vrng$talk$talk_button(event,talk_id){
return (function (){
return vrng.talk.publish.call(null,new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"event","event",301435442),event,new cljs.core.Keyword(null,"talk_id","talk_id",-1851279310),talk_id], null));
});
});
vrng.talk.venue_state = (function vrng$talk$venue_state(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),vrng.talk.t.call(null,"state",new cljs.core.Keyword(null,"state","state",-1988618099).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state))))], null);
});
vrng.talk.venue_name = (function vrng$talk$venue_name(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state)))], null);
});
vrng.talk.talk_comp = (function vrng$talk$talk_comp(talk){
return cljs.core.with_meta(new cljs.core.PersistentVector(null, 5, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"li","li",723558921),talk.call(null,new cljs.core.Keyword(null,"starts_at","starts_at",1460420595)),talk.call(null,new cljs.core.Keyword(null,"title","title",636505583)),((cljs.core._EQ_.call(null,talk.call(null,new cljs.core.Keyword(null,"state","state",-1988618099)),"prelive"))?new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"button","button",1456579943),new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"type","type",1174270348),"button",new cljs.core.Keyword(null,"class","class",-2030961996),"button",new cljs.core.Keyword(null,"on-click","on-click",1632826543),vrng.talk.talk_button.call(null,"start",talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092)))], null),vrng.talk.t.call(null,"start")], null):null),((cljs.core._EQ_.call(null,talk.call(null,new cljs.core.Keyword(null,"state","state",-1988618099)),"live"))?new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"button","button",1456579943),new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"type","type",1174270348),"button",new cljs.core.Keyword(null,"class","class",-2030961996),"button alert",new cljs.core.Keyword(null,"on-click","on-click",1632826543),vrng.talk.talk_button.call(null,"stop",talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092)))], null),vrng.talk.t.call(null,"stop")], null):null)], null),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"key","key",-1516042587),talk.call(null,new cljs.core.Keyword(null,"id","id",-1388402092))], null));
});
vrng.talk.talk_listing = (function vrng$talk$talk_listing(talk_state){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"ul","ul",-1349521403),cljs.core.doall.call(null,cljs.core.map.call(null,vrng.talk.talk_comp,vrng.talk.talks_by_state.call(null,talk_state)))], null);
});
vrng.talk.talk_section = (function vrng$talk$talk_section(talk_state){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h3","h3",2067611163),vrng.talk.t.call(null,"talk_state",talk_state)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.talk_listing,talk_state], null)], null);
});
vrng.talk.countdown = (function vrng$talk$countdown(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"span","span",1394872991),vrng.talk.format_countdown.call(null,vrng.talk.time_to_next_talk.call(null))], null);
});
vrng.talk.set_talk_state = (function vrng$talk$set_talk_state(talk_state,talk_id){
return cljs.core.swap_BANG_.call(null,vrng.talk.state,(function (p1__28443_SHARP_){
return cljs.core.assoc_in.call(null,p1__28443_SHARP_,new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"talks","talks",1628751880),cljs.core.keyword.call(null,talk_id),new cljs.core.Keyword(null,"state","state",-1988618099)], null),talk_state);
}));
});
vrng.talk.venue_message_handler = (function vrng$talk$venue_message_handler(msg){
cljs.core.print.call(null,msg);

if(cljs.core._EQ_.call(null,msg.call(null,new cljs.core.Keyword(null,"event","event",301435442)),"start_talk")){
return vrng.talk.set_talk_state.call(null,"live",msg.call(null,new cljs.core.Keyword(null,"talk_id","talk_id",-1851279310)));
} else {
return cljs.core.print.call(null,msg);

}
});
vrng.talk.container_classes = "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left";
vrng.talk.home_page = (function vrng$talk$home_page(){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 2, [new cljs.core.Keyword(null,"id","id",-1388402092),"claim",new cljs.core.Keyword(null,"class","class",-2030961996),"dark"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"header","header",119441134),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h1","h1",-1896887462),new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.venue_name], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.venue_state], null)], null)], null)], null)], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"section","section",-300141526),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"light"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),"row"], null),new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"div","div",1057191632),new cljs.core.PersistentArrayMap(null, 1, [new cljs.core.Keyword(null,"class","class",-2030961996),vrng.talk.container_classes], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"h2","h2",-372662728),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.countdown,vrng.talk.time_to_next_talk.call(null)], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.talk_section,"live"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.talk_section,"prelive"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.talk_section,"archived"], null)], null)], null)], null)], null);
});
vrng.talk.inc_now = (function vrng$talk$inc_now(state_map){
return cljs.core.update_in.call(null,state_map,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"now","now",-1650525531)], null),cljs.core.inc);
});
vrng.talk.start_timer = (function vrng$talk$start_timer(){
return setInterval((function (){
return cljs.core.swap_BANG_.call(null,vrng.talk.state,vrng.talk.inc_now);
}),(1000));
});
vrng.talk.venue_channel = clojure.string.join.call(null,"/",new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [null,"down","venue",new cljs.core.Keyword(null,"id","id",-1388402092).cljs$core$IFn$_invoke$arity$1(new cljs.core.Keyword(null,"venue","venue",-731609643).cljs$core$IFn$_invoke$arity$1(cljs.core.deref.call(null,vrng.talk.state)))], null));
vrng.talk.setup_faye = (function vrng$talk$setup_faye(){
return fayeClient.subscribe(vrng.talk.venue_channel,(function (p1__28444_SHARP_){
return vrng.talk.venue_message_handler.call(null,cljs.core.js__GT_clj.call(null,p1__28444_SHARP_,new cljs.core.Keyword(null,"keywordize-keys","keywordize-keys",1310784252),true));
}));
});
vrng.talk.mount_root = (function vrng$talk$mount_root(){
reagent.core.render.call(null,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.home_page], null),document.getElementById("talk-app"));

return reagent.core.render.call(null,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.talk.countdown], null),document.getElementById("mount-countdown"));
});
vrng.talk.init_BANG_ = (function vrng$talk$init_BANG_(){
vrng.talk.start_timer.call(null);

vrng.talk.setup_faye.call(null);

return vrng.talk.mount_root.call(null);
});

//# sourceMappingURL=talk.js.map