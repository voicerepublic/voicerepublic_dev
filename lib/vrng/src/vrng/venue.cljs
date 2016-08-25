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

(defonce page-state (atom {:autostart false
                           :launched false
                           :instructions true
                           :menu-open false
                           :mobile-menu-open false
                           :help-text-open false
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
                         hours minutes seconds) " overdue")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format
             "%02dh %02dm %02ds"
             hours minutes seconds))))

(defn nbsp []
  (goog.string/unescapeEntities "&nbsp;"))

;; -------------------------
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

;; FIXME I've seen this fail
(defn active-talk []
  (or (first (talks-by-state "live"))
      (first (sort-by :starts_at (talks-by-state "prelive")))))

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
  [{:id "noop"     :name "-- no streaming source selected --"}
   {:id "pair"     :name "Claim a new client..."}
   {:id "bcms"     :name "BroadcastMyself (Android)"}
   {:id "coolmic"  :name "CoolMic (Android)"}
   {:id "koalasan" :name "KoalaSAN (iOS)"}
   {:id "icast2"   :name "iCast 2 (iOS)"}
   {:id "butt"     :name "B.U.T.T. (Mac, Win, Linux)"}
   {:id "darkice"  :name "Darkice (Linux Console)"}
   {:id "generic"  :name "Other Icecast Client"}])

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

(defn blog-url [page]
  (str "http://blog.voicerepublic.com/" page))

;; -------------------------
;; BUSINESS LOGIC

(defn server-status []
  (cond
    (and (venue-in-state ["provisioning"])
         (> (time-since-provisioning-started)
            (venue-provisioning-duration)))
    {:class "warning" :reason "The server is almost ready."}

    (venue-in-state ["provisioning"])
    {:class "warning" :reason "Server is starting."}

    (venue-in-state ["device_required" "awaiting_stream"
                     "connected" "disconnected"])
    {:class "success" :reason "Good job! Your server is ready."}

    (< (time-to-active-talk) (* 5 60 1000))
    {:class "alert" :reason "Please connect to the streaming server."}

    (venue-in-state ["available"])
    {:class "warning" :reason "If you want to stream, please connect to the streaming server."}

    :else {:class "neutral" :reason (nbsp)}))



(defn device-status []
  (cond
    (venue-in-state ["provisioning" "awaiting_stream"])
    {:class "warning" :reason "You can now select a streaming source."}

    (venue-in-state ["device_required"])
    {:class "alert" :reason "Please select a streaming source."}

    (venue-in-state ["disconnected"])
    {:class "alert" :reason "Look out! Your streaming source seems to be disconnected."}

    (venue-in-state ["connected"])
    {:class "success" :reason "Awesome. Your streaming source is connected."}
    :else {:class "neutral" :reason (nbsp)}))

(defn talk-status []
  (cond
    (and (active-talk-in-state ["live"])
         (venue-in-state ["disconnected" "awaiting_stream"]))
    {:class "alert" :reason "We can't hear you! Reconnect your streaming source to start broadcasting."}

    (and (active-talk-in-state ["live"])
         (venue-in-state ["connected"]))
    {:class "success" :reason "All good. Props to you!"}

    (< (time-to-active-talk) 0)
    {:class "alert" :reason "Are you ready to stream?"}

    (< (time-to-active-talk) (* 10 60 1000))
    {:class "warning" :reason "Less than 10 minutes to scheduled start. Are you ready to stream?"}

    :else {:class "neutral" :reason (nbsp)}))

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
  (when (not (:launched @page-state))
    (track-event "server launch")
    (swap! page-state assoc :launched true)
    (PUT (venue-url)
         {:format :json
          :params { :venue { :event "start_provisioning" }}})))

(defn select-device-action [event]
  (let [device-id-or-name event;(.. event -target -value)
        numeric (re-matches #"^\d+$" device-id-or-name)
        device-id (if numeric device-id-or-name nil)
        device-name (if numeric nil device-id-or-name)]
    (track-event (str "device select " device-id-or-name))
    (if (= "pair" device-name)
      ;; load /devices
      (aset js/window "location" "/devices")
      ;; else
      (do
        (PUT (venue-url)
             {:format :json
              :params { :venue {:device_id device-id
                                :device_name device-name
                                :event "select_device" }}})
        (swap! page-state assoc :device-name device-name)
        (swap! page-state assoc :instructions true)))))


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

(defn toggle-autostart-action []
  (swap! page-state assoc :autostart (not (:autostart @page-state))))


;; -------------------------
;; AUTOSTART

;;(defonce autostart (atom {:active true
;;                          :stimuli 0
;;                          :required-stimuli 45
;;                          :required-volume 50}))

(add-watch state :autostart-countdown
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
  [:button.float-right { :on-click start-server-action } (t "setup")])

(defn autostart-checkbox-comp []
  [:span.float-right.autostart
   [:input {:type "checkbox"
            :on-change toggle-autostart-action
            :checked (:autostart @page-state)} " autostart"]])

(defn titlebar-comp
  ([title status] [titlebar-comp title status nil])
  ([title status subcomp]
   [:div {:class "titlebar clearfix"}
    [:h4 {:class "title"} title
     (if subcomp [subcomp])]]))

(defn message-comp [status]
  [:div.message.clearfix
  [:p [:span {:title (:reason status)
                :class (str (:class status) " badge float-left")}
         (condp = (:class status)
           "success" (goog.string/unescapeEntities "&#x2713;")
           "neutral" "-"
           "warning" "!"
           "alert" "!")]
        (:reason status)]])

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
       [:p {:class "launch-advice"}
        "Server now available."
        ;;"Became available "
        ;;(u/from-now (* 1000 (available-at)))
        ]]
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
       "Uptime: "
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

(defn audio-element []
  (.getElementById js/document "monitor"))

(defn toggle-mute-action []
  (swap! page-state assoc :mute (not (@page-state :mute)))
  (aset (audio-element) "volume" (if (@page-state :mute) 0 1)))

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


(defn help-link-comp
  ([page] [help-link-comp page "Need help?"])
  ([page text] [:a {:target "_blank" :href (blog-url page)} text]))

(defn generic-help-link-comp [link text]
  [:a {:target "_blank" :href link} text])

(defn instructions-for-butt-comp []
  [:div.tiny {:id "instructions"}
   [:h4 "Streaming with B.U.T.T."]
   [:p.lead "Simply download the config file below and import it into B.U.T.T. by clicking \"Settings\" > \"Import\" inside the B.U.T.T. application, and push \"Play.\""]
   [help-link-comp "support/streaming-with-butt-mac-win-linux/?lang=en"]
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
    [:tr [:td "Port"] [:td (:port (venue))]]
    [:tr [:td "User"] [:td "source"]]
    [:tr [:td "Password"] [:td (:source_password (venue))]]
    [:tr [:td "Mountpoint"] [:td (:mount_point (venue))]]]
   [:p.text-center
    [:a.button.small.hollow.btn-white.btn-hover-yellow
     {:href "#" :on-click hide-instructions-action} "Cancel"]]])

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

(defn toggle-help-text-action []
  (swap! page-state assoc :help-text-open (not (@page-state :help-text-open))))

(defn optional-helptext-comp []
  (if (:help-text-open @page-state)
    [:div.row.optional-help-text.clearfix {:id "help-text"}
     [:div
      [:p.clearfix [icon-comp "jeeves"]
       [:button.close-button.float-right {:on-click toggle-help-text-action}
        [:span (goog.string/unescapeEntities "&times;")]]]
      [:p "This is your venue " [:span.strong (venue-name)]
       ". A venue is the digital counterpart to a real stage. For every stage you want to stream,there is one venue page. If you have more than one stage, we’ll help you set up the venues - just contact us under " [generic-help-link-comp "mailto:service@voicerepublic.com" "service@voicerepublic.com"] "."]
      [:p "All talks happening at " [:span.strong (venue-name)] " are listed below.
    You can see and control the streams on this page.
    Start your server, choose your streaming source and then start your broadcast.
    Any questions? Check out the " [help-link-comp "support/?lang=en" "support section"] "."]]]))


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
      ;;[:li [help-text-trigger-comp]]
      [:li [:a {:href "/venues"} "My Stages"]]
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
      (if-not (or (str/blank? device-name) (= device-name "noop"))
        [:div.instruction-container
         (condp = device-name
           "bcms"     [instructions-for-bcms-comp]
           "coolmic"  [instructions-for-coolmic-comp]
           "koalasan" [instructions-for-koalasan-comp]
           "icast2"   [instructions-for-icast2-comp]
           "butt"     [instructions-for-butt-comp]
           "darkice"  [instructions-for-darkice-comp]
           "generic"  [instructions-for-generic-comp])]))))


(defn debug-sort-comp []
  [:ul {:style {:background-color "white"}}
   (doall (map (fn [x] ^{:key (:id x)} [:li (:title x) " " (:starts_at x)])
               (sort :starts_at (talks-by-state "prelive"))))])


(defn listener-count-comp []
  (if (and (< 0 (listener-count))
           (active-talk-in-state ["live"]))
    [:div {:class "medium-float-right listeners"}
     [:p.listener-count (listener-count)]
     [:p.listener-label "listening now"]]))

(defn mute-comp []
  (if (venue-in-state ["connected"])
    [:div#mute-toggle.float-right {:on-click toggle-mute-action}
     (if (@page-state :mute)
       [:div.sound_off [icon-comp "sound_off"]]
       [:div.sound_on [icon-comp "sound_on"]])]))

(defn app-comp [] ; --- mounted to #app
  [:div {:id "page", :on-click close-menu-action}
   ;;[debug-audio-comp]
   ;;[debug-sort-comp]
   (if (venue-in-state ["connected"]) [audio-comp])
   [:div.clearfix.row {:id "venue-header"}
    [:div {:class "medium-9 columns"}
     [:h1 {:class "venue-title"} (venue-name)
      (if (:nopush @page-state) [:span#nopush [icon-comp "cactus"]])
      [:button.icon-button {:on-click toggle-help-text-action} [icon-comp "question"]]]
     [optional-helptext-comp]
     [:p {:class "talk-title"}
      [active-talk-title-prefix-comp]
      [:a {:href (active-talk-url)} (active-talk-title)]]]
    [:div {:class "medium-3 columns dashboard"}
     [on-air-comp]
     [listener-count-comp]
     [mute-comp]
     ]]
   ;;[:span {:class "listener-label"} "LISTENERS"]]]]
   [:div.row.clearfix.control-panels
    [:div {:id "venue-control-panel", :class "clearfix"}
     [:div.venue-panel
      [:div.server-panel
      [titlebar-comp (t "streaming_server") (server-status)]
      ;;[:div {:class "divider"}]
      [server-actionbar-comp]]
      [message-comp (server-status)]]
     [:div.venue-panel
      [:div.device-panel
      [titlebar-comp (t "audio_source") (device-status)]
      ;;[:div {:class "divider"}]
      [device-actionbar-comp]]
      [message-comp (device-status)]]
     [:div.venue-panel
     [:div.talk-panel
      [titlebar-comp (t "broadcast") (talk-status) autostart-checkbox-comp]
      ;;[:div {:class "divider"}]
      [talk-actionbar-comp]]
      [message-comp (talk-status)]]]]
   ;;[debug-comp]
   ;;[:div.row [autostart-comp]]
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
  (if (.-fayeClient js/window)
    (setup-faye schedule-check-availability)
    (swap! page-state assoc :nopush true))
  (mount-root))
