(ns vrng.embeds.core
  (:require
   [vrng.helpers :as helpers :refer [icon]]
   [vrng.sporktrum :as spork]
   [vrng.talk :as talk]
   [vrng.util :as u :refer [t state track-event]]
   [vrng.media :as m]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   goog.string.format
   goog.string
   [clojure.string :as str]
   [ajax.core :refer [POST DELETE to-interceptor default-interceptors]]))


(enable-console-print!)

(defonce page-state (atom {:pin-id (.-pinId js/window)
                           :podcast-url (.-podcastUrl js/window)
                           :itunes-url (.-itunesUrl js/window)
                           ;; this needs to be a comp if not false
                           :popover-message false
                           :popover-share false}))

(defonce current-user
  (atom (js->clj (.-currentUser js/window) :keywordize-keys true)))

(defn volume-percentage []
  (m/volume-percentage))

(defn audio-meter-percentage []
  (str (u/percentage (:volume @spork/audio) 255) "%"))

(defn talk [] (:talk @state))

(defn slides-url [] (:slides_url (talk)))

(defn relative-time []
  (u/from-now (u/to-millis (:starts_at (talk)))))

(defn- humanize [num]
  (cond
    (< num 1000) (str num)
    (>= num 1000) (goog.string.format "%.1f k" (/ num 1000))))

(defn humanreadable-plays []
  (humanize (:play_count (talk))))

;; COMPS USED IN ACTIONS

(defn more-comp []
  (let [w (:width @page-state)]
    (cond
      (< w 900) [:a.more-link {:href "/"} "Moar!"]
      (>= w 900) [:a {:href "/"} "Even Moar!"])))

(defn please-login-comp []
  [:a {:href "/"} "Hey Dude!"])

;; ACTIONS

(defn adjust-volume-action [event]
  (.stopPropagation event)
  (u/track-event (str "embedplayer volume talk:" (:id (talk))))
  (let [meter (.-currentTarget event)
        top (.-top (.getBoundingClientRect meter))
        bottom (.-bottom (.getBoundingClientRect meter))
        current (.-clientY event)
        volume (/ (- bottom current) (- bottom top))]
    (m/volume! volume)))

(defn pin-action []
  (track-event "embedtalk pin-this-talk")
  (POST (str "/talks/" (:id (talk)) "/reminders")
        {:handler #(swap! page-state assoc :pin-id (get % "id"))}))

(defn unpin-action []
  (track-event "embedtalk unpin-this-talk")
  (DELETE (str "/reminders/" (:pin-id @page-state))
          {:handler #(swap! page-state assoc :pin-id nil)}))

(defn open-share-action []
  (swap! page-state assoc :popover-share true))

(defn close-share-action []
  (swap! page-state assoc :popover-share false))

(defn close-message-action []
  (swap! page-state assoc :popover-message false))

(defn pin-anon-action []
  (swap! page-state assoc :popover-message please-login-comp))

(defn play-action [event]
  (.stopPropagation event)
  (track-event (str "embedplayer pause talk:" (:id (talk))))
  (close-message-action)
  (m/play!))

(defn pause-action [event]
  (.stopPropagation event)
  (track-event (str "embedplayer pause talk:" (:id (talk))))
  (swap! page-state assoc :popover-message more-comp)
  (m/pause!))

;; COMPONENTS

(defn play-pause-button-comp []
  [:div.jp-controls
   (if (:paused @m/state)
     [:a.jp-play {:on-click play-action} [icon "play"]]
     [:a.jp-pause {:on-click pause-action} [icon "pause"]])])

(defn message-comp [nested-comp]
  [:div.embed-msg
   [nested-comp]
   (if-not (:paused @m/state)
    [:a.action-btn.close-msg
     {:title "Cancel"
      :on-click close-message-action} "×"])])

(defn action-panel-comp []
  [:div.action-panel

   ;;SLIDES
   (if (slides-url)
     [:a.action-btn.slides-btn
      {:href (:url (talk)) :title "View Slides" :target "_blank"}
      [icon "slides"]])

   [:div.jp-spacer]

   ;;CHAT
   [:a.action-btn.chat-btn
    {:href (:url (talk)) :title "Comment" :target "_blank"}
    [icon "chat"]]

   [:div.jp-spacer]

   ;;PIN
   [:div.pinboard
    (if js/signedIn
      (if (:pin-id @page-state)
        [:button.button.button-playbar.button-unpin
         {:on-click unpin-action} [icon "pin"]]
        [:button.button.button-playbar.button-pin
         {:on-click pin-action} [icon "pin-outline"]])
      [:button.button.button-playbar.button-pin
       {:on-click pin-anon-action} [icon "pin-outline"]])]
   ;; {:data-pin "3728"}
   ;; [:a.button.pin-btn
   ;;  {:href "#" :title "Pin" :data-msg "pinned"}
   ;;  [icon "pin"]
   ;;  [:span.pin-msg "Pin"]]
   ;; [:a.button.unpin-btn
   ;;  {:href "#"
   ;;   :style {:display "none"}
   ;;   :title "Un-Pin"
   ;;   :data-msg "unpinned"}
   ;;  [icon "pin"]
   ;;  [:span.pin-msg "Un-Pin"]]

   [:div.jp-spacer]

   ;;SHARE
   [:a.action-btn.action-share
    {:title "Share"
     :on-click open-share-action}
    [icon "share"]]])

(defn share-panel-comp []
  [:div.share-panel
   [:div.share-title [:p "share:"]]
   [:div.jp-spacer]
   [:div.action-btn.share.share-btn.twitter
    {:data-shareable-type "talk" :data-shareable-id "3728"}
    [:a
     {:href "#"}
     [icon "twitter"]]]
   [:div.jp-spacer]
   [:div.action-btn.facebook.share.share-btn
    {:data-shareable-type "talk" :data-shareable-id "3728"}
    [:a
     {:href "#"}
     [icon "facebook"]]]
   [:div.jp-spacer]
   [:div.action-btn.mail.share.share-btn
    {:data-shareable-type "talk" :data-shareable-id "3728"}
    [:a
     {:href
      "mailto:your@friend.com?body=Hi%20there%0A%0ACheck%20out%20this%20talk%20on%20voicerepublic.com%3A%20http%3A%2F%2Flocalhost%3A3000%2Fembed%2Ftalks%2Fthe-birth-of-comedy-ot-ouf-the-spirit-of-despair%0A%0ABest%20regards%0APhil%20Hofmann&subject=Check%20out%20this%20talk%20on%20voicerepublic.com"}
     [icon "email"]]]
   [:div.jp-spacer]
   [:a.action-btn.close-share {:title "Cancel"
                               :on-click close-share-action} "×"]
   [:div.jp-spacer]])

(defn progress-comp []
  [:div.jp-progress
   [:div.jp-seek-bar {:style {:width "100%"}}
    [:div.jp-play-bar {:style {:width (str (m/progress-percentage) "%")}}]]
   ;;[:div.loading-indicator
   ;; [:p
   ;;  [:span "Loading"]]]
   [:div.jp-time-holder
    [:span.jp-current-time (u/format-m-s (m/current-runtime))]
    [:span.time-divider "/"]
    [:span.jp-duration (u/format-m-s (m/duration))]]])

(defn root-comp []
  [:div.embed-player.clearfix.large

   ;;image
   [:div.image-box
    [:a {:href (:url (talk))}
     [:img {:src (:thumb_url (talk))}]]]

   ;; everything else
   [:div.content-box

    ;;title, meta-data, logo
    [:div.top-box.clearfix
     [:div.info-box
      [:a {:href (:url (talk)) :target "_blank"}
       [:h4.title (:title (talk))]]
      [:div.meta-info
       [:a.user
        {:href (get-in (talk) [:venue :user :url]) :target "_blank"}
        [:span (get-in (talk) [:venue :user :name])]]
       [:span.date.sm-up " / " (relative-time) " / "]
       [:span.play-count.sm-up (humanreadable-plays) " Plays"]]]
     [:div.branding-box
      [:a {:href (:url (talk)) :target "_blank"}
       [:div.brand-logo [icon "logo"]]
       [:div.brand-words [icon "logotype"]]]]]

    ;;player wrapper
    [:div.player-box

     ;;main UI
     [:div.jp-audio

      ;;player controls
      [:div.jp-gui.jp-interface

       [play-pause-button-comp]

       [:div.jp-spacer]

       ;;volume
       [:div.jp-volume-bar
        {:on-click adjust-volume-action}
        [:div.jp-volume-bar-value
         {:style {:height (volume-percentage)}}]
        [:div.jp-volume-bar-value-dancing
         {:style {:height (audio-meter-percentage)}}]]

       (if-let [message (:popover-message @page-state)]
         [message-comp message]
         [progress-comp])

       [:div.jp-spacer]

       (if (:popover-share @page-state)
         [share-panel-comp]
         [action-panel-comp])]]]]])

(defn mount-root []
  (reagent/render [root-comp] (.getElementById js/document "embedded-player"))
  ;;(reagent/render [m/debug-audio-comp] (.getElementById js/document "debug"))
  )

(defn init! []
  (mount-root))

(talk/init-audio! (:talk @state))

(js/setTimeout #(spork/setup-analyser-for-media-element "audio") 500)

(.addEventListener
 js/window "resize"
 (fn [e]
   (->> (.-outerWidth (.-target e))
        (swap! page-state assoc :width))))
