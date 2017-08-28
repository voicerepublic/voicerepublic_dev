(ns vrng.venues.core
  (:require
   [vrng.venues.state :as state :refer [user page-state]]
   [vrng.util :as u :refer [t state to-millis track-event]]
   [vrng.sporktrum :as spork]
   [vrng.media :as media]
   [vrng.helpers :refer [icon]]
   [vrng.venues.talkbar :as tb :refer [talkbar-comp]]
   [vrng.venues.helpers :as helpers :refer [active-talk onair? next-talk venue format-countdown active-talk-runtime time-to-active-talk new-talk-path talks-by-state now active-talk-in-state]]
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   [ajax.core :refer [PUT]]
   [clojure.string :as str]
   [reanimated.core :as anim]
   [cljsjs.selectize]
   [cljsjs.moment]
   goog.string.format
   goog.string
   ;;[cljs.core.async :refer [put! chan <! >! timeout close!]]
   )
  (:require-macros [cljs.core :refer [exists?]]
                   ;;[cljs.core.async.macros :refer [go go-loop]]
                   ))

(if js/audit (.log js/console "loading vrng.venues.core"))

;; Page specific utils

(defn time-to [time] (- time (now)))

(defn user-image-url [] (:image_url @user))
(defn user-url [] (:url @user))

(defn venue-slug [] (:slug (venue)))
(defn venue-url [] (str "/xhr/venues/" (venue-slug)))
(defn config-url [client] (str (venue-url) "/" client))
(defn venue-state [] (:state (venue)))
(defn venue-name [] (:name (venue)))
(defn available-at [] (:available_at (venue)))
(defn talks [] (:talks (venue)))
(defn new-test-talk-path [] (str (new-talk-path) "&talk%5Bdryrun%5D=true"))

(defn active-talk-title [] (:title (active-talk)))
(defn active-talk-url [] (:url (active-talk)))
(defn active-talk-speakers [] (:speakers (active-talk)))

(defn active-talk-duration []
  (* 60 1000 (:duration (active-talk))))

(defn time-to-available
  "Returns the time until the server is available in milliseconds."
  []
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

;; sort by name
(defn user-owned-devices [] (sort-by :name (:devices @state)))

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

(defn blog-url [page]
  (str "http://blog.voicerepublic.com/" page))

;; Select device

(defn try-select-device []
  (PUT (venue-url)
       {:format :json
        :params { :venue {:device_id (@page-state :device-id)
                          :event "select_device" }}}))

(defn start-select-device [device-id]
  (swap! page-state assoc :device-id device-id)
  (try-select-device))

(defn device-selected []
  (swap! page-state dissoc :device-id))

(defn selected-device []
  (first
   (filter #(= (venue-device-id) (:id %))
           (user-owned-devices))))

;; TODO use correct name, noop is not
(defn device-display-name []
  (or (venue-device-name)
      (:name (selected-device)) "Not Selected"))

;; Messaging

(defn venue-message-handler [msg]
  (condp = (:event msg)
    "snapshot" (u/reset-state! (:snapshot msg))
    "stats" (swap! page-state assoc :stats (:stats msg))
    (prn "Unknown message" msg)))

(def uniqkey (atom 0))

(defn gen-key []
  (let [res (swap! uniqkey inc)]
    res))

(defn add-key [x]
  ^{:key (gen-key)} x)

(defn add-server-message
  "Adds a message to the message queue which is displayed in the chat
  window."
  [content]
  (swap! page-state update :messages conj
         {:id (random-uuid)
          :time (.format (js/moment) "x")
          :content (map add-key content)}))

;; Actions

(defn wizard-page-action [page]
  (swap! page-state assoc :wizard-page page))

(defn hide-source-wizard []
  (swap! page-state assoc :show-source-wizard false))

(defn show-source-wizard
  ([] (show-source-wizard "start"))
  ([page]
   (prn "show-source-wizard" page)
   (wizard-page-action page)
   (swap! page-state assoc :show-source-wizard true)))

(defn request-availability-action []
  (add-server-message (t "message.requesting_availability"))
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "become_available" }}}))

(defn start-server-action []
  (if (not (:launched @page-state))
    (do
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
      (aset js/window "location" "/devices/new")
      ;; else if device_id schedule periodic put until connected
      (if device-id
        (do
          (start-select-device device-id)
          (swap! page-state assoc :device-name (:name (selected-device)))
          (hide-source-wizard))
        ;; else
        (do
          (wizard-page-action device-name)
          (when (contains? valid-devices device-name)
            (swap! page-state assoc :device-name device-name)
            ;;(swap! page-state assoc :instructions true)
            (PUT (venue-url)
                 {:format :json
                  :params { :venue {:device_id nil
                                    :device_name device-name
                                    :event "select_device" }}})
            ;;(swap! page-state assoc :show-source-wizard false)
            ))))))

(defn streamboxx-selected? []
  (let [dname (:device-name @page-state)]
    (not (or (nil? dname)
             (contains? valid-devices dname)))))

(defn hide-instructions-action []
  (track-event "instructions close")
  (swap! page-state assoc :instructions false)
  false)

(defn start-talk-action [talk]
  (track-event "talk start")
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "start_talk"}}})
  (add-server-message (t "message.streaming"))
  false)

(defn end-talk-action [talk]
  (swap! page-state assoc :hide-stop-button true)
  (track-event "talk end")
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "end_talk"}}})
  (if (next-talk)
    (add-server-message (t "message.stopped_with_next_talk"))
    (add-server-message (t "message.stopped_create_talk")))
  false)

(defn mouseover-stop-button-action []
  (swap! page-state assoc :over-stop-button true))

(defn mouseout-stop-button-action []
  (swap! page-state assoc :over-stop-button false))

(defn toggle-autostart-action []
  (swap! page-state update :autostart not))

(defn launch-client-selector-action []
  (.log js/console "launch the selector"))

;; Components

;; NOTE maybe we should display an approx. audio delay. later we could
;; use the internal microphone to calculate the exact delay, if on
;; site. It could also be used to detect if on site.

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

(defn pending? []
  (venue-in-state ["available" "offline" "provisioning"]))

(defn ready
  "Will return x only if not pending."
  [x]
  (if (pending?) "Pending..." x))

(defn pending-hint-comp []
  [:p (if (pending?)
        "(Configuration details are pending, please stand by.)"
        "")])

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
     {:class (if (pending?) "disabled")
      :href (config-url "butt")
      :target "_blank"}
     [icon "download"] "download config file"]
    ;; TODO add table here
    [pending-hint-comp]]])

(defn instructions-for-darkice-comp []
  [:div
   [:h4 "Streaming with darkice"]
   [:p.lead "Download the config file below and run with..."]
   [:code "sudo darkice -c <your-config-file>"]
   [:p.lead "Note: root permissions are required to use posix realtime scheduling."]
   [:p.clearfix
    ;; target blank, see above
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:class (if (pending?) "disabled")
      :href (config-url "darkice")
      ; :on-click hide-instructions-action
      :target "_blank"}
     [icon "download"] "download config file"]
    [pending-hint-comp]]])

(defn row [a b]
  [:tr [:td a] [:td (ready b)]])

(defn instructions-for-generic-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming with a Generic Icecast Client"]
   [:p "Use these settings with your Icecast application..."]
   [:table
    [row "Host/Server" (:public_ip_address (venue))]
    [row "Port"        (:port (venue))]
    [row "User"        "source"]
    [row "Password"    (:source_password (venue))]
    [row "Mountpoint"  (:mount_point (venue))]]
   [pending-hint-comp]])

(defn instructions-for-bcms-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from Android with BroadcastMyself"]
   [:table
    [row "Hostname"    (:public_ip_address (venue))]
    [row "Port"        (:port (venue))]
    [row "Path"        (str "/" (:mount_point (venue)))]
    [row "Username"    "source"]
    [row "Password"    (:source_password (venue))]]
   [help-link-comp "support/streaming-with-broadcastmyself-android/?lang=en"]
   [pending-hint-comp]])

(defn instructions-for-koalasan-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from iOS with KoalaSAN"]
   [:table
    [row "Server"     (:public_ip_address (venue))]
    [row "Port"       (:port (venue))]
    [row "Mointpoint" (:mount_point (venue))]
    [row "Username"   "source"]
    [row "Password"   (:source_password (venue))]]
   [help-link-comp "support/streaming-with-koalasan-ios/?lang=en"]
   [pending-hint-comp]])

(defn instructions-for-icast2-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from iOS with iCast 2"]
   [:table
    [row "Host"       (:public_ip_address (venue))]
    [row "Port"       (:port (venue))]
    [row "Mount"      (str "/" (:mount_point (venue)))]
    [row "Username"   "source"]
    [row "Password"   (:source_password (venue))]]
   [help-link-comp "support/streaming-with-icast-2-ios/?lang=en"]
   [pending-hint-comp]])

(defn instructions-for-coolmic-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Streaming from Android with CoolMic"]
   [:table
    [row "Server"     (str (:public_ip_address (venue)) ":" (:port (venue)))]
    [row "Username"   "source"]
    [row "Password"   (:source_password (venue))]
    [row "Mountpoint" (str "/" (:mount_point (venue)))]]
   [help-link-comp "support/streaming-with-coolmic-android/?lang=en"]
   [pending-hint-comp]])

;; FIXME
(defn instructions-to-disconnect-comp []
  [:div.medium {:id "instructions"}
   [:h4 "Alert"]
   (if (venue-device-id)
     [:p "Waiting for disconnect, please stand by..."]
     [:p "Please disconnect your streaming client by stopping the broadcast on your device..."])])

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

(defn mute-comp []
  (if (venue-in-state ["connected"])
    [:button.button.tiny.stage-button.mute-toggle
     {:on-click toggle-mute-action}
     "monitor"
     (if (@page-state :mute)
       [icon "sound_off"]
       [icon "headphones"])]
    ; [:button.tiny.button.btn-gray.btn-hover-green.hollow.float-right "giggle"]
    ))

(defn dropdown-menu-comp []
  (if (:dropdown-menu-open @page-state)
    [:div#mobile-nav
     [:ul.menu.vertical
      [:li [:a {:href "/"} "Home"]]
      [:li [:a {:href (user-url)} "My Profile"]]
      [:li [:a {:href (new-talk-path)} "Create A Talk"]]
      [:li [:a {:href (new-test-talk-path)} "Test A Talk"]]
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
     [icon "grid"]
     [:span.show-for-medium "STAGES"]]]
   [:div#titlebar.small-8.medium-6.columns.text-center
    [:div#venue-title (venue-name)]]
   [:div#dropdown.small-2.medium-3.columns.text-right
    [:a.avatar.float-right
     {:href "#"
      :on-click open-menu-action
      :style {:background (str "url(" (user-image-url) ")")
              :background-size "cover"}}]
    [:div#help-link [:a.float-right.button
                     {:href "#"
                      :on-click toggle-help-text-action }
                     "?"]]]])

(defn device-comp []
  [:div
   [:div#device-label
    [icon "cable"] "source: " [:span.strong (device-display-name)]]
   [:button#device-button.button.tiny.stage-button
    {:on-click #(show-source-wizard)}
    [icon "gear"] "change"]])


;; SVG Components

(def green "#60BD70")
(def lightblue "#54c6c6")
(def red "#f82847")
(def gray "rgba(53, 54, 59, 0.1)")

(defn server-ring-color
  "Server status indication."
  []
  (cond
    (venue-in-state ["available" "offline"]) "rgba(0,0,0,0)"
    (venue-in-state ["provisioning"]) lightblue
    :else green))

(defn stream-ring-color
  "Color of the Live Stream Indicator Ring Capacitor"
  []
  (if (active-talk-in-state ["live"]) green gray))

(defn server-ring-dasharray
  "Server progress."
  [percentage radius]
  (let [circumference (* 2 radius Math/PI)
        current (* percentage (/ circumference 100))]
    (if (js/isNaN percentage)
      (str "0" " " circumference)
      (str current " " (- circumference current)))))

(defn source-ring-color []
  "Source status indication."
  (cond
    (venue-in-state ["awaiting_stream" "disconnected"]) lightblue
    (venue-in-state ["connected" "disconnect_required"]) green
    ;;(venue-in-state ["disconnected"]) red
    :else gray))

(defn source-ring-dasharray
  "Source status indication. Dashed or not."
  [radius]
  (if (venue-in-state ["awaiting_stream"
                       "disconnected"
                       "disconnect_required"])
    (let [circumference (* 2 radius Math/PI)
          stroke-and-gap (/ circumference 69)
          stroke (* 2 (/ stroke-and-gap 5))
          gap (- stroke-and-gap stroke)]
      (str stroke " " gap))
    "0"))

(defn server-base-ring-comp
  "Gray outer ring."
  []
  [:circle.base
   {:r "125"
    :stroke-width "10"
    :stroke gray
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

(defn source-base-ring-comp
  "Gray middle ring."
  []
  (let [offset (atom 0)]
    (fn []
      [:circle.base
       {:r "110"
        :stroke-width "10"
        :stroke (source-ring-color)
        :stroke-dasharray (source-ring-dasharray 50) ; takes the radius
        :fill "none"
        :cy "50%"
        :cx "50%"
        :transform (str "rotate(" @offset ", 130, 130)")}
       [anim/interval (fn [] (swap! offset #(mod (+ % 0.5) 360))) 50]])))

(defn- source-audio-meter-radius
  "min is 20, max is 130"
  []
  (.min js/Math (* (/ (:volume @spork/audio) 255) 20) 10))

(defn- source-audio-meter-opacity
  "min is 0 max is 0.95"
  []
  (* (/ (:volume @spork/audio) 255) 0.95))

(defn source-audio-meter-comp
  "Audio meter that pulsates based on the audio signal."
  []
  [:circle
   {:r 80
    :stroke-width (source-audio-meter-radius)
    :stroke green
    :opacity (source-audio-meter-opacity)
    :fill "none"
    :cy "50%"
    :cx "50%"}])

(defn stream-base-ring-comp
  "Gray inner ring."
  []
  [:circle.base
   {:r "95"
    :stroke (stream-ring-color)
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
    {:r "50" :fill "#60BD70" :cy "50%" :cx "50%"}]
   [:text#buttonText1
    {:fill "#fff"
     :text-anchor "middle"
     :y "120"
     :height "11"
     :x "50%"}
    "click to"]
   [:text#buttonText2
    {:fill "#fff"
     :text-anchor "middle"
     :y "134"
     :height "11"
     :x "50%"}
    "launch"]
   [:text#buttonText3
    {:fill "#fff"
     :text-anchor "middle"
     :y "149"
     :height "11"
     :x "50%"}
    "server"]])

(defn select-source-button-comp []
  [:g {:on-click launch-client-selector-action}
   [:circle#circleButton.button
    {:r "80" :fill "#60BD70" :cy "50%" :cx "50%"}]
   [:text#buttonText5
    {:fill "#54c6c6"
     :text-anchor "middle"
     :y "127"
     :height "12"
     :x "50%"}
    "select"]
   [:text#buttonText6
    {:fill "#54c6c6"
     :text-anchor "middle"
     :y "142"
     :height "12"
     :x "50%"}
    "source"]])

(defn start-talk-button-comp []
  [:g {:on-click #(start-talk-action (active-talk))}
   [:circle#circleButton.button
    {:r "50" :fill "#60BD70" :cy "50%" :cx "50%"}]
   [:text#buttonText3
    {:fill "#fff"
     :text-anchor "middle"
     :y "127"
     :height "12"
     :x "50%"}
    "start"]
   [:text#buttonText4
    {:fill "#fff"
     :text-anchor "middle"
     :y "142"
     :height "12"
     :x "50%"}
    "streaming"]])

(defn end-talk-button-comp []
  [:g {:on-click #(end-talk-action (active-talk))
       :style {:cursor "pointer"}}
   [:rect {:rx 2
           :ry 2
           :width 15
           :height 15
           :x (- (/ 260 2) 7.5)
           :y (- (/ 260 2) 15)
           :fill red}]
   [:text {:x "50%"
           :y (+ (/ 260 2) 20)
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

    (when (onair?)
      [:g
       [stream-overlay-ring-comp]
       (if (not (:hide-stop-button @page-state))
       [end-talk-button-comp])])
    [gui-labels-comp]]])

(defn speaker-comp [speaker]
  ^{:key speaker}
  [:li.clearfix
   [:span.float-left
    [icon "person"]]
   [:span.speaker-name speaker]])

;  Later:
; (defn speaker-comp [speaker]
;   ^{:key speaker}
;   [:li.clearfix
;    [:span.float-left
;     [icon "person"]]
;    [:span.speaker-name speaker]])

; (defn speakers-comp []
;   [:div#speakers.medium-10.columns.medium-offset-1.end
;    [:h4.section-title.text-center "Speakers"]
;    [:ul.menu.vertical.text-center
;     (doall (map speaker-comp (active-talk-speakers)))]])

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
         " here. Any questions? Check out the "
         [:a {:href "http://blog.voicerepublic.com/support/?lang=en"} "support section"]]"."]]
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
       "Check out how to  "
       [:a
        {:target "_blank",
         :href
         "http://blog.voicerepublic.com/support/live-streaming-with-the-voice-republic-streamboxx/?lang=en"}
        "stream with the StreamBoxx"]"."]
      [:p
       "Check out how to "
       [:a
        {:target "_blank",
         :href
         "http://blog.voicerepublic.com/support/streaming-with-butt-mac-win-linux/?lang=en"}
        "stream with your Laptop"]"."]
      [:p
       "Check out how to "
       [:a
        {:target "_blank",
         :href
         "/pages/mobile-live-streaming"}
        "stream with your Mobile Phone"]
       "."]
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



(defn autostart-comp []
  ;; TODO fix shift of source select when autostart is hidden
  ;;(if (active-talk)
    [:button.button.tiny.stage-button.text-left
     {:class (if (:autostart @page-state) "active" "")
      :on-click toggle-autostart-action}
     [icon "bolt"]
     "autostart"]);;)

(defn toggles-comp []
  [:div#toggles.clearfix
   [:div.small-3.columns.text-left.no-pad
    [autostart-comp]]
   [:div.small-6.columns.text-center.no-pad
    [device-comp]]
   [:div.small-3.columns.text-right.no-pad
    [mute-comp]]])

(defn post-talk-link-comp []
  [:div.clearfix [:a.button.tiny.stage-button {:href (active-talk-url)} [icon "eye"] "View Your Talk"]])

(defn messages []
  (reverse (sort-by :time (:messages @page-state))))

(defn vec-if-only-one [x]
  (if (seq? x) x [x]))

(defn server-message-comp [message]
  ;;^{:key (:id message)}
  [:div.row.message-row
   [:div.message-losenge.left.float-left

    (into [:span.message-text]
          ;;(map add-key (:content message)))
          ;;(for [c (:content message)] ^{:key (gen-key)} c))
          (:content message))

    [:span.message-time (.format (js/moment (:time message) "x") "H:mm:ss")]]])

(defn message-container-comp []
  [:div#message-container.medium-4.columns.float-right
   [:h4.section-title.text-center "Messages"]
   ;;(doall (map server-message-comp (messages)))
   (for [message (messages)] ^{:key (:id message)} [server-message-comp message])
   ])

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

(def back-target {
                  "laptop" "start"
                  "box" "start"
                  "mobile" "start"
                  "butt" "laptop"
                  "darkice" "laptop"
                  "generic" "laptop"
                  "bcms" "mobile"
                  "coolmic" "mobile"
                  "koalasan" "mobile"
                  "icast2" "mobile"
                  })

(defn device-option-comp
  "Displays a button inside the wizard."
  [page picto label delay &{:keys [custom-class] :or {custom-class ""}}]
  (let [offset-y (reagent/atom 50)
        drift (anim/interpolate-to offset-y {:easing ease-in-out-quart
                                             :duration 1500})
        opacity (reagent/atom 0)
        fade (anim/interpolate-to opacity {:duration 1500})]
    ;; (prn page icon label delay custom-class)
    (fn [page picto label delay &{:keys [custom-class] :or {custom-class ""}}]
      [:li {:class custom-class
            :on-click (fn []
                        (select-device-action page))
            :style {:opacity @fade
                    :margin-top @drift}}
       [anim/timeout (fn []
                       (reset! opacity 1)
                       (reset! offset-y 0)) delay]
       [:div.itemwrapper

        [icon picto]
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
    (doall (map (fn [x] ^{:key (:id x)} [device-option-comp (:id x) "box" (:name x) 200]) (user-owned-devices)))
    [device-option-comp "pairing" "box" "New Box" 400 :custom-class "new-box"]
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
        [:div.float-left.back-btn {:on-click #(wizard-page-action (back-target (:wizard-page @page-state)))}
         [icon "arrow-left"]]
        [:div.float-right.close-btn {:on-click hide-source-wizard} "×"]]

       ;; HACK
       (if (= "noop" (:wizard-page @page-state))
         (swap! page-state assoc :wizard-page "start"))
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
    [:div.float-right.close-btn {:on-click hide-source-wizard} "×"]]
   (condp = (:wizard-page @page-state)
     "start" [wizard-page-start-comp]
     "box" [wizard-page-box-comp]
     "laptop" [wizard-page-laptop-comp]
     "mobile" [wizard-page-mobile-comp])])

(defn chat-input-comp []
  [:form#chat-form
   [:div#chat-input.clearfix
    [:div#chat-icon.float-left
     [icon "chat"]]
    [:div#chat-input-field.float-left
     [:label
      [:input {:placeholder "" :type "text"}]
      [:input#hidden-input {:placeholder "" :type "hidden"}]]]
    [:div#chat-send.float-right
     [icon "airplane"]]]])

(defn stage-comp []
  [:div
   [navbar-comp]
   [dropdown-menu-comp]
   [talkbar-comp]
   [:div#ui.row.clearfix.expanded
    [:div#left-side.medium-8.columns.no-pad.text-center ; left
     [toggles-comp]
     [circles-comp]

     ;;[post-talk-link-comp]
     ; (if (:active-talk-speakers @page-state)
     ;   [speakers-comp])
     ]
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
  (if (and (= (venue-state) "offline") (active-talk))
    (js/setTimeout request-availability-action (max 0 (time-to-available)))))

(defn setup-faye [callback]
  (print "Subscribe" (venue-channel))
  (let [subscription
        (.subscribe js/fayeClient (venue-channel)
                    #(venue-message-handler (js->clj %  :keywordize-keys true)))]
    (.then subscription callback)))

(defn mount-root []
  (reagent/render [stage-comp] (.getElementById js/document "app")))

(defn welcome-message []
  (cond

    (not (active-talk))
    "message.welcome_create_a_talk"

    (venue-in-state ["available"])
    "message.welcome_launch_server"

    (and (venue-in-state ["offline"]) (<= (time-to-available) 0))
    "message.welcome_requesting_availability"

    (and (venue-in-state ["offline"]) (> (time-to-available) 0))
    "message.welcome_and_see_you_soon"

    :else false))

(defn init! []
  (start-timer)
  (if (.-fayeClient js/window)
    (setup-faye schedule-check-availability)
    (swap! page-state assoc :nopush true))
  (mount-root)
  (if-let [message (welcome-message)]
    (add-server-message
     (t message
        ;;:create-a-talk (str "<a href='" (new-talk-path) "'>create a talk</a>"))))
        :create-a-talk [:a {:href (new-talk-path)} "create a talk"]
        )))
  (when (= (venue-state) "connected")
    ;; subscribe to audio & setup audio meter
    (media/mode! "streamed")
    (media/source! (icecast-url))
    (js/setTimeout #(spork/setup-analyser-for-media-element "audio") 500))
  (when (= (venue-state) "awaiting_stream")
    (if-not (streamboxx-selected?)
      (show-source-wizard (venue-device-name))))
  (when (= (venue-state) "device_required")
    (if-not (streamboxx-selected?) (show-source-wizard))))


(add-watch
 state :now-connected
 (fn [key at0m old new]
   (when (and (not= (get-in old [:venue :state]) "connected")
              (= (get-in new [:venue :state]) "connected"))
     (device-selected) ; cancels retries
     (hide-source-wizard)
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
         (add-server-message (t "message.server_now_available"))

         ["available" "provisioning"]
         (add-server-message (t "message.server_starting"))

         ["provisioning" "device_required"]
         (do
           (show-source-wizard)
         (add-server-message (t "message.server_ready_select_source")))

         ["provisioning" "awaiting_stream"]
         (do
           (if-not (streamboxx-selected?) (show-source-wizard (venue-device-name)))
           (add-server-message (t "message.server_ready_source_preselected"))
           (add-server-message (t "message.connecting")))

         ["awaiting_stream" "connected"]
         (do
           (hide-source-wizard)
         (add-server-message (t "message.connected")))

         ["connected" "disconnected"]
         (add-server-message (t "message.waiting_for_reconnect"
                                :visit-troubleshooting [:a {:href "http://blog.voicerepublic.com/support/troubleshooting-2" :target "_blank"} "here"]))

         ["disconnected" "connected"]
         (if (onair?)
           (add-server-message (t "message.continue_streaming"))
           (add-server-message (t "message.connected_again")))

         ["connected" "disconnect_required"]
         (add-server-message
          (if (venue-device-id)
            (t "message.disconnecting_please_wait")
            (t "message.disconnecting_action_required")))

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
   (if (and (active-talk-in-state ["prelive"])
            (:autostart @page-state)
            (<= (time-to-active-talk) 0))
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
