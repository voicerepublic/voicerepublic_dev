(ns vrng.talk
  (:require
   [vrng.util :as u :refer [t state track-event]]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   goog.string.format
   [clojure.string :as str]
   [ajax.core :refer [POST DELETE to-interceptor default-interceptors]]))


(enable-console-print!)

(defonce page-state (atom {:pin-id (.-pinId js/window)
                           :podcast-url (.-podcastUrl js/window)}))

(defonce player (atom {:paused true}))

(defonce current-user
  (atom (js->clj (.-currentUser js/window) :keywordize-keys true)))

;; -------------------------
;; HELPERS

(defn talk [] (:talk @state))
(defn starts-at [] (:starts_at (talk)))
(defn time-to-start [] (- (u/to-millis (starts-at)) (* 1000 (:now @state))))
(defn channel [] (:channel (talk)))
(defn started-at [] (:started_at (talk)))
(defn now [] (:now @state))
(defn stream-url [] (:stream_url (:venue (talk))))
(defn title [] (:title (talk)))
(defn media-links [] (:media_links (talk)))
(defn talk-state [] (:state (talk)))
(defn create-comment-url [] (:create_message_url (talk)))
(defn talk-speakers [] (:speakers (talk)))
(defn teaser [] (:teaser (talk)))
(defn description [] (:description (talk)))
(defn play-count [] (:play_count (talk)))
(defn series-title [] (:title (:series (talk))))
(defn series-url [] (:url (:series (talk))))
(defn user-name [] (:name (:user (:venue (talk)))))
(defn user-url [] (:url (:user (:venue (talk)))))
(defn user-image-url [] (:image_url (:user (:venue (talk)))))
(defn user-image-alt [] (:image_alt (:user (:venue (talk)))))
(defn image-url [] (:image_url (talk)))
(defn image-alt [] (:image_alt (talk)))
(defn comments [] (sort-by :created_at > (:messages (talk))))
(defn flyer-path [] (:flyer_path (talk)))

(defn format-countdown [millis]
  "Returns a textual respresentation of the countdown."
  (let [[days hours minutes seconds] (u/to-dhms millis)]
    (cond
      (< millis 0) (t "any_time_now")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format "in %02dh %02dm %02ds" hours minutes seconds))))

(defn talk-state-label []
  (cond
    (= (talk-state) "prelive") (str "Starting " (format-countdown (time-to-start)))
    :else (t (str "state." (talk-state)))))

(defn embed-code []
  (goog.string.format
   (str "<iframe width='445' height='140' src='%s'"
        " frameborder='0' scrolling='no'"
        " allowfullscreen></iframe>")
   (:embed_url (talk))))


;; -------------------------
;; DOM HELPERS
;; TODO move to util

(defn content-by-name [name]
  (aget (.getElementsByName js/document name) 0 "content"))

(defn value-by-name [name]
  (aget (.getElementsByName js/document name) 0 "value"))

(defn set-value-by-name [name value]
  (let [element (aget (.getElementsByName js/document name) 0)]
    (set! (.-value element) value)))

(def url-encode (.-encodeURI js/window))

;; -------------------------
;; CSRF TOKEN
;; TODO move to util and use on venues

(defn csrf-token []
  (content-by-name "csrf-token"))

(def csrf-interceptor
  (to-interceptor
   {:name "CSRF Interceptor"
    :request #(assoc-in % [:headers "X-CSRF-Token"] (csrf-token))}))

(swap! default-interceptors (partial cons csrf-interceptor))

;; -------------------------
;; ACTIONS

(defn post-comment-action []
  (track-event "comment post")
  (let [url (create-comment-url)
        content (value-by-name "content")]
    (POST url {:format :json
               :params {:message {:content content}}})
    (set-value-by-name "content" "")))

(defn cancel-comment-action []
  (track-event "comment cancel")
  (set-value-by-name "content" ""))

(defn pin-action []
  (track-event "talk pin-this-talk")
  (POST (str "/talks/" (:id (talk)) "/reminders")
        {:handler #(swap! page-state assoc :pin-id (get % "id"))}))

(defn unpin-action []
  (track-event "talk unpin-this-talk")
  (DELETE (str "/reminders/" (:pin-id @page-state))
          {:handler #(swap! page-state assoc :pin-id nil)}))

(defn social-url [target]
  (let [url (url-encode (.-location js/window))]
    (case target
      :facebook
      (str "https://www.facebook.com/sharer/sharer.php?u=" url)

      :twitter
      (str "https://twitter.com/intent/tweet?source=webclient&text=" url)

      :email
      (str "mailto:your@friend.com?subject="
           (url-encode (t "email.subject")) "&body="
           (url-encode (t "email.body")) url
           (url-encode (t "email.closing"))
           (url-encode (:name @current-user))))))

(defn share-action [target]
  (track-event (str "share " target " talk:" (:id (talk))))
  (let [url (social-url target)]
    (POST "/xhr/social_shares"
          {:format :json
           :params {:social_share {:shareable_id (:id (talk))
                                   :shareable_type "talk"
                                   :social_network target}}
           :handler #(.. js/window (open url "_blank") focus)})))

(defn open-modal-action [action-name]
  (fn []
    (track-event (str "modal open " (name action-name)))
    (swap! page-state assoc action-name true)))

(defn close-modal-action [action-name]
  (fn []
    (track-event (str "modal close " (name action-name)))
    (swap! page-state assoc action-name false)))

;; ------------------------------
;; AUDIO

;; https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement
(defn audio-element []
  (.getElementById js/document "audio"))

(defn paused? []
  (:paused @player))

(defn duration []
  (.-duration (audio-element)))

(defn pause []
  (print "plausing")
  (swap! player assoc :paused true)
  (.pause (audio-element)))

(defn start-playing []
  (print "playing")
  (swap! player assoc :paused false)
  (.play (audio-element)))

(defn play-action []
  (track-event (str "player play talk:" (:id (talk))))
  (print "play-action")
  (start-playing))

(defn pause-action []
  (track-event (str "player pause talk:" (:id (talk))))
  (print "pause-action")
  (pause))

(defn control-stream []
  (if (= (talk-state) "live") (start-playing)))

(defn set-audio-source []
  (let [source (or (stream-url) (:mp3 (media-links)))]
    (print "load" source)
    (aset (audio-element) "preload" "none")
    (aset (audio-element) "src" source)))

(defn format-m-s [time]
  (let [[days hours minutes seconds] (u/to-dhms (* 1000 time))]
    (goog.string.format "%02d:%02d" (+ (* hours 60) minutes) seconds)))

(defn play-progress-percentage []
  (str (u/percentage (:current-time @player) (duration)) "%"))

(defn play-volume-percentage []
  (str (* 100 (:volume @player)) "%"))

(defn set-volume [volume]
  (swap! player assoc :volume volume)
  (aset (audio-element) "volume" volume))

(defn adjust-volume-action [event]
  (track-event (str "player volume talk:" (:id (talk))))
  (let [meter (.-currentTarget event)
        top (.-top (.getBoundingClientRect meter))
        bottom (.-bottom (.getBoundingClientRect meter))
        current (.-clientY event)
        volume (/ (- bottom current) (- bottom top))]
    (set-volume volume)))

;; -------------------------
;; COMPONENTS

(defn icon-comp [icon]
  [:svg {:dangerouslySetInnerHTML
         {:__html (str "<use xlink:href='#icon-" icon "' />")}}])

(defn countdown-comp []
  [:span.label.state-msg (format-countdown (time-to-start))])

(defn edit-link-comp []
  [:li [:a.button.hollow.muted.tiny.btn-hover-light-blue
        {:href (:edit_url (talk))}
        [icon-comp "pencil"]
        "Edit" [:span.hide-for-small-only " This Talk"]]])

(defn venue-link-comp []
  [:li [:a.button.hollow.tiny.btn-yellow.btn-hover-yellow
        {:href (:url (:venue (talk)))}
        [icon-comp "victrola"]
        "Stream" [:span.hide-for-small-only " This Talk"]]])

(defn title-block-comp []
  [:div.row.collapse.talk-title
   [:div
    [:ul.menu.vertical.medium-horizontal.state-container.clearfix.text-center.medium-text-left
     [:li
      [:span.state-msg.label {:class (talk-state)} (talk-state-label)]]]
    [:h1.text-center.medium-text-left
    (cond
      (= (talk-state) "live")
        [:span.live-inline-label "Live"])
     (title)]]])

(defn publisher-only-comp []
  [:div#publisher-options
   [:div.menu-centered [:ul.menu [edit-link-comp]
                        (if (or (= (talk-state) "prelive")
                                (= (talk-state) "live"))
                          [venue-link-comp])]]])

(defn talk-info-comp []
  [:div {:class "row collapse"}
   [:div {:class "medium-7 columns"}
    [:p.teaser.lead.text-center.medium-text-left (teaser)
     (if-not (str/blank? (talk-speakers))
       [:p.speakers.text-center.medium-text-left " Speakers: "
        [:span.names (talk-speakers)]])]]
   [:div#talk-meta.medium-4.medium-offset-1.columns
    [:div {:class "media-object stack-for-small"}
     [:div {:class "media-object-section text-center"}
      [:div {:class "img-circle"}
       [:a {:href (user-url)}
        [:img.avatar-image {:alt "(user-name)" :height "60",
                            :src (user-image-url) :width "60"}]]]]
     [:div {:class "media-object-section pub-meta text-center medium-text-left middle"}
      [:p {:class "meta-publisher"}
       [:a {:href (user-url)} (user-name)]]
      [:p {:class "meta-series"} "From the Series: "
       [:a {:href (series-url)} (series-title)]]
      [:p {:class "meta-info"}
       [:span (u/from-now (u/to-millis (starts-at)))]
       (if (= (talk-state) "archived") [:span " • " (play-count) " Plays"])]]
     ]]])

(defn player-controls-comp []
  (set-audio-source)
  (set-volume 0.5)
  (fn []
  [:div.player-container
   [:div#talk-playbar.row.collapse
    (if (paused?)
      [:button.button.button-playbar.button-play-pause.state-play {:on-click play-action}
       [icon-comp "play"]]
       [:button.button.button-playbar.button-play-pause.state-play {:on-click pause-action}
       [icon-comp "pause"]])
    [:div#meter.jp-volume-bar {:on-click adjust-volume-action}
     [:div#indicator.jp-volume-bar-value {:style {:height (play-volume-percentage)}}]]
    [:span.timecode.jp-current-time (format-m-s (:current-time @player))]
    [:div.timeline.jp-seek-bar {:style {:width "0%"}}
     [:div.track-playing.jp-play-bar {:style {:width (play-progress-percentage)}}]]
    [:span.timecode.right.jp-duration (format-m-s (duration))]
    (if js/signedIn
      (if (:pin-id @page-state)
        ;; TODO nick: either style .button-unpin or introdcue a icon unpin
        [:button.button.button-playbar.button-unpin.hide-for-small-only
         {:on-click unpin-action} [icon-comp "pin"]]
        [:button.button.button-playbar.button-pin.hide-for-small-only
         {:on-click pin-action} [icon-comp "pin"]])
      ;; TODO phil: open a popup or forward to sign in/up
      [:button.button.button-playbar.button-pin.hide-for-small-only
       {:on-click (open-modal-action :signin)} [icon-comp "pin"]])
    ;; NOTE @nick: what is this?
    ;; NOTE @phil: just for putting a tiny bit of space between things
    ;; NOTE @nick: no, i meant the whole commented section
    ;;[:div {:class "playbar-divider"}]
    ;;[:button {:data-selector "tooltip-imm27bsv0", :title "", :data-yeti-box "tooltip-imm27bsv0", :data-resize "tooltip-imm27bsv0", :data-options "disable_for_touch:true", :id "view-slides2", :class "has-tip tip-top tip-center button button-playbar button-volume right hide-for-small-only", :data-tooltip "nz95zk-tooltip", :aria-describedby "tooltip-imm27bsv0", :aria-haspopup "true", :data-toggle "tooltip-imm27bsv0"} ]
    ]]))

(defn talk-image-comp []
  [:div {:class "row collapse"}
   [:div {:class "talk-picture"}
    [:img {:class "image" :src (image-url) :alt "" }]
    ;; TODO phil: slides
    ;; [:button#view-slides.button.button-playbar.button-volume.right.show-for-small-only {:title "View Slides"}
    ;;  [icon-comp "slides"]]
    ]])

(defn action-button-comp [action-name title classes]
  [:li { :class classes }
   [:a {:class "button small" :aria-haspopup "true", :tab-index "0"
        :on-click (open-modal-action action-name)}
    [icon-comp (name action-name)]
    [:span {:class "action-name"} title]]])

(defn dropdown-pane-comp []
  [:div {:class "dropdown-pane" :id "testdrop"} "hii"])

(defn talk-actions-comp []
  [:div {:class "float-right medium-4 large-3 columns", :id "talk-actions"}
   [:ul {:class "button-group float-right"}
    ;; remove from action panel for now, since it's in the play bar
    [action-button-comp :pin "Pin" "hide-for-medium"]
    [action-button-comp :share "Share" ""]
    [:li ; --- comments
     [:a {:class "button small", :href "#comment-container"}
      [icon-comp "chat"]
      [:span {:class "comment-count show-for-small-only"} "3"]
      [:span {:class "action-name"} "Comments"]]]
    [action-button-comp :embed "Embed" "hide-for-small-only"]
    [action-button-comp :podcast "Podcast" "hide-for-small-only"]]])

(defn talk-description-comp []
  [:div.left.medium-8.large-9.columns {:id "talk-description"}
   [:p {:dangerouslySetInnerHTML {:__html (description)}}]])

(defn comment-comp [comment]
  ^{:key (:id comment)}
  [:div {:class "row collapse comment-block"}
   [:div {:class "comment-meta small-3 columns"}
    [:p
     [:img.comment-avatar {:src (:user_image_url comment)
                           :alt (:user_image_alt comment)}]]
    [:p {:class "post-author"} (:user_name comment)]
    [:p {:class "post-time" :title (:created_at comment)}
     (u/from-now (:created_at comment))]]
   [:div {:class "comment-content small-8 small-offset-1 medium-9 medium-offset-0 columns"}
    [:p {:class "meta-info"} (:content comment)]]])

(defn comments-login-comp []
  [:div.clearfix
   [:p "Please "
    [:a {:href js/signInPath} "sign in"]
    " to make a comment."]])

(defn comments-form-comp []
  [:div
   [:textarea.panel {:name "content"
                     :placeholder "Share your thoughts here."}]
   [:button {:class "button float-right small secondary btn-hover-blue" :on-click post-comment-action } "Post"]
   [:button {:class "button float-right cancel small hollow btn-hover-red btn-gray" :on-click cancel-comment-action } "Cancel"]]
  )

(defn comments-comp []
  [:div.clearfix {:id "comment-container"}
   [:div {:class "comment small-12 columns float-center"}
    [:h3 [icon-comp "chat"] " " "Comments"]
    (if js/signedIn [comments-form-comp] [comments-login-comp])]
   [:div {:class "small-12 columns previous-comments"}
    (doall (map comment-comp (comments)))]])

(defn modal-comp [action-name title content-comp]
  [:div.instruction-container
   [:div.modal-background {:on-click (close-modal-action action-name)}]
   [:div#talk-modal {:role "dialog"}
    [:div.row.no-pad
     [:h2 {:id "modalTitle"} title]]
    [content-comp]
    [:button.close-button {:aria-label "Close modal" :type "button"  :on-click (close-modal-action action-name) }
     [:span {:aria-hidden "true"} "×"]]]])

(defn modal-embed-comp []
  [:div
   [:p {:class "lead"} "Copy and paste the following code into your web site:"]
   [:textarea {:rows "3"} (embed-code)]
   [:p [:a {:href "http://blog.voicerepublic.com/support/embed-talks/?lang=en"}
        "You need help?"]]])

(defn modal-pin-comp []
  [:div
   (if js/signedIn
     (if (:pin-id @page-state)
       [:button {:class "button small" :on-click unpin-action} "Unpin"]
       [:button {:class "button small" :on-click pin-action} "Pin"])
     [:button {:class "button small"} "Sign In"])])

(defn modal-podcast-comp []
  [:div
   [:p
    [:a {:class "button hollow btn-hover-yellow"
         :href (:podcast-url @page-state) :target "_blank"}
     [:span "Launch"]]]])

(defn modal-signin-comp []
  [:div
   [:p {:class "lead"} "Hey dude! You need to sign in to do that."]
   [:p
    [:a {:class "button hollow btn-hover-yellow"
         :href "/signin"}
     [:span "Sign In"]]
    [:a {:class "button hollow btn-hover-yellow"
         :href "/signup"}
     [:span "Join for Free"]]]])

(defn modal-share-comp []
  [:div
   [:div
    [:img {:src (flyer-path)}]
    [:ul.menu.share-links
     [:li [:a {:href (flyer-path) :target "_blank" :download true}
           [icon-comp "download"]]]
     [:li [:a {:on-click #(share-action :facebook)} [icon-comp "facebook"]]]
     [:li [:a {:on-click #(share-action :twitter)} [icon-comp "twitter"]]]
     [:li [:a {:on-click #(share-action :email)} [icon-comp "email"]]]
     ]]])

(defn modals-comp []
  [:div
   (if (true? (:signin @page-state))
     [modal-comp :signin "Wait a minute..." modal-signin-comp])
   (if (true? (:pin @page-state))
     [modal-comp :pin "Pin this Talk" modal-pin-comp])
   (if (true? (:share @page-state))
     [modal-comp :share "Share this Talk" modal-share-comp])
   (if (true? (:embed @page-state))
     [modal-comp :embed "Embed this Talk" modal-embed-comp])
   (if (true? (:podcast @page-state))
     [modal-comp :podcast "Podcast this Talk" modal-podcast-comp])])

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
    [:td "comments"]
    [:td (str (comments))]]
   [:tr
    [:td "(paused?)"]
    [:td (str (paused?))]]
   [:tr
    [:td "play-progress-percentage"]
    [:td (play-progress-percentage)]]
   ])

(defn root-comp []
  (.onTalkPageReady js/window)
  (fn []
    [:div.left-side.medium-9.columns.float-left
     ;;[debug-comp]
     [:div.top-container
      [title-block-comp]
      [talk-info-comp]
      [player-controls-comp]
      [talk-image-comp]
      [:div.row.collapse
       [talk-actions-comp]
       [talk-description-comp]]]
     [:div.bottom-container.row.collapse.clearfix
      [comments-comp]]]))


;; -------------------------
;; INITIALIZE & MESSAGEING

(defn add-new-comment [message]
  (let [comment (:message message)]
    (swap! state assoc-in [:talk :messages]
           (concat (comments) [comment]))))

(defn message-handler [message]
  (condp = (message :event)
    "message" (add-new-comment message)
    "snapshot" (do
                 (u/reset-state! (:snapshot message))
                 (print "State now: " (talk-state))
                 (control-stream))))

(defn mount-root []
  (if js/isHost
    (reagent/render [publisher-only-comp] (.getElementById js/document "publisher-options-holder")))
  (reagent/render [root-comp] (.getElementById js/document "app"))
  (reagent/render [modals-comp] (.getElementById js/document "modals")))

(defn update-player []
  ;; track listening
  (if-not (paused?)
    (do
    (swap! player assoc :play-time (+ 250 (:play-time @player)))
    (if (= 0 (mod (:play-time @player) (* 1000 60)))
      (track-event (str "player playing talk:" (:id (talk)))))
    ;; update progress
    (swap! player assoc :current-time (.-currentTime (audio-element))))))

(defonce updater (js/setInterval update-player 250))

(defn init! []
  ;; TODO check what can be played and submit to google analytics
  ;; https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/canPlayType
  (u/start-timer state)
  (u/setup-faye (channel) message-handler)
  (mount-root)
  (control-stream))
