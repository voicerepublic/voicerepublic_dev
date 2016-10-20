(ns vrng.media
  (:require
   [vrng.util :as u]
   [reagent.core :refer [atom]]))

;; --- state

(defonce state (atom {:gesture-required false
                      :mode "none" ; streamed, static, or none
                      :duration 0
                      :offset 0}))

;; --- private

(defn- streamed? []
  (= (@state :mode) "streamed"))

(defn- static? []
  (= (@state :mode) "static"))

(defn- audio-element
  "There has do be an audio tag with id audio in the page.

  https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement"
  []
  (u/element-by-id "audio"))

(defn- play-error-handler [error]
  (prn error)
  (swap! state assoc :gesture-required true))

;; --- public getter

(defn gesture-required? []
  (:gesture-required @state))

(defn paused? []
  (.-paused (audio-element)))

(defn source []
  (.-currentSrc (audio-element)))

(defn current-runtime []
  (if (streamed?)
    (/ (+ (:offset @state) (:play-time @state)) 1000)
    (:current-time @state)))

(defn duration []
  (:duration @state))

(defn progress-percentage []
  (u/percentage (current-runtime) (duration)))

(defn volume-percentage []
  (str (* 100 (:volume @state)) "%"))

;; --- public setter

(defn source! [source]
  (aset (audio-element) "autoplay" "none")
  (aset (audio-element) "preload" "none")
  (aset (audio-element) "src" source))

(defn offset! [offset]
  (swap! state assoc :offset offset))

(defn volume! [volume]
  (swap! state assoc :volume volume)
  (aset (audio-element) "volume" volume))

(defn play! []
  (let [promise (.play (audio-element))]
    ;;(.log js/console "play returned" promise)
    (if promise
      ;; if the play promise throws up^H^H an error...
      (.catch promise play-error-handler))))

(defn pause! []
  (.pause (audio-element)))

;; TODO seek should talk a value 0..1
(defn seek! [time]
  (aset (audio-element) "currentTime" time))

(defn mode! [mode]
  (swap! state assoc :mode mode))

(defn duration! [duration]
  (swap! state assoc :duration duration))

(defn on-playing! [callback]
  (swap! state assoc :on-playing callback))

;; --- updater

(def callback-timeout (* 1000 60)) ; 1 minute

(defn- update-state! []
  (when (not (paused?))
    (swap! state assoc :gesture-required false)
    (swap! state assoc :duration (max (duration) (current-runtime)))
    (swap! state assoc :paused false)
    (swap! state update :play-time (partial + 250))
    (swap! state assoc :current-time (.-currentTime (audio-element)))
    (when-let [callback (:on-playing @state)]
      (when (= 0 (mod (:play-time @state) callback-timeout))
        (callback)))))

(defonce updater (js/setInterval update-state! 250))
