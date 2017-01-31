(ns vrng.util
  (:require
   [reagent.core :as reagent :refer [atom]]
   [clojure.string :as str]
   goog.string.format
   cljsjs.moment
   cljsjs.moment.locale.de))

;; ------------------------------
;; DOM

(defn content-by-name [name]
  (aget (.getElementsByName js/document name) 0 "content"))

(defn value-by-name [name]
  (aget (.getElementsByName js/document name) 0 "value"))

(defn set-value-by-name [name value]
  (let [element (aget (.getElementsByName js/document name) 0)]
    (set! (.-value element) value)))

(def url-encode (.-encodeURI js/window))

(defn element-by-id [id]
  (.getElementById js/document id))

;; ------------------------------
;; STATE

(defonce state
  (atom (js->clj (.-initialSnapshot js/window) :keywordize-keys true)))

(defn reset-state! [data]
  (reset! state data))

;; ------------------------------
;; TRANSLATIONS

(defonce translations
  (atom (js->clj (.-translations js/window))))

(defn- split-and-replace [placeholder value text]
  (-> text
      (str/split (str "%{" (name placeholder) "}"))
      (interleave (repeat value))
      butlast))

(defn- interpolate [text [placeholder value]]
  (map (partial split-and-replace placeholder value) text))

(defn t [key & interpolations]
  (as-> key $
    (str/split $ ".")
    (reduce get @translations $)
    (reduce interpolate [$] (apply hash-map interpolations))))
;;    (map-indexed (fn [i x] ^{:key i} x))))

;; ------------------------------
;; TIMES

(def datetime-format "YYYY-MM-DD hh:mm:ss Z")

(defn to-millis [datetime]
  (.format (.moment js/window datetime datetime-format) "x"))

(defn from-now [datetime]
  (.fromNow (.moment js/window datetime "x")))

(defn to-dhms [millis]
  (let [base    (/ (Math/abs millis) 1000)
        minute  60
        hour    (* 60 minute)
        day     (* 24 hour)
        days    (int (/ base day))
        hours   (int (/ base hour))
        minutes (- (int (/ base minute)) (* hours minute))
        seconds (- (int base) (* hours hour) (* minutes minute))]
    [days hours minutes seconds]))

(defn format-m-s [time]
  (let [[days hours minutes seconds] (to-dhms (* 1000 time))]
    (goog.string.format "%02d:%02d" (+ (* hours 60) minutes) seconds)))

(defn percentage [current total]
  (min 100 (* current (/ 100 total))))

(.locale js/moment "en") ;; or "de", depending on user settings


;; ------------------------------
;; TIMER

(defn inc-now [a-map]
  (update-in a-map [:now] inc))

(defn start-timer [a-atom]
  (js/setInterval #(swap! a-atom inc-now) 1000))

;; ------------------------------
;; MESSAGEING

(defn setup-faye [channel handler]
  (print "Subscribe" channel "...")
  (.subscribe js/fayeClient channel
              #(handler (js->clj %  :keywordize-keys true))))

;; ------------------------------
;; GA

(defn track-event [arguments]
  (if (exists? js/_gaq)
    (let [args (str/split arguments #" ")]
      (.push js/_gaq (clj->js (cons "_trackEvent" args))))
    (print "track:" arguments)))
