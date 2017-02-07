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

(defonce page-state (atom {:pin-id (.-pinId js/window)
                           :podcast-url (.-podcastUrl js/window)
                           :itunes-url (.-itunesUrl js/window)}))

(defonce current-user
  (atom (js->clj (.-currentUser js/window) :keywordize-keys true)))


;;;; -------------------------
;;;; COMPONENTS
;;


;;;; -------------------------
;;;; HELPERS
;;

(defn talk [] (:talk @state))
(defn slides-url [] (:slides_url (talk)))


(defn relative-time []
  (u/from-now (u/to-millis (:starts_at (talk)))))

;; TODO make human readable
(defn humanreadable-plays []
  (:play_count (talk)))


;; ACTIONS

(defn pin-action []
  (track-event "talk pin-this-talk")
  (POST (str "/talks/" (:id (talk)) "/reminders")
        {:handler #(swap! page-state assoc :pin-id (get % "id"))}))

(defn unpin-action []
  (track-event "talk unpin-this-talk")
  (DELETE (str "/reminders/" (:pin-id @page-state))
          {:handler #(swap! page-state assoc :pin-id nil)}))

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

(defn open-modal-action [action-name]
 (fn []
   (prn "modal open " (name action-name))
   ;(swap! page-state assoc action-name true)
   ))

(defn close-modal-action [action-name]
 (fn []
   (track-event (str "modal close " (name action-name)))
   (swap! page-state assoc action-name false)
   ;)
   ))

(defn play-pause-button []
  [:div.jp-controls
   (if (:paused @m/state)
     [:a.jp-play {:on-click play-action} [icon "play"]]
     [:a.jp-pause {:on-click pause-action} [icon "pause"]])])

(defn root-comp []
  [:div.embed-player.clearfix.large

   ;;image
   [:div.image-box [:img {:src (:thumb_url (talk))}]]

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

     ;;player audio
     [:div#jp_jplayer_0.vr-player.jp-jplayer
      {:style { :width "0px" :height "0px" }
       :data-selector "#jc-3728"
       :data-ogg "/vrmedia/3728.ogg"
       :data-mp3 "/vrmedia/3728.mp3"
       :data-m4a "/vrmedia/3728.m4a"}
      [:img#jp_poster_0
       {:style {:width "0px" :height "0px" :display "none"}}]]

     ;;main UI
     [:div#jc-3728.jp-audio

      ;;player controls
      [:div.jp-gui.jp-interface

       [play-pause-button]

       [:div.jp-spacer]

       ;;volume
       [:div.jp-volume-bar
        [:div.jp-volume-bar-value {:style {:height "81%"}}]
        [:div.jp-volume-bar-value-dancing]]

       ;;embed msg
       [:div.embed-msg
        [:a.msg-text
         {:href (:url (talk)) :title "cancel" :target "_blank"}]
        [:p
         [:span
          "Please Login"]]
        [:a.action-btn.close-msg
         {:title "Cancel"} "×"]
        [:div.jp-spacer]]

       ;;teaser
       [:div.teaser-msg.hide
        [:a.teaser-link
         {:href "http://voicerepublic.com" :target "_blank"}]
        [:p
         [:span "Nice Stuff On Vr"]]]

       ;;progress/seek
       [:div.jp-progress
        [:div.jp-seek-bar
         {:style {:width "0%"}}
         [:div.jp-play-bar {:style {:width "0%"}}]]
        [:div.loading-indicator.hide
         [:p
          [:span "Loading"]]]
        [:div.jp-time-holder
         [:span.jp-current-time "00:00"]
         [:span.time-divider "/"]
         [:span.jp-duration "00:00"]]]

       [:div.jp-spacer]

       ;;actions
       [:div.action-panel


        ;;SLIDES
        (if (slides-url)
          [:a.action-btn.slides-btn
           {:href (:url (talk)) :title "View Slides" :target "blank"}
           [icon "slides"]])

        [:div.jp-spacer]

        ;;CHAT
        [:a.action-btn.chat-btn
         {:href (:url (talk)) :title "Comment" :target "blank"}
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
            {:on-click (open-modal-action :signin)} [icon-comp "pin-outline"]])]
        ; {:data-pin "3728"}
        ; [:a.button.pin-btn
        ;  {:href "#" :title "Pin" :data-msg "pinned"}
        ;  [icon "pin"]
        ;  [:span.pin-msg "Pin"]]
        ; [:a.button.unpin-btn
        ;  {:href "#"
        ;   :style {:display "none"}
        ;   :title "Un-Pin"
        ;   :data-msg "unpinned"}
        ;  [icon "pin"]
        ;  [:span.pin-msg "Un-Pin"]]

        [:div.jp-spacer]

        ;;SHARE
        [:a.action-btn.action-share
         {:title "Share"
          :on-click (open-modal-action :share)
          }
         [icon "share"]]]

       ;;SHARE MODAL
       ;; TODO: make this show/hide on click of action-share
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
         {:title "Cancel"} "×"]
        [:div.jp-spacer]]]]]]])

(defn mount-root []
  (reagent/render [root-comp] (.getElementById js/document "embedded-player"))
  (reagent/render [m/debug-audio-comp] (.getElementById js/document "debug")))

(defn init! []
  (mount-root))

(talk/init-audio! (:talk @state))


;;;; -------------------------
;;;; HELPERS
;;
;;(defn now [] (:now @state))
;;(defn talk [] (:talk @state))
;;(defn starts-at [] (:starts_at (talk)))
;;(defn started-at [] (:started_at (talk)))
;;(defn time-to-start [] (- (u/to-millis (starts-at)) (* 1000 (now))))
;;(defn time-since-start [] (- (* 1000 (now)) (u/to-millis (started-at))))
;;(defn channel [] (:channel (talk)))
;;(defn stream-url [] (:stream_url (:venue (talk))))
;;(defn title [] (:title (talk)))
;;(defn media-links [] (:media_links (talk)))
;;(defn talk-state [] (:state (talk)))
;;(defn create-comment-url [] (:create_message_url (talk)))
;;(defn talk-speakers [] (:speakers (talk)))
;;(defn teaser [] (:teaser (talk)))
;;(defn description [] (:description (talk)))
;;(defn play-count [] (:play_count (talk)))
;;(defn series-title [] (:title (:series (talk))))
;;(defn series-url [] (:url (:series (talk))))
;;(defn user-name [] (:name (:user (:venue (talk)))))
;;(defn user-url [] (:url (:user (:venue (talk)))))
;;(defn user-image-url [] (:image_url (:user (:venue (talk)))))
;;(defn user-image-alt [] (:image_alt (:user (:venue (talk)))))
;;(defn image-url [] (:image_url (talk)))
;;(defn image-alt [] (:image_alt (talk)))
;;(defn comments [] (sort-by :created_at > (:messages (talk))))
;;(defn flyer-path [] (:flyer_path (talk)))
;;(defn scheduled-duration [] (* 60 (:duration (talk)))) ; in seconds
;;(defn slides-url [] (:slides_url (talk)))
;;
;;(defn format-countdown [millis]
;;  "Returns a textual respresentation of the countdown."
;;  (let [[days hours minutes seconds] (u/to-dhms millis)]
;;    (cond
;;      (< millis 0) (t "any_time_now")
;;      ;; TODO maybe use moment.js' relative time here
;;      (> hours 48) (str (t "in") " " days " " (t "days"))
;;      :else (goog.string.format "in %02dh %02dm %02ds" hours minutes seconds))))
;;
;;(defn talk-state-label []
;;  (cond
;;    (= (talk-state) "prelive") (str "Starting " (format-countdown (time-to-start)))
;;    :else (t (str "state." (talk-state)))))
;;
;;(defn embed-code []
;;  (goog.string.format
;;   (str "<iframe width='445' height='140' src='%s'"
;;        " frameborder='0' scrolling='no'"
;;        " allowfullscreen></iframe>")
;;   (:embed_url (talk))))
;;
;;(defn blog-url [page]
;;  (let [language "en"] ;; for now
;;    (str "http://blog.voicerepublic.com/"
;;         page "?lang=" language)))
;;
;;;; -------------------------
;;;; DOM HELPERS
;;;; TODO move to util
;;
;;
;;;; -------------------------
;;;; CSRF TOKEN
;;;; TODO move to util and use on venues
;;
;;(defn csrf-token []
;;  (u/content-by-name "csrf-token"))
;;
;;(def csrf-interceptor
;;  (to-interceptor
;;   {:name "CSRF Interceptor"
;;    :request #(assoc-in % [:headers "X-CSRF-Token"] (csrf-token))}))
;;
;;(swap! default-interceptors (partial cons csrf-interceptor))
;;
;;;; -------------------------
;;;; ACTIONS
;;
;;(defn post-comment-action []
;;  (track-event "comment post")
;;  (let [url (create-comment-url)
;;        content (u/value-by-name "content")]
;;    (POST url {:format :json
;;               :params {:message {:content content}}})
;;    (u/set-value-by-name "content" "")))
;;
;;(defn cancel-comment-action []
;;  (track-event "comment cancel")
;;  (u/set-value-by-name "content" ""))
;;
;;(defn pin-action []
;;  (track-event "talk pin-this-talk")
;;  (POST (str "/talks/" (:id (talk)) "/reminders")
;;        {:handler #(swap! page-state assoc :pin-id (get % "id"))}))
;;
;;(defn unpin-action []
;;  (track-event "talk unpin-this-talk")
;;  (DELETE (str "/reminders/" (:pin-id @page-state))
;;          {:handler #(swap! page-state assoc :pin-id nil)}))
;;
;;(defn social-url [target]
;;  (let [url (u/url-encode (.-location js/window))]
;;    (case target
;;      :facebook
;;      (str "https://www.facebook.com/sharer/sharer.php?u=" url)
;;
;;      :twitter
;;      (str "https://twitter.com/intent/tweet?source=webclient&text=" url)
;;
;;      :email
;;      (str "mailto:your@friend.com?subject="
;;           (u/url-encode (t "email.subject")) "&body="
;;           (u/url-encode (t "email.body")) url
;;           (u/url-encode (t "email.closing"))
;;           (u/url-encode (:name @current-user))))))
;;
;;(defn share-action [target]
;;  ;; this already track on ga
;;  (track-event (str "share " target " talk:" (:id (talk))))
;;  ;; so the whole post can be removed
;;  ;; see https://www.pivotaltracker.com/story/show/129054603
;;  (let [url (social-url target)]
;;    (POST "/xhr/social_shares"
;;          {:format :json
;;           :params {:social_share {:shareable_id (:id (talk))
;;                                   :shareable_type "talk"
;;                                   :social_network target}}
;;           ;;:handler #(.. js/window (open url "_blank") focus)
;;           })))
;;
;;(defn open-modal-action [action-name]
;;  (fn []
;;    (track-event (str "modal open " (name action-name)))
;;    (swap! page-state assoc action-name true)))
;;
;;(defn close-modal-action [action-name]
;;  (fn []
;;    (track-event (str "modal close " (name action-name)))
;;    (swap! page-state assoc action-name false)))
;;
;;
;;;; --- audio actions
;;
;;(defn mobile-play-action [event]
;;  (.stopPropagation event)
;;  (u/track-event (str "player mobile-play talk:" (:id (talk))))
;;  (m/play!))
;;
;;(defn play-action [event]
;;  (.stopPropagation event)
;;  (u/track-event (str "player play talk:" (:id (talk))))
;;  (m/play!))
;;
;;(defn pause-action [event]
;;  (.stopPropagation event)
;;  (u/track-event (str "player pause talk:" (:id (talk))))
;;  (m/pause!))
;;
;;(defn adjust-volume-action [event]
;;  (.stopPropagation event)
;;  (u/track-event (str "player volume talk:" (:id (talk))))
;;  (let [meter (.-currentTarget event)
;;        top (.-top (.getBoundingClientRect meter))
;;        bottom (.-bottom (.getBoundingClientRect meter))
;;        current (.-clientY event)
;;        volume (/ (- bottom current) (- bottom top))]
;;    (m/volume! volume)))
;;
;;(defn seek-action [event]
;;  (.stopPropagation event)
;;  (if (= (talk-state) "archived")
;;    (let [timeline (.-currentTarget event)
;;          left (.-left (.getBoundingClientRect timeline))
;;          right (.-right (.getBoundingClientRect timeline))
;;          current (.-clientX event)
;;          requested (/ (- left current) (- left right)) ; 0..1
;;          time (* (m/duration) requested)] ; in seconds
;;      (u/track-event (str "player seek talk:" (:id (talk))))
;;      (m/seek! time))))
;;
;;;; -------------------------
;;;; COMPONENTS
;;
;;(defn icon-comp [icon]
;;  [:svg {:dangerouslySetInnerHTML
;;         {:__html (str "<use xlink:href='#icon-" icon "' />")}}])
;;
;;(defn countdown-comp []
;;  [:span.label.state-msg (format-countdown (time-to-start))])
;;(defn edit-link-comp []
;;  [:li [:a.button.hollow.muted.tiny.btn-hover-light-blue
;;        {:href (:edit_url (talk))}
;;        [icon-comp "pencil"]
;;        "Edit" [:span.hide-for-small-only " This Talk"]]])
;;
;;(defn venue-link-comp []
;;  [:li [:a.button.hollow.tiny.btn-yellow.btn-hover-yellow
;;        {:href (:url (:venue (talk)))}
;;        [icon-comp "victrola"]
;;        "Stream" [:span.hide-for-small-only " Now"]]])
;;
;;(defn title-block-comp []
;;  [:div.row.collapse.talk-title
;;   [:div
;;    (if-not (= (talk-state) "archived")
;;      [:p.state-container.clearfix.text-center.medium-text-left {:class (talk-state)}
;;       [:span.state-msg.label (talk-state-label)]
;;       (if (:nopush @page-state) [:span#nopush {:title "you're not receiving push notifications"}[icon-comp "cactus"]])])
;;    [:h1.text-center.medium-text-left
;;     (title)]]])
;;
;;(defn publisher-only-comp []
;;  [:div#publisher-options
;;   [:div.menu-centered [:ul.menu [edit-link-comp]
;;                        (if (or (= (talk-state) "prelive")
;;                                (= (talk-state) "live"))
;;                          [venue-link-comp])]]])
;;
;;(defn toggle-slides-action []
;;  (swap! slides assoc :show (not (:show @slides))))
;;
;;(defn slides-button-comp []
;;  [:button.button.button-playbar.slides-button.hide-for-small-only
;;   {:on-click toggle-slides-action} [icon-comp "slides"]])
;;
;;(defn talk-info-comp []
;;  [:div {:class "row collapse"}
;;   [:div {:class "medium-7 columns"}
;;    [:p.teaser.lead.text-center.medium-text-left (teaser)
;;     (if-not (str/blank? (talk-speakers))
;;       [:p.speakers.text-center.medium-text-left " Speakers: "
;;        [:span.names (talk-speakers)]])]]
;;   [:div#talk-meta.medium-4.medium-offset-1.columns
;;    [:div {:class "media-object stack-for-small"}
;;     [:div {:class "media-object-section text-center"}
;;      [:div {:class "img-circle"}
;;       [:a {:href (user-url)}
;;        [:img.avatar-image {:alt (user-name) :height "60",
;;                            :src (user-image-url) :width "60"}]]]]
;;     [:div {:class "media-object-section pub-meta text-center medium-text-left middle"}
;;      [:p {:class "meta-publisher"}
;;       [:a {:href (user-url)} (user-name)]]
;;      [:p {:class "meta-series"} "From the Series: "
;;       [:a {:href (series-url)} (series-title)]]
;;      [:p {:class "meta-info"}
;;       [:span (u/from-now (u/to-millis (starts-at)))]
;;       (if (= (talk-state) "archived") [:span " • " (play-count) " Plays"])]]
;;     ]]])
;;
;;(defn player-controls-comp []
;;    [:div.player-container {:class (talk-state)}
;;     [:div#talk-playbar.row.collapse
;;
;;      (if (m/paused?)
;;        [:button.button.button-playbar.button-play-pause.state-play
;;         {:on-click play-action} [icon-comp "play"]]
;;        [:button.button.button-playbar.button-play-pause.state-play
;;         {:on-click pause-action} [icon-comp "pause"]])
;;      [:div#meter.jp-volume-bar {:on-click adjust-volume-action}
;;       [:div#indicator.jp-volume-bar-value
;;        {:style {:height (m/volume-percentage)}}]]
;;      [:span.timecode.jp-current-time (u/format-m-s (m/current-runtime))]
;;      [:div.timeline.jp-seek-bar {:on-click seek-action :style {:width "0%"}}
;;       [:div.track-buffered.jp-play-bar {:style {:width "0%"}}]
;;       [:div.track-playing.jp-play-bar
;;        {:style {:width (str (m/progress-percentage) "%")}}]]
;;      [:span.timecode.right.jp-duration (u/format-m-s (m/duration))]
;;
; (if js/signedIn
;   (if (:pin-id @page-state)
;     [:button.button.button-playbar.button-unpin
;      {:on-click unpin-action} [icon-comp "pin"]]
;     [:button.button.button-playbar.button-pin
;      {:on-click pin-action} [icon-comp "pin-outline"]])
;   [:button.button.button-playbar.button-pin
;    {:on-click (open-modal-action :signin)} [icon-comp "pin-outline"]])
; (if (slides-url) [slides-button-comp])
;;
;;      ]])
;;
;;(defn talk-image-comp []
;;  [:div {:class "row collapse"}
;;   [:div {:class "talk-picture"}
;;    [:img {:class "image" :src (image-url) :alt "" }]]])
;;
;;(defn action-button-comp [action-name title classes]
;;  [:li { :class classes }
;;   [:a {:class "button small" :aria-haspopup "true", :tab-index "0"
;;        :on-click (open-modal-action action-name)}
;;    [icon-comp (name action-name)]
;;    [:span {:class "action-name"} title]]])
;;
;;(defn talk-actions-comp []
;;  [:div {:class "float-right medium-4 large-3 columns", :id "talk-actions"}
;;   [:ul {:class "menu float-right expanded medium-vertical"}
;;    ;; remove from action panel for now, since it's in the play bar
;;    ;;[action-button-comp :slides "slides" "hide-for-medium"]
;;    (if (slides-url)
;;      [:li.hide-for-medium
;;     [:a {:class "button small" :on-click toggle-slides-action}
;;      [icon-comp "slides"] [:span.action-name.hide-for-small-only" Slides"] ]])
;;
;;    [action-button-comp :share "Share" ""]
;;    [:li ; --- comments
;;     [:a {:class "button small", :href "#comment-container"}
;;      [icon-comp "chat"]
;;      [:span {:class "comment-count show-for-small-only"} (count (comments))]
;;      [:span {:class "action-name"} "Comments"]]]
;;    [action-button-comp :embed "Embed" "hide-for-small-only"]
;;    [action-button-comp :podcast "Podcast"]]])
;;
;;(defn talk-description-comp []
;;  [:div.left.medium-8.large-9.columns {:id "talk-description"}
;;   [:p {:dangerouslySetInnerHTML {:__html (description)}}]])
;;
;;(defn comment-comp [comment]
;;  ^{:key (:id comment)}
;;  [:div {:class "row collapse comment-block"}
;;   [:div {:class "comment-meta small-3 columns"}
;;    [:p
;;     [:img.comment-avatar {:src (:user_image_url comment)
;;                           :alt (:user_image_alt comment)}]]
;;    [:p {:class "post-author"} (:user_name comment)]
;;    [:p {:class "post-time" :title (:created_at comment)}
;;     (u/from-now (u/to-millis (:created_at comment)))]]
;;   [:div.comment-content.small-8.small-offset-1.medium-9.medium-offset-0.columns
;;    [:p {:class "meta-info"} (:content comment)]]])
;;
;;(defn comments-login-comp []
;;  [:div.clearfix
;;   [:p "Please "
;;    [:a {:href js/signInPath} "sign in"]
;;    " to make a comment."]])
;;
;;(defn comments-form-comp []
;;  [:div
;;   [:textarea.panel {:name "content"
;;                     :placeholder "Share your thoughts here."}]
;;   [:button {:class "button float-right small secondary btn-hover-blue" :on-click post-comment-action } "Post"]
;;   [:button {:class "button float-right cancel small hollow btn-hover-red btn-gray" :on-click cancel-comment-action } "Cancel"]]
;;  )
;;
;;(defn comments-comp []
;;  [:div.clearfix {:id "comment-container"}
;;   [:div {:class "comment small-12 columns float-center"}
;;    [:h3 [icon-comp "chat"] " " "Comments"]
;;    (if js/signedIn [comments-form-comp] [comments-login-comp])]
;;   [:div {:class "small-12 columns previous-comments"}
;;    (doall (map comment-comp (comments)))]])
;;
;;(defn modal-comp [action-name title content-comp]
;;  [:div.instruction-container
;;   [:div.modal-background {:on-click (close-modal-action action-name)}]
;;   [:div#talk-modal {:role "dialog"}
;;    [:div.row.no-pad
;;     [:h2 {:id "modalTitle"} title]]
;;    [content-comp]
;;    [:button.close-button {:aria-label "Close modal" :type "button"  :on-click (close-modal-action action-name) }
;;     [:span {:aria-hidden "true"} "×"]]]])
;;
;;(defn modal-embed-comp []
;;  [:div
;;   [:p {:class "lead"} (t "embed_instructions")]
;;   [:textarea {:rows "3"} (embed-code)]
;;   [:p [:a {:href (blog-url "support/embed-talks") :target "_blank"}
;;        "Need help?"]]])
;;
;;(defn modal-pin-comp []
;;  [:div
;;   (if js/signedIn
;;     (if (:pin-id @page-state)
;;       [:button {:class "button small" :on-click unpin-action} "Unpin"]
;;       [:button {:class "button small" :on-click pin-action} "Pin"])
;;     [:button {:class "button small"} "Sign In"])])
;;
;;(defn modal-podcast-comp []
;;  [:div
;;   [:p
;;     [:form [:input#podcast-link {:field :text :id :podcast-link :value (:podcast-url @page-state)}]]]
;;   [:p
;;    [:a {:class "button hollow btn-hover-yellow"
;;         :href (:itunes-url @page-state) :target "_blank"
;;         :on-click (track-event (str "podcast itunes talk:" (:id talk)))}
;;     [:span "Open in Itunes"]]
;;    [:span "  "]
;;    [:a {:class "button hollow btn-hover-yellow"
;;         :href (:podcast-url @page-state) :target "_blank"
;;         :on-click (track-event (str "podcast http talk:" (:id talk)))}
;;     [:span "Go to RSS feed"]]]])
;;
;;
;;
;;(defn modal-signin-comp []
;;  [:div
;;   [:p {:class "lead"} "Hey dude! You need to sign in to do that."]
;;   [:p
;;    [:a {:class "button hollow btn-hover-yellow"
;;         :href "/users/sign_in"}
;;     [:span "Sign In"]]
;;    [:a {:class "button hollow btn-hover-yellow"
;;         :href "/users/sign_up"}
;;     [:span "Join for Free"]]]])
;;
;;(defn modal-share-comp []
;;  [:div
;;   [:div.text-center
;;    [:img.share-flyer {:src (flyer-path)}]
;;    [:ul.menu.menu-centered.share-links
;;     [:li [:a {:href (flyer-path) :target "_blank" :download true}
;;           [icon-comp "download"]]]
;;     [:li [:a {:href (social-url :facebook) :target "_blank" :on-click #(share-action :facebook)} [icon-comp "facebook"]]]
;;     [:li [:a {:href (social-url :twitter) :target "_blank" :on-click #(share-action :twitter)} [icon-comp "twitter"]]]
;;     [:li [:a {:href (social-url :email) :on-click #(share-action :email)} [icon-comp "email"]]]
;;     ]]])
;;
;;(defn modals-comp []
;;  [:div
;;   (if (true? (:signin @page-state))
;;     [modal-comp :signin "Wait a minute..." modal-signin-comp])
;;   (if (true? (:pin @page-state))
;;     [modal-comp :pin "Pin this Talk" modal-pin-comp])
;;   (if (true? (:share @page-state))
;;     [modal-comp :share "Share this Talk" modal-share-comp])
;;   (if (true? (:embed @page-state))
;;     [modal-comp :embed "Embed this Talk" modal-embed-comp])
;;   (if (true? (:podcast @page-state))
;;     [modal-comp :podcast "Podcast this Talk's Series" modal-podcast-comp])])
;;
;;(defn debug-comp []
;;  [:table
;;   [:tr
;;    [:td "channel"]
;;    [:td (channel)]]
;;   [:tr
;;    [:td "starts-at"]
;;    [:td (starts-at)]]
;;   [:tr
;;    [:td "started-at"]
;;    [:td (started-at)]]
;;   [:tr
;;    [:td "now"]
;;    [:td (now)]]
;;   [:tr
;;    [:td "stream-url"]
;;    [:td (stream-url)]]
;;   [:tr
;;    [:td "series-title"]
;;    [:td (series-title)]]
;;   [:tr
;;    [:td "series-url"]
;;    [:td (series-url)]]
;;   [:tr
;;    [:td "user-name"]
;;    [:td (user-name)]]
;;   [:tr
;;    [:td "user-url"]
;;    [:td (user-url)]]
;;   [:tr
;;    [:td "image-url"]
;;    [:td (image-url)]]
;;   [:tr
;;    [:td "title"]
;;    [:td (title)]]
;;   [:tr
;;    [:td "comments"]
;;    [:td (str (comments))]]
;;   [:tr
;;    [:td "(m/paused?)"]
;;    [:td (str (m/paused?))]]
;;   [:tr
;;    [:td "m/progress-percentage"]
;;    [:td (m/progress-percentage)]]
;;   ])
;;
;;(defn prev-page-action
;;  "Decreases the page number if not on first page."
;;  []
;;  (let [value (max 1 (dec (:page @slides)))]
;;    (swap! slides assoc :page value)))
;;
;;(defn next-page-action
;;  "Increases the page number if not on last page."
;;  []
;;  (let [value (min (:pages @slides) (inc (:page @slides)))]
;;    (swap! slides assoc :page value)))
;;
;;(defn pdf-render-page
;;  "Renders the given page to the current canvas."
;;  [page]
;;  (let [canvas (.getElementById js/document "slides")
;;        canvas-width (.-width (.getBoundingClientRect canvas))
;;        viewport (.getViewport page 1)
;;        pdf-width (.-width viewport)
;;        pdf-height (.-height viewport)
;;        canvas-height (* canvas-width (/ pdf-height pdf-width))
;;        scale (/ canvas-width pdf-width)
;;        scaled-viewport (.getViewport page scale)
;;        context (.getContext canvas "2d")
;;        render-context #js {:canvasContext context
;;                            :viewport scaled-viewport}]
;;    (swap! slides assoc :height canvas-height)
;;    (.render page render-context)))
;;
;;(defn slides-render-current-page
;;  "Get the current page and render it to the canvas."
;;  [this]
;;  (.then (.getPage (:document @slides) (:page @slides)) pdf-render-page))
;;
;;(defn slides-pager-comp-without-callbacks []
;;  "The naked (without callbacks) pager component."
;;  [:div.pager
;;   [:button.prev {:on-click prev-page-action} [icon-comp "arrow-left"]]
;;   [:span (:page @slides)]
;;   [:span "/"]
;;   [:span (:pages @slides)]
;;   [:button.next {:on-click next-page-action} [icon-comp "arrow-right"]]])
;;
;;(def slides-pager-comp
;;  "The slides pager with associated callbacks. ComponentDidMount and
;;  ComponentDidUpdate will trigger the current page to be rendered."
;;  (with-meta slides-pager-comp-without-callbacks
;;    {:component-did-mount slides-render-current-page
;;     :component-did-update slides-render-current-page}))
;;
;;(defn pdf-progress [progress]
;;  "Takes a progress object of PDF.js and stores the current progress
;;  ratio to the atom."
;;  (let [value (/ (.-loaded progress) (.-total progress))]
;;    (swap! slides assoc :loading value)
;;    (swap! slides assoc :ready (>= value 1))))
;;
;;(defn update-pdf-details
;;  "Takes a pdf object from PDF.js and stores metadata to the atom,
;;  which will implicitly trigger rendering."
;;  [pdf]
;;  (swap! slides assoc :document pdf)
;;  (swap! slides assoc :pages (.-numPages pdf))
;;  (swap! slides assoc :page 1)) ;; this will trigger rendering
;;
;;(defn initialize-pdf
;;  "Initializes PDF.js, loading the workerSrc, loading the document and
;;  setting up a progress handler."
;;  [this]
;;  (swap! slides assoc :width (- (.-width (.getBoundingClientRect (.getElementById js/document "slides-container"))) 24))
;;  ;; TODO remove hardcoded padding with http://stackoverflow.com/questions/21354095/how-to-get-the-dimensions-of-a-dom-element-minus-border-and-padding
;;  (aset js/PDFJS "workerSrc" js/pdfWorkerSrc)
;;  (let [job (.getDocument js/PDFJS (slides-url))]
;;    (aset job "onProgress" pdf-progress)
;;    (.then job update-pdf-details)))
;;
;;(defn pdf-viewer-comp-without-callbacks []
;;  "The naked pdf viewer component."
;;  [:div#slides-container.slides {:style #js {:padding "12px"}}
;;   [:h3.clearfix [:span.float-left "Slides"][:button.float-right.close {:on-click toggle-slides-action} (goog.string/unescapeEntities "&times;")]]
;;   (if (< (:loading @slides) 1) ; - progress
;;     [:div.progress>div.meter
;;      {:style {:width (str (* 100 (:loading @slides)) "%")}}])
;;   (if (:ready @slides)
;;     [:div
;;      [:canvas#slides {:on-click next-page-action
;;                       :width (:width @slides)
;;                       :height (:height @slides)}]
;;      [slides-pager-comp]])]) ; - pager
;;
;;(def pdf-viewer-comp
;;  "The pdf viewer component. ComponentDidMount will trigger the
;;  initialization of PDF.js"
;;  (with-meta pdf-viewer-comp-without-callbacks
;;    {:component-did-mount initialize-pdf}))
;;
;;
;;(defn root-comp []
;;  (.onTalkPageReady js/window)
;;  (fn []
;;    [:div.left-side.medium-9.columns.float-left
;;     ;;[debug-comp]
;;     (if (m/gesture-required?)
;;       [:div#mobile-play-button {:on-click mobile-play-action} [icon-comp "play"]])
;;     [:div.top-container
;;      [title-block-comp]
;;      [talk-info-comp]
;;      [player-controls-comp]
;;      (if (not (:show @slides)) [talk-image-comp])
;;      (if (and (slides-url) (:show @slides)) [pdf-viewer-comp])
;;      [:div.row.collapse
;;       [talk-actions-comp]
;;       [talk-description-comp]]]
;;     [:div.bottom-container.row.collapse.clearfix
;;      [comments-comp]]]))
;;
;;
;;;; -------------------------
;;;; INITIALIZE & MESSAGEING
;;
;;(defn add-new-comment [message]
;;  (let [comment (:message message)]
;;    (swap! state assoc-in [:talk :messages]
;;           (concat (comments) [comment]))))
;;
;;(defn- path-of-url [url]
;;  (->> (str/split url "/")
;;       (drop 3)
;;       (interleave (repeat "/"))
;;       (apply str)))
;;
;;(defn init-audio-live! []
;;  (let [url (stream-url)]
;;    (when (not= url (m/source))
;;      (m/source! url)
;;      (m/offset! (time-since-start))
;;      (m/mode! "streamed")
;;      (m/duration! (scheduled-duration))
;;      (m/volume! 0.5)
;;      (m/on-playing!
;;       #(track-event (str "player playing-live talk:" (:id (talk)))))
;;      (m/play!))))
;;
;;(defn init-audio-archived! []
;;  (let [url (:mp3 (media-links))]
;;    (when (not= url (path-of-url (m/source)))
;;      (m/source! url)
;;      (m/pause!)
;;      (m/mode! "static")
;;      (m/duration! (:archived_duration (talk)))
;;      (m/on-playing!
;;       #(track-event (str "player playing-archived talk:" (:id (talk)))))
;;      (m/volume! 0.5))))
;;
;;(defn init-audio! []
;;  (case (talk-state)
;;    "live" (init-audio-live!)
;;    "archived" (init-audio-archived!)
;;    nil))
;;
;;(defn message-handler [message]
;;  ;;(prn message)
;;  (condp = (message :event)
;;    "message" (add-new-comment message)
;;    "snapshot" (do
;;                 (u/reset-state! (:snapshot message))
;;                 ;;(print "State now: " (talk-state))
;;                 (init-audio!))))

;; (defn init! []
;;   ;; TODO check what can be played and submit to google analytics
;;   ;; https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/canPlayType
;;   (u/start-timer state)
;;   (if (.-fayeClient js/window)
;;     (u/setup-faye (channel) message-handler)
;;     (swap! page-state assoc :nopush true))
;;   (mount-root))
;;
;; (init-audio!)
