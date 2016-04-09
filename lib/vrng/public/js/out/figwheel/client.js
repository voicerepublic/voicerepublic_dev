// Compiled by ClojureScript 1.7.228 {}
goog.provide('figwheel.client');
goog.require('cljs.core');
goog.require('goog.userAgent.product');
goog.require('goog.Uri');
goog.require('cljs.core.async');
goog.require('figwheel.client.socket');
goog.require('figwheel.client.file_reloading');
goog.require('clojure.string');
goog.require('figwheel.client.utils');
goog.require('cljs.repl');
goog.require('figwheel.client.heads_up');
figwheel.client.figwheel_repl_print = (function figwheel$client$figwheel_repl_print(args){
figwheel.client.socket.send_BANG_.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"figwheel-event","figwheel-event",519570592),"callback",new cljs.core.Keyword(null,"callback-name","callback-name",336964714),"figwheel-repl-print",new cljs.core.Keyword(null,"content","content",15833224),args], null));

return args;
});
figwheel.client.autoload_QMARK_ = (cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))?(function (){
var pred__25374 = cljs.core._EQ_;
var expr__25375 = (function (){var or__18370__auto__ = (function (){try{return localStorage.getItem("figwheel_autoload");
}catch (e25378){if((e25378 instanceof Error)){
var e = e25378;
return false;
} else {
throw e25378;

}
}})();
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return "true";
}
})();
if(cljs.core.truth_(pred__25374.call(null,"true",expr__25375))){
return true;
} else {
if(cljs.core.truth_(pred__25374.call(null,"false",expr__25375))){
return false;
} else {
throw (new Error([cljs.core.str("No matching clause: "),cljs.core.str(expr__25375)].join('')));
}
}
}):(function (){
return true;
}));
figwheel.client.toggle_autoload = (function figwheel$client$toggle_autoload(){
if(cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))){
try{localStorage.setItem("figwheel_autoload",cljs.core.not.call(null,figwheel.client.autoload_QMARK_.call(null)));

return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Figwheel autoloading "),cljs.core.str((cljs.core.truth_(figwheel.client.autoload_QMARK_.call(null))?"ON":"OFF"))].join(''));
}catch (e25380){if((e25380 instanceof Error)){
var e = e25380;
return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Unable to access localStorage")].join(''));
} else {
throw e25380;

}
}} else {
return null;
}
});
goog.exportSymbol('figwheel.client.toggle_autoload', figwheel.client.toggle_autoload);
figwheel.client.console_print = (function figwheel$client$console_print(args){
console.log.apply(console,cljs.core.into_array.call(null,args));

return args;
});
figwheel.client.repl_print_fn = (function figwheel$client$repl_print_fn(var_args){
var args__19435__auto__ = [];
var len__19428__auto___25382 = arguments.length;
var i__19429__auto___25383 = (0);
while(true){
if((i__19429__auto___25383 < len__19428__auto___25382)){
args__19435__auto__.push((arguments[i__19429__auto___25383]));

var G__25384 = (i__19429__auto___25383 + (1));
i__19429__auto___25383 = G__25384;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return figwheel.client.repl_print_fn.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

figwheel.client.repl_print_fn.cljs$core$IFn$_invoke$arity$variadic = (function (args){
figwheel.client.figwheel_repl_print.call(null,figwheel.client.console_print.call(null,args));

return null;
});

figwheel.client.repl_print_fn.cljs$lang$maxFixedArity = (0);

figwheel.client.repl_print_fn.cljs$lang$applyTo = (function (seq25381){
return figwheel.client.repl_print_fn.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq25381));
});
figwheel.client.enable_repl_print_BANG_ = (function figwheel$client$enable_repl_print_BANG_(){
cljs.core._STAR_print_newline_STAR_ = false;

return cljs.core._STAR_print_fn_STAR_ = figwheel.client.repl_print_fn;
});
figwheel.client.get_essential_messages = (function figwheel$client$get_essential_messages(ed){
if(cljs.core.truth_(ed)){
return cljs.core.cons.call(null,cljs.core.select_keys.call(null,ed,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"message","message",-406056002),new cljs.core.Keyword(null,"class","class",-2030961996)], null)),figwheel$client$get_essential_messages.call(null,new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(ed)));
} else {
return null;
}
});
figwheel.client.error_msg_format = (function figwheel$client$error_msg_format(p__25385){
var map__25388 = p__25385;
var map__25388__$1 = ((((!((map__25388 == null)))?((((map__25388.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25388.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25388):map__25388);
var message = cljs.core.get.call(null,map__25388__$1,new cljs.core.Keyword(null,"message","message",-406056002));
var class$ = cljs.core.get.call(null,map__25388__$1,new cljs.core.Keyword(null,"class","class",-2030961996));
return [cljs.core.str(class$),cljs.core.str(" : "),cljs.core.str(message)].join('');
});
figwheel.client.format_messages = cljs.core.comp.call(null,cljs.core.partial.call(null,cljs.core.map,figwheel.client.error_msg_format),figwheel.client.get_essential_messages);
figwheel.client.focus_msgs = (function figwheel$client$focus_msgs(name_set,msg_hist){
return cljs.core.cons.call(null,cljs.core.first.call(null,msg_hist),cljs.core.filter.call(null,cljs.core.comp.call(null,name_set,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863)),cljs.core.rest.call(null,msg_hist)));
});
figwheel.client.reload_file_QMARK__STAR_ = (function figwheel$client$reload_file_QMARK__STAR_(msg_name,opts){
var or__18370__auto__ = new cljs.core.Keyword(null,"load-warninged-code","load-warninged-code",-2030345223).cljs$core$IFn$_invoke$arity$1(opts);
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return cljs.core.not_EQ_.call(null,msg_name,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356));
}
});
figwheel.client.reload_file_state_QMARK_ = (function figwheel$client$reload_file_state_QMARK_(msg_names,opts){
var and__18358__auto__ = cljs.core._EQ_.call(null,cljs.core.first.call(null,msg_names),new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563));
if(and__18358__auto__){
return figwheel.client.reload_file_QMARK__STAR_.call(null,cljs.core.second.call(null,msg_names),opts);
} else {
return and__18358__auto__;
}
});
figwheel.client.block_reload_file_state_QMARK_ = (function figwheel$client$block_reload_file_state_QMARK_(msg_names,opts){
return (cljs.core._EQ_.call(null,cljs.core.first.call(null,msg_names),new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563))) && (cljs.core.not.call(null,figwheel.client.reload_file_QMARK__STAR_.call(null,cljs.core.second.call(null,msg_names),opts)));
});
figwheel.client.warning_append_state_QMARK_ = (function figwheel$client$warning_append_state_QMARK_(msg_names){
return cljs.core._EQ_.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356)], null),cljs.core.take.call(null,(2),msg_names));
});
figwheel.client.warning_state_QMARK_ = (function figwheel$client$warning_state_QMARK_(msg_names){
return cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),cljs.core.first.call(null,msg_names));
});
figwheel.client.rewarning_state_QMARK_ = (function figwheel$client$rewarning_state_QMARK_(msg_names){
return cljs.core._EQ_.call(null,new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356)], null),cljs.core.take.call(null,(3),msg_names));
});
figwheel.client.compile_fail_state_QMARK_ = (function figwheel$client$compile_fail_state_QMARK_(msg_names){
return cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),cljs.core.first.call(null,msg_names));
});
figwheel.client.compile_refail_state_QMARK_ = (function figwheel$client$compile_refail_state_QMARK_(msg_names){
return cljs.core._EQ_.call(null,new cljs.core.PersistentVector(null, 2, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289)], null),cljs.core.take.call(null,(2),msg_names));
});
figwheel.client.css_loaded_state_QMARK_ = (function figwheel$client$css_loaded_state_QMARK_(msg_names){
return cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"css-files-changed","css-files-changed",720773874),cljs.core.first.call(null,msg_names));
});
figwheel.client.file_reloader_plugin = (function figwheel$client$file_reloader_plugin(opts){
var ch = cljs.core.async.chan.call(null);
var c__21037__auto___25550 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___25550,ch){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___25550,ch){
return (function (state_25519){
var state_val_25520 = (state_25519[(1)]);
if((state_val_25520 === (7))){
var inst_25515 = (state_25519[(2)]);
var state_25519__$1 = state_25519;
var statearr_25521_25551 = state_25519__$1;
(statearr_25521_25551[(2)] = inst_25515);

(statearr_25521_25551[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (1))){
var state_25519__$1 = state_25519;
var statearr_25522_25552 = state_25519__$1;
(statearr_25522_25552[(2)] = null);

(statearr_25522_25552[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (4))){
var inst_25472 = (state_25519[(7)]);
var inst_25472__$1 = (state_25519[(2)]);
var state_25519__$1 = (function (){var statearr_25523 = state_25519;
(statearr_25523[(7)] = inst_25472__$1);

return statearr_25523;
})();
if(cljs.core.truth_(inst_25472__$1)){
var statearr_25524_25553 = state_25519__$1;
(statearr_25524_25553[(1)] = (5));

} else {
var statearr_25525_25554 = state_25519__$1;
(statearr_25525_25554[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (15))){
var inst_25479 = (state_25519[(8)]);
var inst_25494 = new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(inst_25479);
var inst_25495 = cljs.core.first.call(null,inst_25494);
var inst_25496 = new cljs.core.Keyword(null,"file","file",-1269645878).cljs$core$IFn$_invoke$arity$1(inst_25495);
var inst_25497 = [cljs.core.str("Figwheel: Not loading code with warnings - "),cljs.core.str(inst_25496)].join('');
var inst_25498 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),inst_25497);
var state_25519__$1 = state_25519;
var statearr_25526_25555 = state_25519__$1;
(statearr_25526_25555[(2)] = inst_25498);

(statearr_25526_25555[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (13))){
var inst_25503 = (state_25519[(2)]);
var state_25519__$1 = state_25519;
var statearr_25527_25556 = state_25519__$1;
(statearr_25527_25556[(2)] = inst_25503);

(statearr_25527_25556[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (6))){
var state_25519__$1 = state_25519;
var statearr_25528_25557 = state_25519__$1;
(statearr_25528_25557[(2)] = null);

(statearr_25528_25557[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (17))){
var inst_25501 = (state_25519[(2)]);
var state_25519__$1 = state_25519;
var statearr_25529_25558 = state_25519__$1;
(statearr_25529_25558[(2)] = inst_25501);

(statearr_25529_25558[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (3))){
var inst_25517 = (state_25519[(2)]);
var state_25519__$1 = state_25519;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25519__$1,inst_25517);
} else {
if((state_val_25520 === (12))){
var inst_25478 = (state_25519[(9)]);
var inst_25492 = figwheel.client.block_reload_file_state_QMARK_.call(null,inst_25478,opts);
var state_25519__$1 = state_25519;
if(cljs.core.truth_(inst_25492)){
var statearr_25530_25559 = state_25519__$1;
(statearr_25530_25559[(1)] = (15));

} else {
var statearr_25531_25560 = state_25519__$1;
(statearr_25531_25560[(1)] = (16));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (2))){
var state_25519__$1 = state_25519;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25519__$1,(4),ch);
} else {
if((state_val_25520 === (11))){
var inst_25479 = (state_25519[(8)]);
var inst_25484 = cljs.core.PersistentVector.EMPTY_NODE;
var inst_25485 = figwheel.client.file_reloading.reload_js_files.call(null,opts,inst_25479);
var inst_25486 = cljs.core.async.timeout.call(null,(1000));
var inst_25487 = [inst_25485,inst_25486];
var inst_25488 = (new cljs.core.PersistentVector(null,2,(5),inst_25484,inst_25487,null));
var state_25519__$1 = state_25519;
return cljs.core.async.ioc_alts_BANG_.call(null,state_25519__$1,(14),inst_25488);
} else {
if((state_val_25520 === (9))){
var inst_25479 = (state_25519[(8)]);
var inst_25505 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),"Figwheel: code autoloading is OFF");
var inst_25506 = new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(inst_25479);
var inst_25507 = cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),inst_25506);
var inst_25508 = [cljs.core.str("Not loading: "),cljs.core.str(inst_25507)].join('');
var inst_25509 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),inst_25508);
var state_25519__$1 = (function (){var statearr_25532 = state_25519;
(statearr_25532[(10)] = inst_25505);

return statearr_25532;
})();
var statearr_25533_25561 = state_25519__$1;
(statearr_25533_25561[(2)] = inst_25509);

(statearr_25533_25561[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (5))){
var inst_25472 = (state_25519[(7)]);
var inst_25474 = [new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),null,new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),null];
var inst_25475 = (new cljs.core.PersistentArrayMap(null,2,inst_25474,null));
var inst_25476 = (new cljs.core.PersistentHashSet(null,inst_25475,null));
var inst_25477 = figwheel.client.focus_msgs.call(null,inst_25476,inst_25472);
var inst_25478 = cljs.core.map.call(null,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863),inst_25477);
var inst_25479 = cljs.core.first.call(null,inst_25477);
var inst_25480 = figwheel.client.autoload_QMARK_.call(null);
var state_25519__$1 = (function (){var statearr_25534 = state_25519;
(statearr_25534[(9)] = inst_25478);

(statearr_25534[(8)] = inst_25479);

return statearr_25534;
})();
if(cljs.core.truth_(inst_25480)){
var statearr_25535_25562 = state_25519__$1;
(statearr_25535_25562[(1)] = (8));

} else {
var statearr_25536_25563 = state_25519__$1;
(statearr_25536_25563[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (14))){
var inst_25490 = (state_25519[(2)]);
var state_25519__$1 = state_25519;
var statearr_25537_25564 = state_25519__$1;
(statearr_25537_25564[(2)] = inst_25490);

(statearr_25537_25564[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (16))){
var state_25519__$1 = state_25519;
var statearr_25538_25565 = state_25519__$1;
(statearr_25538_25565[(2)] = null);

(statearr_25538_25565[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (10))){
var inst_25511 = (state_25519[(2)]);
var state_25519__$1 = (function (){var statearr_25539 = state_25519;
(statearr_25539[(11)] = inst_25511);

return statearr_25539;
})();
var statearr_25540_25566 = state_25519__$1;
(statearr_25540_25566[(2)] = null);

(statearr_25540_25566[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25520 === (8))){
var inst_25478 = (state_25519[(9)]);
var inst_25482 = figwheel.client.reload_file_state_QMARK_.call(null,inst_25478,opts);
var state_25519__$1 = state_25519;
if(cljs.core.truth_(inst_25482)){
var statearr_25541_25567 = state_25519__$1;
(statearr_25541_25567[(1)] = (11));

} else {
var statearr_25542_25568 = state_25519__$1;
(statearr_25542_25568[(1)] = (12));

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
});})(c__21037__auto___25550,ch))
;
return ((function (switch__20925__auto__,c__21037__auto___25550,ch){
return (function() {
var figwheel$client$file_reloader_plugin_$_state_machine__20926__auto__ = null;
var figwheel$client$file_reloader_plugin_$_state_machine__20926__auto____0 = (function (){
var statearr_25546 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_25546[(0)] = figwheel$client$file_reloader_plugin_$_state_machine__20926__auto__);

(statearr_25546[(1)] = (1));

return statearr_25546;
});
var figwheel$client$file_reloader_plugin_$_state_machine__20926__auto____1 = (function (state_25519){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_25519);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e25547){if((e25547 instanceof Object)){
var ex__20929__auto__ = e25547;
var statearr_25548_25569 = state_25519;
(statearr_25548_25569[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25519);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25547;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25570 = state_25519;
state_25519 = G__25570;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$file_reloader_plugin_$_state_machine__20926__auto__ = function(state_25519){
switch(arguments.length){
case 0:
return figwheel$client$file_reloader_plugin_$_state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$file_reloader_plugin_$_state_machine__20926__auto____1.call(this,state_25519);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloader_plugin_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloader_plugin_$_state_machine__20926__auto____0;
figwheel$client$file_reloader_plugin_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloader_plugin_$_state_machine__20926__auto____1;
return figwheel$client$file_reloader_plugin_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___25550,ch))
})();
var state__21039__auto__ = (function (){var statearr_25549 = f__21038__auto__.call(null);
(statearr_25549[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___25550);

return statearr_25549;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___25550,ch))
);


return ((function (ch){
return (function (msg_hist){
cljs.core.async.put_BANG_.call(null,ch,msg_hist);

return msg_hist;
});
;})(ch))
});
figwheel.client.truncate_stack_trace = (function figwheel$client$truncate_stack_trace(stack_str){
return cljs.core.take_while.call(null,(function (p1__25571_SHARP_){
return cljs.core.not.call(null,cljs.core.re_matches.call(null,/.*eval_javascript_STAR__STAR_.*/,p1__25571_SHARP_));
}),clojure.string.split_lines.call(null,stack_str));
});
figwheel.client.get_ua_product = (function figwheel$client$get_ua_product(){
if(cljs.core.truth_(figwheel.client.utils.node_env_QMARK_.call(null))){
return new cljs.core.Keyword(null,"chrome","chrome",1718738387);
} else {
if(cljs.core.truth_(goog.userAgent.product.SAFARI)){
return new cljs.core.Keyword(null,"safari","safari",497115653);
} else {
if(cljs.core.truth_(goog.userAgent.product.CHROME)){
return new cljs.core.Keyword(null,"chrome","chrome",1718738387);
} else {
if(cljs.core.truth_(goog.userAgent.product.FIREFOX)){
return new cljs.core.Keyword(null,"firefox","firefox",1283768880);
} else {
if(cljs.core.truth_(goog.userAgent.product.IE)){
return new cljs.core.Keyword(null,"ie","ie",2038473780);
} else {
return null;
}
}
}
}
}
});
var base_path_25578 = figwheel.client.utils.base_url_path.call(null);
figwheel.client.eval_javascript_STAR__STAR_ = ((function (base_path_25578){
return (function figwheel$client$eval_javascript_STAR__STAR_(code,opts,result_handler){
try{var _STAR_print_fn_STAR_25576 = cljs.core._STAR_print_fn_STAR_;
var _STAR_print_newline_STAR_25577 = cljs.core._STAR_print_newline_STAR_;
cljs.core._STAR_print_fn_STAR_ = figwheel.client.repl_print_fn;

cljs.core._STAR_print_newline_STAR_ = false;

try{return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"success","success",1890645906),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"value","value",305978217),figwheel.client.utils.eval_helper.call(null,code,opts)], null));
}finally {cljs.core._STAR_print_newline_STAR_ = _STAR_print_newline_STAR_25577;

cljs.core._STAR_print_fn_STAR_ = _STAR_print_fn_STAR_25576;
}}catch (e25575){if((e25575 instanceof Error)){
var e = e25575;
return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 5, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"exception","exception",-335277064),new cljs.core.Keyword(null,"value","value",305978217),cljs.core.pr_str.call(null,e),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"stacktrace","stacktrace",-95588394),clojure.string.join.call(null,"\n",figwheel.client.truncate_stack_trace.call(null,e.stack)),new cljs.core.Keyword(null,"base-path","base-path",495760020),base_path_25578], null));
} else {
var e = e25575;
return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 4, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"exception","exception",-335277064),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"value","value",305978217),cljs.core.pr_str.call(null,e),new cljs.core.Keyword(null,"stacktrace","stacktrace",-95588394),"No stacktrace available."], null));

}
}});})(base_path_25578))
;
/**
 * The REPL can disconnect and reconnect lets ensure cljs.user exists at least.
 */
figwheel.client.ensure_cljs_user = (function figwheel$client$ensure_cljs_user(){
if(cljs.core.truth_(cljs.user)){
return null;
} else {
return cljs.user = {};
}
});
figwheel.client.repl_plugin = (function figwheel$client$repl_plugin(p__25579){
var map__25586 = p__25579;
var map__25586__$1 = ((((!((map__25586 == null)))?((((map__25586.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25586.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25586):map__25586);
var opts = map__25586__$1;
var build_id = cljs.core.get.call(null,map__25586__$1,new cljs.core.Keyword(null,"build-id","build-id",1642831089));
return ((function (map__25586,map__25586__$1,opts,build_id){
return (function (p__25588){
var vec__25589 = p__25588;
var map__25590 = cljs.core.nth.call(null,vec__25589,(0),null);
var map__25590__$1 = ((((!((map__25590 == null)))?((((map__25590.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25590.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25590):map__25590);
var msg = map__25590__$1;
var msg_name = cljs.core.get.call(null,map__25590__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25589,(1));
if(cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"repl-eval","repl-eval",-1784727398),msg_name)){
figwheel.client.ensure_cljs_user.call(null);

return figwheel.client.eval_javascript_STAR__STAR_.call(null,new cljs.core.Keyword(null,"code","code",1586293142).cljs$core$IFn$_invoke$arity$1(msg),opts,((function (vec__25589,map__25590,map__25590__$1,msg,msg_name,_,map__25586,map__25586__$1,opts,build_id){
return (function (res){
return figwheel.client.socket.send_BANG_.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"figwheel-event","figwheel-event",519570592),"callback",new cljs.core.Keyword(null,"callback-name","callback-name",336964714),new cljs.core.Keyword(null,"callback-name","callback-name",336964714).cljs$core$IFn$_invoke$arity$1(msg),new cljs.core.Keyword(null,"content","content",15833224),res], null));
});})(vec__25589,map__25590,map__25590__$1,msg,msg_name,_,map__25586,map__25586__$1,opts,build_id))
);
} else {
return null;
}
});
;})(map__25586,map__25586__$1,opts,build_id))
});
figwheel.client.css_reloader_plugin = (function figwheel$client$css_reloader_plugin(opts){
return (function (p__25596){
var vec__25597 = p__25596;
var map__25598 = cljs.core.nth.call(null,vec__25597,(0),null);
var map__25598__$1 = ((((!((map__25598 == null)))?((((map__25598.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25598.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25598):map__25598);
var msg = map__25598__$1;
var msg_name = cljs.core.get.call(null,map__25598__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25597,(1));
if(cljs.core._EQ_.call(null,msg_name,new cljs.core.Keyword(null,"css-files-changed","css-files-changed",720773874))){
return figwheel.client.file_reloading.reload_css_files.call(null,opts,msg);
} else {
return null;
}
});
});
figwheel.client.compile_fail_warning_plugin = (function figwheel$client$compile_fail_warning_plugin(p__25600){
var map__25610 = p__25600;
var map__25610__$1 = ((((!((map__25610 == null)))?((((map__25610.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25610.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25610):map__25610);
var on_compile_warning = cljs.core.get.call(null,map__25610__$1,new cljs.core.Keyword(null,"on-compile-warning","on-compile-warning",-1195585947));
var on_compile_fail = cljs.core.get.call(null,map__25610__$1,new cljs.core.Keyword(null,"on-compile-fail","on-compile-fail",728013036));
return ((function (map__25610,map__25610__$1,on_compile_warning,on_compile_fail){
return (function (p__25612){
var vec__25613 = p__25612;
var map__25614 = cljs.core.nth.call(null,vec__25613,(0),null);
var map__25614__$1 = ((((!((map__25614 == null)))?((((map__25614.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25614.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25614):map__25614);
var msg = map__25614__$1;
var msg_name = cljs.core.get.call(null,map__25614__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25613,(1));
var pred__25616 = cljs.core._EQ_;
var expr__25617 = msg_name;
if(cljs.core.truth_(pred__25616.call(null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),expr__25617))){
return on_compile_warning.call(null,msg);
} else {
if(cljs.core.truth_(pred__25616.call(null,new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),expr__25617))){
return on_compile_fail.call(null,msg);
} else {
return null;
}
}
});
;})(map__25610,map__25610__$1,on_compile_warning,on_compile_fail))
});
figwheel.client.heads_up_plugin_msg_handler = (function figwheel$client$heads_up_plugin_msg_handler(opts,msg_hist_SINGLEQUOTE_){
var msg_hist = figwheel.client.focus_msgs.call(null,new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),null,new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),null], null), null),msg_hist_SINGLEQUOTE_);
var msg_names = cljs.core.map.call(null,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863),msg_hist);
var msg = cljs.core.first.call(null,msg_hist);
var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__,msg_hist,msg_names,msg){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__,msg_hist,msg_names,msg){
return (function (state_25833){
var state_val_25834 = (state_25833[(1)]);
if((state_val_25834 === (7))){
var inst_25757 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25757)){
var statearr_25835_25881 = state_25833__$1;
(statearr_25835_25881[(1)] = (8));

} else {
var statearr_25836_25882 = state_25833__$1;
(statearr_25836_25882[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (20))){
var inst_25827 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25837_25883 = state_25833__$1;
(statearr_25837_25883[(2)] = inst_25827);

(statearr_25837_25883[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (27))){
var inst_25823 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25838_25884 = state_25833__$1;
(statearr_25838_25884[(2)] = inst_25823);

(statearr_25838_25884[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (1))){
var inst_25750 = figwheel.client.reload_file_state_QMARK_.call(null,msg_names,opts);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25750)){
var statearr_25839_25885 = state_25833__$1;
(statearr_25839_25885[(1)] = (2));

} else {
var statearr_25840_25886 = state_25833__$1;
(statearr_25840_25886[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (24))){
var inst_25825 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25841_25887 = state_25833__$1;
(statearr_25841_25887[(2)] = inst_25825);

(statearr_25841_25887[(1)] = (20));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (4))){
var inst_25831 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25833__$1,inst_25831);
} else {
if((state_val_25834 === (15))){
var inst_25829 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25842_25888 = state_25833__$1;
(statearr_25842_25888[(2)] = inst_25829);

(statearr_25842_25888[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (21))){
var inst_25788 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25843_25889 = state_25833__$1;
(statearr_25843_25889[(2)] = inst_25788);

(statearr_25843_25889[(1)] = (20));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (31))){
var inst_25812 = figwheel.client.css_loaded_state_QMARK_.call(null,msg_names);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25812)){
var statearr_25844_25890 = state_25833__$1;
(statearr_25844_25890[(1)] = (34));

} else {
var statearr_25845_25891 = state_25833__$1;
(statearr_25845_25891[(1)] = (35));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (32))){
var inst_25821 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25846_25892 = state_25833__$1;
(statearr_25846_25892[(2)] = inst_25821);

(statearr_25846_25892[(1)] = (27));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (33))){
var inst_25810 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25847_25893 = state_25833__$1;
(statearr_25847_25893[(2)] = inst_25810);

(statearr_25847_25893[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (13))){
var inst_25771 = figwheel.client.heads_up.clear.call(null);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(16),inst_25771);
} else {
if((state_val_25834 === (22))){
var inst_25792 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25793 = figwheel.client.heads_up.append_message.call(null,inst_25792);
var state_25833__$1 = state_25833;
var statearr_25848_25894 = state_25833__$1;
(statearr_25848_25894[(2)] = inst_25793);

(statearr_25848_25894[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (36))){
var inst_25819 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25849_25895 = state_25833__$1;
(statearr_25849_25895[(2)] = inst_25819);

(statearr_25849_25895[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (29))){
var inst_25803 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25850_25896 = state_25833__$1;
(statearr_25850_25896[(2)] = inst_25803);

(statearr_25850_25896[(1)] = (27));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (6))){
var inst_25752 = (state_25833[(7)]);
var state_25833__$1 = state_25833;
var statearr_25851_25897 = state_25833__$1;
(statearr_25851_25897[(2)] = inst_25752);

(statearr_25851_25897[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (28))){
var inst_25799 = (state_25833[(2)]);
var inst_25800 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25801 = figwheel.client.heads_up.display_warning.call(null,inst_25800);
var state_25833__$1 = (function (){var statearr_25852 = state_25833;
(statearr_25852[(8)] = inst_25799);

return statearr_25852;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(29),inst_25801);
} else {
if((state_val_25834 === (25))){
var inst_25797 = figwheel.client.heads_up.clear.call(null);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(28),inst_25797);
} else {
if((state_val_25834 === (34))){
var inst_25814 = figwheel.client.heads_up.flash_loaded.call(null);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(37),inst_25814);
} else {
if((state_val_25834 === (17))){
var inst_25779 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25853_25898 = state_25833__$1;
(statearr_25853_25898[(2)] = inst_25779);

(statearr_25853_25898[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (3))){
var inst_25769 = figwheel.client.compile_refail_state_QMARK_.call(null,msg_names);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25769)){
var statearr_25854_25899 = state_25833__$1;
(statearr_25854_25899[(1)] = (13));

} else {
var statearr_25855_25900 = state_25833__$1;
(statearr_25855_25900[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (12))){
var inst_25765 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25856_25901 = state_25833__$1;
(statearr_25856_25901[(2)] = inst_25765);

(statearr_25856_25901[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (2))){
var inst_25752 = (state_25833[(7)]);
var inst_25752__$1 = figwheel.client.autoload_QMARK_.call(null);
var state_25833__$1 = (function (){var statearr_25857 = state_25833;
(statearr_25857[(7)] = inst_25752__$1);

return statearr_25857;
})();
if(cljs.core.truth_(inst_25752__$1)){
var statearr_25858_25902 = state_25833__$1;
(statearr_25858_25902[(1)] = (5));

} else {
var statearr_25859_25903 = state_25833__$1;
(statearr_25859_25903[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (23))){
var inst_25795 = figwheel.client.rewarning_state_QMARK_.call(null,msg_names);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25795)){
var statearr_25860_25904 = state_25833__$1;
(statearr_25860_25904[(1)] = (25));

} else {
var statearr_25861_25905 = state_25833__$1;
(statearr_25861_25905[(1)] = (26));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (35))){
var state_25833__$1 = state_25833;
var statearr_25862_25906 = state_25833__$1;
(statearr_25862_25906[(2)] = null);

(statearr_25862_25906[(1)] = (36));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (19))){
var inst_25790 = figwheel.client.warning_append_state_QMARK_.call(null,msg_names);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25790)){
var statearr_25863_25907 = state_25833__$1;
(statearr_25863_25907[(1)] = (22));

} else {
var statearr_25864_25908 = state_25833__$1;
(statearr_25864_25908[(1)] = (23));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (11))){
var inst_25761 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25865_25909 = state_25833__$1;
(statearr_25865_25909[(2)] = inst_25761);

(statearr_25865_25909[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (9))){
var inst_25763 = figwheel.client.heads_up.clear.call(null);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(12),inst_25763);
} else {
if((state_val_25834 === (5))){
var inst_25754 = new cljs.core.Keyword(null,"autoload","autoload",-354122500).cljs$core$IFn$_invoke$arity$1(opts);
var state_25833__$1 = state_25833;
var statearr_25866_25910 = state_25833__$1;
(statearr_25866_25910[(2)] = inst_25754);

(statearr_25866_25910[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (14))){
var inst_25781 = figwheel.client.compile_fail_state_QMARK_.call(null,msg_names);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25781)){
var statearr_25867_25911 = state_25833__$1;
(statearr_25867_25911[(1)] = (18));

} else {
var statearr_25868_25912 = state_25833__$1;
(statearr_25868_25912[(1)] = (19));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (26))){
var inst_25805 = figwheel.client.warning_state_QMARK_.call(null,msg_names);
var state_25833__$1 = state_25833;
if(cljs.core.truth_(inst_25805)){
var statearr_25869_25913 = state_25833__$1;
(statearr_25869_25913[(1)] = (30));

} else {
var statearr_25870_25914 = state_25833__$1;
(statearr_25870_25914[(1)] = (31));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (16))){
var inst_25773 = (state_25833[(2)]);
var inst_25774 = new cljs.core.Keyword(null,"exception-data","exception-data",-512474886).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25775 = figwheel.client.format_messages.call(null,inst_25774);
var inst_25776 = new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25777 = figwheel.client.heads_up.display_error.call(null,inst_25775,inst_25776);
var state_25833__$1 = (function (){var statearr_25871 = state_25833;
(statearr_25871[(9)] = inst_25773);

return statearr_25871;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(17),inst_25777);
} else {
if((state_val_25834 === (30))){
var inst_25807 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25808 = figwheel.client.heads_up.display_warning.call(null,inst_25807);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(33),inst_25808);
} else {
if((state_val_25834 === (10))){
var inst_25767 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25872_25915 = state_25833__$1;
(statearr_25872_25915[(2)] = inst_25767);

(statearr_25872_25915[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (18))){
var inst_25783 = new cljs.core.Keyword(null,"exception-data","exception-data",-512474886).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25784 = figwheel.client.format_messages.call(null,inst_25783);
var inst_25785 = new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25786 = figwheel.client.heads_up.display_error.call(null,inst_25784,inst_25785);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(21),inst_25786);
} else {
if((state_val_25834 === (37))){
var inst_25816 = (state_25833[(2)]);
var state_25833__$1 = state_25833;
var statearr_25873_25916 = state_25833__$1;
(statearr_25873_25916[(2)] = inst_25816);

(statearr_25873_25916[(1)] = (36));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25834 === (8))){
var inst_25759 = figwheel.client.heads_up.flash_loaded.call(null);
var state_25833__$1 = state_25833;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25833__$1,(11),inst_25759);
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
});})(c__21037__auto__,msg_hist,msg_names,msg))
;
return ((function (switch__20925__auto__,c__21037__auto__,msg_hist,msg_names,msg){
return (function() {
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto__ = null;
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto____0 = (function (){
var statearr_25877 = [null,null,null,null,null,null,null,null,null,null];
(statearr_25877[(0)] = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto__);

(statearr_25877[(1)] = (1));

return statearr_25877;
});
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto____1 = (function (state_25833){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_25833);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e25878){if((e25878 instanceof Object)){
var ex__20929__auto__ = e25878;
var statearr_25879_25917 = state_25833;
(statearr_25879_25917[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25833);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25878;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25918 = state_25833;
state_25833 = G__25918;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto__ = function(state_25833){
switch(arguments.length){
case 0:
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto____1.call(this,state_25833);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto____0;
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto____1;
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__,msg_hist,msg_names,msg))
})();
var state__21039__auto__ = (function (){var statearr_25880 = f__21038__auto__.call(null);
(statearr_25880[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_25880;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__,msg_hist,msg_names,msg))
);

return c__21037__auto__;
});
figwheel.client.heads_up_plugin = (function figwheel$client$heads_up_plugin(opts){
var ch = cljs.core.async.chan.call(null);
figwheel.client.heads_up_config_options_STAR__STAR_ = opts;

var c__21037__auto___25981 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto___25981,ch){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto___25981,ch){
return (function (state_25964){
var state_val_25965 = (state_25964[(1)]);
if((state_val_25965 === (1))){
var state_25964__$1 = state_25964;
var statearr_25966_25982 = state_25964__$1;
(statearr_25966_25982[(2)] = null);

(statearr_25966_25982[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25965 === (2))){
var state_25964__$1 = state_25964;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25964__$1,(4),ch);
} else {
if((state_val_25965 === (3))){
var inst_25962 = (state_25964[(2)]);
var state_25964__$1 = state_25964;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25964__$1,inst_25962);
} else {
if((state_val_25965 === (4))){
var inst_25952 = (state_25964[(7)]);
var inst_25952__$1 = (state_25964[(2)]);
var state_25964__$1 = (function (){var statearr_25967 = state_25964;
(statearr_25967[(7)] = inst_25952__$1);

return statearr_25967;
})();
if(cljs.core.truth_(inst_25952__$1)){
var statearr_25968_25983 = state_25964__$1;
(statearr_25968_25983[(1)] = (5));

} else {
var statearr_25969_25984 = state_25964__$1;
(statearr_25969_25984[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25965 === (5))){
var inst_25952 = (state_25964[(7)]);
var inst_25954 = figwheel.client.heads_up_plugin_msg_handler.call(null,opts,inst_25952);
var state_25964__$1 = state_25964;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25964__$1,(8),inst_25954);
} else {
if((state_val_25965 === (6))){
var state_25964__$1 = state_25964;
var statearr_25970_25985 = state_25964__$1;
(statearr_25970_25985[(2)] = null);

(statearr_25970_25985[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25965 === (7))){
var inst_25960 = (state_25964[(2)]);
var state_25964__$1 = state_25964;
var statearr_25971_25986 = state_25964__$1;
(statearr_25971_25986[(2)] = inst_25960);

(statearr_25971_25986[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25965 === (8))){
var inst_25956 = (state_25964[(2)]);
var state_25964__$1 = (function (){var statearr_25972 = state_25964;
(statearr_25972[(8)] = inst_25956);

return statearr_25972;
})();
var statearr_25973_25987 = state_25964__$1;
(statearr_25973_25987[(2)] = null);

(statearr_25973_25987[(1)] = (2));


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
});})(c__21037__auto___25981,ch))
;
return ((function (switch__20925__auto__,c__21037__auto___25981,ch){
return (function() {
var figwheel$client$heads_up_plugin_$_state_machine__20926__auto__ = null;
var figwheel$client$heads_up_plugin_$_state_machine__20926__auto____0 = (function (){
var statearr_25977 = [null,null,null,null,null,null,null,null,null];
(statearr_25977[(0)] = figwheel$client$heads_up_plugin_$_state_machine__20926__auto__);

(statearr_25977[(1)] = (1));

return statearr_25977;
});
var figwheel$client$heads_up_plugin_$_state_machine__20926__auto____1 = (function (state_25964){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_25964);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e25978){if((e25978 instanceof Object)){
var ex__20929__auto__ = e25978;
var statearr_25979_25988 = state_25964;
(statearr_25979_25988[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25964);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25978;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25989 = state_25964;
state_25964 = G__25989;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$heads_up_plugin_$_state_machine__20926__auto__ = function(state_25964){
switch(arguments.length){
case 0:
return figwheel$client$heads_up_plugin_$_state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$heads_up_plugin_$_state_machine__20926__auto____1.call(this,state_25964);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$heads_up_plugin_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$heads_up_plugin_$_state_machine__20926__auto____0;
figwheel$client$heads_up_plugin_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$heads_up_plugin_$_state_machine__20926__auto____1;
return figwheel$client$heads_up_plugin_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto___25981,ch))
})();
var state__21039__auto__ = (function (){var statearr_25980 = f__21038__auto__.call(null);
(statearr_25980[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto___25981);

return statearr_25980;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto___25981,ch))
);


figwheel.client.heads_up.ensure_container.call(null);

return ((function (ch){
return (function (msg_hist){
cljs.core.async.put_BANG_.call(null,ch,msg_hist);

return msg_hist;
});
;})(ch))
});
figwheel.client.enforce_project_plugin = (function figwheel$client$enforce_project_plugin(opts){
return (function (msg_hist){
if(((1) < cljs.core.count.call(null,cljs.core.set.call(null,cljs.core.keep.call(null,new cljs.core.Keyword(null,"project-id","project-id",206449307),cljs.core.take.call(null,(5),msg_hist)))))){
figwheel.client.socket.close_BANG_.call(null);

console.error("Figwheel: message received from different project. Shutting socket down.");

if(cljs.core.truth_(new cljs.core.Keyword(null,"heads-up-display","heads-up-display",-896577202).cljs$core$IFn$_invoke$arity$1(opts))){
var c__21037__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21037__auto__){
return (function (){
var f__21038__auto__ = (function (){var switch__20925__auto__ = ((function (c__21037__auto__){
return (function (state_26010){
var state_val_26011 = (state_26010[(1)]);
if((state_val_26011 === (1))){
var inst_26005 = cljs.core.async.timeout.call(null,(3000));
var state_26010__$1 = state_26010;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_26010__$1,(2),inst_26005);
} else {
if((state_val_26011 === (2))){
var inst_26007 = (state_26010[(2)]);
var inst_26008 = figwheel.client.heads_up.display_system_warning.call(null,"Connection from different project","Shutting connection down!!!!!");
var state_26010__$1 = (function (){var statearr_26012 = state_26010;
(statearr_26012[(7)] = inst_26007);

return statearr_26012;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_26010__$1,inst_26008);
} else {
return null;
}
}
});})(c__21037__auto__))
;
return ((function (switch__20925__auto__,c__21037__auto__){
return (function() {
var figwheel$client$enforce_project_plugin_$_state_machine__20926__auto__ = null;
var figwheel$client$enforce_project_plugin_$_state_machine__20926__auto____0 = (function (){
var statearr_26016 = [null,null,null,null,null,null,null,null];
(statearr_26016[(0)] = figwheel$client$enforce_project_plugin_$_state_machine__20926__auto__);

(statearr_26016[(1)] = (1));

return statearr_26016;
});
var figwheel$client$enforce_project_plugin_$_state_machine__20926__auto____1 = (function (state_26010){
while(true){
var ret_value__20927__auto__ = (function (){try{while(true){
var result__20928__auto__ = switch__20925__auto__.call(null,state_26010);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20928__auto__;
}
break;
}
}catch (e26017){if((e26017 instanceof Object)){
var ex__20929__auto__ = e26017;
var statearr_26018_26020 = state_26010;
(statearr_26018_26020[(5)] = ex__20929__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_26010);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e26017;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20927__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__26021 = state_26010;
state_26010 = G__26021;
continue;
} else {
return ret_value__20927__auto__;
}
break;
}
});
figwheel$client$enforce_project_plugin_$_state_machine__20926__auto__ = function(state_26010){
switch(arguments.length){
case 0:
return figwheel$client$enforce_project_plugin_$_state_machine__20926__auto____0.call(this);
case 1:
return figwheel$client$enforce_project_plugin_$_state_machine__20926__auto____1.call(this,state_26010);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$enforce_project_plugin_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$enforce_project_plugin_$_state_machine__20926__auto____0;
figwheel$client$enforce_project_plugin_$_state_machine__20926__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$enforce_project_plugin_$_state_machine__20926__auto____1;
return figwheel$client$enforce_project_plugin_$_state_machine__20926__auto__;
})()
;})(switch__20925__auto__,c__21037__auto__))
})();
var state__21039__auto__ = (function (){var statearr_26019 = f__21038__auto__.call(null);
(statearr_26019[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21037__auto__);

return statearr_26019;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21039__auto__);
});})(c__21037__auto__))
);

return c__21037__auto__;
} else {
return null;
}
} else {
return null;
}
});
});
figwheel.client.default_on_jsload = cljs.core.identity;
figwheel.client.default_on_compile_fail = (function figwheel$client$default_on_compile_fail(p__26022){
var map__26029 = p__26022;
var map__26029__$1 = ((((!((map__26029 == null)))?((((map__26029.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26029.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26029):map__26029);
var ed = map__26029__$1;
var formatted_exception = cljs.core.get.call(null,map__26029__$1,new cljs.core.Keyword(null,"formatted-exception","formatted-exception",-116489026));
var exception_data = cljs.core.get.call(null,map__26029__$1,new cljs.core.Keyword(null,"exception-data","exception-data",-512474886));
var cause = cljs.core.get.call(null,map__26029__$1,new cljs.core.Keyword(null,"cause","cause",231901252));
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: Compile Exception");

var seq__26031_26035 = cljs.core.seq.call(null,figwheel.client.format_messages.call(null,exception_data));
var chunk__26032_26036 = null;
var count__26033_26037 = (0);
var i__26034_26038 = (0);
while(true){
if((i__26034_26038 < count__26033_26037)){
var msg_26039 = cljs.core._nth.call(null,chunk__26032_26036,i__26034_26038);
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),msg_26039);

var G__26040 = seq__26031_26035;
var G__26041 = chunk__26032_26036;
var G__26042 = count__26033_26037;
var G__26043 = (i__26034_26038 + (1));
seq__26031_26035 = G__26040;
chunk__26032_26036 = G__26041;
count__26033_26037 = G__26042;
i__26034_26038 = G__26043;
continue;
} else {
var temp__4657__auto___26044 = cljs.core.seq.call(null,seq__26031_26035);
if(temp__4657__auto___26044){
var seq__26031_26045__$1 = temp__4657__auto___26044;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__26031_26045__$1)){
var c__19173__auto___26046 = cljs.core.chunk_first.call(null,seq__26031_26045__$1);
var G__26047 = cljs.core.chunk_rest.call(null,seq__26031_26045__$1);
var G__26048 = c__19173__auto___26046;
var G__26049 = cljs.core.count.call(null,c__19173__auto___26046);
var G__26050 = (0);
seq__26031_26035 = G__26047;
chunk__26032_26036 = G__26048;
count__26033_26037 = G__26049;
i__26034_26038 = G__26050;
continue;
} else {
var msg_26051 = cljs.core.first.call(null,seq__26031_26045__$1);
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),msg_26051);

var G__26052 = cljs.core.next.call(null,seq__26031_26045__$1);
var G__26053 = null;
var G__26054 = (0);
var G__26055 = (0);
seq__26031_26035 = G__26052;
chunk__26032_26036 = G__26053;
count__26033_26037 = G__26054;
i__26034_26038 = G__26055;
continue;
}
} else {
}
}
break;
}

if(cljs.core.truth_(cause)){
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Error on file "),cljs.core.str(new cljs.core.Keyword(null,"file","file",-1269645878).cljs$core$IFn$_invoke$arity$1(cause)),cljs.core.str(", line "),cljs.core.str(new cljs.core.Keyword(null,"line","line",212345235).cljs$core$IFn$_invoke$arity$1(cause)),cljs.core.str(", column "),cljs.core.str(new cljs.core.Keyword(null,"column","column",2078222095).cljs$core$IFn$_invoke$arity$1(cause))].join(''));
} else {
}

return ed;
});
figwheel.client.default_on_compile_warning = (function figwheel$client$default_on_compile_warning(p__26056){
var map__26059 = p__26056;
var map__26059__$1 = ((((!((map__26059 == null)))?((((map__26059.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26059.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26059):map__26059);
var w = map__26059__$1;
var message = cljs.core.get.call(null,map__26059__$1,new cljs.core.Keyword(null,"message","message",-406056002));
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),[cljs.core.str("Figwheel: Compile Warning - "),cljs.core.str(message)].join(''));

return w;
});
figwheel.client.default_before_load = (function figwheel$client$default_before_load(files){
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: notified of file changes");

return files;
});
figwheel.client.default_on_cssload = (function figwheel$client$default_on_cssload(files){
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: loaded CSS files");

figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),cljs.core.pr_str.call(null,cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),files)));

return files;
});
if(typeof figwheel.client.config_defaults !== 'undefined'){
} else {
figwheel.client.config_defaults = cljs.core.PersistentHashMap.fromArrays([new cljs.core.Keyword(null,"on-compile-warning","on-compile-warning",-1195585947),new cljs.core.Keyword(null,"on-jsload","on-jsload",-395756602),new cljs.core.Keyword(null,"reload-dependents","reload-dependents",-956865430),new cljs.core.Keyword(null,"on-compile-fail","on-compile-fail",728013036),new cljs.core.Keyword(null,"debug","debug",-1608172596),new cljs.core.Keyword(null,"heads-up-display","heads-up-display",-896577202),new cljs.core.Keyword(null,"websocket-url","websocket-url",-490444938),new cljs.core.Keyword(null,"before-jsload","before-jsload",-847513128),new cljs.core.Keyword(null,"load-warninged-code","load-warninged-code",-2030345223),new cljs.core.Keyword(null,"eval-fn","eval-fn",-1111644294),new cljs.core.Keyword(null,"retry-count","retry-count",1936122875),new cljs.core.Keyword(null,"autoload","autoload",-354122500),new cljs.core.Keyword(null,"on-cssload","on-cssload",1825432318)],[figwheel.client.default_on_compile_warning,figwheel.client.default_on_jsload,true,figwheel.client.default_on_compile_fail,false,true,[cljs.core.str("ws://"),cljs.core.str((cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))?location.host:"localhost:3449")),cljs.core.str("/figwheel-ws")].join(''),figwheel.client.default_before_load,false,false,(100),true,figwheel.client.default_on_cssload]);
}
figwheel.client.handle_deprecated_jsload_callback = (function figwheel$client$handle_deprecated_jsload_callback(config){
if(cljs.core.truth_(new cljs.core.Keyword(null,"jsload-callback","jsload-callback",-1949628369).cljs$core$IFn$_invoke$arity$1(config))){
return cljs.core.dissoc.call(null,cljs.core.assoc.call(null,config,new cljs.core.Keyword(null,"on-jsload","on-jsload",-395756602),new cljs.core.Keyword(null,"jsload-callback","jsload-callback",-1949628369).cljs$core$IFn$_invoke$arity$1(config)),new cljs.core.Keyword(null,"jsload-callback","jsload-callback",-1949628369));
} else {
return config;
}
});
figwheel.client.base_plugins = (function figwheel$client$base_plugins(system_options){
var base = new cljs.core.PersistentArrayMap(null, 5, [new cljs.core.Keyword(null,"enforce-project-plugin","enforce-project-plugin",959402899),figwheel.client.enforce_project_plugin,new cljs.core.Keyword(null,"file-reloader-plugin","file-reloader-plugin",-1792964733),figwheel.client.file_reloader_plugin,new cljs.core.Keyword(null,"comp-fail-warning-plugin","comp-fail-warning-plugin",634311),figwheel.client.compile_fail_warning_plugin,new cljs.core.Keyword(null,"css-reloader-plugin","css-reloader-plugin",2002032904),figwheel.client.css_reloader_plugin,new cljs.core.Keyword(null,"repl-plugin","repl-plugin",-1138952371),figwheel.client.repl_plugin], null);
var base__$1 = ((cljs.core.not.call(null,figwheel.client.utils.html_env_QMARK_.call(null)))?cljs.core.select_keys.call(null,base,new cljs.core.PersistentVector(null, 3, 5, cljs.core.PersistentVector.EMPTY_NODE, [new cljs.core.Keyword(null,"file-reloader-plugin","file-reloader-plugin",-1792964733),new cljs.core.Keyword(null,"comp-fail-warning-plugin","comp-fail-warning-plugin",634311),new cljs.core.Keyword(null,"repl-plugin","repl-plugin",-1138952371)], null)):base);
var base__$2 = ((new cljs.core.Keyword(null,"autoload","autoload",-354122500).cljs$core$IFn$_invoke$arity$1(system_options) === false)?cljs.core.dissoc.call(null,base__$1,new cljs.core.Keyword(null,"file-reloader-plugin","file-reloader-plugin",-1792964733)):base__$1);
if(cljs.core.truth_((function (){var and__18358__auto__ = new cljs.core.Keyword(null,"heads-up-display","heads-up-display",-896577202).cljs$core$IFn$_invoke$arity$1(system_options);
if(cljs.core.truth_(and__18358__auto__)){
return figwheel.client.utils.html_env_QMARK_.call(null);
} else {
return and__18358__auto__;
}
})())){
return cljs.core.assoc.call(null,base__$2,new cljs.core.Keyword(null,"heads-up-display-plugin","heads-up-display-plugin",1745207501),figwheel.client.heads_up_plugin);
} else {
return base__$2;
}
});
figwheel.client.add_message_watch = (function figwheel$client$add_message_watch(key,callback){
return cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,key,(function (_,___$1,___$2,msg_hist){
return callback.call(null,cljs.core.first.call(null,msg_hist));
}));
});
figwheel.client.add_plugins = (function figwheel$client$add_plugins(plugins,system_options){
var seq__26067 = cljs.core.seq.call(null,plugins);
var chunk__26068 = null;
var count__26069 = (0);
var i__26070 = (0);
while(true){
if((i__26070 < count__26069)){
var vec__26071 = cljs.core._nth.call(null,chunk__26068,i__26070);
var k = cljs.core.nth.call(null,vec__26071,(0),null);
var plugin = cljs.core.nth.call(null,vec__26071,(1),null);
if(cljs.core.truth_(plugin)){
var pl_26073 = plugin.call(null,system_options);
cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,k,((function (seq__26067,chunk__26068,count__26069,i__26070,pl_26073,vec__26071,k,plugin){
return (function (_,___$1,___$2,msg_hist){
return pl_26073.call(null,msg_hist);
});})(seq__26067,chunk__26068,count__26069,i__26070,pl_26073,vec__26071,k,plugin))
);
} else {
}

var G__26074 = seq__26067;
var G__26075 = chunk__26068;
var G__26076 = count__26069;
var G__26077 = (i__26070 + (1));
seq__26067 = G__26074;
chunk__26068 = G__26075;
count__26069 = G__26076;
i__26070 = G__26077;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__26067);
if(temp__4657__auto__){
var seq__26067__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__26067__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__26067__$1);
var G__26078 = cljs.core.chunk_rest.call(null,seq__26067__$1);
var G__26079 = c__19173__auto__;
var G__26080 = cljs.core.count.call(null,c__19173__auto__);
var G__26081 = (0);
seq__26067 = G__26078;
chunk__26068 = G__26079;
count__26069 = G__26080;
i__26070 = G__26081;
continue;
} else {
var vec__26072 = cljs.core.first.call(null,seq__26067__$1);
var k = cljs.core.nth.call(null,vec__26072,(0),null);
var plugin = cljs.core.nth.call(null,vec__26072,(1),null);
if(cljs.core.truth_(plugin)){
var pl_26082 = plugin.call(null,system_options);
cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,k,((function (seq__26067,chunk__26068,count__26069,i__26070,pl_26082,vec__26072,k,plugin,seq__26067__$1,temp__4657__auto__){
return (function (_,___$1,___$2,msg_hist){
return pl_26082.call(null,msg_hist);
});})(seq__26067,chunk__26068,count__26069,i__26070,pl_26082,vec__26072,k,plugin,seq__26067__$1,temp__4657__auto__))
);
} else {
}

var G__26083 = cljs.core.next.call(null,seq__26067__$1);
var G__26084 = null;
var G__26085 = (0);
var G__26086 = (0);
seq__26067 = G__26083;
chunk__26068 = G__26084;
count__26069 = G__26085;
i__26070 = G__26086;
continue;
}
} else {
return null;
}
}
break;
}
});
figwheel.client.start = (function figwheel$client$start(var_args){
var args26087 = [];
var len__19428__auto___26090 = arguments.length;
var i__19429__auto___26091 = (0);
while(true){
if((i__19429__auto___26091 < len__19428__auto___26090)){
args26087.push((arguments[i__19429__auto___26091]));

var G__26092 = (i__19429__auto___26091 + (1));
i__19429__auto___26091 = G__26092;
continue;
} else {
}
break;
}

var G__26089 = args26087.length;
switch (G__26089) {
case 1:
return figwheel.client.start.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 0:
return figwheel.client.start.cljs$core$IFn$_invoke$arity$0();

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args26087.length)].join('')));

}
});

figwheel.client.start.cljs$core$IFn$_invoke$arity$1 = (function (opts){
if((goog.dependencies_ == null)){
return null;
} else {
if(typeof figwheel.client.__figwheel_start_once__ !== 'undefined'){
return null;
} else {
figwheel.client.__figwheel_start_once__ = setTimeout((function (){
var plugins_SINGLEQUOTE_ = new cljs.core.Keyword(null,"plugins","plugins",1900073717).cljs$core$IFn$_invoke$arity$1(opts);
var merge_plugins = new cljs.core.Keyword(null,"merge-plugins","merge-plugins",-1193912370).cljs$core$IFn$_invoke$arity$1(opts);
var system_options = figwheel.client.handle_deprecated_jsload_callback.call(null,cljs.core.merge.call(null,figwheel.client.config_defaults,cljs.core.dissoc.call(null,opts,new cljs.core.Keyword(null,"plugins","plugins",1900073717),new cljs.core.Keyword(null,"merge-plugins","merge-plugins",-1193912370))));
var plugins = (cljs.core.truth_(plugins_SINGLEQUOTE_)?plugins_SINGLEQUOTE_:cljs.core.merge.call(null,figwheel.client.base_plugins.call(null,system_options),merge_plugins));
figwheel.client.utils._STAR_print_debug_STAR_ = new cljs.core.Keyword(null,"debug","debug",-1608172596).cljs$core$IFn$_invoke$arity$1(opts);

figwheel.client.add_plugins.call(null,plugins,system_options);

figwheel.client.file_reloading.patch_goog_base.call(null);

return figwheel.client.socket.open.call(null,system_options);
}));
}
}
});

figwheel.client.start.cljs$core$IFn$_invoke$arity$0 = (function (){
return figwheel.client.start.call(null,cljs.core.PersistentArrayMap.EMPTY);
});

figwheel.client.start.cljs$lang$maxFixedArity = 1;
figwheel.client.watch_and_reload_with_opts = figwheel.client.start;
figwheel.client.watch_and_reload = (function figwheel$client$watch_and_reload(var_args){
var args__19435__auto__ = [];
var len__19428__auto___26098 = arguments.length;
var i__19429__auto___26099 = (0);
while(true){
if((i__19429__auto___26099 < len__19428__auto___26098)){
args__19435__auto__.push((arguments[i__19429__auto___26099]));

var G__26100 = (i__19429__auto___26099 + (1));
i__19429__auto___26099 = G__26100;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic = (function (p__26095){
var map__26096 = p__26095;
var map__26096__$1 = ((((!((map__26096 == null)))?((((map__26096.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26096.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26096):map__26096);
var opts = map__26096__$1;
return figwheel.client.start.call(null,opts);
});

figwheel.client.watch_and_reload.cljs$lang$maxFixedArity = (0);

figwheel.client.watch_and_reload.cljs$lang$applyTo = (function (seq26094){
return figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq26094));
});

//# sourceMappingURL=client.js.map