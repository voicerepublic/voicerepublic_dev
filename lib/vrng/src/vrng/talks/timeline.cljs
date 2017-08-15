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

(defn timeline-comp
  "progress bar for audio player with fallback"
  []
  [:div.timeline.jp-seek-bar {:style {:width "0%"
                                                            :clip-path "url(#progress)"
                                                            :position "relative"}}
   [:div.container {:on-click seek-action :style {:position "absolute"}}]
   [:div.track-buffered.jp-play-bar {:style {:width "0%"
                                             :background "#4a4502"}}]
        [:div.track-playing.jp-play-bar
         {:style {:width (str (m/progress-percentage) "%")
                  :background "#ffed00"}}]])
