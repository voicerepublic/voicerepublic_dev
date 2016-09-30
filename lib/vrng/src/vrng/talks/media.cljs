(ns vrng.talks.media
  (:require
   [vrng.util :as u]
   [reagent.core :refer [atom]]))

;; --- state

(defonce player (atom {:gesture-required false
                       :mode nil ; streamed or static (live or archived)
                       :paused true
                       :scheduled-duration 0
                       :archived-duration 0
                       :source-url nil
                       :offset 0}))

;; --- private

(defn- streamed? []
  (= (@player :mode) "streamed"))

(defn- static? []
  (= (@player :mode) "static"))

(defn- audio-element
  "https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement"
  []
  (u/element-by-id "audio"))

(defn- play-error-handler [error]
  (prn error)
  (swap! player assoc :gesture-required true))

(defn- playing! []
  (swap! player assoc :paused false))

;; --- public

(defn paused? []
  (:paused @player))

(defn current-runtime []
  (if (streamed?)
    (/ (+ (:offset @player) (:play-time @player)) 1000)
    (:current-time @player)))

(defn duration []
  (if (streamed?)
    (max (@player :scheduled-duration) (current-runtime))
    (or (@player :archived-duration)
        (.-duration (audio-element)))))

(defn pause! []
  (swap! player assoc :paused true)
  (.pause (audio-element)))

(defn source! [source]
  (aset (audio-element) "autoplay" "none")
  (aset (audio-element) "preload" "none")
  (aset (audio-element) "src" source)
  ;; TODO remove pause
  (pause!))

(defn play! []
  (let [promise (.play (audio-element))]
    ;;(.log js/console "play returned" promise)
    (if promise
      ;; if the play promise throws up^H^H an error...
      (do
        (.catch promise play-error-handler)
        (.then promise playing!))
      (playing!))))

(defn progress-percentage []
  (u/percentage (current-runtime) (duration)))

(defn volume-percentage []
  (str (* 100 (:volume @player)) "%"))

(defn offset! [offset]
  (swap! player assoc :offset offset))

(defn volume! [volume]
  (swap! player assoc :volume volume)
  (aset (audio-element) "volume" volume))

;; TODO seek should talk a value 0..1
(defn seek! [time]
  (aset (audio-element) "currentTime" time))

;; --- updater

(defn- update-player []
  ;; track listening
  (when (not (paused?))
    (swap! player assoc :play-time (+ 250 (:play-time @player)))
    ;; TODO move into callback
    ;;(if (= 0 (mod (:play-time @player) (* 1000 60)))
      ;;(u/track-event (str "player playing talk:" (:id (talk)))))
    ;; update progress
    (swap! player assoc :current-time (.-currentTime (audio-element)))
    (print @player)))

(defonce updater (js/setInterval update-player 250))
