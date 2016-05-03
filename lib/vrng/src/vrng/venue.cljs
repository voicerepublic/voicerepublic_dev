(ns vrng.venue
  (:require
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   [ajax.core :refer [PUT]]
   goog.string.format))

;;      [cljs.core.async :as async
;;    :refer [<! >! chan close! sliding-buffer put! alts! timeout]])
;;  (:require-macros [cljs.core.async.macros :as m :refer [go alt! go-loop]]))

;; -------------------------
;; State

(defonce state
  (atom (js->clj (.-initialState js/window) :keywordize-keys true)))

(defonce translations
  (atom (js->clj (.-translations js/window))))

;; -------------------------
;; Utils

(defn venue-slug []
  (:slug (:venue @state)))

(defn venue-url []
  (str "/venues/" (venue-slug)))

(defn t [& key]
  (let [keys (flatten (map #(clojure.string/split % ".") key))]
    (reduce get @translations keys)))

(defn talks-by-state [talk-state]
  (filter #(= talk-state (:state %)) (vals (:talks @state))))

(defn active-talk []
  (last (sort :starts_at (talks-by-state "prelive"))))

(defn active-talk-title []
  (:title (active-talk)))

(defn active-talk-state []
  (:state (active-talk)))


(defn millis [datetime]
  (.parse js/Date datetime))

(defn time-to-active-talk []
  (- (millis (:starts_at (active-talk))) (* 1000 (:now @state))))

(defn time-to-available []
  (* (- (:availability @state) (:now @state)) 1000))

(defn time-since-provisioning []
  (- (* (:now @state) 1000) (millis (:completed_provisioning_at (:venue @state)))))

(defn format-countdown [millis]
  (let [base    (/ (Math/abs millis) 1000)
        minute  60
        hour    (* 60 minute)
        day     (* 24 hour)
        days    (int (/ base day))
        hours   (int (/ base hour))
        minutes (- (int (/ base minute)) (* hours minute))
        seconds (- (int base) (* hours hour) (* minutes minute))]
    (cond
      (< millis 0) (str (goog.string.format "%02dh %02dm %02ds" hours minutes seconds) " over due")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format "%02dh %02dm %02ds" hours minutes seconds))))

(defn format-datetime [datetime]
  (.parse js/Date datetime))

(def back-channel
  (clojure.string/join "/" [nil, "up",
                            "user", (:id (:user @state)),
                            "venue", (:id (:venue @state))]))

(defn publish [message]
  (.publish js/fayeClient back-channel (clj->js message)))

(defn talk-button [event talk-id]
  #(publish { :event event :talk_id talk-id }))

;; -------------------------
;; Components

(defn venue-state []
  (:state (:venue @state)))

(defn venue-state-component []
  [:span (t "state" (venue-state))])

(defn venue-name []
  (:name (:venue @state)))

(defn talk-comp [talk]
  ^{:key (talk :id)}
  [:li
   (talk :starts_at)
   (talk :title)
   "(" (talk :id) ")"
   ;;(if (= (talk :state) "prelive")
   ;;  [:button {:type "button"
   ;;            :class "button"
   ;;            :on-click (talk-button "start" (talk :id))} (t "start")])
   ;;(if (= (talk :state) "live")
   ;;  [:button {:type "button"
   ;;            :class "button alert"
   ;;            :on-click (talk-button "stop" (talk :id))} (t "stop")])
   ])

(defn select-device [device-id]
  (PUT (venue-url)
       {:format :json
        :params { :venue {:device_id device-id
                          :event "device_selected" }}}))

(defn device-comp [device]
  ^{:key (device :id)}
  [:li (device :name)
   [:button {:on-click #(select-device (device :id))} (t "select")]])

(defn talk-listing [talk-state]
  [:ul
   (doall
    (map talk-comp (talks-by-state talk-state)))])

(defn icecast-url []
  (:stream_url (:venue @state)))

(defn audio-comp []
  [:audio { :auto-play "autoplay" }
   [:source { :src (icecast-url) :data-x 1 }]])


(defn device-list []
  [:ul
   (doall
    (map device-comp (:devices @state)))])

(defn talk-section [talk-state]
  [:div
   [:h3 (t "talk_state" talk-state)]
   [talk-listing talk-state]])


;; -------------------------
;; Messageing

(defn set-talk-state [talk-state talk-id]
  ;;(print "set talk state of talk" talk-id "to" talk-state)
  ;;(print (:state ((keyword talk-id) (:talks @state))))
  (swap! state #(assoc-in % [:talks (keyword talk-id) :state] talk-state))
  ;;(print (:state ((keyword talk-id) (:talks @state))))
  )

;;(set-talk-state "live" 4148)


(defn update-atom [atom-data]
  (reset! state atom-data))

(defn update-venue-state [state-name]
  (print "Venue state now:" state-name)
  (swap! state #(assoc-in % [:venue :state] state-name)))

(defn venue-message-handler [msg]
  (condp = (:event msg)
    "venue-transition" (do
                         ;;(print msg)
                         (update-atom (:atom msg))
                         (update-venue-state (second (:args msg))))
    (print (str "Unknown message" msg))))
;;(cond
;;  (= (msg :event) "start_talk") (set-talk-state "live" (msg :talk_id))
;;  :else (print msg)))


;; -------------------------
;; Helpers

(defn talk-url [talk]
  (str "/xhr/talks/" (talk :id)))

(defn venue-in-state [venue-states]
  (some #(= (venue-state) %) venue-states))

(defn active-talk-in-state [active-talk-states]
  (some #(= (active-talk-state) %) active-talk-states))

;; -------------------------
;; Actions

(defn start-talk-action [talk]
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "start_talk!"}}}))

(defn start-server-action []
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "start_provisioning" }}}))





;; -------------------------
;; Shortcuts

(def container-classes
  "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left")


;; -------------------------
;; Components

(defn countdown-comp [millis]
  [:span (format-countdown millis)])



(defn server-status []
  (cond
    (venue-in-state ["select_device" "awaiting_stream" "connected" "disconnected"]) "success"
    (venue-in-state ["provisioning"]) "warning"
    (< (time-to-active-talk) (* 4 60 1000)) "alert"
    (venue-in-state ["available"]) "warning"
    :else "neutral"))

(defn device-status []
  (cond
    :else "neutral"))

(defn talk-status []
  (cond
    (active-talk-in-state ["live"]) "success"
    (< (time-to-active-talk) 0) "alert"
    (< (time-to-active-talk) (* 10 60 1000)) "warning"
    :else "neutral"))


(defn venue-status-label-comp []
  [:span])

(defn server-progress-comp []
  [:img {:src "/images/awaiting-loading.gif"}])

(defn talk-progress-comp []
  [:img {:src "/images/awaiting-loading.gif"}])



;; -------------------------
;; Views


(defn talk-start-button-comp [talk]
  [:button { :on-click #(start-talk-action talk) } (t "start")])

(defn server-start-button-comp []
  [:button { :on-click start-server-action } (t "setup")])

;; (defn home-page []
;;   [:div
;;    (if (venue-in-state ["connected"]) [:div [audio-comp]])
;;    [:section { :id "claim" :class "dark" }
;;     [:div { :class "row" }
;;      [:header
;;       [:h1 [venue-name-comp]]
;;       [:h2 [venue-state-component]]
;;       (if (venue-in-state ["offline"]) [countdown-comp (time-to-available)])
;;       (if (venue-in-state ["provisioning" "awaiting_stream"]) [server-progress-comp])
;;       (if (venue-in-state ["available"]) [server-start-button-comp])
;;       (if (venue-in-state ["provisioning" "select_device"]) [device-list])]]]
;;    [:section { :class "light" }
;;     [:div { :class "row" }
;;      [:div { :class container-classes }
;;       [:h2 [countdown-comp (time-to-active-talk)]]
;;       (if (= "connected" (venue-state))
;;         [talk-start-button-comp (active-talk)])
;;       [talk-section "live"]
;;       [talk-section "prelive"]
;;       [talk-section "archived"]
;;       ]]]])

(defn titlebar-comp [title status]
  [:div {:class "titlebar clearfix"}
   [:h4 {:class "title"} title
    [:span {:class (str status " badge float-right")} "∞"]]])

(defn server-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   (if (venue-in-state ["connected"]) [audio-comp])
   (cond
     (venue-in-state ["offline"])
     [:div {:class "holder"}
      [:p {:class "launchable-in float-left"} "Available in "
       [:span {:class "countdown", :id "time-till-provisioning"}
        [countdown-comp (time-to-available)]]]
      [:a {:class "button success tiny float-right server-start-button disabled"} "LAUNCH SERVER"]]

     (venue-in-state ["available"])
     [:div {:class "holder"}
      [:p {:class "launch-advice float-left"} "Start Server Now!"]
      [:a {:class "button success tiny float-right server-start-button"
           :on-click start-server-action} "LAUNCH SERVER"]]

     (venue-in-state ["provisioning"])
     [:div {:class "secondary progress server-progress", :role "progressbar",
            :tabindex "0", :aria-valuenow "25", :aria-valuemin "0",
            :aria-valuetext "25 percent", :aria-valuemax "100"}
      [:div {:class "progress-meter", :style { :width "25%" }}
       [:p {:class "progress-meter-text"} "Server is starting"]]]

     :else ;; all other
     [:div {:class "holder clearfix"}
      [:p {:class "label online-for"}] [countdown-comp (time-since-provisioning)]
      [:span {:class "float-right server-bitrate-wrapper"}
       [:span {:class "server-bitrate"} "--"] " kB/sec"]])])

(defn device-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   [:select
    [:option {:value "none"} "No Device Selected"]
    [:option {:value "butt"} "B.U.T.T."]
    [:option {:value "vr"} "VR Box 1"]
    [:option {:value "new"} "Setup New Device..."]]])

(defn talk-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   (cond
     (active-talk-in-state ["prelive"])
     [:div {:class "holder talk-phase2"}
      [:span {:class "label scheduled-start"} "Scheduled Start: "
       (format-countdown (time-to-active-talk))
       [:span {:class "clock-msg"}]
       [:span {:class "ago-msg hide"}]]
                                        ; add disabled as a link class if setup not ready
      [:a {:class "button success tiny talk-start-button float-right"
           :on-click start-talk-action} "Start Broadcast"]]

     (active-talk-in-state ["live"])
     [:div {:class "secondary progress talk-progress", :role "progressbar", :tabindex "0", :aria-valuenow "25", :aria-valuemin "0", :aria-valuetext "25 percent", :aria-valuemax "100"}
      [:div {:class "progress-meter", :style { :width "3%"}}
       [:p {:class "progress-meter-text"}]]
      [:a {:href "#", :class "button tiny alert talk-stop-button hollow has-tip tip-top", :data-tooltip "", :aria-haspopup "true", :data-disable-hover "false", :tabindex "1", :title "Are you sure you want to stop the stream early?"} "Stop Broadcast"]])])

(defn active-talk-title-prefix-comp []
  [:span {:class "talk-label"}
   (if (= (active-talk-state) "prelive")
     "NEXT UP: "
     "CURRENT TALK: ")])

(defn debug-comp []
  [:ul { :style { :color "magenta" } }
   [:li "now: " (:now @state)]
   [:li "avail: " (time-to-available) " - " (format-countdown (time-to-available))]
   [:li "active: " (time-to-active-talk) " - " (format-countdown (time-to-active-talk))]
   [:li "provis: " (time-since-provisioning) " - " (format-countdown (time-since-provisioning))]
   ])

(defn full-page []
  [:div {:id "page"}
   ;;[debug-comp]
   [:div {:id "venue-header", :class "clearfix row expanded"}
    [:div {:class "medium-6 columns"}
     [:h1 {:class "venue-title"} (venue-name)]
     [:p {:class "talk-title"}
      [active-talk-title-prefix-comp] (active-talk-title)]]
    [:div {:class "medium-6 columns dashboard"}
     [:span {:class "label on-air float-right"} "OFF AIR"]
     [:span {:class "soundbars float-right"}
      [:div {:id "bars"}
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]
       [:div {:class "bar-holder"}
        [:div {:class "bar"}]]]]
     [:div {:class "float-right listeners hide"}
      [:span {:class "listener-count"} "210"]
      [:span {:class "listener-label"} "LISTENERS"]]]]
   [:div {:class "row clearfix"}
    [:div {:id "venue-control-panel", :class "clearfix"}
     [:div {:class "medium-4 columns server-panel"}
      [titlebar-comp (t "streaming_server") (server-status)]
      [:div {:class "divider"}]
      [server-actionbar-comp]]
     [:div {:class "medium-4 columns device-panel"}
      [titlebar-comp (t "audio_source") (device-status)]
      [:div {:class "divider"}]
      [device-actionbar-comp]]
     [:div {:class "medium-4 columns talk-panel"}
      [titlebar-comp (t "broadcast") (talk-status)]
      [:div {:class "divider"}]
      [talk-actionbar-comp]]]]])

;; -------------------------
;; Initialize

(defn inc-now [state-map]
  (update-in state-map [:now] inc))

(defn start-timer []
  (js/setInterval #(swap! state inc-now) 1000))

(defn venue-channel []
  (:channel @state))

(defn setup-faye []
  (print "Subscribe" (venue-channel))
  (.subscribe js/fayeClient (venue-channel)
              #(venue-message-handler (js->clj %  :keywordize-keys true))))

(defn mount-root []
  (reagent/render [full-page] (.getElementById js/document "app")))

(defn request-availability []
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "become_available" }}}))


(defn init! []
  (start-timer)
  (setup-faye)
  (if (= (venue-state) "offline")
    (js/setTimeout request-availability (max 2000 (time-to-available))))
  (mount-root))

;; https://www.bignerdranch.com/blog/music-visualization-with-d3-js/
