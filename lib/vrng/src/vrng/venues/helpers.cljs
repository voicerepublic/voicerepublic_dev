(ns vrng.venues.helpers
  (:require
   [vrng.util :as u :refer [t state to-millis]]
   [vrng.venues.state :as state :refer [page-state]]
   ))

;; Extract app actions from helpers/utils into own namespace
(defn venue [] (:venue @state))

(defn now [] (* 1000 (:now @state)))

(defn listener-count []
  (:listener_count (:stats @page-state)))

(defn toggle-talkbar-action []
  (swap! page-state assoc :talkbar-expanded (not (@page-state :talkbar-expanded))))

(defn new-talk-path [] (str "/talks/new?talk%5Bvenue_id%5D=" (:id (venue))))

(defn format-countdown [millis]
  (let [[days hours minutes seconds] (u/to-dhms millis)]
    (cond
      (< millis 0) (str (goog.string.format
                         "%02dh %02dm %02ds"
                         hours minutes seconds) " overdue")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format
             "%02dh %02dm %02ds"
             hours minutes seconds))))

(defn talks-by-state [talk-state]
  (filter #(= talk-state (:state %)) (:talks (venue))))

(defn next-talk []
  (if (empty? (talks-by-state "live"))
              (second (sort-by :starts_at (talks-by-state "prelive")))
      (first (sort-by :starts_at (talks-by-state "prelive")))))


(defn active-talk []
  (or (first (talks-by-state "live"))
      (first (sort-by :starts_at (talks-by-state "prelive")))))

(defn active-talk-state [] (:state (active-talk)))

(defn active-talk-runtime []
  (- (now) (to-millis (:started_at (active-talk)))))

(defn active-talk-in-state [active-talk-states]
  (some #(= (active-talk-state) %) active-talk-states))

(defn onair? []
  (active-talk-in-state ["live"]))

(defn time-to-active-talk []
  (- (to-millis (:starts_at (active-talk))) (now)))

(defn time-to-next-talk []
  (- (to-millis (:starts_at (next-talk))) (now)))

(defn talk-list [talk-states sort-options]
  (doall (mapcat #(apply sort-by (conj sort-options (talks-by-state %))) talk-states)))

