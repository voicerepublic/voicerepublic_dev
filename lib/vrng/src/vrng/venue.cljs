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

(defn next-talk []
  (last (sort :starts_at (talks-by-state "prelive"))))


(defn millis [datetime]
  (.parse js/Date datetime))

(defn time-to-next-talk []
  (- (millis (:starts_at (next-talk))) (* 1000 (:now @state))))

(defn format-countdown [millis]
  (let [base    (/ millis 1000)
        minute  60
        hour    (* 60 minute)
        day     (* 24 hour)
        days    (int (/ base day))
        hours   (int (/ base hour))
        minutes (- (int (/ base minute)) (* hours minute))
        seconds (- (int base) (* hours hour) (* minutes minute))]
    (cond
      (< millis 0) (t "any_time_now")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format "%02d:%02d:%02d" hours minutes seconds))))

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
  [:span (:name (:venue @state))])

(defn talk-comp [talk]
  ^{:key (talk :id)}
  [:li
   (talk :starts_at)
   (talk :title)
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

(defn countdown [millis]
  [:span (format-countdown millis)])

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
;; Shortcuts

(def container-classes
  "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left")

;; -------------------------
;; Views

(defn put-setup []
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "start_provisioning" }}}))

;; fix InvalidAuthenticityToken
(defn setup []
  (put-setup))

(defn home-page []
  [:div
   (if (= "connected" (venue-state)) [:div [audio-comp]])
   [:section { :id "claim" :class "dark" }
    [:div { :class "row" }
     [:header
      [:h1 [venue-name]]
      [:h2 [venue-state-component]]
      (if (= (venue-state) "offline") [:button { :on-click setup } (t "setup")])
      (if (some #(= (venue-state) %) ["provisioning" "select_device"])
        [device-list])
      ]]]
   [:section { :class "light" }
    [:div { :class "row" }
     [:div { :class container-classes }
      [:h2 [countdown (time-to-next-talk)]]
      [talk-section "live"]
      [talk-section "prelive"]
      [talk-section "archived"]
      ]]]])

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
  (reagent/render [home-page] (.getElementById js/document "app")))





(defn init! []
  (start-timer)
  (setup-faye)
  (mount-root))
