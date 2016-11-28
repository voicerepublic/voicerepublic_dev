(ns vrng.venues.core
  (:require
   [vrng.util :as u :refer [t state to-millis track-event]]
   [vrng.sporktrum :as spork]
   [vrng.media :as media]
   ;;[vrng.venues.data :as data]
   ;;[vrng.venues.actions :as actions]
   ;;[vrng.venues.components :as components]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   [ajax.core :refer [PUT]]
   [clojure.string :as str]
   [reanimated.core :as anim]
   [cljsjs.selectize]
   goog.string.format
   goog.string
   ;;[cljs.core.async :refer [put! chan <! >! timeout close!]]
   )
  (:require-macros [cljs.core :refer [exists?]]
                   ;;[cljs.core.async.macros :refer [go go-loop]]
                   ))

;; State

(defonce page-state (atom {:messages []
                           :autostart false
                           :launched false
                           :instructions true
                           :dropdown-menu-open false
                           :talkbar-expanded false
                           :help-text-open false
                           :device-name (:device_name (:venue @state))
                           :stats {:listener_count 0}}))

(defonce user
  (atom (js->clj (.-user js/window) :keywordize-keys true)))

;; Generic Utils

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

(defn nbsp []
  (goog.string/unescapeEntities "&nbsp;"))

;; Page specific utils

(defn now [] (* 1000 (:now @state)))
(defn time-to [time] (- time (now)))

(defn user-image-url [] (:image_url @user))
(defn user-url [] (:url @user))

(defn venue [] (:venue @state))
(defn venue-slug [] (:slug (venue)))
(defn venue-url [] (str "/xhr/venues/" (venue-slug)))
(defn config-url [client] (str (venue-url) "/" client))
(defn venue-state [] (:state (venue)))
(defn venue-name [] (:name (venue)))
(defn available-at [] (:available_at (venue)))
(defn talks [] (:talks (venue)))
(defn new-talk-path [] (str "/talks/new?talk%5Bvenue_id%5D=" (:id (venue))))

(defn talks-by-state [talk-state]
  (filter #(= talk-state (:state %)) (:talks (venue))))

(defn next-talk []
  (if (empty? (talks-by-state "live"))
              (second (sort-by :starts_at (talks-by-state "prelive")))
      (first (sort-by :starts_at (talks-by-state "prelive")))))

(defn active-talk []
  (or (first (talks-by-state "live"))
      (first (sort-by :starts_at (talks-by-state "prelive")))))

(defn active-talk-title [] (:title (active-talk)))
(defn active-talk-url [] (:url (active-talk)))
(defn active-talk-state [] (:state (active-talk)))
(defn active-talk-speakers [] (:speakers (active-talk)))
(defn active-talk-runtime []
  (- (now) (to-millis (:started_at (active-talk)))))

(defn active-talk-duration []
  (* 60 1000 (:duration (active-talk))))

(defn time-to-active-talk []
  (- (to-millis (:starts_at (active-talk))) (now)))

(defn time-to-next-talk []
  (- (to-millis (:starts_at (next-talk))) (now)))


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

(defn icecast-url [] (:stream_url (venue)))
(defn venue-device-id [] (:device_id (venue)))
(defn venue-device-name [] (:device_name (venue)))

(defn venue-device-id-or-name []
  (or (venue-device-id) (venue-device-name)))

(defn user-owned-devices [] (:devices @state))

(defn listener-count []
  (:listener_count (:stats @page-state)))

(defn show-stop-warning? [] ;; if progress is < 85%
  (and (:over-stop-button @page-state)
       (< (active-talk-progress-percentage) 85)))

(defn talk-url [talk] (str "/xhr/talks/" (talk :id)))

;; TODO make variadic with &
(defn venue-in-state [venue-states]
  (some #(= (venue-state) %) venue-states))

(defn server-progress-percentage []
  (if (venue-in-state ["provisioning"])
    (u/percentage
     (time-since-provisioning-started)
     (venue-provisioning-duration))
    100))

(defn server-progress
  ([] (server-progress ""))
  ([suffix] (str (server-progress-percentage) suffix)))

(defn active-talk-in-state [active-talk-states]
  (some #(= (active-talk-state) %) active-talk-states))

(defn blog-url [page]
  (str "http://blog.voicerepublic.com/" page))

;; Select device

(defn try-select-device []
  (PUT (venue-url)
       {:format :json
        :params { :venue {:device_id (@page-state :device-id)
                          :event "select_device" }}}))

(defn start-select-device [device-id]
  (prn "start-select-device device-id" device-id)
  (swap! page-state assoc :device-id device-id)
  (try-select-device))

(defn device-selected []
  (prn "device selected!")
  (swap! page-state dissoc :device-id))

(defn selected-device []
  (first
   (filter #(= (venue-device-id) (:id %))
           (user-owned-devices))))

(defn device-display-name []
  (or (venue-device-name)
      (:name (selected-device))))

;; Messaging

(defn venue-message-handler [msg]
  (condp = (:event msg)
    "snapshot" (u/reset-state! (:snapshot msg))
    "stats" (swap! page-state assoc :stats (:stats msg))
    (prn "Unknown message" msg)))

;; Actions

(defn wizard-page-action [page]
  (swap! page-state assoc :wizard-page page))

(defn toggle-source-wizard-action []
  (println "show the wizzzz!")
  (swap! page-state update :show-source-wizard not)
  (swap! page-state assoc :wizard-page "start"))

(defn toggle-talkbar-action []
  (swap! page-state assoc :talkbar-expanded (not (@page-state :talkbar-expanded))))

(defn request-availability-action []
  (print "Request availability...")
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "become_available" }}}))

(defn start-server-action []
  (if (not (:launched @page-state))
    (do
      (prn "server launched")
      (track-event "server launch")
      (swap! page-state assoc :launched true)
      (PUT (venue-url)
           {:format :json
            :params { :venue { :event "start_provisioning" }}}))
    (prn "launched already, event debounced")))

(def valid-devices
  #{"butt" "darkice" "generic" "bcms" "coolmic" "icast2" "koalasan"})

(defn select-device-action [device-id-or-name]
  (let [numeric (re-matches #"^\d+$" (str device-id-or-name))
        device-id (if numeric device-id-or-name nil)
        device-name (if numeric nil device-id-or-name)]
    (track-event (str "device select " device-id-or-name))
    (if (= "pairing" device-name)
      ;; load /devices
      (aset js/window "location" "/devices")
      ;; else if device_id schedule periodic put until connected
      (if device-id
        (do
          (start-select-device device-id)
          (swap! page-state assoc :device-name (:name (selected-device)))
          (toggle-source-wizard-action))
        ;; else
        (do
          (wizard-page-action device-name)
          (when (contains? valid-devices device-name)
            (println "works")
            (swap! page-state assoc :device-name device-name)
            ;;(swap! page-state assoc :instructions true)
            (PUT (venue-url)
                 {:format :json
                  :params { :venue {:device_id nil
                                    :device_name device-name
                                    :event "select_device" }}})
            ;;(swap! page-state assoc :show-source-wizard false)
            ))))))

(defn hide-instructions-action []
  (track-event "instructions close")
  (swap! page-state assoc :instructions false)
  false)

(defn start-talk-action [talk]
  (track-event "talk start")
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "start_talk"}}})
  false)

(defn end-talk-action [talk]
  (track-event "talk end")
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "end_talk"}}})
  false)

(defn mouseover-stop-button-action []
  (swap! page-state assoc :over-stop-button true))

(defn mouseout-stop-button-action []
  (swap! page-state assoc :over-stop-button false))

(defn toggle-autostart-action []
  (swap! page-state assoc :autostart (not (:autostart @page-state))))

(defn launch-client-selector-action []
  (.log js/console "launch the selector"))

;; Components

;; NOTE maybe we should display an approx. audio delay. later we could
;; use the internal microphone to calculate the exact delay, if on
;; site. It could also be used to detect if on site.

(defn icon-comp [icon]
  [:svg {:dangerouslySetInnerHTML
         {:__html (str "<use xlink:href='#icon-" icon "' />")}}])

(defn countdown-comp [millis]
  [:span (format-countdown millis)])

(defn toggle-mute-action []
  (swap! page-state assoc :mute (not (@page-state :mute)))
  (media/volume! (if (@page-state :mute) 0 1)))

;; TODO phil: maybe refactor using a macro?
(defn debug-comp []
  [:table
   [:tr
    [:td "(device-display-name)"]
    [:td (device-display-name)]
    [:td]]
   [:tr
    [:td "(venue-device-name)"]
    [:td (venue-device-name)]
    [:td]]
   [:tr
    [:td "(:name (selected-device))"]
    [:td (:name (selected-device))]
    [:td]]
   ;;[:tr
   ;; [:td "(@page-state :device-id)"]
   ;; [:td (@page-state :device-id)]
   ;; [:td]]
   ;;[:tr
   ;; [:td "(to-millis (:starts_at (active-talk)))"]
   ;; [:td (to-millis (:starts_at (active-talk)))]
   ;; [:td]]
   ;;[:tr
   ;; [:td "(:starts_at (active-talk))"]
   ;; [:td (:starts_at (active-talk))]
   ;; [:td]]
   ;;[:tr
   ;; [:td "venue-state"]
   ;; [:td (venue-state)]
   ;; [:td]]
   ;;[:tr
   ;; [:td "now"]
   ;; [:td (now)]
   ;; [:td]]
   ;;[:tr
   ;; [:td "time-to-available"]
   ;; [:td (time-to-available)]
   ;; [:td (format-countdown (time-to-available))]]
   ;;[:tr
   ;; [:td "time-to-active-talk"]
   ;; [:td (time-to-active-talk)]
   ;; [:td (format-countdown (time-to-active-talk))]]
   ;;[:tr
   ;; [:td "time-since-provisioning-completed"]
   ;; [:td (time-since-provisioning-completed)]
   ;; [:td (format-countdown (time-since-provisioning-completed))]]
   ;;[:tr
   ;; [:td "active-talk-runtime"]
   ;; [:td (active-talk-runtime)]
   ;; [:td (format-countdown (active-talk-runtime))]]
   ;;[:tr
   ;; [:td "active-talk-state"]
   ;; [:td (active-talk-state)]
   ;; [:td]]
   ;;[:tr
   ;; [:td "active-talk-duration"]
   ;; [:td (active-talk-duration)]
   ;; [:td (format-countdown (active-talk-duration))]]
   ;;[:tr
   ;; [:td "active-talk-progress"]
   ;; [:td (goog.string.format "%.3f" (active-talk-progress))]
   ;; [:td]]
   ;;[:tr
   ;; [:td "time-since-provisioning-started"]
   ;; [:td (time-since-provisioning-started)]
   ;; [:td (format-countdown (time-since-provisioning-started))]]
   ;;[:tr
   ;; [:td "venue-provisioning-duration"]
   ;; [:td (venue-provisioning-duration)]
   ;; [:td (format-countdown (venue-provisioning-duration))]]
   ;;[:tr
   ;; [:td "server-progress"]
   ;; [:td (goog.string.format "%.3f" (server-progress))]
   ;; [:td]]
   ])

(defn help-link-comp
  ([page] [help-link-comp page "Need help?"])
  ([page text] [:a.help-link {:target "_blank" :href (blog-url page)} text]))

(defn generic-help-link-comp [link text]
  [:a {:target "_blank" :href link} text])

(defn instructions-for-butt-comp
  "Component that displays instructions for B.U.T.T."
  []
  [:div
   [:h4 "Streaming with B.U.T.T."]
   [:div.row.clearfix
    [:div.medium-6.medium-offset-3.columns
     [:p "Simply download the config file below and import it into B.U.T.T. by clicking \"Settings\" > \"Import\" inside the B.U.T.T. application, and push \"Play.\""]
     [help-link-comp "support/streaming-with-butt-mac-win-linux/?lang=en"]]]
   [:p.clearfix
    ;; NOTE target blank as a workaround for
    ;; https://bugzilla.mozilla.org/show_bug.cgi?id=712329
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href (config-url "butt")
      :target "_blank"}
     [icon-comp "download"] "download config file"]]])

(defn instructions-for-darkice-comp []
  [:div
   [:h4 "Streaming with darkice"]
   [:p.lead "Download the config file below and run with..."]
   [:code "sudo darkice -c <your-config-file>"]
   [:p.lead "Note: root permissions are required to use posix realtime scheduling."]
   [:p.clearfix
    ;; target blank, see above
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:on-click hide-instructions-action
      :target "_blank"}
     [icon-comp "download"] "download config file"]]])

(defn instructions-for-generic-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming with a Generic Icecast Client"]
   [:p "Use these settings with your Icecast application..."]
   [:table
    [:tr [:td "Host/Server"] [:td (:public_ip_address (venue))]]
    [:tr [:td "Port"] [:td (:port (venue))]]
    [:tr [:td "User"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]
    [:tr [:td "Mountpoint"] [:td (:mount_point (venue))]]]])

(defn instructions-for-bcms-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from Android with BroadcastMyself"]
   [:table
    [:tr [:td "Hostname"] [:td (:public_ip_address (venue))]]
    [:tr [:td "Port"] [:td (:port (venue))]]
    [:tr [:td "Path"] [:td (str "/" (:mount_point (venue)))]]
    [:tr [:td "Username"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]]
   [help-link-comp "support/streaming-with-broadcastmyself-android/?lang=en"]
   [:p.text-center
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href "#" :on-click hide-instructions-action} "Cancel"]]])

(defn instructions-for-koalasan-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from iOS with KoalaSAN"]
   [:table
    [:tr [:td "Server"] [:td (:public_ip_address (venue))]]
    [:tr [:td "Port"] [:td (:port (venue))]]
    [:tr [:td "Mointpoint"] [:td (:mount_point (venue))]]
    [:tr [:td "Username"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]]
   [help-link-comp "support/streaming-with-koalasan-ios/?lang=en"]
   [:p.text-center
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href "#" :on-click hide-instructions-action} "Cancel"]]])

(defn instructions-for-icast2-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from iOS with iCast 2"]
   [:table
    [:tr [:td "Host"] [:td (:public_ip_address (venue))]]
    [:tr [:td "Port"] [:td (:port (venue))]]
    [:tr [:td "Mount"] [:td (str "/" (:mount_point (venue)))]]
    [:tr [:td "Username"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]]
   [help-link-comp "support/streaming-with-icast-2-ios/?lang=en"]
   [:p.text-center
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href "#" :on-click hide-instructions-action} "Cancel"]]])

(defn instructions-for-coolmic-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from Android with CoolMic"]
   [:table
    [:tr [:td "Server"] [:td (str (:public_ip_address (venue)) ":" (:port (venue)))]]
    [:tr [:td "Username"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]
    [:tr [:td "Mountpoint"] [:td (str "/" (:mount_point (venue)))]]]
   [help-link-comp "support/streaming-with-coolmic-android/?lang=en"]
   [:p.text-center
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href "#" :on-click hide-instructions-action} "Cancel"]]])

(defn instructions-to-disconnect-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Alert"]
   (if (venue-device-id)
     [:p "Waiting for disconnect, please stand by..."]
     [:p "Please disconnect your streaming client by stopping the broadcast on your device..."])])

(defn talk-list [talk-states sort-options]
  (doall (mapcat #(apply sort-by (conj sort-options (talks-by-state %))) talk-states)))

;; more actions

(defn close-menu-action []
  (swap! page-state assoc :dropdown-menu-open false))

(defn open-menu-action []
  (swap! page-state assoc :dropdown-menu-open (not (:dropdown-menu-open @page-state)))
  false)

(defn toggle-help-text-action []
  (swap! page-state assoc :help-text-open (not (@page-state :help-text-open))))

;; more components

(defn debug-sort-comp []
  [:ul {:style {:background-color "white"}}
   (doall (map (fn [x] ^{:key (:id x)} [:li (:title x) " " (:starts_at x)])
               (sort :starts_at (talks-by-state "prelive"))))])

;;(defn listener-count-comp []
;;  (if (and (< 0 (listener-count))
;;           (active-talk-in-state ["live"]))
;;    [:div {:class "medium-float-right listeners"}
;;     [:p.listener-count (listener-count)]
;;     [:p.listener-label "listening now"]]))

;;(defn reconnect-action []
;;  (PUT (venue-url)
;;       {:format :json
;;        :params { :venue {:event "require_disconnect" }}}))
;;
;;(defn device-control-comp []
;;  (if (@page-state :device-id)
;;    [:div#spinner.float-right [icon-comp "loading"]]
;;    [:button#reconnect.float-right.icon-button.large {:on-click reconnect-action} [icon-comp "reload"]]))

(defn autostart-notice-comp []
  [:div.autostart-warning "Please don't leave! For the autostart feature to work, you need to keep this page open."])

;; New Stuff Stage 2

(defn mute-comp []
  (if (venue-in-state ["connected"])
    [:button.tiny.button.btn-gray.btn-hover-green.hollow.float-right
     {:on-click toggle-mute-action}
     "sound"
     (if (@page-state :mute)
       [icon-comp "sound_off"]
       [icon-comp "sound_on"])]))

(defn dropdown-menu-comp []
  (if (:dropdown-menu-open @page-state)
    [:div#mobile-nav
     [:ul.menu.vertical
      [:li [:a {:href "/"} "Home"]]
      [:li [:a {:href (user-url)} "My Profile"]]
      [:li [:a {:href "/talks/new"} "Create A Talk"]]
      [:li [:a {:href "/users/sign_out"
                :data-method "delete"
                :rel "nofollow"}
            "Logout"]]]]))

(defn navbar-comp []
  [:div#navbar.row.expanded {:on-click close-menu-action
                             :class
                             (if (@page-state :nopush) "nopush")}
   [:div#back-arrow.small-2.medium-3.columns
    [:a
     {:href "/venues"}
     [icon-comp "grid"]
     [:span.show-for-medium "STAGES"]]]
   [:div#titlebar.small-8.medium-6.columns.text-center
    [:div#venue-title (venue-name)]]
   [:div#dropdown.small-2.medium-3.columns.text-right
    [:a.avatar.float-right
     {:href "#"
      :on-click open-menu-action
      :style {:background (str "url(" (user-image-url) ")")}}]
    [:div#help-link [:a.float-right.button
                     {:href "#"
                      :on-click toggle-help-text-action }
                     "?"]]]])

(defn talk-item-comp [talk]
  ^{:key (:id talk)}
  [:div.small-12.columns.talkitem.clearfix
   [:p.clearfix
    [:span.title.float-left.text-left [:a {:href "#"} (:title talk)]]
    [:span.time.float-left.text-left (:starts_at_time talk)]
    [:span.series.float-left.text-left
     [:a {:href (:url (:series talk))} (:title (:series talk))]]
    [:span.duration.float-left.text-right (:duration talk)]]])

(defn talkbar-comp
  "the current/next and the dropdown with all scheduled and past talks" []
  [:div#talkbar
   {:style {:height (if (@page-state :talkbar-expanded) "auto" "36px")}}
   ;;current
   [:div#current
    [:p#current-talk-title
     [:span.next-talk "Now: "]
     [:a {:href (:url (active-talk))} (:title (active-talk))]
     [:span.listener-info {:title "listeners"}
      [icon-comp "headphones"] " "
      (listener-count)]
     [:span.float-right.time-info (format-countdown (time-to-active-talk))]
     ]]
     (if (next-talk)
   [:div#next
                [:span.next-talk "Next: "]
                [:a {:href (:url (next-talk))} (:title (next-talk))]
                [:span.float-right.time-info (format-countdown (time-to-next-talk))]]
                          ;;)
       [:div#next
        [:a {:href "/talks/new"} "+ Create a Talk"]])

   ;;dropdown
   [:div#list-toggle
    [:a.float-left.hide-for-small-only
     {:href "#" :on-click toggle-talkbar-action}
     [:span.show-for-medium.float-left "ALL TALKS"]
     [icon-comp "list"]]
    [:a.see-all.show-for-small-only.text-center "view all"]]
   [:div#listrow.row.clearfix
    ;; TODO for each DAY of schedule, one of these blocks:
    [:div.small-12.columns.dayitem.clearfix [:p [:span "TODAY"]]]
    [:div.small-12.columns.headeritem.clearfix
     [:p
      [:span "TITLE"]
      [:span "TIME"]
      [:span "SERIES"]
      [:span.text-right "DURATION"]]]
    ;; TODO for each talk in the day, one of these:
    (doall (map talk-item-comp (talk-list ["live" "prelive"] [:starts_at <])))]])

;; SVG Components

(def green "#60BD70")
(def lightblue "#54c6c6")
(def red "#f82847")
(def gray "rgba(53, 54, 59, 0.1)")

(defn server-ring-color []
  (cond
    (venue-in-state ["available" "offline"]) gray
    (venue-in-state ["provisioning"]) lightblue
    :else green))

(defn source-ring-color []
  (cond
    (venue-in-state ["awaiting_stream" "disconnected"]) lightblue
    (venue-in-state ["connected" "disconnect_required"]) green
    ;;(venue-in-state ["disconnected"]) red
    :else gray))

(defn source-ring-offset []
  (cond
    (venue-in-state ["awaiting_stream"]) "500"
    :else "0"))

(defn server-ring-dasharray [percentage radius]
  (let [circumference (* 2 radius Math/PI)
        current (* percentage (/ circumference 100))]
    (if (js/isNaN percentage)
      (str "0" " " circumference)
      (str current " " (- circumference current)))))

(defn source-ring-dasharray []
  (if (venue-in-state ["awaiting_stream" "disconnected"]) "4 6" "0"))

(defn server-base-ring-comp
  "Gray outer ring."
  []
  [:circle.base
   {:r "125"
    :stroke-width "10"
    :fill "none"
    :cy "50%"
    :cx "50%"}])

(defn server-overlay-ring-comp
  "Displays the server launching progress."
  []
  [:circle.overlay
   {:data-svg-origin "130 130"
    :stroke-dasharray (server-ring-dasharray (server-progress-percentage) 125)
    :stroke-dashoffset "100"
    :transform "matrix(0, -1, 1, 0, 0, 260)"
    :stroke (server-ring-color)
    :r "125"
    :stroke-width "10"
    :fill "none"
    :cy "50%"
    :cx "50%"}])

;; TODO replace animation of dasharray offset with translating to spin
(defn source-base-ring-comp
  "Gray middle ring."
  []
  (let [offset (atom 0)
        rotation (anim/interpolate-to offset)]
    (fn []
      [:circle.base
       {:r "110"
        :stroke-width "10"
        :stroke (source-ring-color)
        :stroke-dasharray (source-ring-dasharray)
        :fill "none"
        :cy "50%"
        :cx "50%"
        :style {:strokeDashoffset @rotation}}
       [anim/interval (fn [] (swap! offset #(- % 10))) 200]])))

(defn- source-audio-meter-radius
  "min is 20, max is 130"
  []
  (+ 20 (* (/ (:volume @spork/audio) 255) 110)))

(defn- source-audio-meter-opacity
  "min is 0 max is 0.95"
  []
  (* (/ (:volume @spork/audio) 255) 0.95))

(defn source-audio-meter-comp
  "Audio meter that pulsates based on the audio signal."
  []
  [:circle
   {:r (source-audio-meter-radius)
    :opacity (source-audio-meter-opacity)
    :fill green
    :cy "50%"
    :cx "50%"}])

(defn stream-base-ring-comp
  "Gray inner ring."
  []
  [:circle.base
   {:r "95"
    :stroke gray
    :stroke-width "10"
    :fill "none"
    :cy "50%"
    :cx "50%"}])

(defn stream-overlay-ring-comp
  "Indicates the progress of the talk."
  []
  [:circle.overlay
   {:data-svg-origin "130 130"
    :r "95"
    :stroke-width "10"
    :stroke "black"
    :opacity .3
    :stroke-dasharray (server-ring-dasharray (active-talk-progress-percentage) 95)
    :style {:stroke-dashoffset 150} ; workaround for react missing attribute
    :fill "none"
    :cy "50%"
    :cx "50%"}])

(defn server-launch-button-comp []
  [:g {:on-click start-server-action}
   [:circle#circleButton.button
    {:r "80" :fill "#60BD70" :cy "50%" :cx "50%"}]
   [:text#buttonText
    {:fill "#fff"
     :text-anchor "middle"
     :y "133"
     :height "12"
     :x "50%"}
    "launch this"]])

(defn select-source-button-comp []
  [:g {:on-click launch-client-selector-action}
   [:circle#circleButton.button
    {:r "80" :fill "#60BD70" :cy "50%" :cx "50%"}]
   [:text#buttonText
    {:fill "#54c6c6"
     :text-anchor "middle"
     :y "133"
     :height "12"
     :x "50%"}
    "launch this"]])

(defn start-talk-button-comp []
  [:g {:on-click #(start-talk-action (active-talk))}
   [:circle#circleButton.button
    {:r "80" :fill "#60BD70" :cy "50%" :cx "50%"}]
   [:text#buttonText
    {:fill "#54c6c6"
     :text-anchor "middle"
     :y "133"
     :height "12"
     :x "50%"}
    "start streaming"]])

(defn end-talk-button-comp []
  [:g {:on-click #(end-talk-action (active-talk))
       :style {:cursor "pointer"}}
   [:rect {:rx 2
           :ry 2
           :width 15
           :height 15
           :x (- (/ 260 2) 7.5)
           :y (+ (/ 260 2) 30)
           :fill red}]
   [:text {:x "50%"
           :y (+ (/ 260 2) 60)
           :height 12
           :text-anchor "middle"
           :fill red}
    "stop streaming"]])


;; GUI labels

(defn gui-labels-comp []
  [:g#ui-labels
   [:line
    {:stroke-width ".5" :stroke "#666" :y2 "10" :x2 "35" :y1 "31.8" :x1 "56.8"}]
   [:line
    {:stroke-width ".5" :stroke "#666" :y2 "24.5" :x2 "35.5" :y1 "46.6" :x1 "57.6"}]
   [:line
    {:stroke-width ".5" :stroke "#666" :y2 "38.9" :x2 "35.5" :y1 "64.6" :x1 "61.1"}]
   [:text#server-label
    {:fill "#666" :font-size "8" :text-anchor "left" :y "10" :height "12" :x "1"}
    "server"]
   [:text#source-label
    {:fill "#666" :font-size "8" :text-anchor "left" :y "25" :height "12" :x "1"}
    "source"]
   [:text#stream-label
    {:fill "#666" :font-size "8" :text-anchor "left" :y "40" :height "12" :x "1"}
    "stream"]])

;; The SVG

(defn circles-comp []
  [:div#circles
   [:svg {:viewBox "0 0 260 260"}
    [source-audio-meter-comp]
    [server-base-ring-comp]
    [server-overlay-ring-comp]
    [source-base-ring-comp]
    ;; [source-overlay-ring-comp]
    [stream-base-ring-comp]

    ;;show the button if it's available
    (if (venue-in-state ["available"])
      [server-launch-button-comp])

    (if (and (venue-in-state ["connected"])
             (active-talk-in-state ["prelive"]))
      [start-talk-button-comp])

    (when (active-talk-in-state ["live"])
      [stream-overlay-ring-comp]
      [end-talk-button-comp])
    [gui-labels-comp]]])

(defn speaker-comp [speaker]
  ^{:key speaker}
  [:li.clearfix
   [:span.float-left
    [icon-comp "person"]]
   [:span.speaker-name speaker]])

(defn speakers-comp []
  [:div#speakers.medium-10.columns.medium-offset-1.end
   [:h4.section-title.text-center "Speakers"]
   [:ul.menu.vertical.text-center
    (doall (map speaker-comp (active-talk-speakers)))]])

;; TODO move this into sections somehow
(defn help-comp []
  (if (:help-text-open @page-state)
    [:div#helpbar.row.clearfix
     [:div#helptext.row

      [:h3 "The Stage Control Panel"]
      [:p
       "Welcome to the Stage Control Panel of your stage "
       [:stage
        {:name "name"}
        ". You can control all live streams happening at \n"
        [:stage
         {:name "name"}
         " here. Any questions? Check out the support section (http://blog.voicerepublic.com/support/?lang=en)."]]]
      [:h4 "Your Talk Line-Up"]
      [:p
       "On the top of the page you can see which talk you are currently streaming and which talk is coming up next. Click on “VIEW ALL TALKS” to see your complete line-up for this stage."]
      [:h4 "Speakers"]
      [:p
       "If you added speakers to a talk, they will be displayed below the control rings. You can click on a speaker’s name to let your listeners know that this person is currently talking."]
      [:h4 "How to start a Live Stream\n"]
      [:h5 "The Streaming Server"]
      [:p
       "On Voice Republic, every stage has its own streaming server. Start connecting to the streaming server by clicking the green button."]
      [:h5 "The Streaming Source"]
      [:p
       "Voice Republic offers multiple ways to conduct audio live streams. You can stream using one or several Voice Republic StreamBoxxes, your laptop or your mobile phone. Choose your streaming source by clicking the green button. If you want to choose another streaming source, just click again on the circle named Streaming Source. \n"]
      [:p
       "Check out how to stream with the StreamBoxx: "
       [:a
        {:target "_blank",
         :href
         "http://blog.voicerepublic.com/support/live-streaming-with-the-voice-republic-streamboxx/?lang=en"}
        "http://blog.voicerepublic.com/support/live-streaming-with-the-voice-republic-streamboxx/?lang=en"]]
      [:p
       "Check out how to stream with your Laptop: "
       [:a
        {:target "_blank",
         :href
         "http://blog.voicerepublic.com/support/streaming-with-butt-mac-win-linux/?lang=en"}
        "http://blog.voicerepublic.com/support/streaming-with-butt-mac-win-linux/?lang=en"]]
      [:p
       "Check out how to stream with your Mobile Phone: \n"
       [:a
        {:target "_blank",
         :href
         "http://blog.voicerepublic.com/support/streaming-with-android-phone/?lang=en"}
        "http://blog.voicerepublic.com/support/streaming-with-android-phone/?lang=en"]
       " "]
      [:h5 "Start Live Stream"]
      [:p
       "Click on the button “Start Live Stream” to broadcast your talk. "]
      [:h5 "Autostart"]
      [:p
       "The Autostart feature takes care of starting the live stream for you. Please be aware that you still have to end the talk. For the autostart feature to work, you need to keep the Stage Control Panel of this stage open.\n"]
      [:h5 "Stop the Live Stream"]
      [:p
       "To stop your live stream, simply click on “Stop Live Stream”. Your talk will automatically be stored in the Voice Republic Archive. You can now choose the next talk on this stage. You don’t have to connect to the Streaming Server and Streaming Source again. Simply click on “Start Live Stream”."]
      [:h4 "Messaging Board"]
      [:p
       "On the Messaging Board you see all updates concerning your live stream. You will be informed whether the server and your streaming source are connected and if any troubles with the audio signal or the internet occur. You can enter messages yourself.
    These are published in the comment section of the talk page. That way you can interact with your listeners."]

      [:a {:href "#" :on-click toggle-help-text-action }[:button#close-help [:span "×"]]]]]))

(defn device-comp []
  [:button.tiny.button.btn-gray.btn-hover-green.hollow.device-button
   {:on-click toggle-source-wizard-action}
   [icon-comp "headphones"]
   (device-display-name)])

(defn toggles-comp []
  [:div#toggles.clearfix
   [:button.tiny.button.btn-gray.btn-hover-green.hollow.float-left {:class (if (:autostsart @page-state) "active" "") :on-click toggle-autostart-action}
    [icon-comp "bolt"]
    "autostart"]
   [device-comp]
   [mute-comp]])

(defn new-modals-comp []
  [:div#main-modal
   [:div#modal-box
    [:p.lead
     "Hi, Nick! Welcome to your Stage Control Panel. Here's where you can control the live-streaming of the lineup for the whole stage."]
    [:p.text-right.buttons
     [:button.cancel.button.hollow.hide.btn-red.btn-hover-red
      "Cancel"]
     [:button.yes.button.hollow.btn-green.btn-hover-green "OK"]]]])

(defn messages []
  (sort-by :time (:messages @page-state)))

(defn add-server-message
  "Adds a message to the message queue which is displayed in the chat
  window."
  [text]
  (swap! page-state update :messages conj
         {:time (.format (js/moment) "x") :text text}))

(defn server-message-comp [message]
  ^{:key (:time message)}
  [:div.row.message-row
   [:div.message-losenge.left.float-left
    [:span.message-text (:text message)]
    [:span.message-time (.format (js/moment (:time message) "x") "H:mm")]]])

(defn message-container-comp []
  [:div#message-container.medium-4.columns.float-right
   ;;[debug-comp]
   [:h4.section-title.text-center "Messages"]
   (doall (map server-message-comp (messages)))])

;;logo test
(defn logo-component []
  (let [tilt (reagent/atom 0)
        rotation (anim/spring tilt)
        flip (reagent/atom 90)
        scale (anim/spring flip)
        size (reagent/atom 0)
        width (anim/spring size)]
    (fn a-logo-component []
      [:div
       [anim/timeout #(reset! size 300) 1000]
       ;;[anim/interval #(swap! flip -) 10000]
       [:img
        {:src "img/monster_zombie_hand-512.png"
         :width (str @width "px")
         :style (zipmap [:-ms-transform
                         :-moz-transform
                         :-webkit-transform
                         :transform]
                        (repeat (str "rotate(" @rotation "deg) rotateY(" (+ 90 @scale) "deg)")))
         :on-mouse-over (fn logo-mouseover [e]
                          (reset! tilt 15))
         :on-mouse-out (fn logo-mouseout [e]
                         (reset! tilt 0))}]])))


(defn ease-in-out-quart
  "Easing function.

   Math.easeInOutQuart = function (t, b, c, d) {
     t /= d/2;
     if (t < 1) return c/2*t*t*t*t + b;
     t -= 2;
     return -c/2 * (t*t*t*t - 2) + b;
   };"
  [a b duration t]
  (cond
    (<= t 0) a
    (>= t duration) b
    :else
    (let [in-out (/ t (/ duration 2))]
      (if (< in-out 1)
        (+ b (* (Math/pow t 4) (/ (- b a) 2))) ; in
        (+ (* (/ (* (- b a) -1) 2) (- (Math/pow (- in-out 2) 4) 2)) a))))) ; out

(defn device-option-comp
  "Displays a button inside the wizard."
  [page icon label delay &{:keys [custom-class] :or {custom-class ""}}]
  
  (let [offset-y (reagent/atom 50)
       drift (anim/interpolate-to offset-y {:easing ease-in-out-quart
                                            :duration 1500})
       opacity (reagent/atom 0)
       fade (anim/interpolate-to opacity {:duration 1500})]
  ; (prn page icon label delay custom-class)
  (fn [page icon label delay &{:keys [custom-class] :or {custom-class ""}}]
  
    [:li {:class custom-class
            :on-click (fn []
                        (select-device-action page))
            :style {:opacity @fade
                    :margin-top @drift}
            :key page}
      [anim/timeout (fn []
                      (reset! opacity 1)
                      (reset! offset-y 0)) delay]
       [:div.itemwrapper
        [icon-comp icon]
        [:br]
        label]])))

(defn wizard-page-start-comp []
  [:div#screen1
   [:h3 "How will you stream?"]
   [:ul.menu.vertical.medium-horizontal.text-center
    [device-option-comp "box" "box" "StreamBoxx" 0]
    [device-option-comp "laptop" "laptop" "Laptop" 200]
    [device-option-comp "mobile" "mobile" "Mobile" 400]]])

(defn wizard-page-box-comp []
  [:div
   [:h3 "Which StreamBoxx?"]
   [:ul.menu.vertical.medium-horizontal.text-center
    (doall (map (fn [x] [device-option-comp (:id x) "box" (:name x) 200]) (user-owned-devices)))
    ;;[device-option-comp "pairing" "box" "New Box" 400 :custom-class "new-box"]
    ]])

(defn wizard-page-laptop-comp []
  [:div
   [:h3 "Which Software Will You Use?"]
   [:ul.menu.vertical.medium-horizontal.text-center
    [device-option-comp "butt" "laptop" "B.U.T.T." 0]
    [device-option-comp "darkice" "laptop" "Darkice" 200]
    [device-option-comp "generic" "laptop" "Another IceCast Client..." 400]]])

(defn wizard-page-mobile-comp []
  [:div
   [:h3 "Which Mobile App Will You Use?"]
   [:ul.menu.vertical.medium-horizontal.text-center
    [device-option-comp "bcms" "android" "Broadcast Myself" 0]
    [device-option-comp "coolmic" "android" "CoolMic" 200]
    [device-option-comp "koalasan" "apple" "KoalaSAN" 400]
    [device-option-comp "icast2" "apple" "iCast2" 600]]])

(defn devices-wizard-comp
  "Main wizard component."
  []
  (let [opacity (reagent/atom .2)
        fade (anim/interpolate-to opacity {:duration 200})]
    (fn a-wizard-component []
      (reset! opacity 1)
      [:div#devices-wizard {:style {:opacity @fade}
                            :class (:wizard-page @page-state)}
       [:div.back-close.clearfix
        [:div.float-left.back-btn {:on-click #(wizard-page-action "start")}
         [icon-comp "arrow-left"]]
        [:div.float-right.close-btn {:on-click toggle-source-wizard-action} "×"]]
       (prn "wizard page -> " (:wizard-page @page-state))
       (condp = (:wizard-page @page-state)
         nil [wizard-page-start-comp]
         "start" [wizard-page-start-comp]
         ;; streamboxx
         "box" [wizard-page-box-comp]
         ;; laptop (desktop)
         "laptop" [wizard-page-laptop-comp]
         "butt" [instructions-for-butt-comp]
         "darkice" [instructions-for-darkice-comp]
         "generic" [instructions-for-generic-comp]
         ;; mobile
         "mobile" [wizard-page-mobile-comp]
         "bcms" [instructions-for-bcms-comp]
         "coolmic" [instructions-for-coolmic-comp]
         "koalasan" [instructions-for-koalasan-comp]
         "icast2" [instructions-for-icast2-comp] )])))

(defn instructions-comp []
  [:div#devices-wizard
   [:div.back-close.clearfix
    [:div.float-right.close-btn {:on-click toggle-source-wizard-action} "×"]]
   (condp = (:wizard-page @page-state)
     "start" [wizard-page-start-comp]
     "box" [wizard-page-box-comp]
     "laptop" [wizard-page-laptop-comp]
     "mobile" [wizard-page-mobile-comp])])

(defn chat-input-comp []
  [:form#chat-form
   [:div#chat-input.clearfix
    [:div#chat-icon.float-left
     [icon-comp "chat"]]
    [:div#chat-input-field.float-left
     [:label
      [:input {:placeholder "" :type "text"}]
      [:input#hidden-input {:placeholder "" :type "hidden"}]]]
    [:div#chat-send.float-right
     [icon-comp "airplane"]]]])

(defn stage-comp []
  [:div
   [navbar-comp]
   [dropdown-menu-comp]
   [talkbar-comp]
   [:div#ui.row.clearfix.expanded
    [:div#left-side.medium-8.columns.no-pad.text-center ; left
     [toggles-comp]
     [circles-comp]
     (if (:active-talk-speakers @page-state)
       [speakers-comp])]
    [message-container-comp] ; right
    ;;[chat-input-comp]
    ]
   [help-comp]
   (if (:show-source-wizard @page-state) [devices-wizard-comp])])

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
  (reagent/render [stage-comp] (.getElementById js/document "app")))

(defn init! []
  (start-timer)
  (if (.-fayeClient js/window)
    (setup-faye schedule-check-availability)
    (swap! page-state assoc :nopush true))
  (mount-root)
  (when (= (venue-state) "connected")
    ;; subscribe to audio & setup audio meter
    (media/source! (icecast-url))
    (js/setTimeout #(spork/setup-analyser-for-media-element "audio") 500))
  (when (= (venue-state) "awaiting_stream")
    (toggle-source-wizard-action)
    (wizard-page-action (venue-device-name))))

(add-watch
 state :now-connected
 (fn [key at0m old new]
   (when (and (not= (get-in old [:venue :state]) "connected")
              (= (get-in new [:venue :state]) "connected"))
     ;; cancels retries
     (device-selected)
     ;; subscribe to audio & setup audio meter
     (media/source! (icecast-url))
     (js/setTimeout #(spork/setup-analyser-for-media-element "audio") 500)
     )))

(add-watch
 state :change-state
 (fn [key at0m old new]
   (let [old-state (get-in old [:venue :state])
         new-state (get-in new [:venue :state])]
     (if (not= old-state new-state)
       (case [old-state new-state]

         ["offline" "available"]
         (add-server-message
          "Your streaming server is ready to be launched.")

         ["available" "provisioning"]
         (add-server-message
          "Your streaming server is launching...")

         (prn [old-state new-state])
         )))))

;; Autostart

;;(defonce autostart (atom {:active true
;;                          :stimuli 0
;;                          :required-stimuli 45
;;                          :required-volume 50}))

(add-watch
 state :autostart-countdown
 (fn [key an-atom old-state new-state]
   ;;(swap! autostart assoc :countdown (time-to-active-talk))
   (if (and (:autostart @page-state) (= 0 (time-to-active-talk)))
     (start-talk-action (active-talk)))
   ;;(prn @autostart)
   ))

;; (defn average [numbers]
;;   (/ (reduce + numbers) (count numbers)))
;;
;; (add-watch spork/audio :autostart-volume
;;            (fn [key an-atom old-state new-state]
;;              (if (:active @autostart)
;;                (let [mags (map #(:mag %) (:freq-mags @an-atom))
;;                      avg (average mags)
;;                      stimuli (:stimuli @autostart)
;;                      stimuli-modifier (if (> avg (:required-volume @autostart))
;;                                         inc dec) ; threshold volume
;;                      new-stimuli (max 0 (stimuli-modifier stimuli))]
;;
;;                  (swap! autostart assoc :volume avg)
;;                  (swap! autostart assoc :stimuli new-stimuli)
;;
;;                  (if (>= new-stimuli (:required-stimuli @autostart)) ; threshold sample count
;;                    (do
;;                      (swap! autostart assoc :active false)
;;                      ;;(start-talk-action (active-talk))
;;                      ;;(prn "AUTOSTART!")
;;                      ))
;;                  ))))
;;
;; (defn autostart-progress
;;   ([] (autostart-progress ""))
;;   ([suffix] (str (u/percentage (:stimuli @autostart)
;;                                (:required-stimuli @autostart)) suffix)))
;;
;; (defn autostart-comp []
;;   [:div
;;
;;    ;;"Volume"
;;    ;;[:input {:name "volume-threshold"
;;    ;;         :type "number"
;;    ;;         :value (:required-volume @autostart)
;;    ;;         :on-click #(swap! autostart assoc :required-volume %)}]
;;    ;;"Sample Count"
;;    ;;[:input {:name "sample-count-threshold"
;;    ;;         :type "number"
;;    ;;         :value (:required-stimuli @autostart)
;;    ;;         :on-click #(swap! autostart assoc :required-stimuli %)}]
;;
;;    [:div {:class "secondary progress server-progress", :role "progressbar",
;;           :tab-index "0", :aria-valuenow (autostart-progress), :aria-valuemin "0",
;;           :aria-valuetext (autostart-progress " percent"), :aria-valuemax "100"}
;;     [:div {:class "progress-meter", :style { :width (autostart-progress "%") }}
;;      [:p {:class "progress-meter-text" :style {:color (if (:active @autostart) "lightgray" "lime")}} "AUTOSTART" ]]]])
;;
;;   ;;[:div {:class "label" :style {:width "120px"
;;   ;;                              :border-color "lime"
;;   ;;                              :color "lime"
;;   ;;                              :margin-right "20px"}} "AUTOSTART"])
