(ns vrng.talk
  (:require
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   goog.string.format))

;; -------------------------
;; State

(defonce state
  (atom (js->clj (.-initialState js/window) :keywordize-keys true)))

(defonce translations
  (atom (js->clj (.-translations js/window))))

;; -------------------------
;; State Shortcuts

(defn starts-at []
  (:starts_at (:talk @state)))

(defn now []
  (:now @state))

(defn talk-id []
  (:id (:talk @state)))

;; -------------------------
;; Utils (Regular Functions, as opposed to Components)

(defn t
  "Returns the translation for the given key(s)."
  [& key]
  (let [keys (flatten (map #(clojure.string/split % ".") key))]
    (reduce get @translations keys)))

(defn millis
  "Parses the given string a return the date time in milliseconds."
  [datetime]
  (.parse js/Date datetime))

(defn time-to-start
  "Returns time to start in millseconds."
  []
  (- (millis (starts-at)) (* 1000 (:now @state))))

(defn format-countdown [millis]
  "Returns a textual respresentation of the countdown."
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

;; -------------------------
;; Components

(defn countdown []
  [:h1 (format-countdown (time-to-start))])

;; -------------------------
;; Messageing

(defn set-talk-state [talk-state]
  (swap! state #(assoc-in % [:talk :state] talk-state)))

(defn message-handler [msg]
  (print msg)
  (cond
    (= (msg :event) "start_talk") (set-talk-state "live")
    :else (print msg)))

;; -------------------------
;; Initialize

(defn inc-now [state-map]
  (update-in state-map [:now] inc))

(defn start-timer []
  (js/setInterval #(swap! state inc-now) 1000))

(defn channel []
  (clojure.string/join "/" [nil, "down", "talk", (talk-id)]))

(defn setup-faye []
  (print (str "Subscribing to channel " (channel) "..."))
  (.subscribe js/fayeClient (channel)
              #(message-handler (js->clj %  :keywordize-keys true))))

(defn mount-root []
  (reagent/render [countdown] (.getElementById js/document "mount-countdown")))

(defn init! []
  (start-timer)
  (setup-faye)
  (mount-root))
