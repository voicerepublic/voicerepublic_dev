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
var pred__25509 = cljs.core._EQ_;
var expr__25510 = (function (){var or__18370__auto__ = (function (){try{return localStorage.getItem("figwheel_autoload");
}catch (e25513){if((e25513 instanceof Error)){
var e = e25513;
return false;
} else {
throw e25513;

}
}})();
if(cljs.core.truth_(or__18370__auto__)){
return or__18370__auto__;
} else {
return "true";
}
})();
if(cljs.core.truth_(pred__25509.call(null,"true",expr__25510))){
return true;
} else {
if(cljs.core.truth_(pred__25509.call(null,"false",expr__25510))){
return false;
} else {
throw (new Error([cljs.core.str("No matching clause: "),cljs.core.str(expr__25510)].join('')));
}
}
}):(function (){
return true;
}));
figwheel.client.toggle_autoload = (function figwheel$client$toggle_autoload(){
if(cljs.core.truth_(figwheel.client.utils.html_env_QMARK_.call(null))){
try{localStorage.setItem("figwheel_autoload",cljs.core.not.call(null,figwheel.client.autoload_QMARK_.call(null)));

return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Figwheel autoloading "),cljs.core.str((cljs.core.truth_(figwheel.client.autoload_QMARK_.call(null))?"ON":"OFF"))].join(''));
}catch (e25515){if((e25515 instanceof Error)){
var e = e25515;
return figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),[cljs.core.str("Unable to access localStorage")].join(''));
} else {
throw e25515;

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
var len__19428__auto___25517 = arguments.length;
var i__19429__auto___25518 = (0);
while(true){
if((i__19429__auto___25518 < len__19428__auto___25517)){
args__19435__auto__.push((arguments[i__19429__auto___25518]));

var G__25519 = (i__19429__auto___25518 + (1));
i__19429__auto___25518 = G__25519;
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

figwheel.client.repl_print_fn.cljs$lang$applyTo = (function (seq25516){
return figwheel.client.repl_print_fn.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq25516));
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
figwheel.client.error_msg_format = (function figwheel$client$error_msg_format(p__25520){
var map__25523 = p__25520;
var map__25523__$1 = ((((!((map__25523 == null)))?((((map__25523.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25523.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25523):map__25523);
var message = cljs.core.get.call(null,map__25523__$1,new cljs.core.Keyword(null,"message","message",-406056002));
var class$ = cljs.core.get.call(null,map__25523__$1,new cljs.core.Keyword(null,"class","class",-2030961996));
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
var c__21172__auto___25685 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___25685,ch){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___25685,ch){
return (function (state_25654){
var state_val_25655 = (state_25654[(1)]);
if((state_val_25655 === (7))){
var inst_25650 = (state_25654[(2)]);
var state_25654__$1 = state_25654;
var statearr_25656_25686 = state_25654__$1;
(statearr_25656_25686[(2)] = inst_25650);

(statearr_25656_25686[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (1))){
var state_25654__$1 = state_25654;
var statearr_25657_25687 = state_25654__$1;
(statearr_25657_25687[(2)] = null);

(statearr_25657_25687[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (4))){
var inst_25607 = (state_25654[(7)]);
var inst_25607__$1 = (state_25654[(2)]);
var state_25654__$1 = (function (){var statearr_25658 = state_25654;
(statearr_25658[(7)] = inst_25607__$1);

return statearr_25658;
})();
if(cljs.core.truth_(inst_25607__$1)){
var statearr_25659_25688 = state_25654__$1;
(statearr_25659_25688[(1)] = (5));

} else {
var statearr_25660_25689 = state_25654__$1;
(statearr_25660_25689[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (15))){
var inst_25614 = (state_25654[(8)]);
var inst_25629 = new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(inst_25614);
var inst_25630 = cljs.core.first.call(null,inst_25629);
var inst_25631 = new cljs.core.Keyword(null,"file","file",-1269645878).cljs$core$IFn$_invoke$arity$1(inst_25630);
var inst_25632 = [cljs.core.str("Figwheel: Not loading code with warnings - "),cljs.core.str(inst_25631)].join('');
var inst_25633 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),inst_25632);
var state_25654__$1 = state_25654;
var statearr_25661_25690 = state_25654__$1;
(statearr_25661_25690[(2)] = inst_25633);

(statearr_25661_25690[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (13))){
var inst_25638 = (state_25654[(2)]);
var state_25654__$1 = state_25654;
var statearr_25662_25691 = state_25654__$1;
(statearr_25662_25691[(2)] = inst_25638);

(statearr_25662_25691[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (6))){
var state_25654__$1 = state_25654;
var statearr_25663_25692 = state_25654__$1;
(statearr_25663_25692[(2)] = null);

(statearr_25663_25692[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (17))){
var inst_25636 = (state_25654[(2)]);
var state_25654__$1 = state_25654;
var statearr_25664_25693 = state_25654__$1;
(statearr_25664_25693[(2)] = inst_25636);

(statearr_25664_25693[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (3))){
var inst_25652 = (state_25654[(2)]);
var state_25654__$1 = state_25654;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25654__$1,inst_25652);
} else {
if((state_val_25655 === (12))){
var inst_25613 = (state_25654[(9)]);
var inst_25627 = figwheel.client.block_reload_file_state_QMARK_.call(null,inst_25613,opts);
var state_25654__$1 = state_25654;
if(cljs.core.truth_(inst_25627)){
var statearr_25665_25694 = state_25654__$1;
(statearr_25665_25694[(1)] = (15));

} else {
var statearr_25666_25695 = state_25654__$1;
(statearr_25666_25695[(1)] = (16));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (2))){
var state_25654__$1 = state_25654;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25654__$1,(4),ch);
} else {
if((state_val_25655 === (11))){
var inst_25614 = (state_25654[(8)]);
var inst_25619 = cljs.core.PersistentVector.EMPTY_NODE;
var inst_25620 = figwheel.client.file_reloading.reload_js_files.call(null,opts,inst_25614);
var inst_25621 = cljs.core.async.timeout.call(null,(1000));
var inst_25622 = [inst_25620,inst_25621];
var inst_25623 = (new cljs.core.PersistentVector(null,2,(5),inst_25619,inst_25622,null));
var state_25654__$1 = state_25654;
return cljs.core.async.ioc_alts_BANG_.call(null,state_25654__$1,(14),inst_25623);
} else {
if((state_val_25655 === (9))){
var inst_25614 = (state_25654[(8)]);
var inst_25640 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"warn","warn",-436710552),"Figwheel: code autoloading is OFF");
var inst_25641 = new cljs.core.Keyword(null,"files","files",-472457450).cljs$core$IFn$_invoke$arity$1(inst_25614);
var inst_25642 = cljs.core.map.call(null,new cljs.core.Keyword(null,"file","file",-1269645878),inst_25641);
var inst_25643 = [cljs.core.str("Not loading: "),cljs.core.str(inst_25642)].join('');
var inst_25644 = figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),inst_25643);
var state_25654__$1 = (function (){var statearr_25667 = state_25654;
(statearr_25667[(10)] = inst_25640);

return statearr_25667;
})();
var statearr_25668_25696 = state_25654__$1;
(statearr_25668_25696[(2)] = inst_25644);

(statearr_25668_25696[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (5))){
var inst_25607 = (state_25654[(7)]);
var inst_25609 = [new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),null,new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),null];
var inst_25610 = (new cljs.core.PersistentArrayMap(null,2,inst_25609,null));
var inst_25611 = (new cljs.core.PersistentHashSet(null,inst_25610,null));
var inst_25612 = figwheel.client.focus_msgs.call(null,inst_25611,inst_25607);
var inst_25613 = cljs.core.map.call(null,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863),inst_25612);
var inst_25614 = cljs.core.first.call(null,inst_25612);
var inst_25615 = figwheel.client.autoload_QMARK_.call(null);
var state_25654__$1 = (function (){var statearr_25669 = state_25654;
(statearr_25669[(9)] = inst_25613);

(statearr_25669[(8)] = inst_25614);

return statearr_25669;
})();
if(cljs.core.truth_(inst_25615)){
var statearr_25670_25697 = state_25654__$1;
(statearr_25670_25697[(1)] = (8));

} else {
var statearr_25671_25698 = state_25654__$1;
(statearr_25671_25698[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (14))){
var inst_25625 = (state_25654[(2)]);
var state_25654__$1 = state_25654;
var statearr_25672_25699 = state_25654__$1;
(statearr_25672_25699[(2)] = inst_25625);

(statearr_25672_25699[(1)] = (13));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (16))){
var state_25654__$1 = state_25654;
var statearr_25673_25700 = state_25654__$1;
(statearr_25673_25700[(2)] = null);

(statearr_25673_25700[(1)] = (17));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (10))){
var inst_25646 = (state_25654[(2)]);
var state_25654__$1 = (function (){var statearr_25674 = state_25654;
(statearr_25674[(11)] = inst_25646);

return statearr_25674;
})();
var statearr_25675_25701 = state_25654__$1;
(statearr_25675_25701[(2)] = null);

(statearr_25675_25701[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25655 === (8))){
var inst_25613 = (state_25654[(9)]);
var inst_25617 = figwheel.client.reload_file_state_QMARK_.call(null,inst_25613,opts);
var state_25654__$1 = state_25654;
if(cljs.core.truth_(inst_25617)){
var statearr_25676_25702 = state_25654__$1;
(statearr_25676_25702[(1)] = (11));

} else {
var statearr_25677_25703 = state_25654__$1;
(statearr_25677_25703[(1)] = (12));

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
});})(c__21172__auto___25685,ch))
;
return ((function (switch__21060__auto__,c__21172__auto___25685,ch){
return (function() {
var figwheel$client$file_reloader_plugin_$_state_machine__21061__auto__ = null;
var figwheel$client$file_reloader_plugin_$_state_machine__21061__auto____0 = (function (){
var statearr_25681 = [null,null,null,null,null,null,null,null,null,null,null,null];
(statearr_25681[(0)] = figwheel$client$file_reloader_plugin_$_state_machine__21061__auto__);

(statearr_25681[(1)] = (1));

return statearr_25681;
});
var figwheel$client$file_reloader_plugin_$_state_machine__21061__auto____1 = (function (state_25654){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_25654);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e25682){if((e25682 instanceof Object)){
var ex__21064__auto__ = e25682;
var statearr_25683_25704 = state_25654;
(statearr_25683_25704[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25654);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e25682;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__25705 = state_25654;
state_25654 = G__25705;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$file_reloader_plugin_$_state_machine__21061__auto__ = function(state_25654){
switch(arguments.length){
case 0:
return figwheel$client$file_reloader_plugin_$_state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$file_reloader_plugin_$_state_machine__21061__auto____1.call(this,state_25654);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$file_reloader_plugin_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$file_reloader_plugin_$_state_machine__21061__auto____0;
figwheel$client$file_reloader_plugin_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$file_reloader_plugin_$_state_machine__21061__auto____1;
return figwheel$client$file_reloader_plugin_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___25685,ch))
})();
var state__21174__auto__ = (function (){var statearr_25684 = f__21173__auto__.call(null);
(statearr_25684[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___25685);

return statearr_25684;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___25685,ch))
);


return ((function (ch){
return (function (msg_hist){
cljs.core.async.put_BANG_.call(null,ch,msg_hist);

return msg_hist;
});
;})(ch))
});
figwheel.client.truncate_stack_trace = (function figwheel$client$truncate_stack_trace(stack_str){
return cljs.core.take_while.call(null,(function (p1__25706_SHARP_){
return cljs.core.not.call(null,cljs.core.re_matches.call(null,/.*eval_javascript_STAR__STAR_.*/,p1__25706_SHARP_));
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
var base_path_25713 = figwheel.client.utils.base_url_path.call(null);
figwheel.client.eval_javascript_STAR__STAR_ = ((function (base_path_25713){
return (function figwheel$client$eval_javascript_STAR__STAR_(code,opts,result_handler){
try{var _STAR_print_fn_STAR_25711 = cljs.core._STAR_print_fn_STAR_;
var _STAR_print_newline_STAR_25712 = cljs.core._STAR_print_newline_STAR_;
cljs.core._STAR_print_fn_STAR_ = figwheel.client.repl_print_fn;

cljs.core._STAR_print_newline_STAR_ = false;

try{return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"success","success",1890645906),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"value","value",305978217),figwheel.client.utils.eval_helper.call(null,code,opts)], null));
}finally {cljs.core._STAR_print_newline_STAR_ = _STAR_print_newline_STAR_25712;

cljs.core._STAR_print_fn_STAR_ = _STAR_print_fn_STAR_25711;
}}catch (e25710){if((e25710 instanceof Error)){
var e = e25710;
return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 5, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"exception","exception",-335277064),new cljs.core.Keyword(null,"value","value",305978217),cljs.core.pr_str.call(null,e),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"stacktrace","stacktrace",-95588394),clojure.string.join.call(null,"\n",figwheel.client.truncate_stack_trace.call(null,e.stack)),new cljs.core.Keyword(null,"base-path","base-path",495760020),base_path_25713], null));
} else {
var e = e25710;
return result_handler.call(null,new cljs.core.PersistentArrayMap(null, 4, [new cljs.core.Keyword(null,"status","status",-1997798413),new cljs.core.Keyword(null,"exception","exception",-335277064),new cljs.core.Keyword(null,"ua-product","ua-product",938384227),figwheel.client.get_ua_product.call(null),new cljs.core.Keyword(null,"value","value",305978217),cljs.core.pr_str.call(null,e),new cljs.core.Keyword(null,"stacktrace","stacktrace",-95588394),"No stacktrace available."], null));

}
}});})(base_path_25713))
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
figwheel.client.repl_plugin = (function figwheel$client$repl_plugin(p__25714){
var map__25721 = p__25714;
var map__25721__$1 = ((((!((map__25721 == null)))?((((map__25721.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25721.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25721):map__25721);
var opts = map__25721__$1;
var build_id = cljs.core.get.call(null,map__25721__$1,new cljs.core.Keyword(null,"build-id","build-id",1642831089));
return ((function (map__25721,map__25721__$1,opts,build_id){
return (function (p__25723){
var vec__25724 = p__25723;
var map__25725 = cljs.core.nth.call(null,vec__25724,(0),null);
var map__25725__$1 = ((((!((map__25725 == null)))?((((map__25725.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25725.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25725):map__25725);
var msg = map__25725__$1;
var msg_name = cljs.core.get.call(null,map__25725__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25724,(1));
if(cljs.core._EQ_.call(null,new cljs.core.Keyword(null,"repl-eval","repl-eval",-1784727398),msg_name)){
figwheel.client.ensure_cljs_user.call(null);

return figwheel.client.eval_javascript_STAR__STAR_.call(null,new cljs.core.Keyword(null,"code","code",1586293142).cljs$core$IFn$_invoke$arity$1(msg),opts,((function (vec__25724,map__25725,map__25725__$1,msg,msg_name,_,map__25721,map__25721__$1,opts,build_id){
return (function (res){
return figwheel.client.socket.send_BANG_.call(null,new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"figwheel-event","figwheel-event",519570592),"callback",new cljs.core.Keyword(null,"callback-name","callback-name",336964714),new cljs.core.Keyword(null,"callback-name","callback-name",336964714).cljs$core$IFn$_invoke$arity$1(msg),new cljs.core.Keyword(null,"content","content",15833224),res], null));
});})(vec__25724,map__25725,map__25725__$1,msg,msg_name,_,map__25721,map__25721__$1,opts,build_id))
);
} else {
return null;
}
});
;})(map__25721,map__25721__$1,opts,build_id))
});
figwheel.client.css_reloader_plugin = (function figwheel$client$css_reloader_plugin(opts){
return (function (p__25731){
var vec__25732 = p__25731;
var map__25733 = cljs.core.nth.call(null,vec__25732,(0),null);
var map__25733__$1 = ((((!((map__25733 == null)))?((((map__25733.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25733.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25733):map__25733);
var msg = map__25733__$1;
var msg_name = cljs.core.get.call(null,map__25733__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25732,(1));
if(cljs.core._EQ_.call(null,msg_name,new cljs.core.Keyword(null,"css-files-changed","css-files-changed",720773874))){
return figwheel.client.file_reloading.reload_css_files.call(null,opts,msg);
} else {
return null;
}
});
});
figwheel.client.compile_fail_warning_plugin = (function figwheel$client$compile_fail_warning_plugin(p__25735){
var map__25745 = p__25735;
var map__25745__$1 = ((((!((map__25745 == null)))?((((map__25745.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25745.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25745):map__25745);
var on_compile_warning = cljs.core.get.call(null,map__25745__$1,new cljs.core.Keyword(null,"on-compile-warning","on-compile-warning",-1195585947));
var on_compile_fail = cljs.core.get.call(null,map__25745__$1,new cljs.core.Keyword(null,"on-compile-fail","on-compile-fail",728013036));
return ((function (map__25745,map__25745__$1,on_compile_warning,on_compile_fail){
return (function (p__25747){
var vec__25748 = p__25747;
var map__25749 = cljs.core.nth.call(null,vec__25748,(0),null);
var map__25749__$1 = ((((!((map__25749 == null)))?((((map__25749.cljs$lang$protocol_mask$partition0$ & (64))) || (map__25749.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__25749):map__25749);
var msg = map__25749__$1;
var msg_name = cljs.core.get.call(null,map__25749__$1,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863));
var _ = cljs.core.nthnext.call(null,vec__25748,(1));
var pred__25751 = cljs.core._EQ_;
var expr__25752 = msg_name;
if(cljs.core.truth_(pred__25751.call(null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),expr__25752))){
return on_compile_warning.call(null,msg);
} else {
if(cljs.core.truth_(pred__25751.call(null,new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),expr__25752))){
return on_compile_fail.call(null,msg);
} else {
return null;
}
}
});
;})(map__25745,map__25745__$1,on_compile_warning,on_compile_fail))
});
figwheel.client.heads_up_plugin_msg_handler = (function figwheel$client$heads_up_plugin_msg_handler(opts,msg_hist_SINGLEQUOTE_){
var msg_hist = figwheel.client.focus_msgs.call(null,new cljs.core.PersistentHashSet(null, new cljs.core.PersistentArrayMap(null, 3, [new cljs.core.Keyword(null,"compile-failed","compile-failed",-477639289),null,new cljs.core.Keyword(null,"compile-warning","compile-warning",43425356),null,new cljs.core.Keyword(null,"files-changed","files-changed",-1418200563),null], null), null),msg_hist_SINGLEQUOTE_);
var msg_names = cljs.core.map.call(null,new cljs.core.Keyword(null,"msg-name","msg-name",-353709863),msg_hist);
var msg = cljs.core.first.call(null,msg_hist);
var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__,msg_hist,msg_names,msg){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__,msg_hist,msg_names,msg){
return (function (state_25968){
var state_val_25969 = (state_25968[(1)]);
if((state_val_25969 === (7))){
var inst_25892 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25892)){
var statearr_25970_26016 = state_25968__$1;
(statearr_25970_26016[(1)] = (8));

} else {
var statearr_25971_26017 = state_25968__$1;
(statearr_25971_26017[(1)] = (9));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (20))){
var inst_25962 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25972_26018 = state_25968__$1;
(statearr_25972_26018[(2)] = inst_25962);

(statearr_25972_26018[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (27))){
var inst_25958 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25973_26019 = state_25968__$1;
(statearr_25973_26019[(2)] = inst_25958);

(statearr_25973_26019[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (1))){
var inst_25885 = figwheel.client.reload_file_state_QMARK_.call(null,msg_names,opts);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25885)){
var statearr_25974_26020 = state_25968__$1;
(statearr_25974_26020[(1)] = (2));

} else {
var statearr_25975_26021 = state_25968__$1;
(statearr_25975_26021[(1)] = (3));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (24))){
var inst_25960 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25976_26022 = state_25968__$1;
(statearr_25976_26022[(2)] = inst_25960);

(statearr_25976_26022[(1)] = (20));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (4))){
var inst_25966 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_25968__$1,inst_25966);
} else {
if((state_val_25969 === (15))){
var inst_25964 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25977_26023 = state_25968__$1;
(statearr_25977_26023[(2)] = inst_25964);

(statearr_25977_26023[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (21))){
var inst_25923 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25978_26024 = state_25968__$1;
(statearr_25978_26024[(2)] = inst_25923);

(statearr_25978_26024[(1)] = (20));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (31))){
var inst_25947 = figwheel.client.css_loaded_state_QMARK_.call(null,msg_names);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25947)){
var statearr_25979_26025 = state_25968__$1;
(statearr_25979_26025[(1)] = (34));

} else {
var statearr_25980_26026 = state_25968__$1;
(statearr_25980_26026[(1)] = (35));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (32))){
var inst_25956 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25981_26027 = state_25968__$1;
(statearr_25981_26027[(2)] = inst_25956);

(statearr_25981_26027[(1)] = (27));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (33))){
var inst_25945 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25982_26028 = state_25968__$1;
(statearr_25982_26028[(2)] = inst_25945);

(statearr_25982_26028[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (13))){
var inst_25906 = figwheel.client.heads_up.clear.call(null);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(16),inst_25906);
} else {
if((state_val_25969 === (22))){
var inst_25927 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25928 = figwheel.client.heads_up.append_message.call(null,inst_25927);
var state_25968__$1 = state_25968;
var statearr_25983_26029 = state_25968__$1;
(statearr_25983_26029[(2)] = inst_25928);

(statearr_25983_26029[(1)] = (24));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (36))){
var inst_25954 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25984_26030 = state_25968__$1;
(statearr_25984_26030[(2)] = inst_25954);

(statearr_25984_26030[(1)] = (32));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (29))){
var inst_25938 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25985_26031 = state_25968__$1;
(statearr_25985_26031[(2)] = inst_25938);

(statearr_25985_26031[(1)] = (27));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (6))){
var inst_25887 = (state_25968[(7)]);
var state_25968__$1 = state_25968;
var statearr_25986_26032 = state_25968__$1;
(statearr_25986_26032[(2)] = inst_25887);

(statearr_25986_26032[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (28))){
var inst_25934 = (state_25968[(2)]);
var inst_25935 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25936 = figwheel.client.heads_up.display_warning.call(null,inst_25935);
var state_25968__$1 = (function (){var statearr_25987 = state_25968;
(statearr_25987[(8)] = inst_25934);

return statearr_25987;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(29),inst_25936);
} else {
if((state_val_25969 === (25))){
var inst_25932 = figwheel.client.heads_up.clear.call(null);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(28),inst_25932);
} else {
if((state_val_25969 === (34))){
var inst_25949 = figwheel.client.heads_up.flash_loaded.call(null);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(37),inst_25949);
} else {
if((state_val_25969 === (17))){
var inst_25914 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25988_26033 = state_25968__$1;
(statearr_25988_26033[(2)] = inst_25914);

(statearr_25988_26033[(1)] = (15));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (3))){
var inst_25904 = figwheel.client.compile_refail_state_QMARK_.call(null,msg_names);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25904)){
var statearr_25989_26034 = state_25968__$1;
(statearr_25989_26034[(1)] = (13));

} else {
var statearr_25990_26035 = state_25968__$1;
(statearr_25990_26035[(1)] = (14));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (12))){
var inst_25900 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_25991_26036 = state_25968__$1;
(statearr_25991_26036[(2)] = inst_25900);

(statearr_25991_26036[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (2))){
var inst_25887 = (state_25968[(7)]);
var inst_25887__$1 = figwheel.client.autoload_QMARK_.call(null);
var state_25968__$1 = (function (){var statearr_25992 = state_25968;
(statearr_25992[(7)] = inst_25887__$1);

return statearr_25992;
})();
if(cljs.core.truth_(inst_25887__$1)){
var statearr_25993_26037 = state_25968__$1;
(statearr_25993_26037[(1)] = (5));

} else {
var statearr_25994_26038 = state_25968__$1;
(statearr_25994_26038[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (23))){
var inst_25930 = figwheel.client.rewarning_state_QMARK_.call(null,msg_names);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25930)){
var statearr_25995_26039 = state_25968__$1;
(statearr_25995_26039[(1)] = (25));

} else {
var statearr_25996_26040 = state_25968__$1;
(statearr_25996_26040[(1)] = (26));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (35))){
var state_25968__$1 = state_25968;
var statearr_25997_26041 = state_25968__$1;
(statearr_25997_26041[(2)] = null);

(statearr_25997_26041[(1)] = (36));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (19))){
var inst_25925 = figwheel.client.warning_append_state_QMARK_.call(null,msg_names);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25925)){
var statearr_25998_26042 = state_25968__$1;
(statearr_25998_26042[(1)] = (22));

} else {
var statearr_25999_26043 = state_25968__$1;
(statearr_25999_26043[(1)] = (23));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (11))){
var inst_25896 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_26000_26044 = state_25968__$1;
(statearr_26000_26044[(2)] = inst_25896);

(statearr_26000_26044[(1)] = (10));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (9))){
var inst_25898 = figwheel.client.heads_up.clear.call(null);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(12),inst_25898);
} else {
if((state_val_25969 === (5))){
var inst_25889 = new cljs.core.Keyword(null,"autoload","autoload",-354122500).cljs$core$IFn$_invoke$arity$1(opts);
var state_25968__$1 = state_25968;
var statearr_26001_26045 = state_25968__$1;
(statearr_26001_26045[(2)] = inst_25889);

(statearr_26001_26045[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (14))){
var inst_25916 = figwheel.client.compile_fail_state_QMARK_.call(null,msg_names);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25916)){
var statearr_26002_26046 = state_25968__$1;
(statearr_26002_26046[(1)] = (18));

} else {
var statearr_26003_26047 = state_25968__$1;
(statearr_26003_26047[(1)] = (19));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (26))){
var inst_25940 = figwheel.client.warning_state_QMARK_.call(null,msg_names);
var state_25968__$1 = state_25968;
if(cljs.core.truth_(inst_25940)){
var statearr_26004_26048 = state_25968__$1;
(statearr_26004_26048[(1)] = (30));

} else {
var statearr_26005_26049 = state_25968__$1;
(statearr_26005_26049[(1)] = (31));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (16))){
var inst_25908 = (state_25968[(2)]);
var inst_25909 = new cljs.core.Keyword(null,"exception-data","exception-data",-512474886).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25910 = figwheel.client.format_messages.call(null,inst_25909);
var inst_25911 = new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25912 = figwheel.client.heads_up.display_error.call(null,inst_25910,inst_25911);
var state_25968__$1 = (function (){var statearr_26006 = state_25968;
(statearr_26006[(9)] = inst_25908);

return statearr_26006;
})();
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(17),inst_25912);
} else {
if((state_val_25969 === (30))){
var inst_25942 = new cljs.core.Keyword(null,"message","message",-406056002).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25943 = figwheel.client.heads_up.display_warning.call(null,inst_25942);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(33),inst_25943);
} else {
if((state_val_25969 === (10))){
var inst_25902 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_26007_26050 = state_25968__$1;
(statearr_26007_26050[(2)] = inst_25902);

(statearr_26007_26050[(1)] = (4));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (18))){
var inst_25918 = new cljs.core.Keyword(null,"exception-data","exception-data",-512474886).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25919 = figwheel.client.format_messages.call(null,inst_25918);
var inst_25920 = new cljs.core.Keyword(null,"cause","cause",231901252).cljs$core$IFn$_invoke$arity$1(msg);
var inst_25921 = figwheel.client.heads_up.display_error.call(null,inst_25919,inst_25920);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(21),inst_25921);
} else {
if((state_val_25969 === (37))){
var inst_25951 = (state_25968[(2)]);
var state_25968__$1 = state_25968;
var statearr_26008_26051 = state_25968__$1;
(statearr_26008_26051[(2)] = inst_25951);

(statearr_26008_26051[(1)] = (36));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_25969 === (8))){
var inst_25894 = figwheel.client.heads_up.flash_loaded.call(null);
var state_25968__$1 = state_25968;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_25968__$1,(11),inst_25894);
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
});})(c__21172__auto__,msg_hist,msg_names,msg))
;
return ((function (switch__21060__auto__,c__21172__auto__,msg_hist,msg_names,msg){
return (function() {
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto__ = null;
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto____0 = (function (){
var statearr_26012 = [null,null,null,null,null,null,null,null,null,null];
(statearr_26012[(0)] = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto__);

(statearr_26012[(1)] = (1));

return statearr_26012;
});
var figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto____1 = (function (state_25968){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_25968);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e26013){if((e26013 instanceof Object)){
var ex__21064__auto__ = e26013;
var statearr_26014_26052 = state_25968;
(statearr_26014_26052[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_25968);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e26013;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__26053 = state_25968;
state_25968 = G__26053;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto__ = function(state_25968){
switch(arguments.length){
case 0:
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto____1.call(this,state_25968);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto____0;
figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto____1;
return figwheel$client$heads_up_plugin_msg_handler_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__,msg_hist,msg_names,msg))
})();
var state__21174__auto__ = (function (){var statearr_26015 = f__21173__auto__.call(null);
(statearr_26015[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_26015;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__,msg_hist,msg_names,msg))
);

return c__21172__auto__;
});
figwheel.client.heads_up_plugin = (function figwheel$client$heads_up_plugin(opts){
var ch = cljs.core.async.chan.call(null);
figwheel.client.heads_up_config_options_STAR__STAR_ = opts;

var c__21172__auto___26116 = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto___26116,ch){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto___26116,ch){
return (function (state_26099){
var state_val_26100 = (state_26099[(1)]);
if((state_val_26100 === (1))){
var state_26099__$1 = state_26099;
var statearr_26101_26117 = state_26099__$1;
(statearr_26101_26117[(2)] = null);

(statearr_26101_26117[(1)] = (2));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_26100 === (2))){
var state_26099__$1 = state_26099;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_26099__$1,(4),ch);
} else {
if((state_val_26100 === (3))){
var inst_26097 = (state_26099[(2)]);
var state_26099__$1 = state_26099;
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_26099__$1,inst_26097);
} else {
if((state_val_26100 === (4))){
var inst_26087 = (state_26099[(7)]);
var inst_26087__$1 = (state_26099[(2)]);
var state_26099__$1 = (function (){var statearr_26102 = state_26099;
(statearr_26102[(7)] = inst_26087__$1);

return statearr_26102;
})();
if(cljs.core.truth_(inst_26087__$1)){
var statearr_26103_26118 = state_26099__$1;
(statearr_26103_26118[(1)] = (5));

} else {
var statearr_26104_26119 = state_26099__$1;
(statearr_26104_26119[(1)] = (6));

}

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_26100 === (5))){
var inst_26087 = (state_26099[(7)]);
var inst_26089 = figwheel.client.heads_up_plugin_msg_handler.call(null,opts,inst_26087);
var state_26099__$1 = state_26099;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_26099__$1,(8),inst_26089);
} else {
if((state_val_26100 === (6))){
var state_26099__$1 = state_26099;
var statearr_26105_26120 = state_26099__$1;
(statearr_26105_26120[(2)] = null);

(statearr_26105_26120[(1)] = (7));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_26100 === (7))){
var inst_26095 = (state_26099[(2)]);
var state_26099__$1 = state_26099;
var statearr_26106_26121 = state_26099__$1;
(statearr_26106_26121[(2)] = inst_26095);

(statearr_26106_26121[(1)] = (3));


return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
if((state_val_26100 === (8))){
var inst_26091 = (state_26099[(2)]);
var state_26099__$1 = (function (){var statearr_26107 = state_26099;
(statearr_26107[(8)] = inst_26091);

return statearr_26107;
})();
var statearr_26108_26122 = state_26099__$1;
(statearr_26108_26122[(2)] = null);

(statearr_26108_26122[(1)] = (2));


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
});})(c__21172__auto___26116,ch))
;
return ((function (switch__21060__auto__,c__21172__auto___26116,ch){
return (function() {
var figwheel$client$heads_up_plugin_$_state_machine__21061__auto__ = null;
var figwheel$client$heads_up_plugin_$_state_machine__21061__auto____0 = (function (){
var statearr_26112 = [null,null,null,null,null,null,null,null,null];
(statearr_26112[(0)] = figwheel$client$heads_up_plugin_$_state_machine__21061__auto__);

(statearr_26112[(1)] = (1));

return statearr_26112;
});
var figwheel$client$heads_up_plugin_$_state_machine__21061__auto____1 = (function (state_26099){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_26099);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e26113){if((e26113 instanceof Object)){
var ex__21064__auto__ = e26113;
var statearr_26114_26123 = state_26099;
(statearr_26114_26123[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_26099);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e26113;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__26124 = state_26099;
state_26099 = G__26124;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$heads_up_plugin_$_state_machine__21061__auto__ = function(state_26099){
switch(arguments.length){
case 0:
return figwheel$client$heads_up_plugin_$_state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$heads_up_plugin_$_state_machine__21061__auto____1.call(this,state_26099);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$heads_up_plugin_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$heads_up_plugin_$_state_machine__21061__auto____0;
figwheel$client$heads_up_plugin_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$heads_up_plugin_$_state_machine__21061__auto____1;
return figwheel$client$heads_up_plugin_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto___26116,ch))
})();
var state__21174__auto__ = (function (){var statearr_26115 = f__21173__auto__.call(null);
(statearr_26115[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto___26116);

return statearr_26115;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto___26116,ch))
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
var c__21172__auto__ = cljs.core.async.chan.call(null,(1));
cljs.core.async.impl.dispatch.run.call(null,((function (c__21172__auto__){
return (function (){
var f__21173__auto__ = (function (){var switch__21060__auto__ = ((function (c__21172__auto__){
return (function (state_26145){
var state_val_26146 = (state_26145[(1)]);
if((state_val_26146 === (1))){
var inst_26140 = cljs.core.async.timeout.call(null,(3000));
var state_26145__$1 = state_26145;
return cljs.core.async.impl.ioc_helpers.take_BANG_.call(null,state_26145__$1,(2),inst_26140);
} else {
if((state_val_26146 === (2))){
var inst_26142 = (state_26145[(2)]);
var inst_26143 = figwheel.client.heads_up.display_system_warning.call(null,"Connection from different project","Shutting connection down!!!!!");
var state_26145__$1 = (function (){var statearr_26147 = state_26145;
(statearr_26147[(7)] = inst_26142);

return statearr_26147;
})();
return cljs.core.async.impl.ioc_helpers.return_chan.call(null,state_26145__$1,inst_26143);
} else {
return null;
}
}
});})(c__21172__auto__))
;
return ((function (switch__21060__auto__,c__21172__auto__){
return (function() {
var figwheel$client$enforce_project_plugin_$_state_machine__21061__auto__ = null;
var figwheel$client$enforce_project_plugin_$_state_machine__21061__auto____0 = (function (){
var statearr_26151 = [null,null,null,null,null,null,null,null];
(statearr_26151[(0)] = figwheel$client$enforce_project_plugin_$_state_machine__21061__auto__);

(statearr_26151[(1)] = (1));

return statearr_26151;
});
var figwheel$client$enforce_project_plugin_$_state_machine__21061__auto____1 = (function (state_26145){
while(true){
var ret_value__21062__auto__ = (function (){try{while(true){
var result__21063__auto__ = switch__21060__auto__.call(null,state_26145);
if(cljs.core.keyword_identical_QMARK_.call(null,result__21063__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
continue;
} else {
return result__21063__auto__;
}
break;
}
}catch (e26152){if((e26152 instanceof Object)){
var ex__21064__auto__ = e26152;
var statearr_26153_26155 = state_26145;
(statearr_26153_26155[(5)] = ex__21064__auto__);


cljs.core.async.impl.ioc_helpers.process_exception.call(null,state_26145);

return new cljs.core.Keyword(null,"recur","recur",-437573268);
} else {
throw e26152;

}
}})();
if(cljs.core.keyword_identical_QMARK_.call(null,ret_value__21062__auto__,new cljs.core.Keyword(null,"recur","recur",-437573268))){
var G__26156 = state_26145;
state_26145 = G__26156;
continue;
} else {
return ret_value__21062__auto__;
}
break;
}
});
figwheel$client$enforce_project_plugin_$_state_machine__21061__auto__ = function(state_26145){
switch(arguments.length){
case 0:
return figwheel$client$enforce_project_plugin_$_state_machine__21061__auto____0.call(this);
case 1:
return figwheel$client$enforce_project_plugin_$_state_machine__21061__auto____1.call(this,state_26145);
}
throw(new Error('Invalid arity: ' + arguments.length));
};
figwheel$client$enforce_project_plugin_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$0 = figwheel$client$enforce_project_plugin_$_state_machine__21061__auto____0;
figwheel$client$enforce_project_plugin_$_state_machine__21061__auto__.cljs$core$IFn$_invoke$arity$1 = figwheel$client$enforce_project_plugin_$_state_machine__21061__auto____1;
return figwheel$client$enforce_project_plugin_$_state_machine__21061__auto__;
})()
;})(switch__21060__auto__,c__21172__auto__))
})();
var state__21174__auto__ = (function (){var statearr_26154 = f__21173__auto__.call(null);
(statearr_26154[cljs.core.async.impl.ioc_helpers.USER_START_IDX] = c__21172__auto__);

return statearr_26154;
})();
return cljs.core.async.impl.ioc_helpers.run_state_machine_wrapped.call(null,state__21174__auto__);
});})(c__21172__auto__))
);

return c__21172__auto__;
} else {
return null;
}
} else {
return null;
}
});
});
figwheel.client.default_on_jsload = cljs.core.identity;
figwheel.client.default_on_compile_fail = (function figwheel$client$default_on_compile_fail(p__26157){
var map__26164 = p__26157;
var map__26164__$1 = ((((!((map__26164 == null)))?((((map__26164.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26164.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26164):map__26164);
var ed = map__26164__$1;
var formatted_exception = cljs.core.get.call(null,map__26164__$1,new cljs.core.Keyword(null,"formatted-exception","formatted-exception",-116489026));
var exception_data = cljs.core.get.call(null,map__26164__$1,new cljs.core.Keyword(null,"exception-data","exception-data",-512474886));
var cause = cljs.core.get.call(null,map__26164__$1,new cljs.core.Keyword(null,"cause","cause",231901252));
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"debug","debug",-1608172596),"Figwheel: Compile Exception");

var seq__26166_26170 = cljs.core.seq.call(null,figwheel.client.format_messages.call(null,exception_data));
var chunk__26167_26171 = null;
var count__26168_26172 = (0);
var i__26169_26173 = (0);
while(true){
if((i__26169_26173 < count__26168_26172)){
var msg_26174 = cljs.core._nth.call(null,chunk__26167_26171,i__26169_26173);
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),msg_26174);

var G__26175 = seq__26166_26170;
var G__26176 = chunk__26167_26171;
var G__26177 = count__26168_26172;
var G__26178 = (i__26169_26173 + (1));
seq__26166_26170 = G__26175;
chunk__26167_26171 = G__26176;
count__26168_26172 = G__26177;
i__26169_26173 = G__26178;
continue;
} else {
var temp__4657__auto___26179 = cljs.core.seq.call(null,seq__26166_26170);
if(temp__4657__auto___26179){
var seq__26166_26180__$1 = temp__4657__auto___26179;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__26166_26180__$1)){
var c__19173__auto___26181 = cljs.core.chunk_first.call(null,seq__26166_26180__$1);
var G__26182 = cljs.core.chunk_rest.call(null,seq__26166_26180__$1);
var G__26183 = c__19173__auto___26181;
var G__26184 = cljs.core.count.call(null,c__19173__auto___26181);
var G__26185 = (0);
seq__26166_26170 = G__26182;
chunk__26167_26171 = G__26183;
count__26168_26172 = G__26184;
i__26169_26173 = G__26185;
continue;
} else {
var msg_26186 = cljs.core.first.call(null,seq__26166_26180__$1);
figwheel.client.utils.log.call(null,new cljs.core.Keyword(null,"info","info",-317069002),msg_26186);

var G__26187 = cljs.core.next.call(null,seq__26166_26180__$1);
var G__26188 = null;
var G__26189 = (0);
var G__26190 = (0);
seq__26166_26170 = G__26187;
chunk__26167_26171 = G__26188;
count__26168_26172 = G__26189;
i__26169_26173 = G__26190;
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
figwheel.client.default_on_compile_warning = (function figwheel$client$default_on_compile_warning(p__26191){
var map__26194 = p__26191;
var map__26194__$1 = ((((!((map__26194 == null)))?((((map__26194.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26194.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26194):map__26194);
var w = map__26194__$1;
var message = cljs.core.get.call(null,map__26194__$1,new cljs.core.Keyword(null,"message","message",-406056002));
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
var seq__26202 = cljs.core.seq.call(null,plugins);
var chunk__26203 = null;
var count__26204 = (0);
var i__26205 = (0);
while(true){
if((i__26205 < count__26204)){
var vec__26206 = cljs.core._nth.call(null,chunk__26203,i__26205);
var k = cljs.core.nth.call(null,vec__26206,(0),null);
var plugin = cljs.core.nth.call(null,vec__26206,(1),null);
if(cljs.core.truth_(plugin)){
var pl_26208 = plugin.call(null,system_options);
cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,k,((function (seq__26202,chunk__26203,count__26204,i__26205,pl_26208,vec__26206,k,plugin){
return (function (_,___$1,___$2,msg_hist){
return pl_26208.call(null,msg_hist);
});})(seq__26202,chunk__26203,count__26204,i__26205,pl_26208,vec__26206,k,plugin))
);
} else {
}

var G__26209 = seq__26202;
var G__26210 = chunk__26203;
var G__26211 = count__26204;
var G__26212 = (i__26205 + (1));
seq__26202 = G__26209;
chunk__26203 = G__26210;
count__26204 = G__26211;
i__26205 = G__26212;
continue;
} else {
var temp__4657__auto__ = cljs.core.seq.call(null,seq__26202);
if(temp__4657__auto__){
var seq__26202__$1 = temp__4657__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__26202__$1)){
var c__19173__auto__ = cljs.core.chunk_first.call(null,seq__26202__$1);
var G__26213 = cljs.core.chunk_rest.call(null,seq__26202__$1);
var G__26214 = c__19173__auto__;
var G__26215 = cljs.core.count.call(null,c__19173__auto__);
var G__26216 = (0);
seq__26202 = G__26213;
chunk__26203 = G__26214;
count__26204 = G__26215;
i__26205 = G__26216;
continue;
} else {
var vec__26207 = cljs.core.first.call(null,seq__26202__$1);
var k = cljs.core.nth.call(null,vec__26207,(0),null);
var plugin = cljs.core.nth.call(null,vec__26207,(1),null);
if(cljs.core.truth_(plugin)){
var pl_26217 = plugin.call(null,system_options);
cljs.core.add_watch.call(null,figwheel.client.socket.message_history_atom,k,((function (seq__26202,chunk__26203,count__26204,i__26205,pl_26217,vec__26207,k,plugin,seq__26202__$1,temp__4657__auto__){
return (function (_,___$1,___$2,msg_hist){
return pl_26217.call(null,msg_hist);
});})(seq__26202,chunk__26203,count__26204,i__26205,pl_26217,vec__26207,k,plugin,seq__26202__$1,temp__4657__auto__))
);
} else {
}

var G__26218 = cljs.core.next.call(null,seq__26202__$1);
var G__26219 = null;
var G__26220 = (0);
var G__26221 = (0);
seq__26202 = G__26218;
chunk__26203 = G__26219;
count__26204 = G__26220;
i__26205 = G__26221;
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
var args26222 = [];
var len__19428__auto___26225 = arguments.length;
var i__19429__auto___26226 = (0);
while(true){
if((i__19429__auto___26226 < len__19428__auto___26225)){
args26222.push((arguments[i__19429__auto___26226]));

var G__26227 = (i__19429__auto___26226 + (1));
i__19429__auto___26226 = G__26227;
continue;
} else {
}
break;
}

var G__26224 = args26222.length;
switch (G__26224) {
case 1:
return figwheel.client.start.cljs$core$IFn$_invoke$arity$1((arguments[(0)]));

break;
case 0:
return figwheel.client.start.cljs$core$IFn$_invoke$arity$0();

break;
default:
throw (new Error([cljs.core.str("Invalid arity: "),cljs.core.str(args26222.length)].join('')));

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
var len__19428__auto___26233 = arguments.length;
var i__19429__auto___26234 = (0);
while(true){
if((i__19429__auto___26234 < len__19428__auto___26233)){
args__19435__auto__.push((arguments[i__19429__auto___26234]));

var G__26235 = (i__19429__auto___26234 + (1));
i__19429__auto___26234 = G__26235;
continue;
} else {
}
break;
}

var argseq__19436__auto__ = ((((0) < args__19435__auto__.length))?(new cljs.core.IndexedSeq(args__19435__auto__.slice((0)),(0))):null);
return figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic(argseq__19436__auto__);
});

figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic = (function (p__26230){
var map__26231 = p__26230;
var map__26231__$1 = ((((!((map__26231 == null)))?((((map__26231.cljs$lang$protocol_mask$partition0$ & (64))) || (map__26231.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__26231):map__26231);
var opts = map__26231__$1;
return figwheel.client.start.call(null,opts);
});

figwheel.client.watch_and_reload.cljs$lang$maxFixedArity = (0);

figwheel.client.watch_and_reload.cljs$lang$applyTo = (function (seq26229){
return figwheel.client.watch_and_reload.cljs$core$IFn$_invoke$arity$variadic(cljs.core.seq.call(null,seq26229));
});

//# sourceMappingURL=client.js.map