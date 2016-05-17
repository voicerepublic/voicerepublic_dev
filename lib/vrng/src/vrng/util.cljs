(ns vrng.util
  (:require
   [reagent.core :as reagent :refer [atom]]))

(defonce state
  (atom (js->clj (.-initialSnapshot js/window) :keywordize-keys true)))

(defonce translations
  (atom (js->clj (.-translations js/window))))

;; ---

(defn t [& key]
  (let [keys (flatten (map #(clojure.string/split % ".") key))]
    (reduce get @translations keys)))

(defn millis [datetime]
  (.parse js/Date datetime))

(defn millis-to-dhms [millis]
  (let [base    (/ (Math/abs millis) 1000)
        minute  60
        hour    (* 60 minute)
        day     (* 24 hour)
        days    (int (/ base day))
        hours   (int (/ base hour))
        minutes (- (int (/ base minute)) (* hours minute))
        seconds (- (int base) (* hours hour) (* minutes minute))]
    [days hours minutes seconds]))

(defn percentage [current total]
  (min 100 (* current (/ 100 total))))

;; ---

(defn update-snapshot [a-atom a-message]
  (if (= (a-message :event) "snapshot")
    (reset! a-atom (a-message :snapshot))))

;; ---

(defn inc-now [a-map]
  (update-in a-map [:now] inc))

(defn start-timer [a-atom]
  (js/setInterval #(swap! a-atom inc-now) 1000))

;; ---

(defn setup-faye [channel handler]
  (print "Subscribe" channel "...")
  (.subscribe js/fayeClient channel
              #(handler (js->clj %  :keywordize-keys true))))
