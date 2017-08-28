(ns vrng.venues.talkbar
  (:require
   [vrng.venues.state :as state :refer [page-state]]
   [vrng.venues.helpers :as helpers :refer [active-talk onair? next-talk venue listener-count format-countdown active-talk-runtime time-to-active-talk time-to-next-talk new-talk-path toggle-talkbar-action talk-list]]
   [vrng.helpers :refer [icon]]
   ))

<<<<<<< Updated upstream
(defn get-date-label
=======
(defn- get-date-label
>>>>>>> Stashed changes
  "overwrites label with TODAY for talks scheduled today"
  [date]
  (if (.isSame date (js/moment) "day")
    "TODAY"
    (.format date "DD-MM-YYYY")))

<<<<<<< Updated upstream
(defn get-start-date
=======
(defn- get-start-date
>>>>>>> Stashed changes
  "extacts start_at from talk and applies format DD-MM-YYYY"
  [talk]
  (get-date-label (new js/moment (:starts_at talk)) ))

<<<<<<< Updated upstream
(defn group-talks-by-date
  "returns a map with dates as keys and talks as values"
  [talks]
  (reduce (fn [acc talk]
            (update acc (-> talk get-start-date keyword)
                    (fn [item]
                      (conj (or item []) talk)))) {} talks))

(defn talk-item-comp
=======
(defn- group-talks-by-date
  "returns a map with dates as keys and talks as values"
  [talks]
  (reduce (fn [acc talk]
            (update acc (-> talk get-start-date keyword) conj talk)) {} talks))

(defn- talk-item-comp
>>>>>>> Stashed changes
  "returns a talk row component"
  [talk]
  ^{:key (:id talk)}
  [:div.small-12.columns.talkitem.clearfix
   [:p.clearfix
    [:span.title.float-left.text-left
     [:a {:href (:url talk)
          :target "_blank"}
      (:title talk)]]
    [:span.time.float-left.text-left (:starts_at_time talk)]
    [:span.series.float-left.text-left
     [:a {:href (:url (:series talk))} (:title (:series talk))]]
    [:span.duration.float-left.text-right (:duration talk)]]])

<<<<<<< Updated upstream
(defn day-comp
  "returns a day row component containing talks"
  [talk]
  ^{:key (nth talk 0)}
  [:div#listrow.row.clearfix
    [:div.small-12.columns.dayitem.clearfix [:p [:span (name (nth talk 0))]]]
=======
(defn- day-comp
  "returns a day row component containing talks"
  [date talks]
  ^{:key date}
  [:div#listrow.row.clearfix
    [:div.small-12.columns.dayitem.clearfix [:p [:span (name date)]]]
>>>>>>> Stashed changes
    [:div.small-12.columns.headeritem.clearfix
     [:p
      [:span "TITLE"]
      [:span "TIME"]
      [:span "SERIES"]
      [:span.text-right "DURATION"]]]
<<<<<<< Updated upstream
    (doall (map talk-item-comp (nth talk 1)))])
=======
    (doall (map talk-item-comp talks))])
>>>>>>> Stashed changes

(defn talkbar-comp
  "the current/next and the dropdown with all scheduled and past talks"
  []
  [:div#talkbar
   {:style {:height (if (@page-state :talkbar-expanded) "auto" "36px")}}
   ;;current
   [:div#current
    (if (active-talk)
      [:p#current-talk-title
       [:span.next-talk "Now: "]
       [:a {:href (:url (active-talk))} (:title (active-talk))]
       (if (onair?)
         [:span.listener-info {:title "listeners"}
          [icon "person"] " " (listener-count)])
       [:span.float-right.time-info (format-countdown
                                     (if (onair?)
                                       (active-talk-runtime)
                                       (time-to-active-talk)))]])]
   (if (next-talk)
     [:div#next
      [:span.next-talk "Next: "]
      [:a {:href (:url (next-talk))} (:title (next-talk))]
      [:span.float-right.time-info (format-countdown (time-to-next-talk))]]
     ;;)
     [:div#next
      [:a {:href (new-talk-path)} "+ Schedule Live Stream"]])

   ;;dropdown
   [:div#list-toggle
    [:a.float-left.hide-for-small-only
     {:href "#" :on-click toggle-talkbar-action}
     [:span.show-for-medium.float-left "ALL TALKS"]
     [icon "list"]]
    [:a.see-all.show-for-small-only.text-center "view all"]]
<<<<<<< Updated upstream
   (map #(day-comp %) (into (group-talks-by-date (talk-list ["live" "prelive"] [:starts_at <]))))])
=======
   (map (partial apply day-comp) (group-talks-by-date (talk-list ["live" "prelive"] [:starts_at <])))])
>>>>>>> Stashed changes

