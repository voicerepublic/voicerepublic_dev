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
var pred__25375 = cljs.core._EQ_;
var expr__25376 = (function (){var or__18370__auto__ = (function (){try{return localStorage.getItem("figwheel_autoload");
}catch (e25379){if((e25379 instanceof Error)){
var e = e25379;
return false;
} else {
throw e25379;

}
}})();
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return "true";
}
})();
if(cljs.core.truth_(pred__25375.call(null,"true",expr__25376))){
return true;
} else {
if(cljs.core.truth_(pred__25375.call(null,"false",expr__25376))){
return false;
} else {
throw (new Error([cljs.core.str("No matching clause: "),cljs.core.str(expr__25376)].join('')));
}
}
}):(function (){
return true;
}));
figwheel.client.toggle_autoload = (function figwheel$client$toggle_autoload(){
if(cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))){
try{localStorage.setItem("figwheel_autoload",cljs.core.not.call(null,figwheel.client.autoload_QMARK_.call(null)));

return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Figwheel autoloading "),cljs.core.str((cljs.core.truth_(figwheel.client.autoload_QMARK_.call(null))?"ON":"OFF"))].join(''));
}catch (e25381){if((e25381 instanceof Error)){
var e = e25381;
return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Unable to access localStorage")].join(''));
} else {
throw e25381;

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
var len__19428__auto___25383 = arguments.length;
var i__19429__auto___25384 = (0);
while(true){
if((i__19429__auto___25384 < len__19428__auto___25383)){
args__19435__auto__.push((arguments[i__19429__auto___25384]));

var G__25385 = (i__19429__auto___25384 + (1));
i__19429__auto___25384 = G__25385;
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

figwheel.client.repl_print_fn.cljs$lang$applyTo = (function (seq25382){
return figwheel.client.repl_print_fn.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq25382));
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
figwheel.client.error_msg_format = (function figwheel$client$error_msg_format(p__25386){
var map__25389 = p__25386;
var map__25389__$1 = ((((!((map__25389 == null)))?((((map__25389.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25389.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25389):map__25389);
var message = cljs.core.get.call(null,map__25389__$1,new cljs.core.Keyword(null,"message","message",-406056002));
var class$ = cljs.core.get.call(null,map__25389__$1,new cljs.core.Keyword(null,"class","class",-2030961996));
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
var c__21038__auto___25551 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___25551,ch){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___25551,ch){
return (function (state_25520){
var state_val_25521 = (state_25520[(1)]);
if((state_val_25521 === (7))){
var inst_25516 = (state_25520[(2)]);
var state_25520__$1 = state_25520;
var statearr_25522_25552 = state_25520__$1;
(statearr_25522_25552[(2)] = inst_25516);

(statearr_25522_25552[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (1))){
var state_25520__$1 = state_25520;
var statearr_25523_25553 = state_25520__$1;
(statearr_25523_25553[(2)] = null);

(statearr_25523_25553[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (4))){
var inst_25473 = (state_25520[(7)]);
var inst_25473__$1 = (state_25520[(2)]);
var state_25520__$1 = (function (){var statearr_25524 = state_25520;
(statearr_25524[(7)] = inst_25473__$1);

return statearr_25524;
})();
if(cljs.core.truth_(inst_25473__$1)){
var statearr_25525_25554 = state_25520__$1;
(statearr_25525_25554[(1)] = (5));

} else {
var statearr_25526_25555 = state_25520__$1;
(statearr_25526_25555[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (15))){
var inst_25480 = (state_25520[(8)]);
var inst_25495 = new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(inst_25480);
var inst_25496 = cljs.core.first.call(null,inst_25495);
var inst_25497 = new cljs.core.Keyword(null,"file","file",-1269645878).cljs$core$IFn$_invoke$arity$1(inst_25496);
var inst_25498 = [cljs.core.str("Figwheel: Not loading code with warnings - "),cljs.core.str(inst_25497)].join('');
var inst_25499 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),inst_25498);
var state_25520__$1 = state_25520;
var statearr_25527_25556 = state_25520__$1;
(statearr_25527_25556[(2)] = inst_25499);

(statearr_25527_25556[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (13))){
var inst_25504 = (state_25520[(2)]);
var state_25520__$1 = state_25520;
var statearr_25528_25557 = state_25520__$1;
(statearr_25528_25557[(2)] = inst_25504);

(statearr_25528_25557[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (6))){
var state_25520__$1 = state_25520;
var statearr_25529_25558 = state_25520__$1;
(statearr_25529_25558[(2)] = null);

(statearr_25529_25558[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (17))){
var inst_25502 = (state_25520[(2)]);
var state_25520__$1 = state_25520;
var statearr_25530_25559 = state_25520__$1;
(statearr_25530_25559[(2)] = inst_25502);

(statearr_25530_25559[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (3))){
var inst_25518 = (state_25520[(2)]);
var state_25520__$1 = state_25520;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25520__$1,inst_25518);
} else {
if((state_val_25521 === (12))){
var inst_25479 = (state_25520[(9)]);
var inst_25493 = figwheel.client.block_reload_file_state_QMARK_.call(null,inst_25479,opts);
var state_25520__$1 = state_25520;
if(cljs.core.truth_(inst_25493)){
var statearr_25531_25560 = state_25520__$1;
(statearr_25531_25560[(1)] = (15));

} else {
var statearr_25532_25561 = state_25520__$1;
(statearr_25532_25561[(1)] = (16));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (2))){
var state_25520__$1 = state_25520;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25520__$1,(4),ch);
} else {
if((state_val_25521 === (11))){
var inst_25480 = (state_25520[(8)]);
var inst_25485 = cljs.core.PersistentVector.EMPTY_NODE;
var inst_25486 = figwheel.client.file_reloading.reload_js_files.call(null,opts,inst_25480);
var inst_25487 = cljs.core.async.timeout.call(null,(1000));
var inst_25488 = [inst_25486,inst_25487];
var inst_25489 = (new cljs.core.PersistentVector(null,2,(5),inst_25485,inst_25488,null));
var state_25520__$1 = state_25520;
return cljs.core.async.ioc_alts_BANG_.call(null,state_25520__$1,(14),inst_25489);
} else {
if((state_val_25521 === (9))){
var inst_25480 = (state_25520[(8)]);
var inst_25506 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),"Figwheel: code autoloading is OFF");
var inst_25507 = new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(inst_25480);
var inst_25508 = cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),inst_25507);
var inst_25509 = [cljs.core.str("Not loading: "),cljs.core.str(inst_25508)].join('');
var inst_25510 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),inst_25509);
var state_25520__$1 = (function (){var statearr_25533 = state_25520;
(statearr_25533[(10)] = inst_25506);

return statearr_25533;
})();
var statearr_25534_25562 = state_25520__$1;
(statearr_25534_25562[(2)] = inst_25510);

(statearr_25534_25562[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (5))){
var inst_25473 = (state_25520[(7)]);
var inst_25475 = [new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),null,new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),null];
var inst_25476 = (new cljs.core.PersistentArrayMap(null,2,inst_25475,null));
var inst_25477 = (new cljs.core.PersistentHashSet(null,inst_25476,null));
var inst_25478 = figwheel.client.focus_msgs.call(null,inst_25477,inst_25473);
var inst_25479 = cljs.core.map.call(null,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863),inst_25478);
var inst_25480 = cljs.core.first.call(null,inst_25478);
var inst_25481 = figwheel.client.autoload_QMARK_.call(null);
var state_25520__$1 = (function (){var statearr_25535 = state_25520;
(statearr_25535[(8)] = inst_25480);

(statearr_25535[(9)] = inst_25479);

return statearr_25535;
})();
if(cljs.core.truth_(inst_25481)){
var statearr_25536_25563 = state_25520__$1;
(statearr_25536_25563[(1)] = (8));

} else {
var statearr_25537_25564 = state_25520__$1;
(statearr_25537_25564[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (14))){
var inst_25491 = (state_25520[(2)]);
var state_25520__$1 = state_25520;
var statearr_25538_25565 = state_25520__$1;
(statearr_25538_25565[(2)] = inst_25491);

(statearr_25538_25565[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (16))){
var state_25520__$1 = state_25520;
var statearr_25539_25566 = state_25520__$1;
(statearr_25539_25566[(2)] = null);

(statearr_25539_25566[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (10))){
var inst_25512 = (state_25520[(2)]);
var state_25520__$1 = (function (){var statearr_25540 = state_25520;
(statearr_25540[(11)] = inst_25512);

return statearr_25540;
})();
var statearr_25541_25567 = state_25520__$1;
(statearr_25541_25567[(2)] = null);

(statearr_25541_25567[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25521 === (8))){
var inst_25479 = (state_25520[(9)]);
var inst_25483 = figwheel.client.reload_file_state_QMARK_.call(null,inst_25479,opts);
var state_25520__$1 = state_25520;
if(cljs.core.truth_(inst_25483)){
var statearr_25542_25568 = state_25520__$1;
(statearr_25542_25568[(1)] = (11));

} else {
var statearr_25543_25569 = state_25520__$1;
(statearr_25543_25569[(1)] = (12));

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
});})(c__21038__auto___25551,ch))
;
return ((function (switch__20926__auto__,c__21038__auto___25551,ch){
return (function() {
var figwheel$client$file_reloader_plugin_$_state_machine__20927__auto__ = null;
var figwheel$client$file_reloader_plugin_$_state_machine__20927__auto____0 = (function (){
var statearr_25547 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_25547[(0)] = figwheel$client$file_reloader_plugin_$_state_machine__20927__auto__);

(statearr_25547[(1)] = (1));

return statearr_25547;
});
var figwheel$client$file_reloader_plugin_$_state_machine__20927__auto____1 = (function (state_25520){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_25520);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e25548){if((e25548 instanceof Object)){
var ex__20930__auto__ = e25548;
var statearr_25549_25570 = state_25520;
(statearr_25549_25570[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25520);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25548;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25571 = state_25520;
state_25520 = G__25571;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$file_reloader_plugin_$_state_machine__20927__auto__ = function(state_25520){
switch(arguments.length){
case 0:
return figwheel$client$file_reloader_plugin_$_state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$file_reloader_plugin_$_state_machine__20927__auto____1.call(this,state_25520);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloader_plugin_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloader_plugin_$_state_machine__20927__auto____0;
figwheel$client$file_reloader_plugin_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloader_plugin_$_state_machine__20927__auto____1;
return figwheel$client$file_reloader_plugin_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___25551,ch))
})();
var state__21040__auto__ = (function (){var statearr_25550 = f__21039__auto__.call(null);
(statearr_25550[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___25551);

return statearr_25550;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___25551,ch))
);


return ((function (ch){
return (function (msg_hist){
cljs.core.async.put_BANG_.call(null,ch,msg_hist);

return msg_hist;
});
;})(ch))
});
figwheel.client.truncate_stack_trace = (function figwheel$client$truncate_stack_trace(stack_str){
return cljs.core.take_while.call(null,(function (p1__25572_SHARP_){
return cljs.core.not.call(null,cljs.core.re_matches.call(null,/.*eval_javascript_STAR__STAR_.*/,p1__25572_SHARP_));
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
var base_path_25579 = figwheel.client.utils.base_url_path.call(null);
figwheel.client.eval_javascript_STAR__STAR_ = ((function (base_path_25579){
return (function figwheel$client$eval_javascript_STAR__STAR_(code,opts,result_handler){
try{var _STAR_print_fn_STAR_25577 = cljs.core._STAR_print_fn_STAR_;
var _STAR_print_newline_STAR_25578 = cljs.core._STAR_print_newline_STAR_;
cljs.core._STAR_print_fn_STAR_ = figwheel.client.repl_print_fn;

cljs.core._STAR_print_newline_STAR_ = false;

try{return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"success","success",1890645906),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"value","value",305978217),figwheel.client.utils.eval_helper.call(null,code,opts)], null));
}finally {cljs.core._STAR_print_newline_STAR_ = _STAR_print_newline_STAR_25578;

cljs.core._STAR_print_fn_STAR_ = _STAR_print_fn_STAR_25577;
}}catch (e25576){if((e25576 instanceof Error)){
var e = e25576;
return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 5, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"exception","exception",-335277064),new cljs.core.Keyword(null,"value","value",305978217),cljs.core.pr_str.call(null,e),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"stacktrace","stacktrace",-95588394),clojure.string.join.call(null,"\n",figwheel.client.truncate_stack_trace.call(null,e.stack)),new cljs.core.Keyword(null,"base-path","base-path",495760020),base_path_25579], null));
} else {
var e = e25576;
return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 4, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"exception","exception",-335277064),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"value","value",305978217),cljs.core.pr_str.call(null,e),new cljs.core.Keyword(null,"stacktrace","stacktrace",-95588394),"No stacktrace available."], null));

}
}});})(base_path_25579))
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
figwheel.client.repl_plugin = (function figwheel$client$repl_plugin(p__25580){
var map__25587 = p__25580;
var map__25587__$1 = ((((!((map__25587 == null)))?((((map__25587.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25587.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25587):map__25587);
var opts = map__25587__$1;
var build_id = cljs.core.get.call(null,map__25587__$1,new cljs.core.Keyword(null,"build-id","build-id",1642831089));
return ((function (map__25587,map__25587__$1,opts,build_id){
return (function (p__25589){
var vec__25590 = p__25589;
var map__25591 = cljs.core.nth.call(null,vec__25590,(0),null);
var map__25591__$1 = ((((!((map__25591 == null)))?((((map__25591.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25591.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25591):map__25591);
var msg = map__25591__$1;
var msg_name = cljs.core.get.call(null,map__25591__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25590,(1));
if(cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"repl-eval","repl-eval",-1784727398),msg_name)){
figwheel.client.ensure_cljs_user.call(null);

return figwheel.client.eval_javascript_STAR__STAR_.call(null,new cljs.core.Keyword(null,"code","code",1586293142).cljs$core$IFn$_invoke$arity$1(msg),opts,((function (vec__25590,map__25591,map__25591__$1,msg,msg_name,_,map__25587,map__25587__$1,opts,build_id){
return (function (res){
return figwheel.client.socket.send_BANG_.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"figwheel-event","figwheel-event",519570592),"callback",new cljs.core.Keyword(null,"callback-name","callback-name",336964714),new cljs.core.Keyword(null,"callback-name","callback-name",336964714).cljs$core$IFn$_invoke$arity$1(msg),new cljs.core.Keyword(null,"content","content",15833224),res], null));
});})(vec__25590,map__25591,map__25591__$1,msg,msg_name,_,map__25587,map__25587__$1,opts,build_id))
);
} else {
return null;
}
});
;})(map__25587,map__25587__$1,opts,build_id))
});
figwheel.client.css_reloader_plugin = (function figwheel$client$css_reloader_plugin(opts){
return (function (p__25597){
var vec__25598 = p__25597;
var map__25599 = cljs.core.nth.call(null,vec__25598,(0),null);
var map__25599__$1 = ((((!((map__25599 == null)))?((((map__25599.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25599.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25599):map__25599);
var msg = map__25599__$1;
var msg_name = cljs.core.get.call(null,map__25599__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25598,(1));
if(cljs.core._EQ_.call(null,msg_name,new cljs.core.Keyword(null,"css-files-changed","css-files-changed",720773874))){
return figwheel.client.file_reloading.reload_css_files.call(null,opts,msg);
} else {
return null;
}
});
});
figwheel.client.compile_fail_warning_plugin = (function figwheel$client$compile_fail_warning_plugin(p__25601){
var map__25611 = p__25601;
var map__25611__$1 = ((((!((map__25611 == null)))?((((map__25611.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25611.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25611):map__25611);
var on_compile_warning = cljs.core.get.call(null,map__25611__$1,new cljs.core.Keyword(null,"on-compile-warning","on-compile-warning",-1195585947));
var on_compile_fail = cljs.core.get.call(null,map__25611__$1,new cljs.core.Keyword(null,"on-compile-fail","on-compile-fail",728013036));
return ((function (map__25611,map__25611__$1,on_compile_warning,on_compile_fail){
return (function (p__25613){
var vec__25614 = p__25613;
var map__25615 = cljs.core.nth.call(null,vec__25614,(0),null);
var map__25615__$1 = ((((!((map__25615 == null)))?((((map__25615.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25615.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25615):map__25615);
var msg = map__25615__$1;
var msg_name = cljs.core.get.call(null,map__25615__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25614,(1));
var pred__25617 = cljs.core._EQ_;
var expr__25618 = msg_name;
if(cljs.core.truth_(pred__25617.call(null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),expr__25618))){
return on_compile_warning.call(null,msg);
} else {
if(cljs.core.truth_(pred__25617.call(null,new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),expr__25618))){
return on_compile_fail.call(null,msg);
} else {
return null;
}
}
});
;})(map__25611,map__25611__$1,on_compile_warning,on_compile_fail))
});
figwheel.client.heads_up_plugin_msg_handler = (function figwheel$client$heads_up_plugin_msg_handler(opts,msg_hist_SINGLEQUOTE_){
var msg_hist = figwheel.client.focus_msgs.call(null,new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),null,new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),null], null), null),msg_hist_SINGLEQUOTE_);
var msg_names = cljs.core.map.call(null,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863),msg_hist);
var msg = cljs.core.first.call(null,msg_hist);
var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__,msg_hist,msg_names,msg){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__,msg_hist,msg_names,msg){
return (function (state_25834){
var state_val_25835 = (state_25834[(1)]);
if((state_val_25835 === (7))){
var inst_25758 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25758)){
var statearr_25836_25882 = state_25834__$1;
(statearr_25836_25882[(1)] = (8));

} else {
var statearr_25837_25883 = state_25834__$1;
(statearr_25837_25883[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (20))){
var inst_25828 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25838_25884 = state_25834__$1;
(statearr_25838_25884[(2)] = inst_25828);

(statearr_25838_25884[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (27))){
var inst_25824 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25839_25885 = state_25834__$1;
(statearr_25839_25885[(2)] = inst_25824);

(statearr_25839_25885[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (1))){
var inst_25751 = figwheel.client.reload_file_state_QMARK_.call(null,msg_names,opts);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25751)){
var statearr_25840_25886 = state_25834__$1;
(statearr_25840_25886[(1)] = (2));

} else {
var statearr_25841_25887 = state_25834__$1;
(statearr_25841_25887[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (24))){
var inst_25826 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25842_25888 = state_25834__$1;
(statearr_25842_25888[(2)] = inst_25826);

(statearr_25842_25888[(1)] = (20));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (4))){
var inst_25832 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25834__$1,inst_25832);
} else {
if((state_val_25835 === (15))){
var inst_25830 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25843_25889 = state_25834__$1;
(statearr_25843_25889[(2)] = inst_25830);

(statearr_25843_25889[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (21))){
var inst_25789 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25844_25890 = state_25834__$1;
(statearr_25844_25890[(2)] = inst_25789);

(statearr_25844_25890[(1)] = (20));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (31))){
var inst_25813 = figwheel.client.css_loaded_state_QMARK_.call(null,msg_names);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25813)){
var statearr_25845_25891 = state_25834__$1;
(statearr_25845_25891[(1)] = (34));

} else {
var statearr_25846_25892 = state_25834__$1;
(statearr_25846_25892[(1)] = (35));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (32))){
var inst_25822 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25847_25893 = state_25834__$1;
(statearr_25847_25893[(2)] = inst_25822);

(statearr_25847_25893[(1)] = (27));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (33))){
var inst_25811 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25848_25894 = state_25834__$1;
(statearr_25848_25894[(2)] = inst_25811);

(statearr_25848_25894[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (13))){
var inst_25772 = figwheel.client.heads_up.clear.call(null);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(16),inst_25772);
} else {
if((state_val_25835 === (22))){
var inst_25793 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25794 = figwheel.client.heads_up.append_message.call(null,inst_25793);
var state_25834__$1 = state_25834;
var statearr_25849_25895 = state_25834__$1;
(statearr_25849_25895[(2)] = inst_25794);

(statearr_25849_25895[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (36))){
var inst_25820 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25850_25896 = state_25834__$1;
(statearr_25850_25896[(2)] = inst_25820);

(statearr_25850_25896[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (29))){
var inst_25804 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25851_25897 = state_25834__$1;
(statearr_25851_25897[(2)] = inst_25804);

(statearr_25851_25897[(1)] = (27));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (6))){
var inst_25753 = (state_25834[(7)]);
var state_25834__$1 = state_25834;
var statearr_25852_25898 = state_25834__$1;
(statearr_25852_25898[(2)] = inst_25753);

(statearr_25852_25898[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (28))){
var inst_25800 = (state_25834[(2)]);
var inst_25801 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25802 = figwheel.client.heads_up.display_warning.call(null,inst_25801);
var state_25834__$1 = (function (){var statearr_25853 = state_25834;
(statearr_25853[(8)] = inst_25800);

return statearr_25853;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(29),inst_25802);
} else {
if((state_val_25835 === (25))){
var inst_25798 = figwheel.client.heads_up.clear.call(null);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(28),inst_25798);
} else {
if((state_val_25835 === (34))){
var inst_25815 = figwheel.client.heads_up.flash_loaded.call(null);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(37),inst_25815);
} else {
if((state_val_25835 === (17))){
var inst_25780 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25854_25899 = state_25834__$1;
(statearr_25854_25899[(2)] = inst_25780);

(statearr_25854_25899[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (3))){
var inst_25770 = figwheel.client.compile_refail_state_QMARK_.call(null,msg_names);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25770)){
var statearr_25855_25900 = state_25834__$1;
(statearr_25855_25900[(1)] = (13));

} else {
var statearr_25856_25901 = state_25834__$1;
(statearr_25856_25901[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (12))){
var inst_25766 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25857_25902 = state_25834__$1;
(statearr_25857_25902[(2)] = inst_25766);

(statearr_25857_25902[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (2))){
var inst_25753 = (state_25834[(7)]);
var inst_25753__$1 = figwheel.client.autoload_QMARK_.call(null);
var state_25834__$1 = (function (){var statearr_25858 = state_25834;
(statearr_25858[(7)] = inst_25753__$1);

return statearr_25858;
})();
if(cljs.core.truth_(inst_25753__$1)){
var statearr_25859_25903 = state_25834__$1;
(statearr_25859_25903[(1)] = (5));

} else {
var statearr_25860_25904 = state_25834__$1;
(statearr_25860_25904[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (23))){
var inst_25796 = figwheel.client.rewarning_state_QMARK_.call(null,msg_names);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25796)){
var statearr_25861_25905 = state_25834__$1;
(statearr_25861_25905[(1)] = (25));

} else {
var statearr_25862_25906 = state_25834__$1;
(statearr_25862_25906[(1)] = (26));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (35))){
var state_25834__$1 = state_25834;
var statearr_25863_25907 = state_25834__$1;
(statearr_25863_25907[(2)] = null);

(statearr_25863_25907[(1)] = (36));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (19))){
var inst_25791 = figwheel.client.warning_append_state_QMARK_.call(null,msg_names);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25791)){
var statearr_25864_25908 = state_25834__$1;
(statearr_25864_25908[(1)] = (22));

} else {
var statearr_25865_25909 = state_25834__$1;
(statearr_25865_25909[(1)] = (23));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (11))){
var inst_25762 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25866_25910 = state_25834__$1;
(statearr_25866_25910[(2)] = inst_25762);

(statearr_25866_25910[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (9))){
var inst_25764 = figwheel.client.heads_up.clear.call(null);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(12),inst_25764);
} else {
if((state_val_25835 === (5))){
var inst_25755 = new cljs.core.Keyword(null,"autoload","autoload",-354122500).cljs$core$IFn$_invoke$arity$1(opts);
var state_25834__$1 = state_25834;
var statearr_25867_25911 = state_25834__$1;
(statearr_25867_25911[(2)] = inst_25755);

(statearr_25867_25911[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (14))){
var inst_25782 = figwheel.client.compile_fail_state_QMARK_.call(null,msg_names);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25782)){
var statearr_25868_25912 = state_25834__$1;
(statearr_25868_25912[(1)] = (18));

} else {
var statearr_25869_25913 = state_25834__$1;
(statearr_25869_25913[(1)] = (19));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (26))){
var inst_25806 = figwheel.client.warning_state_QMARK_.call(null,msg_names);
var state_25834__$1 = state_25834;
if(cljs.core.truth_(inst_25806)){
var statearr_25870_25914 = state_25834__$1;
(statearr_25870_25914[(1)] = (30));

} else {
var statearr_25871_25915 = state_25834__$1;
(statearr_25871_25915[(1)] = (31));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (16))){
var inst_25774 = (state_25834[(2)]);
var inst_25775 = new cljs.core.Keyword(null,"exception-data","exception-data",-512474886).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25776 = figwheel.client.format_messages.call(null,inst_25775);
var inst_25777 = new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25778 = figwheel.client.heads_up.display_error.call(null,inst_25776,inst_25777);
var state_25834__$1 = (function (){var statearr_25872 = state_25834;
(statearr_25872[(9)] = inst_25774);

return statearr_25872;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(17),inst_25778);
} else {
if((state_val_25835 === (30))){
var inst_25808 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25809 = figwheel.client.heads_up.display_warning.call(null,inst_25808);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(33),inst_25809);
} else {
if((state_val_25835 === (10))){
var inst_25768 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25873_25916 = state_25834__$1;
(statearr_25873_25916[(2)] = inst_25768);

(statearr_25873_25916[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (18))){
var inst_25784 = new cljs.core.Keyword(null,"exception-data","exception-data",-512474886).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25785 = figwheel.client.format_messages.call(null,inst_25784);
var inst_25786 = new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25787 = figwheel.client.heads_up.display_error.call(null,inst_25785,inst_25786);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(21),inst_25787);
} else {
if((state_val_25835 === (37))){
var inst_25817 = (state_25834[(2)]);
var state_25834__$1 = state_25834;
var statearr_25874_25917 = state_25834__$1;
(statearr_25874_25917[(2)] = inst_25817);

(statearr_25874_25917[(1)] = (36));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25835 === (8))){
var inst_25760 = figwheel.client.heads_up.flash_loaded.call(null);
var state_25834__$1 = state_25834;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25834__$1,(11),inst_25760);
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
});})(c__21038__auto__,msg_hist,msg_names,msg))
;
return ((function (switch__20926__auto__,c__21038__auto__,msg_hist,msg_names,msg){
return (function() {
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto__ = null;
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto____0 = (function (){
var statearr_25878 = [null,null,null,null,null,null,null,null,null,null];
(statearr_25878[(0)] = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto__);

(statearr_25878[(1)] = (1));

return statearr_25878;
});
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto____1 = (function (state_25834){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_25834);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e25879){if((e25879 instanceof Object)){
var ex__20930__auto__ = e25879;
var statearr_25880_25918 = state_25834;
(statearr_25880_25918[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25834);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25879;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25919 = state_25834;
state_25834 = G__25919;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto__ = function(state_25834){
switch(arguments.length){
case 0:
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto____1.call(this,state_25834);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto____0;
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto____1;
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__,msg_hist,msg_names,msg))
})();
var state__21040__auto__ = (function (){var statearr_25881 = f__21039__auto__.call(null);
(statearr_25881[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_25881;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__,msg_hist,msg_names,msg))
);

return c__21038__auto__;
});
figwheel.client.heads_up_plugin = (function figwheel$client$heads_up_plugin(opts){
var ch = cljs.core.async.chan.call(null);
figwheel.client.heads_up_config_options_STAR__STAR_ = opts;

var c__21038__auto___25982 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto___25982,ch){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto___25982,ch){
return (function (state_25965){
var state_val_25966 = (state_25965[(1)]);
if((state_val_25966 === (1))){
var state_25965__$1 = state_25965;
var statearr_25967_25983 = state_25965__$1;
(statearr_25967_25983[(2)] = null);

(statearr_25967_25983[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25966 === (2))){
var state_25965__$1 = state_25965;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25965__$1,(4),ch);
} else {
if((state_val_25966 === (3))){
var inst_25963 = (state_25965[(2)]);
var state_25965__$1 = state_25965;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25965__$1,inst_25963);
} else {
if((state_val_25966 === (4))){
var inst_25953 = (state_25965[(7)]);
var inst_25953__$1 = (state_25965[(2)]);
var state_25965__$1 = (function (){var statearr_25968 = state_25965;
(statearr_25968[(7)] = inst_25953__$1);

return statearr_25968;
})();
if(cljs.core.truth_(inst_25953__$1)){
var statearr_25969_25984 = state_25965__$1;
(statearr_25969_25984[(1)] = (5));

} else {
var statearr_25970_25985 = state_25965__$1;
(statearr_25970_25985[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25966 === (5))){
var inst_25953 = (state_25965[(7)]);
var inst_25955 = figwheel.client.heads_up_plugin_msg_handler.call(null,opts,inst_25953);
var state_25965__$1 = state_25965;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25965__$1,(8),inst_25955);
} else {
if((state_val_25966 === (6))){
var state_25965__$1 = state_25965;
var statearr_25971_25986 = state_25965__$1;
(statearr_25971_25986[(2)] = null);

(statearr_25971_25986[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25966 === (7))){
var inst_25961 = (state_25965[(2)]);
var state_25965__$1 = state_25965;
var statearr_25972_25987 = state_25965__$1;
(statearr_25972_25987[(2)] = inst_25961);

(statearr_25972_25987[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25966 === (8))){
var inst_25957 = (state_25965[(2)]);
var state_25965__$1 = (function (){var statearr_25973 = state_25965;
(statearr_25973[(8)] = inst_25957);

return statearr_25973;
})();
var statearr_25974_25988 = state_25965__$1;
(statearr_25974_25988[(2)] = null);

(statearr_25974_25988[(1)] = (2));


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
});})(c__21038__auto___25982,ch))
;
return ((function (switch__20926__auto__,c__21038__auto___25982,ch){
return (function() {
var figwheel$client$heads_up_plugin_$_state_machine__20927__auto__ = null;
var figwheel$client$heads_up_plugin_$_state_machine__20927__auto____0 = (function (){
var statearr_25978 = [null,null,null,null,null,null,null,null,null];
(statearr_25978[(0)] = figwheel$client$heads_up_plugin_$_state_machine__20927__auto__);

(statearr_25978[(1)] = (1));

return statearr_25978;
});
var figwheel$client$heads_up_plugin_$_state_machine__20927__auto____1 = (function (state_25965){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_25965);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e25979){if((e25979 instanceof Object)){
var ex__20930__auto__ = e25979;
var statearr_25980_25989 = state_25965;
(statearr_25980_25989[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25965);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25979;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25990 = state_25965;
state_25965 = G__25990;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$heads_up_plugin_$_state_machine__20927__auto__ = function(state_25965){
switch(arguments.length){
case 0:
return figwheel$client$heads_up_plugin_$_state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$heads_up_plugin_$_state_machine__20927__auto____1.call(this,state_25965);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$heads_up_plugin_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$heads_up_plugin_$_state_machine__20927__auto____0;
figwheel$client$heads_up_plugin_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$heads_up_plugin_$_state_machine__20927__auto____1;
return figwheel$client$heads_up_plugin_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto___25982,ch))
})();
var state__21040__auto__ = (function (){var statearr_25981 = f__21039__auto__.call(null);
(statearr_25981[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto___25982);

return statearr_25981;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto___25982,ch))
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
var c__21038__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21038__auto__){
return (function (){
var f__21039__auto__ = (function (){var switch__20926__auto__ = ((function (c__21038__auto__){
return (function (state_26011){
var state_val_26012 = (state_26011[(1)]);
if((state_val_26012 === (1))){
var inst_26006 = cljs.core.async.timeout.call(null,(3000));
var state_26011__$1 = state_26011;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_26011__$1,(2),inst_26006);
} else {
if((state_val_26012 === (2))){
var inst_26008 = (state_26011[(2)]);
var inst_26009 = figwheel.client.heads_up.display_system_warning.call(null,"Connection from different project","Shutting connection down!!!!!");
var state_26011__$1 = (function (){var statearr_26013 = state_26011;
(statearr_26013[(7)] = inst_26008);

return statearr_26013;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_26011__$1,inst_26009);
} else {
return null;
}
}
});})(c__21038__auto__))
;
return ((function (switch__20926__auto__,c__21038__auto__){
return (function() {
var figwheel$client$enforce_project_plugin_$_state_machine__20927__auto__ = null;
var figwheel$client$enforce_project_plugin_$_state_machine__20927__auto____0 = (function (){
var statearr_26017 = [null,null,null,null,null,null,null,null];
(statearr_26017[(0)] = figwheel$client$enforce_project_plugin_$_state_machine__20927__auto__);

(statearr_26017[(1)] = (1));

return statearr_26017;
});
var figwheel$client$enforce_project_plugin_$_state_machine__20927__auto____1 = (function (state_26011){
while(true){
var ret_value__20928__auto__ = (function (){try{while(true){
var result__20929__auto__ = switch__20926__auto__.call(null,state_26011);
if(cljs.core.keyword_identical_QMARK_.call(null,result__20929__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__20929__auto__;
}
break;
}
}catch (e26018){if((e26018 instanceof Object)){
var ex__20930__auto__ = e26018;
var statearr_26019_26021 = state_26011;
(statearr_26019_26021[(5)] = ex__20930__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_26011);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e26018;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__20928__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__26022 = state_26011;
state_26011 = G__26022;
continue;
} else {
return ret_value__20928__auto__;
}
break;
}
});
figwheel$client$enforce_project_plugin_$_state_machine__20927__auto__ = function(state_26011){
switch(arguments.length){
case 0:
return figwheel$client$enforce_project_plugin_$_state_machine__20927__auto____0.call(this);
case 1:
return figwheel$client$enforce_project_plugin_$_state_machine__20927__auto____1.call(this,state_26011);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$enforce_project_plugin_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$enforce_project_plugin_$_state_machine__20927__auto____0;
figwheel$client$enforce_project_plugin_$_state_machine__20927__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$enforce_project_plugin_$_state_machine__20927__auto____1;
return figwheel$client$enforce_project_plugin_$_state_machine__20927__auto__;
})()
;})(switch__20926__auto__,c__21038__auto__))
})();
var state__21040__auto__ = (function (){var statearr_26020 = f__21039__auto__.call(null);
(statearr_26020[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21038__auto__);

return statearr_26020;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21040__auto__);
});})(c__21038__auto__))
);

return c__21038__auto__;
} else {
return null;
}
} else {
return null;
}
});
});
figwheel.client.default_on_jsload = cljs.core.identity;
figwheel.client.default_on_compile_fail = (function figwheel$client$default_on_compile_fail(p__26023){
var map__26030 = p__26023;
var map__26030__$1 = ((((!((map__26030 == null)))?((((map__26030.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26030.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26030):map__26030);
var ed = map__26030__$1;
var formatted_exception = cljs.core.get.call(null,map__26030__$1,new cljs.core.Keyword(null,"formatted-exception","formatted-exception",-116489026));
var exception_data = cljs.core.get.call(null,map__26030__$1,new cljs.core.Keyword(null,"exception-data","exception-data",-512474886));
var cause = cljs.core.get.call(null,map__26030__$1,new cljs.core.Keyword(null,"cause","cause",231901252));
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: Compile Exception");

var seq__26032_26036 = cljs.core.seq.call(null,figwheel.client.format_messages.call(null,exception_data));
var chunk__26033_26037 = null;
var count__26034_26038 = (0);
var i__26035_26039 = (0);
while(true){
if((i__26035_26039 < count__26034_26038)){
var msg_26040 = cljs.core._nth.call(null,chunk__26033_26037,i__26035_26039);
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),msg_26040);

var G__26041 = seq__26032_26036;
var G__26042 = chunk__26033_26037;
var G__26043 = count__26034_26038;
var G__26044 = (i__26035_26039 + (1));
seq__26032_26036 = G__26041;
chunk__26033_26037 = G__26042;
count__26034_26038 = G__26043;
i__26035_26039 = G__26044;
continue;
} else {
var temp__4657__auto___26045 = cljs.core.seq.call(null,seq__26032_26036);
if(temp__4657__auto___26045){
var seq__26032_26046__$1 = temp__4657__auto___26045;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__26032_26046__$1)){
var c__19173__auto___26047 = cljs.core.chunk_first.call(null,seq__26032_26046__$1);
var G__26048 = cljs.core.chunk_rest.call(null,seq__26032_26046__$1);
var G__26049 = c__19173__auto___26047;
var G__26050 = cljs.core.count.call(null,c__19173__auto___26047);
var G__26051 = (0);
seq__26032_26036 = G__26048;
chunk__26033_26037 = G__26049;
count__26034_26038 = G__26050;
i__26035_26039 = G__26051;
continue;
} else {
var msg_26052 = cljs.core.first.call(null,seq__26032_26046__$1);
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),msg_26052);

var G__26053 = cljs.core.next.call(null,seq__26032_26046__$1);
var G__26054 = null;
var G__26055 = (0);
var G__26056 = (0);
seq__26032_26036 = G__26053;
chunk__26033_26037 = G__26054;
count__26034_26038 = G__26055;
i__26035_26039 = G__26056;
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
figwheel.client.default_on_compile_warning = (function figwheel$client$default_on_compile_warning(p__26057){
var map__26060 = p__26057;
var map__26060__$1 = ((((!((map__26060 == null)))?((((map__26060.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26060.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26060):map__26060);
var w = map__26060__$1;
var message = cljs.core.get.call(null,map__26060__$1,new cljs.core.Keyword(null,"message","message",-406056002));
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
var seq__26068 = cljs.core.seq.call(null,plugins);
var chunk__26069 = null;
var count__26070 = (0);
var i__26071 = (0);
while(true){
if((i__26071 < count__26070)){
var vec__26072 = cljs.core._nth.call(null,chunk__26069,i__26071);
var k = cljs.core.nth.call(null,vec__26072,(0),null);
var plugin = cljs.core.nth.call(null,vec__26072,(1),null);
if(cljs.core.truth_(plugin)){
var pl_26074 = plugin.call(null,system_options);
cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,k,((function (seq__26068,chunk__26069,count__26070,i__26071,pl_26074,vec__26072,k,plugin){
return (function (_,___$1,___$2,msg_hist){
return pl_26074.call(null,msg_hist);
});})(seq__26068,chunk__26069,count__26070,i__26071,pl_26074,vec__26072,k,plugin))
);
} else {
}

var G__26075 = seq__26068;
var G__26076 = chunk__26069;
var G__26077 = count__26070;
var G__26078 = (i__26071 + (1));
seq__26068 = G__26075;
chunk__26069 = G__26076;
count__26070 = G__26077;
i__26071 = G__26078;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__26068);
if(temp__4657__auto__){
var seq__26068__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__26068__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__26068__$1);
var G__26079 = cljs.core.chunk_rest.call(null,seq__26068__$1);
var G__26080 = c__19173__auto__;
var G__26081 = cljs.core.count.call(null,c__19173__auto__);
var G__26082 = (0);
seq__26068 = G__26079;
chunk__26069 = G__26080;
count__26070 = G__26081;
i__26071 = G__26082;
continue;
} else {
var vec__26073 = cljs.core.first.call(null,seq__26068__$1);
var k = cljs.core.nth.call(null,vec__26073,(0),null);
var plugin = cljs.core.nth.call(null,vec__26073,(1),null);
if(cljs.core.truth_(plugin)){
var pl_26083 = plugin.call(null,system_options);
cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,k,((function (seq__26068,chunk__26069,count__26070,i__26071,pl_26083,vec__26073,k,plugin,seq__26068__$1,temp__4657__auto__){
return (function (_,___$1,___$2,msg_hist){
return pl_26083.call(null,msg_hist);
});})(seq__26068,chunk__26069,count__26070,i__26071,pl_26083,vec__26073,k,plugin,seq__26068__$1,temp__4657__auto__))
);
} else {
}

var G__26084 = cljs.core.next.call(null,seq__26068__$1);
var G__26085 = null;
var G__26086 = (0);
var G__26087 = (0);
seq__26068 = G__26084;
chunk__26069 = G__26085;
count__26070 = G__26086;
i__26071 = G__26087;
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
var args26088 = [];
var len__19428__auto___26091 = arguments.length;
var i__19429__auto___26092 = (0);
while(true){
if((i__19429__auto___26092 < len__19428__auto___26091)){
args26088.push((arguments[i__19429__auto___26092]));

var G__26093 = (i__19429__auto___26092 + (1));
i__19429__auto___26092 = G__26093;
continue;
} else {
}
break;
}

var G__26090 = args26088.length;
switch (G__26090) {
case 1:
return figwheel.client.start.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 0:
return figwheel.client.start.cljs$core$IFn$_invoke$arity$0();

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args26088.length)].join('')));

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
var len__19428__auto___26099 = arguments.length;
var i__19429__auto___26100 = (0);
while(true){
if((i__19429__auto___26100 < len__19428__auto___26099)){
args__19435__auto__.push((arguments[i__19429__auto___26100]));

var G__26101 = (i__19429__auto___26100 + (1));
i__19429__auto___26100 = G__26101;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic = (function (p__26096){
var map__26097 = p__26096;
var map__26097__$1 = ((((!((map__26097 == null)))?((((map__26097.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26097.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26097):map__26097);
var opts = map__26097__$1;
return figwheel.client.start.call(null,opts);
});

figwheel.client.watch_and_reload.cljs$lang$maxFixedArity = (0);

figwheel.client.watch_and_reload.cljs$lang$applyTo = (function (seq26095){
return figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq26095));
});

//# sourceMappingURL=client.js.map