(ns vrng.talk
  (:require
   [vrng.util :as u :refer [t state]]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   goog.string.format
   [clojure.string :as str]))


(defonce page-state (atom {}))



(defn starts-at []
  (:starts_at (:talk @state)))

;; -------------------------
;; Utils

(defn time-to-start []
  (- (u/millis (starts-at)) (* 1000 (:now @state))))

;; ---------------
;; todo: change this to "state message??"
;; so that it can display the countdown and then the state (live, processing, etc)?
(defn format-countdown [millis]
  "Returns a textual respresentation of the countdown."
  (let [[days hours minutes seconds] (u/millis-to-dhms millis)]
    (cond
      (< millis 0) (t "any_time_now")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format "%02dh %02dm %02ds" hours minutes seconds))))

;; -------------------------
;; Helpers

(defn channel []
  (:channel (:talk @state)))

(defn started-at []
  (:started_at (:talk @state)))

(defn now []
  (:now @state))

(defn stream-url []
  (:stream_url (:venue (:talk @state))))

(defn title []
  (:title (:talk @state)))

(defn talk-state []
  (:state (:talk @state)))

(defn talk-speakers []
  (:speakers (:talk @state)))

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

(defn user-image-url []
  (:image_url (:user (:venue (:talk @state)))))

(defn image-url []
  (:image_url (:talk @state)))

(defn messages []
  (:messages (:talk @state)))

(defn pin-id []
  (:pin-id (:talk @state)))

(defn talk-state-label []
  (cond
    (= (talk-state) "prelive") (format-countdown (time-to-start))
    :else (t (str "state." (talk-state)))))


;; -------------------------
;; Actions

;;(defn add-message-action []
;;  )

;; -------------------------
;; Components

(defn countdown-comp []
  [:p.label.state-msg (format-countdown (time-to-start))])

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


(defn title-block-comp []
  [:div.row.collapse.talk-title
   [:div
    [:p.label.state-msg {:class (talk-state)} (talk-state-label)]]
   [:h1 (title)]])

(defn talk-info-comp []
  [:div {:class "row collapse"}
   [:div {:class "medium-7 columns"}
    [:p {:class "lead teaser"} (teaser)]
    (if-not (str/blank? (talk-speakers))
      [:p {:class "speakers"} "Speakers: "
       [:span (talk-speakers)]])]
   [:div {:class "medium-5 columns"}
    [:div {:class "media-object float-right"}
     [:div {:class "media-object-section pub-meta text-right middle"}
      [:p {:class "meta-publisher"}
       [:a {:href (user-url)} (user-name)]]
      [:p {:class "meta-series"} "From the Series: "
       [:a {:href (series-url)} (series-title)]]
      [:p {:class "meta-info"}
       [:span "7 months"]
       (if-not (= (talk-state) "prelive") [:span " • " (play-count) " Plays"])]]
     [:div {:class "media-object-section"}
      [:div {:class "img-circle"}
       [:a {:href (user-url)}
        [:img.avatar-image {:alt "" :height "60",
                            :src (user-image-url) :width "60"}]]]]]]])

(defn player-media-comp []
  [:div {:id "player", :style { :width "0px" :height "0px" }}
   [:img {:id "jp_poster_0", :style { :width "0px" :height "0px" :display "none" }}]
   [:audio {:id "jp_audio_0", :preload "none"}]])

(defn player-controls-comp []
  [:div {:class "player-container"}
   [:div {:class "row collapse", :id "talk-playbar"}
    [:button {:class "button button-playbar button-play-pause state-play"}
     [:span {:class "jp-play"}
      [:svg
       [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-play"}]]]
     [:span {:class "jp-pause icon-uniE6B8 hide", :style { :display "none"}}]]
    [:div {:class "jp-volume-bar", :id "meter"}
     [:div {:class "jp-volume-bar-value", :id "indicator", :style { :height "80%"}}]]
    [:span {:class "timecode jp-current-time"} "00:00"]
    [:div {:class "timeline jp-seek-bar", :style {:width  "0%" }}
     [:div {:class "track-playing jp-play-bar", :style { :width "0%"}}]]
    [:span {:class "timecode right jp-duration"} "00:00"]
    [:button {:class "button button-playbar button-volume right hide-for-small-only"}
     [:span {:class "icon-uniE6BE"}]
     [:span {:class "icon-uniE6C1 hide"}]]
    [:div {:class "playbar-divider"}]
    [:button {:data-selector "tooltip-imm27bsv0", :title "", :data-yeti-box "tooltip-imm27bsv0", :data-resize "tooltip-imm27bsv0", :data-options "disable_for_touch:true", :id "view-slides2", :class "has-tip tip-top tip-center button button-playbar button-volume right hide-for-small-only", :data-tooltip "nz95zk-tooltip", :aria-describedby "tooltip-imm27bsv0", :aria-haspopup "true", :data-toggle "tooltip-imm27bsv0"} ]]])


(defn talk-image-comp []
  [:div {:class "row collapse"}
   [:div {:class "talk-picture"}
    [:img {:class "image" :src (image-url) :alt "" }]
    [:button {:class "button button-playbar button-volume right show-for-small-only", :id "view-slides", :title "View Slides"}
     [:svg
      [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-slides"}]]]]])

(defn open-modal-action [action-name]
  #(swap! page-state assoc action-name true))

(defn close-modal-action [action-name]
  #(swap! page-state assoc action-name false))

(defn action-button-comp [action-name title classes]
  [:li { :class classes }; --- pin
   [:a {:class "button small" :aria-haspopup "true", :tabindex "0"
        :on-click (open-modal-action action-name)}
    [:svg
     [:use {:xmlns:xlink "http://www.w3.org/1999/xlink",
            :xlink:href (str "#icon-" action-name)}]]
    [:span {:class "action-name"} title]]])

(defn talk-actions-comp []
  [:div {:class "float-right medium-4 large-3 columns", :id "talk-actions"}
   [:ul {:class "button-group float-right"}
    [action-button-comp :pin "Pin" ""]
    [action-button-comp :share "Share" ""]
    [:li ; --- comments
     [:a {:class "button small", :href "#comment-container"}
      [:svg
       [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-chat"}]]
      [:span {:class "comment-count show-for-small-only"} "3"]
      [:span {:class "action-name"} "Comments"]]]
    [action-button-comp :embed "Embed" "hide-for-small-only"]
    [action-button-comp :podcast "Podcast" "hide-for-small-only"]]])

(defn talk-description-comp []
  [:div {:class "left medium-8 large-9 columns", :id "talk-description"}
   [:p (description)]])

(defn comment-comp [comment]
  [:div {:class "row collapse comment-block"}
   [:div {:class "comment-meta small-3 columns"}
    [:p
     [:img {:class "comment-avatar", :src "/images/dude.png", :alt "Dude"}]]
    [:p {:class "post-author"} "The Dude"]
    [:p {:class "post-time"} "2 min ago"]]
   [:div {:class "comment-content small-8 small-offset-1 medium-9 medium-offset-0 columns"}
    [:p {:class "meta-info"} "Look, let me explain something. I&#39;m not Mr. Lebowski;  you&#39;re Mr. Lebowski.  I&#39;m the Dude.  So that&#39;s  what  you  call me.  That, or Duder. His Dudeness.Or El Duderino, if, you know, you &#39;re not into the whole brevity thing--"]]]
  )

(defn comments-comp []
  [:div.clearfix {:id "comment-container"}
   [:div {:class "comment small-12 columns float-center"}
    [:h3
     [:svg
      [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-chat"}]]]
    [:div {:class "panel"}
     [:p {:contenteditable "true"} "Share your thoughts here."]]
    [:button {:class "button float-right small secondary btn-hover-blue"} "Post"]
    [:button {:class "button float-right cancel small hollow btn-hover-red btn-gray"} "Cancel"]]
   [:div {:class "small-12 columns previous-comments"}
    [comment-comp {}]
    [comment-comp {}]]])

(defn modal-comp [action-name title content-comp]
  [:div
   [:div {:id "share-modal" :role "dialog"}
    [:div {:class "row collapse"}
     [:h2 {:id "modalTitle"} title]]
    [content-comp]
    [:button {:aria-label "Close modal", :class "close-button", :type "button"  :on-click (close-modal-action action-name) }
     [:span {:aria-hidden "true"} "×"]]]])

(defn modal-embed-comp []
  [:div
   [:p {:class "lead"} "Copy and paste the following code into your web site:"]
   [:textarea {:rows "3"} "&lt;iframe width=&quot;445&quot; height=&quot;140&quot; src=&quot;http://localhost:3000/embed/talks/games-net-presents-howard-phillips&quot; frameborder=&quot;0&quot; scrolling=&quot;no&quot; allowfullscreen&gt;&lt;/iframe&gt;"]
   [:button {:aria-label "Close modal", :class "close-button", :data-close "", :type "button"}
    [:span {:aria-hidden "true"} "×"]]])

(defn modal-pin-comp []
  [:div
   [:button {:class "button small"} "Sign In"]
   [:button {:aria-label "Close modal", :class "close-button", :data-close "", :type "button"}
    [:span {:aria-hidden "true"} "×"]]])

(defn modal-podcast-comp []
  [:div
   [:p {:class "lead"}
    [:button {:class "button hollow btn-hover-yellow"}
     [:span {:class "translation_missing", :title "translation missing: en.talks.show.launch"} "Launch"]]]
   [:button {:aria-label "Close modal", :class "close-button", :data-close "", :type "button"}
    [:span {:aria-hidden "true"} "×"]]])

(defn modal-share-comp []
  [:div
   [:div {:class "small-6 columns"}
    [:ul {:class "menu vertical"}
     [:li
      [:a {:class "button small btn-hover-yellow"}
       [:svg
        [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-facebook"}]]
       [:span {:class "translation_missing", :title "translation missing: en.talks.show.facebook"} "Facebook"]]]
     [:li
      [:a {:class "button small btn-hover-yellow"}
       [:svg
        [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-twitter"}]]
       [:span {:class "translation_missing", :title "translation missing: en.talks.show.twitter"} "Twitter"]]]
     [:li
      [:a {:class "button small btn-hover-yellow"}
       [:svg
        [:use {:xmlns:xlink "http://www.w3.org/1999/xlink", :xlink:href "#icon-email"}]]
       [:span {:class "translation_missing", :title "translation missing: en.talks.show.mail"} "Mail"]]]]]
   [:div {:class "small-6 columns"}
    [:img {:class "flyer", :src "/system/flyer/3378.png", :alt "3378"}]]])


(defn modals-comp []
  [:div
   (if (true? (:pin @page-state))
     [modal-comp :pin "Pin this Talk" modal-pin-comp])
   (if (true? (:share @page-state))
     [modal-comp :share "Share this Talk" modal-share-comp])
   (if (true? (:embed @page-state))
     [modal-comp :embed "Embed this Talk" modal-embed-comp])
   (if (true? (:podcast @page-state))
     [modal-comp :podcast "Podcast this Talk" modal-podcast-comp])])

(defn root-comp []
  ;;[debug-comp])
  [:div.left-side.medium-9.columns
   [:div.top-container
    [title-block-comp]
    [talk-info-comp]
    [player-media-comp]
    [player-controls-comp]
    [talk-image-comp]
    [:div.row.collapse
     [talk-actions-comp]
     [talk-description-comp]]]
   [:div.bottom-container.row.collapse.clearfix
    [comments-comp]]
   [modals-comp]])


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
  ;;(reagent/render [countdown-comp] (.getElementById js/document "mount-countdown"))
  ;;(reagent/render [audio-comp] (.getElementById js/document "mount-audio"))
  )

(defn init! []
  (u/start-timer state)
  (u/setup-faye (channel) message-handler)
  ;;(js/setTimeout #(start-stream) 1000) ;; move start-stream to message-handler
  (mount-root))
