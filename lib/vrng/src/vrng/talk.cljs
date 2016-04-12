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

(defn millis [datetime]
  (.parse js/Date datetime))

(defn time-to-start []
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

;; -------------------------
;; Components

(defn countdown []
  [:span (format-countdown (time-to-start))])

;; -------------------------
;; Messageing

(defn set-talk-state [talk-state]
  ;;(print "set talk state of talk" talk-id "to" talk-state)
  ;;(print (:state ((keyword talk-id) (:talks @state))))
  (swap! state #(assoc-in % [:talk :state] talk-state))
  ;;(print (:state ((keyword talk-id) (:talks @state))))
  )

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

(def channel
  (clojure.string/join "/" [nil, "down", "talk",
                            (:id (:talk @state))]))

(defn setup-faye []
  (.subscribe js/fayeClient channel
              #(message-handler (js->clj %  :keywordize-keys true))))

(defn mount-root []
  ;;(reagent/render [home-page] (.getElementById js/document "talk-app"))
  (reagent/render [countdown] (.getElementById js/document "mount-countdown")))

(defn init! []
  (start-timer)
  (setup-faye)
  (mount-root))
