(ns vrng.talks.timeline
  (:require
   [vrng.util :as u :refer [t state track-event]]
   [vrng.media :as m]))

;; -------------------------
;; HELPERS

(defn talk [] (:talk @state))
(defn talk-state [] (:state (talk)))

(defn seek-action [event]
  (.stopPropagation event)
  (if (= (talk-state) "archived")
    (let [timeline (.-currentTarget event)
          left (.-left (.getBoundingClientRect timeline))
          right (.-right (.getBoundingClientRect timeline))
          current (.-clientX event)
          requested (/ (- left current) (- left right)) ; 0..1
          time (* (m/duration) requested)] ; in seconds
      (u/track-event (str "player seek talk:" (:id (talk))))
      (m/seek! time))))

(defn is-valid?
  [data]
  (not (clojure.string/blank? data)))

;; -------------------------
;; STYLES

(defn style-buffered
  [data]
  (if (is-valid? data) 
    {:style {:height "70px" :width "0%" :background "none"}}
    {:style {:height "12px" :width "0%" :background "#64697e"}}))

(defn style-playing
  [data]
  (if (is-valid? data)
    {:style {:height "70px" :background "#3F4044" :width (str (m/progress-percentage) "%")
             :mix-blend-mode "darken"}}
    {:style {:height "12px" :background "#54c6c6" :width (str (m/progress-percentage) "%")}}))

(defn style-timeline
  [data]
  (if (is-valid? data)
    {:style {:height "70px" :width "0%" :background "none"}}
    {:style {:height "12px" :width "0%" :background "rgba(60, 66, 88, 0.4)"
             }}))

(defn timeline-comp
  "progress bar for audio player with fallback"
  [data]
  [:div.timeline.jp-seek-bar (merge (style-buffered data) {:on-click seek-action}) 
   [:div.track-buffered.jp-play-bar (style-buffered data)]
   [:div.track-playing.jp-play-bar (style-playing data)]])
