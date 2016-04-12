(ns vrng.talk
  (:require
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
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
  [:span (t "state" (:state (:venue @state)))])

(defn venue-name []
  [:span (:name (:venue @state))])

(defn talk-comp [talk]
  ^{:key (talk :id)}
  [:li
   (talk :starts_at)
   (talk :title)
   (if (= (talk :state) "prelive")
     [:button {:type "button"
               :class "button"
               :on-click (talk-button "start" (talk :id))} (t "start")])
   (if (= (talk :state) "live")
     [:button {:type "button"
               :class "button alert"
               :on-click (talk-button "stop" (talk :id))} (t "stop")])
   ])

(defn talk-listing [talk-state]
  [:ul
   (doall
    (map talk-comp (talks-by-state talk-state)))])

(defn talk-section [talk-state]
  [:div
   [:h3 (t "talk_state" talk-state)]
   [talk-listing talk-state]])

(defn countdown []
  [:span (format-countdown (time-to-next-talk))])

;; -------------------------
;; Messageing

(defn set-talk-state [talk-state talk-id]
  ;;(print "set talk state of talk" talk-id "to" talk-state)
  ;;(print (:state ((keyword talk-id) (:talks @state))))
  (swap! state #(assoc-in % [:talks (keyword talk-id) :state] talk-state))
  ;;(print (:state ((keyword talk-id) (:talks @state))))
  )

;;(set-talk-state "live" 4148)

(defn venue-message-handler [msg]
  (print msg)
  (cond
    (= (msg :event) "start_talk") (set-talk-state "live" (msg :talk_id))
    :else (print msg)))

;; -------------------------
;; Shortcuts

(def container-classes
  "container medium-10 medium-offset-1 large-8 large-offset-2 columns text-left")

;; -------------------------
;; Views

(defn home-page []
  [:div
   [:section { :id "claim" :class "dark" }
    [:div { :class "row" }
     [:header
      [:h1 [venue-name]]
      [:h2 [venue-state]]
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

(def venue-channel
  (clojure.string/join "/" [nil, "down",
                            "venue", (:id (:venue @state))]))

(defn setup-faye []
  (.subscribe js/fayeClient venue-channel
              #(venue-message-handler (js->clj %  :keywordize-keys true))))

(defn mount-root []
  (reagent/render [home-page] (.getElementById js/document "talk-app"))
  (reagent/render [countdown] (.getElementById js/document "mount-countdown")))

(defn init! []
  (start-timer)
  (setup-faye)
  (mount-root))
