(ns vrng.talk
  (:require
   [vrng.util :as u :refer [t state]]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   goog.string.format))

;; -------------------------
;; Helpers

(defn channel []
  (:channel (:talk @state)))

(defn starts-at []
  (:starts_at (:talk @state)))

(defn started-at []
  (:started_at (:talk @state)))

(defn now []
  (:now @state))

(defn stream-url []
  (:stream_url (:venue (:talk @state))))

(defn title []
  (:title (:talk @state)))

(defn teaser []
  (:teaser (:talk @state)))

(defn description []
  (:description (:talk @state)))

(defn play-count []
  (:play_count (:talk @state)))

(defn series-title []
  (:title (:series (:talk @state))))

(defn series-url []
  (:url (:series (:talk @state))))

(defn user-name []
  (:name (:user (:venue (:talk @state)))))

(defn user-url []
  (:url (:user (:venue (:talk @state)))))

(defn image-url []
  (:image_url (:talk @state)))

(defn messages []
  (:messages (:talk @state)))

(defn pin-id []
  (:pin-id (:talk @state)))

;; -------------------------
;; Utils

(defn time-to-start []
  (- (u/millis (starts-at)) (* 1000 (:now @state))))

(defn format-countdown [millis]
  "Returns a textual respresentation of the countdown."
  (let [[days hours minutes seconds] (u/millis-to-dhms millis)]
    (cond
      (< millis 0) (t "any_time_now")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format "%02dh %02dm %02ds" hours minutes seconds))))

;; -------------------------
;; Actions

;;(defn add-message-action []
;;  )

;; -------------------------
;; Components

(defn countdown-comp []
  [:h1 (format-countdown (time-to-start))])

(defn audio-comp []
  [:audio { :auto-play "autoplay" }
   [:source { :src (stream-url) :data-x 1 }]])

(defn debug-comp []
  [:table
   [:tr
    [:td "channel"]
    [:td (channel)]]
   [:tr
    [:td "starts-at"]
    [:td (starts-at)]]
   [:tr
    [:td "started-at"]
    [:td (started-at)]]
   [:tr
    [:td "now"]
    [:td (now)]]
   [:tr
    [:td "stream-url"]
    [:td (stream-url)]]
   [:tr
    [:td "series-title"]
    [:td (series-title)]]
   [:tr
    [:td "series-url"]
    [:td (series-url)]]
   [:tr
    [:td "pin-id"]
    [:td (pin-id)]]
   [:tr
    [:td "user-name"]
    [:td (user-name)]]
   [:tr
    [:td "user-url"]
    [:td (user-url)]]
   [:tr
    [:td "image-url"]
    [:td (image-url)]]
   [:tr
    [:td "title"]
    [:td (title)]]
   [:tr
    [:td "messages"]
    [:td (str (messages))]]
   ])

(defn root-comp []
  [debug-comp])

;; -------------------------
;; Interfacing
;;
;; (defn stop-stream []
;;   (print "stop" (stream-url))
;;   (.jPlayer js/player "stop"))
;;
;; (defn start-stream []
;;   (print "start" (stream-url))
;;   (js/playMedia (clj->js (stream-url))))

;; -------------------------
;; Initialize & Messageing

(defn message-handler [message]
  (u/update-snapshot state message))

(defn mount-root []
  (reagent/render [root-comp] (.getElementById js/document "app"))
  (reagent/render [countdown-comp] (.getElementById js/document "mount-countdown"))
  (reagent/render [audio-comp] (.getElementById js/document "mount-audio")))

(defn init! []
  (u/start-timer state)
  (u/setup-faye (channel) message-handler)
  ;;(js/setTimeout #(start-stream) 1000) ;; move start-stream to message-handler
  (mount-root))
