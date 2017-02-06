(ns vrng.talk
  (:require
   [vrng.util :as u :refer [state track-event]]
   [vrng.media :as m]))

(defn now [] (:now @state))

(defn time-since-start [talk]
  (- (* 1000 (now)) (u/to-millis (:started_at talk))))

(defn init-audio-live! [talk]
  (let [url (:stream_url talk)]
    (prn "init-audio-live! " url)
    (when (not= url (m/source))
      (m/source! url)
      (m/offset! (time-since-start talk))
      (m/mode! "streamed")
      (m/duration! (:scheduled_duration talk))
      (m/volume! 0.5)
      (m/on-playing!
       #(track-event (str "player playing-live talk:" (:id talk))))
      (m/play!))))

(defn init-audio-archived! [talk]
  (let [url (:mp3 (:media_links talk))]
    (prn "init-audio-archived! " url)
    (when (not= url (u/path-of-url (m/source)))
      (m/source! url)
      (m/pause!)
      (m/mode! "static")
      (m/duration! (:archived_duration talk))
      (m/on-playing!
       #(track-event (str "player playing-archived talk:" (:id talk))))
      (m/volume! 0.5))))

(defn init-audio! [talk]
  (case (:state talk)
    "live" (init-audio-live! talk)
    "archived" (init-audio-archived! talk)
    nil))
