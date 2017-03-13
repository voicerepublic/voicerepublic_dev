(ns vrng.embeds.core
  (:require
   [vrng.helpers :as helpers :refer [icon]]
   [vrng.sporktrum :as spork]
   [vrng.talk :as talk]
   [vrng.util :as u :refer [t state track-event log]]
   [vrng.media :as m]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   goog.string.format
   goog.string
   [clojure.string :as str]
   [ajax.core :refer [POST DELETE to-interceptor default-interceptors]]))


(def token   150)
(def tiny    320)
(def xs      480)
(def small   640)
(def medium 1024)

(defn responsive-class [width]
  "Returns the responsive class based on a given width."
  (condp > width
    token  "token"
    tiny   "tiny"
    xs     "xs"
    small  "small"
    medium "medium"
    "large")) ; else

(enable-console-print!)

(defonce page-state (atom {:user-name (.-userName js/window)
                           :pin-id (.-pinId js/window)
                           :podcast-url (.-podcastUrl js/window)
                           :itunes-url (.-itunesUrl js/window)
                           ;; this needs to be a comp if not false
                           :popover-message false
                           :popover-share false
                           :width nil
                           :now (js/Date.)}))

(defonce current-user
  (atom (js->clj (.-currentUser js/window) :keywordize-keys true)))

(defn volume-percentage []
  (m/volume-percentage))

(defn audio-meter-percentage []
  (str (u/percentage (:volume @spork/audio) 255) "%"))

(defn talk [] (:talk @state))

(defn slides-url [] (:slides_url (talk)))

(defn in-talk-state [& states]
  (not= -1 (.indexOf states (:state (:talk @state)))))

(defn relative-time []
  (u/from-now (u/to-millis (:starts_at (talk)))))

(defn relative-countdown []
  (if (> (:now @page-state) (u/to-millis (:starts_at (talk))))
    "any time now..."
    (relative-time)))


(defn- humanize [num]
  (cond
    (< num 1000) (str num)
    (>= num 1000) (goog.string.format "%.1f k" (/ num 1000))))

(defn humanreadable-plays []
  (humanize (:play_count (talk))))

(defn close-message-action []
  (swap! page-state assoc :popover-message false))

;; COMPS USED IN ACTIONS

(defn more-comp []
  [:div.msg-holder

   [:a.msg-text
    (case (:responsive-class @page-state)
      "xs"     "More..."
      "small"  "More on VR..."
      "medium" "More on Voice Republic..."
      :else    "There's more on Voice Republic...")]
   [:a.action-btn.close-msg
    {:title "Cancel"
     :on-click close-message-action} "×"]])

(defn please-login-comp []
  [:div.msg-holder
   [:a.msg-text {:href "/"}
    [:p
     [:span  "Please log in"]]]
   [:a.action-btn.close-msg
    {:title "Cancel"
     :on-click close-message-action} "×"]
   ])

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

(defn seek-action [event]
  ;;(.log js/console event)
  (.stopPropagation event)
  (if (= (:state (:talk @state)) "archived")
    (let [timeline (.-currentTarget event)
          left (.-left (.getBoundingClientRect timeline))
          right (.-right (.getBoundingClientRect timeline))
          current (.-clientX event)
          requested (/ (- left current) (- left right)) ; 0..1
          time (* (m/duration) requested)] ; in seconds
      ;;(.log js/console timeline left right current requested time)
      (u/track-event (str "embedplayer seek talk:" (:id (talk))))
      (m/seek! time))))

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
(defn responsive-size-display-comp []
  [:span (:responsive-class @page-state)])

(defn play-pause-button-comp []
  [:div.jp-controls
   {:class (if (in-talk-state "prelive") "disabled" "")}
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

   ;;SLIDES BUTTON
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


   [:div.jp-spacer]

   ;;SHARE
   [:a.action-btn.action-share
    {:title "Share"
     :on-click open-share-action}
    [icon "share"]]])

(defn share-url [target]
  (let [url (u/url-encode (.-location js/window))]
    (case target
      :facebook
      (str "https://www.facebook.com/sharer/sharer.php?u=" url)
      :twitter
      (str "https://twitter.com/intent/tweet?source=webclient&text=" url))))

;; TODO the clicks on social shares are not GA tracked, yet!
(defn share-panel-comp []
  [:div.share-panel
   [:div.share-title [:p "share:"]]
   [:div.jp-spacer]
   [:div.action-btn.share.share-btn.twitter
    {:data-shareable-type "talk" :data-shareable-id "3728"}
    [:a
     {:href (share-url :twitter)
      :target "_blank"}
     [icon "twitter"]]]
   [:div.jp-spacer]
   [:div.action-btn.facebook.share.share-btn
    {:data-shareable-type "talk" :data-shareable-id "3728"}
    [:a
     {:href (share-url :facebook)
      :target "_blank"}
     [icon "facebook"]]]
   [:div.jp-spacer]
   [:div.action-btn.mail.share.share-btn
    {:data-shareable-type "talk" :data-shareable-id "3728"}
    [:a
     {:href
      (str "mailto:your@friend.com?"
           "body=Hi%20there%0A%0ACheck%20out%20this%20talk%20on"
           "%20voicerepublic.com%3A%20"
           (:url (:talk @state))
           "%0A%0ABest%20regards%0A"
           (:user-name @page-state)
           "&subject=Check%20out%20this%20talk%20on"
           "%20voicerepublic.com")}
     [icon "email"]]]
   [:div.jp-spacer]
   [:a.action-btn.close-share {:title "Cancel"
                               :on-click close-share-action} "×"]
   [:div.jp-spacer]])

(defn progress-percentage []
  (if (in-talk-state "live")
    (str (m/progress-percentage) "%")
    "0%"))

(defn progress-comp []
  [:div.jp-progress
   [:div.jp-seek-bar {:style {:width "100%"}
                      :on-click seek-action}
    [:div.jp-play-bar {:style {:width (progress-percentage)}}]]
   ;;[:div.loading-indicator
   ;; [:p
   ;;  [:span "Loading"]]]
   (if-not (and (< (:width @page-state) small)
                (:popover-share @page-state))
     [:div.jp-time-holder
      (cond

        (in-talk-state "prelive")
        [:span "Starts " (relative-countdown)]

        (in-talk-state "postlive" "queued" "processing")
        [:span "Will be available shortly..."]

        (in-talk-state "suspended")
        [:span "Currently unavailable."]

        (in-talk-state "live")
        [:span
         [:span.jp-current-time (u/format-m-s (m/current-runtime))]
         [:span.time-divider "/"]
         [:span.jp-duration (u/format-m-s (m/duration))]]

        :else
        [:span "Unknown state " (:state (:talk @state))]

        )])])

(defn root-comp []
  [:div.embed-player.clearfix {:class (:responsive-class @page-state)}

   ;;image
   [:div.image-box ;{:class (image-class)}

    [:a {:href (:url (talk))}
     [:img {:src (:thumb_url (talk))}]]]

   ;; everything else
   [:div.content-box


    ;;title, meta-data, logo
    [:div.top-box.clearfix
     [:div.info-box
      [:a {:href (:url (talk)) :target "_blank"}
       [:h4.title
        (:title (talk))]]
      [:div.meta-info
       [:a.user
        {:href (get-in (talk) [:venue :user :url]) :target "_blank"}
        [:span (get-in (talk) [:venue :user :name])]]
       (when (in-talk-state "archived")
         [:span.date.sm-up " / " (relative-time)]
         [:span.play-count.sm-up " / " (humanreadable-plays) " Plays"])]]
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

(defn channel [] (:channel (:talk @state)))

(defn message-handler [message]
  (condp = (message :event)
    ;;"message" (add-new-comment message)
    "snapshot" (do
                 (u/reset-state! (:snapshot message))
                 (talk/init-audio! (:talk @state))
                 (when-not (in-talk-state "live")
                   (m/pause!)
                   (m/source! nil)))))

(defn init! []
  (if (.-fayeClient js/window)
    (u/setup-faye (channel) message-handler)
    (swap! page-state assoc :nopush true))
  (mount-root))

(talk/init-audio! (:talk @state))

(js/setTimeout #(spork/setup-analyser-for-media-element "audio") 500)

(js/setInterval #(swap! page-state assoc :now (js/Date.)) 1000)



;; RESPONSIVE SHENANIGANS

(defn image-class [width]
  (condp < width
    900 "small"
    "big")) ; else

(defn set-size []
  (let [width (.-outerWidth js/window)
        r-class (responsive-class width)
        i-class (image-class width)]
    ;;(.log js/console width r-class i-class)
    (swap! page-state assoc
           :width width
           :responsive-class r-class
           :image-class i-class)))

(.addEventListener js/window "resize" set-size)

(set-size)
