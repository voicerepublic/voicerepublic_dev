(ns vrng.embeds.core
  (:require
   [vrng.helpers :as helpers :refer [icon]]
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

(defn talk [] (:talk @state))

(defn relative-time []
  (u/from-now (u/to-millis (:starts_at (talk)))))

;; TODO make human readable
(defn humanreadable-plays []
  (:play_count (talk)))

(defn play-action [event]
  (u/log event)
  (.stopPropagation event)
  (u/track-event (str "player pause talk:" (:id (talk))))
  (m/play!))

(defn pause-action [event]
  (u/log event)
  (.stopPropagation event)
  (u/track-event (str "player pause talk:" (:id (talk))))
  (m/pause!))


(defn root-comp []
  [:div.embed-player.clearfix.large
   [:div.image-box [:img {:src (:thumb_url (talk))}]]
   [:div.content-box
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
    [:div.player-box
     [:div#jp_jplayer_0.vr-player.jp-jplayer
      {:style { :width "0px" :height "0px" }
       :data-selector "#jc-3728"
       :data-ogg "/vrmedia/3728.ogg"
       :data-mp3 "/vrmedia/3728.mp3"
       :data-m4a "/vrmedia/3728.m4a"}
      [:img#jp_poster_0
       {:style {:width "0px" :height "0px" :display "none"}}]]
     [:div#jc-3728.jp-audio
      [:div.jp-gui.jp-interface
       [:div.jp-controls
        [:a.jp-pause {:style {:display "none"}} [icon "pause"]]
        [:a.jp-play {:on-click play-action} [icon "play"]]]
       [:div.jp-spacer]
       [:div.jp-volume-bar
        [:div.jp-volume-bar-value {:style {:height "81%"}}]
        [:div.jp-volume-bar-value-dancing]]
       [:div.embed-msg.hide
        [:a.msg-text
         {:href (:url (talk)) :title "cancel" :target "_blank"}]
        [:p
         [:span.translation_missing
          {:title
           "translation missing: en.shared.velvet_player.please_login"}
          "Please Login"]]
        [:a.action-btn.close-msg
         {:title "Cancel"}
         "\n                      ×\n                    "]
        [:div.jp-spacer]]
       [:div.teaser-msg.hide
        [:a.teaser-link
         {:href "http://voicerepublic.com" :target "_blank"}]
        [:p
         [:span "Nice Stuff On Vr"]]]
       [:div.jp-progress
        [:div.jp-seek-bar
         {:style {:width "0%"}}
         [:div.jp-play-bar {:style {:width "0%"}}]]
        [:div.loading-indicator.hide
         [:p
          [:span.translation_missing "Loading"]]]
        [:div.jp-time-holder
         [:span.jp-current-time "00:00"]
         [:span.time-divider "/"]
         [:span.jp-duration "00:00"]]]
       [:div.jp-spacer]
       [:div.action-panel
        [:a.action-btn.slides-btn
         {:href (:url (talk)) :title "View Slides" :target "blank"}
         [icon "slides"]]
        [:div.jp-spacer]]
       [:div.action-panel
        [:a.action-btn.chat-btn
         {:href (:url (talk)) :title "Comment" :target "blank"}
         [icon "chat"]]
        [:div.jp-spacer]
        [:div.pinboard
         {:data-pin "3728"}
         [:a.button.pin-btn
          {:href "#" :title "Pin" :data-msg "pinned"}
          [icon "pin"]
          [:span.pin-msg "Pin"]]
         [:a.button.unpin-btn
          {:href "#"
           :style {:display "none"}
           :title "Un-Pin"
           :data-msg "unpinned"}
          [icon "pin"]
          [:span.pin-msg "Un-Pin"]]]
        [:div.jp-spacer]
        [:a.action-btn.action-share
         {:title "Share"}
         [icon "share"]]]
       [:div.share-panel.hide
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
        [:a.action-btn.close-share
         {:title "Cancel"}
         "\n                      ×\n                    "]
        [:div.jp-spacer]]]
      [:div.jp-no-solution
       {:style {:display "none"}}
       [:span
        [:span.translation_missing
         {:title
          "translation missing: en.shared.velvet_player.update_required"}
         "Update Required"]]
       [:span.translation_missing
        {:title
         "translation missing: en.shared.velvet_player.update_message"}
        "Update Message"]
       [:a
        {:target "_blank"
         :href "http://get.adobe.com/flashplayer/"}
        "\n                    Flash plugin\n                  "]
       ".\n                "]]]]])

(defn mount-root []
  (reagent/render [root-comp] (.getElementById js/document "embedded-player")))

(defn init! []
  (mount-root))

(talk/init-audio! (:talk @state))
