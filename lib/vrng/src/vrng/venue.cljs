(ns vrng.venue
  (:require
   [vrng.util :as u :refer [t state to-millis track-event]]
   [vrng.sporktrum :as spork]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   [ajax.core :refer [PUT]]
   [clojure.string :as str]
   [cljsjs.selectize]
   goog.string.format
   goog.string)
  (:require-macros [cljs.core :refer [exists?]]))

;; -------------------------
;; STATE

(defonce page-state (atom {:instructions true
                           :menu-open false
                           :mobile-menu-open false
                           :device-name (:device_name (:venue @state))
                           :stats {:listener_count 0}}))

(defonce user
  (atom (js->clj (.-user js/window) :keywordize-keys true)))

;; -------------------------
;; GENERIC UTILS

(defn format-countdown [millis]
  (let [[days hours minutes seconds] (u/to-dhms millis)]
    (cond
      (< millis 0) (str (goog.string.format
                         "%02dh %02dm %02ds"
                         hours minutes seconds) " over due")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format
             "%02dh %02dm %02ds"
             hours minutes seconds))))

;; -------------------------
;; Page specific utils

(defn now [] (* 1000 (:now @state)))
(defn time-to [time] (- time (now)))

(defn user-image-url [] (:image_url @user))
(defn user-url [] (:url @user))

(defn venue [] (:venue @state))
(defn venue-slug [] (:slug (venue)))
(defn venue-url [] (str "/venues/" (venue-slug)))
(defn config-url [client] (str (venue-url) "/" client))
(defn venue-state [] (:state (venue)))
(defn venue-name [] (:name (venue)))
(defn available-at [] (:available_at (venue)))
(defn talks [] (:talks (venue)))
(defn new-talk-path [] (str "/talks/new?talk%5Bvenue_id%5D=" (:id (venue))))

(defn talks-by-state [talk-state]
  (filter #(= talk-state (:state %)) (:talks (venue))))

;; FIXME I've seen this fail
(defn active-talk []
  (or (first (talks-by-state "live"))
      (first (sort :starts_at (talks-by-state "prelive")))))

(defn active-talk-title [] (:title (active-talk)))
(defn active-talk-url [] (:url (active-talk)))
(defn active-talk-state [] (:state (active-talk)))

(defn active-talk-runtime []
  (- (now) (to-millis (:started_at (active-talk)))))

(defn active-talk-duration []
  (* 60 1000 (:duration (active-talk))))

(defn time-to-active-talk []
  (- (to-millis (:starts_at (active-talk))) (now)))

(defn time-to-available []
  (* (- (available-at) (:now @state)) 1000))

(defn time-since-provisioning-completed []
  (- (now) (to-millis (:completed_provisioning_at (venue)))))

(defn time-since-provisioning-started []
  (- (now) (to-millis (:started_provisioning_at (venue)))))

(defn venue-provisioning-started-at []
  (to-millis (:provisioning_started_at (venue))))

(defn venue-provisioning-duration []
  (* 1000 (:provisioning_duration (venue))))

(defn active-talk-progress-percentage []
  (u/percentage (active-talk-runtime) (active-talk-duration)))

(defn active-talk-progress
  ([] (active-talk-progress ""))
  ([suffix] (str (active-talk-progress-percentage) suffix)))

(defn server-progress
  ([] (server-progress ""))
  ([suffix] (str (u/percentage
                  (time-since-provisioning-started)
                  (venue-provisioning-duration)) suffix)))

(defn icecast-url [] (:stream_url (venue)))
(defn venue-device-id [] (:device_id (venue)))
(defn venue-device-name [] (:device_name (venue)))

(defn venue-device-id-or-name []
  (or (venue-device-id) (venue-device-name)))

(defn generic-devices []
  [{:id "butt"    :name "B.U.T.T."}
   {:id "darkice" :name "Darkice"}
   {:id "generic" :name "Generic Icecast Client"}])

(defn user-owned-devices [] (:devices @state))

(defn devices []
  (concat (user-owned-devices) (generic-devices)))

(defn listener-count []
  (:listener_count (:stats @page-state)))

(defn show-stop-warning? [] ;; if progress is < 85%
  (and (:over-stop-button @page-state)
       (< (active-talk-progress-percentage) 85)))

(defn talk-url [talk] (str "/xhr/talks/" (talk :id)))

;; TODO make variadic with &
(defn venue-in-state [venue-states]
  (some #(= (venue-state) %) venue-states))

(defn active-talk-in-state [active-talk-states]
  (some #(= (active-talk-state) %) active-talk-states))

;; -------------------------
;; BUSINESS LOGIC

(defn server-status []
  (cond
    (and (venue-in-state ["provisioning"])
         (> (time-since-provisioning-started)
            (venue-provisioning-duration)))
    {:class "alert" :reason "The server takes too long to provision."}

    (venue-in-state ["provisioning"])
    {:class "warning" :reason "The server is currently being provisioned."}

    (venue-in-state ["device_required" "awaiting_stream"
                     "connected" "disconnected"])
    {:class "success" :reason "The server is healthy."}

    (< (time-to-active-talk) (* 5 60 1000))
    {:class "alert" :reason "Time is running out. Less than 5min to scheduled start."}

    (venue-in-state ["available"])
    {:class "warning" :reason "The server is now available and ready to be launched."}

    :else {:class "neutral"}))

(defn device-status []
  (cond
    (venue-in-state ["provisioning" "awaiting_stream"])
    {:class "warning" :reason "You can now select an audio source."}

    (venue-in-state ["device_required"])
    {:class "alert" :reason "You need to select an audio source."}

    (venue-in-state ["disconnected"])
    {:class "alert" :reason "This audio source disconnected from the server."}

    (venue-in-state ["connected"])
    {:class "success" :reason "The audio source is happily streaming."}
    :else {:class "neutral"}))

(defn talk-status []
  (cond
    (and (active-talk-in-state ["live"])
         (venue-in-state ["disconnected" "awaiting_stream"]))
    {:class "alert" :reason "The talk is LIVE but the audio source disconnected!"}

    (and (active-talk-in-state ["live"])
         (venue-in-state ["connected"]))
    {:class "success" :reason "All good. Props to you!"}

    (< (time-to-active-talk) 0)
    {:class "alert" :reason "Time is up! You are behind schedule."}

    (< (time-to-active-talk) (* 10 60 1000))
    {:class "warning" :reason "Time is running out. Less than 10min to scheduled start."}

    :else {:class "neutral"}))

;; -------------------------
;; MESSAGING

(defn venue-message-handler [msg]
  (condp = (:event msg)
    "snapshot" (u/reset-state! (:snapshot msg))
    "stats" (swap! page-state assoc :stats (:stats msg))
    (prn "Unknown message" msg)))

;; -------------------------
;; ACTIONS

(defn request-availability-action []
  (print "Request availability...")
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "become_available" }}}))

(defn start-server-action []
  (track-event "server launch")
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "start_provisioning" }}}))

(defn select-device-action [event]
  (let [device-id-or-name event;(.. event -target -value)
        numeric (re-matches #"^\d+$" device-id-or-name)
        device-id (if numeric device-id-or-name nil)
        device-name (if numeric nil device-id-or-name)]
    (track-event (str "device select " device-id-or-name))
    (PUT (venue-url)
         {:format :json
          :params { :venue {:device_id device-id
                            :device_name device-name
                            :event "select_device" }}})
    (swap! page-state assoc :device-name device-name)
    (swap! page-state assoc :instructions true)))

(defn hide-instructions-action []
  (track-event "instructions close")
  (swap! page-state assoc :instructions false)
  false)

(defn start-talk-action [talk]
  (track-event "talk start")
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "start_talk"}}}))

(defn end-talk-action [talk]
  (track-event "talk end")
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "end_talk"}}}))

(defn mouseover-stop-button-action []
  (swap! page-state assoc :over-stop-button true))

(defn mouseout-stop-button-action []
  (swap! page-state assoc :over-stop-button false))

;; -------------------------
;; COMPONENTS

;; NOTE maybe we should display an approx. audio delay. later we could
;; use the internal microphone to calculate the exact delay, if on
;; site. It could also be used to detect if on site.

(defn icon-comp [icon]
  [:svg {:dangerouslySetInnerHTML
         {:__html (str "<use xlink:href='#icon-" icon "' />")}}])

;; https://developer.mozilla.org/de/docs/Web/HTML/Element/audio
;; https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement
(defn debug-audio-comp []
  (let [element (.getElementById js/document "monitor")]
    (if element
      [:table {:style {:font-size "70%"}}
       [:tr [:td "audioTracks"]           [:td (.-audioTracks element)]]
       [:tr [:td "autoplay"]              [:td (.-autoplay element)]]
       [:tr [:td "buffered"]              [:td (.-buffered element)]]
       [:tr [:td "controller"]            [:td (.-controller element)]]
       [:tr [:td "controls"]              [:td (.-controls element)]]
       [:tr [:td "crossOrigin"]           [:td (.-crossOrigin element)]]
       [:tr [:td "currentSrc"]            [:td (.-currentSrc element)]]
       [:tr [:td "currentTime"]           [:td (.-currentTime element)]]
       [:tr [:td "defaultMuted"]          [:td (.-defaultMuted element)]]
       [:tr [:td "defaultPlaybackRate"]   [:td (.-defaultPlaybackRate element)]]
       [:tr [:td "disableRemotePlayback"] [:td (.-disableRemotePlayback element)]]
       [:tr [:td "duration"]              [:td (.-duration element)]]
       [:tr [:td "ended"]                 [:td (.-ended element)]]
       [:tr [:td "error"]                 [:td (.-error element)]]
       [:tr [:td "initialTime"]           [:td (.-initialTime element)]]
       [:tr [:td "loop"]                  [:td (.-loop element)]]
       [:tr [:td "mediaGroup"]            [:td (.-mediaGroup element)]]
       ;;[:tr [:td "mediaKeys"]             [:td (.-mediaKeys element)]]
       ;;[:tr [:td "mozAudioCaptured"]      [:td (.-mozAudioCaptured element)]]
       ;;[:tr [:td "mozAudioChannelType"]   [:td (.-mozAudioChannelType element)]]
       ;;[:tr [:td "mozChannels"]           [:td (.-mozChannels element)]]
       ;;[:tr [:td "mozFragemntId"]         [:td (.-mozFragemntId element)]]
       ;;[:tr [:td "mozFrameBufferLength"]  [:td (.-mozFrameBufferLength element)]]
       ;;[:tr [:td "mozSampleRate"]         [:td (.-mozSampleRate element)]]
       [:tr [:td "muted"]                 [:td (.-muted element)]]
       [:tr [:td "networkState"]          [:td (.-networkState element)]]
       [:tr [:td "paused"]                [:td (.-paused element)]]
       [:tr [:td "playbackRate"]          [:td (.-playbackRate element)]]
       [:tr [:td "played"]                [:td (.-played element)]]
       [:tr [:td "preload"]               [:td (.-preload element)]]
       ;;[:tr [:td "preservesPitch"]        [:td (.-preservesPitch element)]]
       [:tr [:td "readyState"]            [:td (.-readyState element)]]
       [:tr [:td "seekable"]              [:td (.-seekable element)]]
       [:tr [:td "seeking"]               [:td (.-seeking element)]]
       ;;[:tr [:td "sinkId"]                [:td (.-sinkId element)]]
       [:tr [:td "src"]                   [:td (.-src element)]]
       [:tr [:td "srcObject"]             [:td (.-srcObject element)]]
       ;;[:tr [:td "textTracks"]            [:td (.-textTracks element)]]
       ;;[:tr [:td "videoTracks"]           [:td (.-videoTracks element)]]
       [:tr [:td "volume"]                [:td (.-volume element)]]
       ]
      [:span "no audio tag found"])))

;; TODO phil: maybe find a more solid way to subscribe to the audio stream
;; http://stackoverflow.com/questions/27429123/html5-audio-web-audio-api-cors-and-firefox
(defn audio-comp []
  (js/setTimeout #(spork/setup-analyser-for-media-element "monitor") 500)
  (fn []
    [:audio#monitor {:cross-origin "anonymous" :auto-play "autoplay"}
     [:source {:src (icecast-url) :type "audio/ogg"}]]))

(defn countdown-comp [millis]
  [:span (format-countdown millis)])

(defn server-start-button-comp []
  [:button { :on-click start-server-action } (t "setup")])

(defn titlebar-comp [title status]
  [:div {:class "titlebar clearfix"}
   [:h4 {:class "title"} title
    [:span {:title (:reason status)
            :class (str (:class status) " badge float-right")}
     (condp = (:class status)
       "success" (goog.string/unescapeEntities "&#x2713;")
       "neutral" "-"
       "warning" "!"
       "alert" "!")]]])

(defn server-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   (cond
     (venue-in-state ["offline"]) ; offline
     [:div {:class "holder"}
      [:div.status-bar
       (if-not (neg? (time-to-available))
         [:p {:class "launchable-in"} "Available in "
          [:span {:class "countdown", :id "time-till-provisioning"}
           [countdown-comp (time-to-available)]]]
         [:p "Checking..."])]
      [:p [:a.button.success.small.expanded.server-start-button.disabled
           "LAUNCH SERVER"]]]

     (venue-in-state ["available"]) ; available
     [:div {:class "holder"}
      [:div.status-bar
       [:p {:class "launch-advice"} "Became available "
        (u/from-now (* 1000 (available-at)))]]
      [:p [:a.button.success.small.expanded.server-start-button
           {:on-click start-server-action} "LAUNCH SERVER"]]]

     (venue-in-state ["provisioning"]) ; provisioning
     [:div {:class "secondary progress server-progress", :role "progressbar",
            :tab-index "0", :aria-valuenow (server-progress), :aria-valuemin "0",
            :aria-valuetext (server-progress " percent"), :aria-valuemax "100"}
      [:div {:class "progress-meter", :style { :width (server-progress "%") }}
       [:p {:class "progress-meter-text"} "Server is starting"]]]

     :else ; all other
     [:div {:class "holder clearfix"}
      [:div.status-bar
       [:p {:class "label online-for"}]
       [countdown-comp (time-since-provisioning-completed)]]
      [:span {:class "float-right server-bitrate-wrapper hide"}
       [:span {:class "server-bitrate"} "--"] " kB/sec"]])])

(defn device-option-comp [device]
  (let [key (device :id)]
    ^{:key key}
    [:option {:value key} (device :name)]))

(defn device-select-comp []
  [:select#device-selector {:on-change #(select-device-action %)
            :value (venue-device-id-or-name)}
   (doall (map device-option-comp (devices)))])

(def device-select-comp-with-callback
  (with-meta device-select-comp
    {:component-did-mount
     (fn [this]
       (.selectize (js/jQuery (.getElementById js/document "device-selector"))
                   #js{:onChange select-device-action}))}))

(defn device-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   [:div.status-bar
    [spork/audio-meter-comp]
    [device-select-comp-with-callback]]])

(defn talk-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   (cond
     (= nil (active-talk)) ; none
     [:div {:class "holder"}
      [:div.status-bar
       [:a {:href (new-talk-path)} ">> Schedule your next Talk"]]]

     (active-talk-in-state ["prelive"]) ; prelive
     [:div {:class "holder"}
      [:div.status-bar
       [:span {:class "label scheduled-start"} "Scheduled Start: "
        (format-countdown (time-to-active-talk))
        [:span {:class "clock-msg"}]
        [:span {:class "ago-msg hide"}]]]
      [:a {:class (str "button success small talk-start-button expanded"
                       (if (not (venue-in-state ["connected"])) " disabled"))
           :on-click #(start-talk-action (active-talk))} "Start Broadcast"]]

     (active-talk-in-state ["live"]) ; live
     [:div.holder
      [:div.status-bar.secondary.progress.talk-progress
       {:role "progressbar"
        :tab-index "0"
        :aria-valuenow (active-talk-progress)
        :aria-valuemin "0"
        :aria-valuetext (active-talk-progress " percent")
        :aria-valuemax "100"}
       [:div {:class "progress-meter", :style
              {:width (active-talk-progress "%")}}
        [:p {:class "progress-meter-text"}
         [countdown-comp (active-talk-runtime)]]]]
      [:p.button-holder
       (if (show-stop-warning?)
         [:span {:class "stop-warning"}
          "Stopping early?"])
       [:a {:href "#"
            :on-click #(end-talk-action (active-talk))
            :class "button btn-red btn-hover-red small float-right hollow"
            :tab-index "1",
            :on-mouse-over mouseover-stop-button-action
            :on-mouse-out mouseout-stop-button-action}
        "Stop Broadcast"]]])])

(defn active-talk-title-prefix-comp []
  [:span {:class "talk-label"}
   (if (= nil (active-talk))
     "NO TALKS SCHEDULED"
     (if (= (active-talk-state) "prelive")
       "NEXT UP: "
       "CURRENT TALK: "))])


;; TODO phil: maybe refactor using a macro?
(defn debug-comp []
  [:table
   [:tr
    [:td "(to-millis (:starts_at (active-talk)))"]
    [:td (to-millis (:starts_at (active-talk)))]
    [:td]]
   [:tr
    [:td "(:starts_at (active-talk))"]
    [:td (:starts_at (active-talk))]
    [:td]]
   [:tr
    [:td "venue-state"]
    [:td (venue-state)]
    [:td]]
   [:tr
    [:td "now"]
    [:td (now)]
    [:td]]
   [:tr
    [:td "time-to-available"]
    [:td (time-to-available)]
    [:td (format-countdown (time-to-available))]]
   [:tr
    [:td "time-to-active-talk"]
    [:td (time-to-active-talk)]
    [:td (format-countdown (time-to-active-talk))]]
   [:tr
    [:td "time-since-provisioning-completed"]
    [:td (time-since-provisioning-completed)]
    [:td (format-countdown (time-since-provisioning-completed))]]
   [:tr
    [:td "active-talk-runtime"]
    [:td (active-talk-runtime)]
    [:td (format-countdown (active-talk-runtime))]]
   [:tr
    [:td "active-talk-state"]
    [:td (active-talk-state)]
    [:td]]
   [:tr
    [:td "active-talk-duration"]
    [:td (active-talk-duration)]
    [:td (format-countdown (active-talk-duration))]]
   [:tr
    [:td "active-talk-progress"]
    [:td (goog.string.format "%.3f" (active-talk-progress))]
    [:td]]
   [:tr
    [:td "time-since-provisioning-started"]
    [:td (time-since-provisioning-started)]
    [:td (format-countdown (time-since-provisioning-started))]]
   [:tr
    [:td "venue-provisioning-duration"]
    [:td (venue-provisioning-duration)]
    [:td (format-countdown (venue-provisioning-duration))]]
   [:tr
    [:td "server-progress"]
    [:td (goog.string.format "%.3f" (server-progress))]
    [:td]]
   ])

(defn on-air-comp []
  (let [on (and (venue-in-state ["connected"])
                (active-talk-in-state ["live"]))]
    [:div {:class (str "label on-air" (if on " success" ""))}
     (if on "ON AIR" "OFF AIR")]))

(defn instructions-for-butt-comp []
  [:div.tiny {:id "instructions"}
   [:h4 "Streaming with B.U.T.T."]
   [:p.lead "Simply download the config file below and import it into B.U.T.T. by clicking \"Settings\" > \"Import\" inside the B.U.T.T. application, and push \"Play.\""]
   [:p.clearfix
    [:a.button.small.hollow.btn-white.btn-hover-red.float-left
     {:href "#" :on-click hide-instructions-action} "Cancel"]
    ;; target blank as a workaround for
    ;; https://bugzilla.mozilla.org/show_bug.cgi?id=712329
    [:a.button.small.secondary.float-right {:href (config-url "butt")
                                            :target "_blank"}
     [icon-comp "download"] "download config file"]]])

(defn instructions-for-darkice-comp []
  [:div {:id "instructions"}
   [:h4 "Streaming with darkice"]
   [:p.lead "Download the config file below and run with..."]
   [:code "sudo darkice -c <your-config-file>"]
   [:p.lead "Note: root permissions are required to use posix realtime scheduling."]
   [:p.clearfix
    [:a.button.small.hollow.btn-white.btn-hover-red.float-left
     {:href "#" :on-click hide-instructions-action} "Cancel"]
    ;; target blank, s.o.
    [:a.button.small.secondary.float-right {:href (config-url "darkice")
                                            :target "_blank"}
     [icon-comp "download"] "download config file"]]])

(defn instructions-for-generic-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming with a Generic Icecast Client"]
   [:table
    [:tr [:td "Host/Server"] [:td (:public_ip_address (venue))]]
    [:tr [:td "User"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]
    [:tr [:td "Mountpoint"] [:td (:mount_point (venue))]]]
   [:p.text-center
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href "#" :on-click hide-instructions-action} "Cancel"]]])

(defn instructions-to-disconnect-comp []
  [:div.medium {:id "instructions"}
   [:h4 "alert"]
    [:p "Please disconnect your streaming client. This message will self destruct as soon as you obey our command."]])

(defn talk-listing-talk-comp [talk]
  ^{:key (:id talk)}
  [:tr.lineup-list-item
   [:td.blank]
   [:td.talk-date (:starts_at_date talk)]
   [:td.talk-time (:starts_at_time talk)]
   [:td.talk-duration (:duration talk) " min"]
   [:td.talk-title [:a {:href (:url talk)} (:title talk) " "]
    (cond (= (:state talk) "live")
          [:span.label.live "LIVE"]
          (= talk (active-talk))
          [:span.label.next "NEXT"])]
   [:td.talk-title [:a {:href (:url (:series talk))} (:title (:series talk))]]
   [:td.blank]])

(defn talk-listing-comp [title talk-states sort-options]
  ;; only render if the table has any content
  (if (not-empty (mapcat #(talks-by-state %) talk-states))
    [:div.lineup-list
     [:div.title-bar
      [:h5.lineup-title title]]
     [:table
      [:tbody
       [:tr
        [:th]
        [:th.talk-date {:width "12%"} "Date"]
        [:th.talk-time {:width "9%"} "Time"]
        [:th.talk-duration {:width "10%"} "Duration"]
        [:th.talk-title {:width "42%"} "Title"]
        [:th.talk-title "Series"]
        [:th]]
       (doall (map #(doall (map talk-listing-talk-comp (apply sort-by (conj sort-options (talks-by-state %))))) talk-states))]]])) ; ¯\_(ツ)_/¯

(defn close-menu-action []
  (swap! page-state assoc :menu-open false))

(defn open-menu-action []
  (swap! page-state assoc :menu-open (not (:menu-open @page-state)))
  false)


(defn close-mobile-menu-action []
  (swap! page-state assoc :mobile-menu-open false))

(defn open-mobile-menu-action []
  (swap! page-state assoc :mobile-menu-open (not (:mobile-menu-open @page-state)))
  false)

;; TODO phil: needs workover, still has a lot of hardcoded stuff
(defn topbar-comp [] ; --- mounted to #topbar
  ;; NOTE nick: I had to add the leading div since the component has two
  ;; siblings I think this introduced a blue bar while loading, no idea
  ;; why
  [:div {:on-click close-menu-action}
   [:div#main-menu.top-bar {:class (:class (talk-status))}
    [:div.top-bar-left
     [:ul#branding.menu
      {:role "menubar"}
      [:li.logo.show-for-medium
       {:role "menuitem"}
       [:a
        {:tab-index "0", :href "/"}
        [icon-comp "logo"]]]
      [:li#mobile-logo.logo.show-for-small-only
       {:on-click open-mobile-menu-action :role "menuitem"}
       [:a [icon-comp "logo"]]]]]
    [:div.message (:message @page-state)] ; TODO nick: needs styling
    [:div.top-bar-right.show-for-medium
     [:ul.dropdown.menu {:role "menubar"}
      [:li [:a {:href "/venues"} "My Venues"]]
      [:li [:a {:href (new-talk-path)} "Schedule Talk"]]
      [:li.has-submenu.avatar.hide-for-small-only.opens-right
       {:aria-label "                            ",
        :aria-expanded "false",
        :aria-haspopup "true",
        :role "menuitem"}
       [:a
        {:tab-index "0", :href "#", :on-click open-menu-action}
        [:img.avatar-image {:width "36" :src (user-image-url) :height "36" :alt ""}]]]]
        (if (:menu-open @page-state)
        [:ul.menu.vertical.first-sub
        {:id "venue-dropdown" :role "menu", :aria-hidden "true"}
        [:li.is-submenu-item.is-dropdown-submenu-item
         {:role "menuitem"}
         [:a {:href (user-url)} "My Profile"]]
        [:li.is-submenu-item.is-dropdown-submenu-item
         {:role "menuitem"}
         [:a {:href "/talks/new?talk%5Bdryrun%5D=true"} "Test Talk"]]
        [:li.is-submenu-item.is-dropdown-submenu-item
         {:role "menuitem"}
         [:a {:href "/talks/new"} "Schedule Talk"]]
        [:li.is-submenu-item.is-dropdown-submenu-item
         {:role "menuitem"}
         [:a {:href "/uploads/new"} "Upload Talk"]]
        [:li.is-submenu-item.is-dropdown-submenu-item
         {:role "menuitem"}
         [:a {:href "/users/sign_out" :data-method "delete" :rel "nofollow"} "Logout"]]])
       ]]
    (if (:mobile-menu-open @page-state)
   [:div#mobile-nav.show-for-small-only
    ;;[:div.menu.vertical
     [:ul.menu.vertical
      [:li [:a {:href "/"} "Home"]]
      [:li [:a {:href (user-url)} "My Profile"]]
      [:li [:a {:href "/talks/new"} "Create A Talk"]]
      [:li [:a {:href "/users/sign_out" :data-method "delete" :rel "nofollow"} "Logout"]]]])])


(defn modals-comp [] ; --- mounted to #modals
  (cond
    (venue-in-state ["disconnect_required"])
    [:div.instruction-container [instructions-to-disconnect-comp]]

    (and (venue-in-state ["awaiting_stream"]) (:instructions @page-state))
    (let [device-name (:device-name @page-state)]
      (if-not (str/blank? device-name)
        [:div.instruction-container
         (condp = device-name
           "butt"    [instructions-for-butt-comp]
           "darkice" [instructions-for-darkice-comp]
           "generic" [instructions-for-generic-comp])]))))

(defn debug-sort-comp []
  [:ul {:style {:background-color "white"}}
   (doall (map (fn [x] ^{:key (:id x)} [:li (:title x) " " (:starts_at x)])
               (sort :starts_at (talks-by-state "prelive"))))])


(defn app-comp [] ; --- mounted to #app
  [:div {:id "page", :on-click close-menu-action}
   ;;[debug-audio-comp]
   ;;[debug-sort-comp]
   (if (venue-in-state ["connected"]) [audio-comp])
   [:div.clearfix.row {:id "venue-header"}
    [:div {:class "medium-9 columns"}
     [:h1 {:class "venue-title"} (venue-name)]
     [:p {:class "talk-title"}
      [active-talk-title-prefix-comp]
      [:a {:href (active-talk-url)} (active-talk-title)]]]
    [:div {:class "medium-3 columns dashboard"}
     [on-air-comp]
     (if (and (< 0 (listener-count))
              (active-talk-in-state ["live"]))
       [:div {:class "medium-float-right listeners"}
        [:p.listener-count (listener-count)]
        [:p.listener-label "listening now"]])]]
   ;;[:span {:class "listener-label"} "LISTENERS"]]]]
   [:div.row.clearfix.control-panels
    [:div {:id "venue-control-panel", :class "clearfix"}
     [:div {:class "medium-4 columns server-panel"}
      [titlebar-comp (t "streaming_server") (server-status)]
      [:div {:class "divider"}]
      [server-actionbar-comp]]
     [:div {:class "medium-4 columns device-panel"}
      [titlebar-comp (t "audio_source") (device-status)]
      [:div {:class "divider"}]
      [device-actionbar-comp]]
     [:div {:class "medium-4 columns talk-panel"}
      [titlebar-comp (t "broadcast") (talk-status)]
      [:div {:class "divider"}]
      [talk-actionbar-comp]]]]
   ;;[debug-comp]
   [talk-listing-comp "Upcoming Talks" ["live" "prelive"] [:starts_at <]]
   [talk-listing-comp "Previous Talks"
    ["postlive" "processing" "archived" "suspended"] [:starts_at >]]])

;; -------------------------
;; Initialize

(defn inc-now [state-map]
  (update-in state-map [:now] inc))

(defn start-timer []
  (let [intervalId (js/setInterval #(swap! state inc-now) 1000)]
    (swap! page-state assoc :intervalId intervalId)))

(defn venue-channel []
  (:channel (venue)))

(defn schedule-check-availability []
  (if (= (venue-state) "offline")
    (js/setTimeout request-availability-action (max 0 (time-to-available)))))

(defn setup-faye [callback]
  (print "Subscribe" (venue-channel))
  (let [subscription
        (.subscribe js/fayeClient (venue-channel)
                    #(venue-message-handler (js->clj %  :keywordize-keys true)))]
    (.then subscription callback)))

(defn mount-root []
  (reagent/render [topbar-comp] (.getElementById js/document "topbar"))
  (reagent/render [modals-comp] (.getElementById js/document "modals"))
  (reagent/render [app-comp] (.getElementById js/document "app")))

(defn init! []
  (start-timer)
  (setup-faye schedule-check-availability)
  (mount-root))
