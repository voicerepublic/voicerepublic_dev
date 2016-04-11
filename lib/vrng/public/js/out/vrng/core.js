// Compiled by ClojureScript 1.7.228 {:static-fns true, :optimize-constants true}
goog.provide('vrng.core');
goog.require('cljs.core');
goog.require('reagent.core');
goog.require('reagent.session');
goog.require('secretary.core');
goog.require('goog.string.format');
if(typeof vrng.core.state !== 'undefined'){
} else {
vrng.core.state = reagent.core.atom.cljs$core$IFn$_invoke$arity$1(cljs.core.js__GT_clj.cljs$core$IFn$_invoke$arity$variadic(window.initialState,cljs.core.array_seq([cljs.core.cst$kw$keywordize_DASH_keys,true], 0)));
}
if(typeof vrng.core.translations !== 'undefined'){
} else {
vrng.core.translations = reagent.core.atom.cljs$core$IFn$_invoke$arity$1(cljs.core.js__GT_clj.cljs$core$IFn$_invoke$arity$1(window.translations));
}
vrng.core.t = (function vrng$core$t(var_args){
var args__7218__auto__ = [];
var len__7211__auto___9563 = arguments.length;
var i__7212__auto___9564 = (0);
while(true){
if((i__7212__auto___9564 < len__7211__auto___9563)){
args__7218__auto__.push((arguments[i__7212__auto___9564]));

var G__9565 = (i__7212__auto___9564 + (1));
i__7212__auto___9564 = G__9565;
continue;
} else {
}
break;
}

var argseq__7219__auto__ = ((((0) < args__7218__auto__.length))?(new cljs.core.IndexedSeq(args__7218__auto__.slice((0)),(0))):null);
return vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(argseq__7219__auto__);
});

vrng.core.t.cljs$core$IFn$_invoke$arity$variadic = (function (key){
var keys = cljs.core.flatten(cljs.core.map.cljs$core$IFn$_invoke$arity$2((function (p1__9561_SHARP_){
return clojure.string.split.cljs$core$IFn$_invoke$arity$2(p1__9561_SHARP_,".");
}),key));
return cljs.core.reduce.cljs$core$IFn$_invoke$arity$3(cljs.core.get,(cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.translations) : cljs.core.deref.call(null,vrng.core.translations)),keys);
});

vrng.core.t.cljs$lang$maxFixedArity = (0);

vrng.core.t.cljs$lang$applyTo = (function (seq9562){
return vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq(seq9562));
});
vrng.core.talks_by_state = (function vrng$core$talks_by_state(talk_state){
return cljs.core.filter.cljs$core$IFn$_invoke$arity$2((function (p1__9566_SHARP_){
return cljs.core._EQ_.cljs$core$IFn$_invoke$arity$2(talk_state,cljs.core.cst$kw$state.cljs$core$IFn$_invoke$arity$1(p1__9566_SHARP_));
}),cljs.core.vals(cljs.core.cst$kw$talks.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state)))));
});
vrng.core.next_talk = (function vrng$core$next_talk(){
return cljs.core.last(cljs.core.sort.cljs$core$IFn$_invoke$arity$2(cljs.core.cst$kw$starts_at,vrng.core.talks_by_state("prelive")));
});
vrng.core.millis = (function vrng$core$millis(datetime){
return Date.parse(datetime);
});
vrng.core.time_to_next_talk = (function vrng$core$time_to_next_talk(){
return (vrng.core.millis(cljs.core.cst$kw$starts_at.cljs$core$IFn$_invoke$arity$1(vrng.core.next_talk())) - ((1000) * cljs.core.cst$kw$now.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state)))));
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
return vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq(["any_time_now"], 0));
} else {
if((hours > (48))){
return [cljs.core.str(days),cljs.core.str(" "),cljs.core.str(vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq(["days"], 0)))].join('');
} else {
return goog.string.format("%02d:%02d:%02d",hours,minutes,seconds);

}
}
});
vrng.core.format_datetime = (function vrng$core$format_datetime(datetime){
return Date.parse(datetime);
});
vrng.core.back_channel = clojure.string.join.cljs$core$IFn$_invoke$arity$2("/",new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [null,"up","user",cljs.core.cst$kw$id.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$user.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state)))),"venue",cljs.core.cst$kw$id.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$venue.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state))))], null));
vrng.core.publish = (function vrng$core$publish(message){
return fayeClient.publish(vrng.core.back_channel,cljs.core.clj__GT_js(message));
});
vrng.core.talk_button = (function vrng$core$talk_button(event,talk_id){
return (function (){
return vrng.core.publish(new cljs.core.PersistentArrayMap(null, 2, [cljs.core.cst$kw$event,event,cljs.core.cst$kw$talk_id,talk_id], null));
});
});
vrng.core.venue_state = (function vrng$core$venue_state(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$span,vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq(["state",cljs.core.cst$kw$state.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$venue.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state))))], 0))], null);
});
vrng.core.venue_name = (function vrng$core$venue_name(){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$span,cljs.core.cst$kw$name.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$venue.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state))))], null);
});
vrng.core.talk_comp = (function vrng$core$talk_comp(talk){
return cljs.core.with_meta(new cljs.core.PersistentVector(null, 5, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$li,(talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$starts_at) : talk.call(null,cljs.core.cst$kw$starts_at)),(talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$title) : talk.call(null,cljs.core.cst$kw$title)),((cljs.core._EQ_.cljs$core$IFn$_invoke$arity$2((talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$state) : talk.call(null,cljs.core.cst$kw$state)),"prelive"))?new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$button,new cljs.core.PersistentArrayMap(null, 3, [cljs.core.cst$kw$type,"button",cljs.core.cst$kw$class,"button",cljs.core.cst$kw$on_DASH_click,vrng.core.talk_button("start",(talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$id) : talk.call(null,cljs.core.cst$kw$id)))], null),vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq(["start"], 0))], null):null),((cljs.core._EQ_.cljs$core$IFn$_invoke$arity$2((talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$state) : talk.call(null,cljs.core.cst$kw$state)),"live"))?new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$button,new cljs.core.PersistentArrayMap(null, 3, [cljs.core.cst$kw$type,"button",cljs.core.cst$kw$class,"button alert",cljs.core.cst$kw$on_DASH_click,vrng.core.talk_button("stop",(talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$id) : talk.call(null,cljs.core.cst$kw$id)))], null),vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq(["stop"], 0))], null):null)], null),new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$key,(talk.cljs$core$IFn$_invoke$arity$1 ? talk.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$id) : talk.call(null,cljs.core.cst$kw$id))], null));
});
vrng.core.talk_listing = (function vrng$core$talk_listing(talk_state){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$ul,cljs.core.doall.cljs$core$IFn$_invoke$arity$1(cljs.core.map.cljs$core$IFn$_invoke$arity$2(vrng.core.talk_comp,vrng.core.talks_by_state(talk_state)))], null);
});
vrng.core.talk_section = (function vrng$core$talk_section(talk_state){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$div,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$h3,vrng.core.t.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq(["talk_state",talk_state], 0))], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_listing,talk_state], null)], null);
});
vrng.core.countdown = (function vrng$core$countdown(millis){
return new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$span,vrng.core.format_countdown(millis)], null);
});
vrng.core.set_talk_state = (function vrng$core$set_talk_state(talk_state,talk_id){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$2(vrng.core.state,(function (p1__9567_SHARP_){
return cljs.core.assoc_in(p1__9567_SHARP_,new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$talks,cljs.core.keyword.cljs$core$IFn$_invoke$arity$1(talk_id),cljs.core.cst$kw$state], null),talk_state);
}));
});
vrng.core.venue_message_handler = (function vrng$core$venue_message_handler(msg){
cljs.core.print.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([msg], 0));

if(cljs.core._EQ_.cljs$core$IFn$_invoke$arity$2((msg.cljs$core$IFn$_invoke$arity$1 ? msg.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$event) : msg.call(null,cljs.core.cst$kw$event)),"start_talk")){
return vrng.core.set_talk_state("live",(msg.cljs$core$IFn$_invoke$arity$1 ? msg.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$talk_id) : msg.call(null,cljs.core.cst$kw$talk_id)));
} else {
return cljs.core.print.cljs$core$IFn$_invoke$arity$variadic(cljs.core.array_seq([msg], 0));

}
});
vrng.core.container_classes = "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left";
vrng.core.home_page = (function vrng$core$home_page(){
return new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$div,new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$section,new cljs.core.PersistentArrayMap(null, 2, [cljs.core.cst$kw$id,"claim",cljs.core.cst$kw$class,"dark"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$div,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$class,"row"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$header,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$h1,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.venue_name], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$h2,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.venue_state], null)], null)], null)], null)], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$section,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$class,"light"], null),new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$div,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$class,"row"], null),new cljs.core.PersistentVector(null, 6, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$div,new cljs.core.PersistentArrayMap(null, 1, [cljs.core.cst$kw$class,vrng.core.container_classes], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$h2,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.countdown,vrng.core.time_to_next_talk()], null)], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_section,"live"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_section,"prelive"], null),new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.talk_section,"archived"], null)], null)], null)], null)], null);
});
vrng.core.inc_now = (function vrng$core$inc_now(state_map){
return cljs.core.update_in.cljs$core$IFn$_invoke$arity$3(state_map,new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [cljs.core.cst$kw$now], null),cljs.core.inc);
});
vrng.core.start_timer = (function vrng$core$start_timer(){
var G__9570 = (function (){
return cljs.core.swap_BANG_.cljs$core$IFn$_invoke$arity$2(vrng.core.state,vrng.core.inc_now);
});
var G__9571 = (1000);
return setInterval(G__9570,G__9571);
});
vrng.core.venue_channel = clojure.string.join.cljs$core$IFn$_invoke$arity$2("/",new cljs.core.PersistentVector(null, 4, 5, cljs.core.PersistentVector.EMPTY_NODE, [null,"down","venue",cljs.core.cst$kw$id.cljs$core$IFn$_invoke$arity$1(cljs.core.cst$kw$venue.cljs$core$IFn$_invoke$arity$1((cljs.core.deref.cljs$core$IFn$_invoke$arity$1 ? cljs.core.deref.cljs$core$IFn$_invoke$arity$1(vrng.core.state) : cljs.core.deref.call(null,vrng.core.state))))], null));
vrng.core.setup_faye = (function vrng$core$setup_faye(){
return fayeClient.subscribe(vrng.core.venue_channel,(function (p1__9572_SHARP_){
return vrng.core.venue_message_handler(cljs.core.js__GT_clj.cljs$core$IFn$_invoke$arity$variadic(p1__9572_SHARP_,cljs.core.array_seq([cljs.core.cst$kw$keywordize_DASH_keys,true], 0)));
}));
});
vrng.core.mount_root = (function vrng$core$mount_root(){
return reagent.core.render.cljs$core$IFn$_invoke$arity$2(new cljs.core.PersistentVector(null, 1, 5, cljs.core.PersistentVector.EMPTY_NODE, [vrng.core.home_page], null),document.getElementById("app"));
});
vrng.core.init_BANG_ = (function vrng$core$init_BANG_(){
vrng.core.start_timer();

vrng.core.setup_faye();

return vrng.core.mount_root();
});
