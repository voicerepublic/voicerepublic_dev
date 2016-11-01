(ns vrng.venues.core
  (:require
   [vrng.util :as u :refer [t state to-millis track-event]]
   [vrng.sporktrum :as spork]
   [vrng.media :as media]
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

;; -------------------------
;; STATE

(defonce page-state (atom {:autostart false
                           :launched false
                           :instructions true
                           :dropdown-menu-open false
                           :talkbar-expanded false
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
(defn active-talk-speakers [] (:speakers (active-talk)))
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
    (and (@page-state :device-id) (venue-in-state ["provisioning" "awaiting_stream"]))
    {:class "warning" :reason "Waiting for the device to become ready..."}

    (venue-in-state ["provisioning" "awaiting_stream"])
    {:class "warning" :reason "You can now select a streaming source."}

    (venue-in-state ["device_required"])
    {:class "alert" :reason "You need to select a streaming source."}

    (venue-in-state ["disconnected"])
    {:class "warning" :reason "Look out! Your streaming source seems to be disconnected."}

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

;; ------------------------------
;; select device

(defn try-select-device []
  ;;(prn "trying to select device...")
  (PUT (venue-url)
       {:format :json
        :params { :venue {:device_id (@page-state :device-id)
                          :event "select_device" }}}))

(defn start-select-device [device-id]
  (prn "start-select-device device-id" device-id)
  (swap! page-state assoc :device-id device-id)
  ;;(go-loop []
  (try-select-device)
  ;;(<! (timeout 3000))
  ;;(if (@page-state :device-id) (recur))))
  )

(defn device-selected []
  (prn "device selected!")
  (swap! page-state dissoc :device-id))

;; -------------------------
;; MESSAGING

(defn venue-message-handler [msg]
  (condp = (:event msg)
    "snapshot" (u/reset-state! (:snapshot msg))
    "stats" (swap! page-state assoc :stats (:stats msg))
    (prn "Unknown message" msg)))

;; -------------------------
;; ACTIONS

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

(defn select-device-action [device-id-or-name]
  (let [numeric (re-matches #"^\d+$" device-id-or-name)
        device-id (if numeric device-id-or-name nil)
        device-name (if numeric nil device-id-or-name)]
    (track-event (str "device select " device-id-or-name))
    (if (= "pair" device-name)
      ;; load /devices
      (aset js/window "location" "/devices")
      ;; else if device_id schedule periodic put until connected
      (if device-id
        (start-select-device device-id)
        ;; else
        (do
          (println "works")
          (swap! page-state assoc :device-name device-name)
          (swap! page-state assoc :instructions true)
          (PUT (venue-url)
               {:format :json
                :params { :venue {:device_id nil
                                  :device_name device-name
                                  :event "select_device" }}})
          (swap! page-state assoc :show-source-wizard false))))))

(defn toggle-source-wizard-action []
  (println "show the wizzzz!")
  (swap! page-state update :show-source-wizard not)
  (swap! page-state assoc :wizard-page "start"))


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

(defn wizard-page-action [page]
   (swap! page-state assoc :wizard-page page))


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
  (let [element (.getElementById js/document "audio")]
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

; (defn device-option-comp [device]
;   (let [key (device :id)]
;     ^{:key key}
;     [:option {:value key} (device :name)]))

; (defn device-select-comp []
;   [:select#device-selector {:on-change select-device-action
;                             :value (venue-device-id-or-name)}
;    (doall (map device-option-comp (devices)))])

; (def device-select-comp-with-callback
;   (with-meta device-select-comp
;     {:component-did-mount
;      (fn [this]
;        (.selectize (js/jQuery (.getElementById js/document "device-selector"))
;                    #js{:onChange select-device-action}))}))

(defn toggle-mute-action []
  (swap! page-state assoc :mute (not (@page-state :mute)))
  (media/volume! (if (@page-state :mute) 0 1)))

(defn device-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   [:div.status-bar
    [spork/audio-meter-comp]
    ; [device-select-comp-with-callback]
    ]])

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
    [:td "(@page-state :device-id)"]
    [:td (@page-state :device-id)]
    [:td]]
   ;;[:tr
   ;; [:td "(@page-state :device-id)"]
   ;; [:td (@page-state :device-id)]
   ;; [:td]]
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
  ([page text] [:a.help-link {:target "_blank" :href (blog-url page)} text]))

(defn generic-help-link-comp [link text]
  [:a {:target "_blank" :href link} text])

(defn instructions-for-butt-comp []
  [:div
   [:h4 "Streaming with B.U.T.T."]
   [:div.row.clearfix
    [:div.medium-6.medium-offset-3.columns
     [:p "Simply download the config file below and import it into B.U.T.T. by clicking \"Settings\" > \"Import\" inside the B.U.T.T. application, and push \"Play.\""]
     [help-link-comp "support/streaming-with-butt-mac-win-linux/?lang=en"]]]

   [:p.clearfix
    ; [:a.button.small.hollow.btn-white.btn-hover-red.float-left
    ;  {:href "#" :on-click hide-instructions-action} "Cancel"]
    ;; target blank as a workaround for
    ;; https://bugzilla.mozilla.org/show_bug.cgi?id=712329
    [:a.button.small.hollow.btn-white.btn-hover-yellow {:href (config-url "butt")
                                            :target "_blank"}
     [icon-comp "download"] "download config file"]]])

(defn instructions-for-darkice-comp []
  [:div
   [:h4 "Streaming with darkice"]
   [:p.lead "Download the config file below and run with..."]
   [:code "sudo darkice -c <your-config-file>"]
   [:p.lead "Note: root permissions are required to use posix realtime scheduling."]
   [:p.clearfix
    ; [:a.button.small.hollow.btn-white.btn-hover-red.float-left
    ;  {:href "#" :on-click hide-instructions-action} "Cancel"]
    ;; target blank, s.o.
    [:a.button.small.hollow.btn-white.btn-hover-yellow {:on-click hide-instructions-action
                      ; :href (config-url "darkice")
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

(defn talk-list [talk-states sort-options]
 (doall (mapcat #(apply sort-by (conj sort-options (talks-by-state %))) talk-states)))

;; ------------------------------
;; more actions


(defn close-menu-action []
  (swap! page-state assoc :dropdown-menu-open false))

(defn open-menu-action []
  (swap! page-state assoc :dropdown-menu-open (not (:dropdown-menu-open @page-state)))
  false)

(defn toggle-help-text-action []
  (swap! page-state assoc :help-text-open (not (@page-state :help-text-open))))

;; ------------------------------
;; more components

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
       {:on-click open-menu-action :role "menuitem"}
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
    (if (:dropdown-menu-open @page-state)
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

(defn reconnect-action []
  (PUT (venue-url)
       {:format :json
        :params { :venue {:event "require_disconnect" }}}))

(defn device-control-comp []
  (if (@page-state :device-id)
    [:div#spinner.float-right [icon-comp "loading"]]
    [:button#reconnect.float-right.icon-button.large {:on-click reconnect-action} [icon-comp "reload"]]))



(defn autostart-notice-comp []
  [:div.autostart-warning "Please don't leave! For the autostart feature to work, you need to keep this page open."])



;;-------------------------
;;NEW STUFF STAGE 2
;;-----------------------------
;;-----------------------------
;;-----------------------------
;;-----------------------------
;;-----------------------------
;;-----------------------------
;;-----------------------------

;;---------------------------

;; ---------------------------
;; STAGE MARKUP

(defn mute-comp []
  (if (venue-in-state ["connected"])
    [:button.tiny.button.btn-gray.btn-hover-green.hollow.float-right {:on-click toggle-mute-action}
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
      [:li [:a {:href "/users/sign_out" :data-method "delete" :rel "nofollow"} "Logout"]]]]))


(defn navbar-comp []
   [:div#navbar.row.expanded {:on-click close-menu-action}
    [:div#back-arrow.small-2.medium-3.columns
     [:a
      {:href "/venues"}
      [icon-comp "grid"]
      [:span.show-for-medium "STAGES"]]]
    [:div#titlebar.small-8.medium-6.columns.text-center
     [:div#venue-title (venue-name)]]
    [:div#dropdown.small-2.medium-3.columns.text-right
     [:a.avatar.float-right {:href "#" :on-click open-menu-action :style {:background (str "url(" (user-image-url) ")")}}]
     [:div#help-link [:a.float-right.button {:href "#" :on-click toggle-help-text-action } "?"]]]])

(defn talk-item-comp [talk]
  ^{:key (:id talk)}
  ; (.log js/console talk)
  [:div.small-12.columns.talkitem.clearfix
      [:p.clearfix
       [:span.title.float-left.text-left [:a {:href "#"} (:title talk)]]
       [:span.time.float-left.text-left (:starts_at_time talk)]
       [:span.series.float-left.text-left [:a {:href (:url (:series talk))} (:title (:series talk))]]
       [:span.duration.float-left.text-right (:duration talk)]]])

(defn talkbar-comp []
   [:div#talkbar {:style {:height (if (@page-state :talkbar-expanded) "auto" "36px")}}
    [:div#current
     [:p#current-talk-title
      [:span.next-talk "Now: "]
      [:a {:href (:url (active-talk))} (:title (active-talk))]
      [:span.float-right.time-info (format-countdown (time-to-active-talk))]]]
    [:div#next
     [:p#current-talk-title
      [:span.next-talk "Next: "]
      [:a {:href "#"} "Stream A Little Stream of Me"]
      [:span.float-right.time-info "(14:30)"]]]
    [:div#list-toggle
     [:a.float-left.hide-for-small-only
      {:href "#" :on-click toggle-talkbar-action}
      [:span.show-for-medium.float-left "ALL TALKS"]
      [icon-comp "list"]]
     [:a.see-all.show-for-small-only.text-center "view all"]]

    [:div#listrow.row.clearfix

    ;;for each DAY of schedule, one of these blocks:
     [:div.small-12.columns.dayitem.clearfix [:p [:span "TODAY"]]]
     [:div.small-12.columns.headeritem.clearfix
      [:p
       [:span "TITLE"]
       [:span "TIME"]
       [:span "SERIES"]
       [:span.text-right "DURATION"]]]

     ;for each talk in the day, one of these:
     (doall (map talk-item-comp (talk-list ["live" "prelive"] [:starts_at <])))
     ]])

;;-----------------
;;SVG Components:
;;-----------------

;;colors
(def green "#60BD70")
(def lightblue "#54c6c6")
(def red "red")
(def gray "gray")

(defn server-ring-color []
  (cond
    (venue-in-state ["available" "offline"]) gray
    (venue-in-state ["provisioning"]) lightblue
    :else green))

(defn source-ring-color []
   (cond
    (venue-in-state ["awaiting_stream"]) lightblue
    (venue-in-state ["connected" "disconnect_required"]) green
    (venue-in-state ["disconnected"]) red
    :else gray))

(defn source-ring-offset []
   (cond
    (venue-in-state ["awaiting_stream"]) "500"
    :else "0"))


(defn server-ring-dasharray [percentage radius]
  ;;2*r*pi
  (let [circumference (* 2 radius Math/PI)
        current (* percentage (/ circumference 100))]
    ; (println percentage)
    (if (js/isNaN percentage)
      (str "0" " " circumference)
      (str current " " (- circumference current)))))

(defn source-ring-dasharray []
    (if (venue-in-state ["awaiting_stream"]) "4 6" "0"))




;;server base ring
(defn server-base-ring-comp []
  [:circle.base
    {:r "125",
     :stroke-width "10",
     :fill "none",
     :cy "50%",
     :cx "50%"}])

;;server overlay ring
(defn server-overlay-ring-comp []
  [:circle.overlay
    {
     :data-svg-origin "130 130",
     :stroke-dasharray (server-ring-dasharray (server-progress-percentage) 125),
     :stroke-dashoffset "100",
     :transform "matrix(0, -1, 1, 0, 0, 260)",

     :stroke (server-ring-color),
     :r "125",
     :stroke-width "10",
     :fill "none",
     :cy "50%",
     :cx "50%"}])

;;audio source base ring
(defn source-base-ring-comp []
  (let [offset (atom 0)
        rotation (anim/interpolate-to offset)]
  (fn []
    [:circle.base
      {
       :r "110",
       :stroke-width "10",
       :stroke (source-ring-color),
       :stroke-dasharray (source-ring-dasharray),
       :fill "none",
       :cy "50%",
       :cx "50%"
       :style {:strokeDashoffset @rotation}}
      ; (println @offset)
      [anim/interval (fn [] (swap! offset #(- % 10))) 200]])))




;;steam base ring
(defn stream-base-ring-comp []
  [:circle.base
    {:r "95",
     :stroke-width "10",
     :fill "none",
     :cy "50%",
     :cx "50%"}])

;;stream overlay ring
(defn stream-overlay-ring-comp []
  [:circle.overlay
    {
     :data-svg-origin "130 130",
     :r "95",
     :stroke-width "10",
     :fill "none",
     :cy "50%",
     :cx "50%"}])

;;server launch button
(defn server-launch-button-comp []
  [:g {:on-click start-server-action}
   [:circle#circleButton.button
    {:r "80", :fill "#60BD70", :cy "50%", :cx "50%"}]
   [:text#buttonText
    {:fill "#fff",
     :text-anchor "middle",
     :y "133",
     :height "12",
     :x "50%"}
    "launch this"]])

;;select source button
(defn select-source-button-comp []
  [:g {:on-click launch-client-selector-action}
   [:circle#circleButton.button
    {:r "80", :fill "#60BD70", :cy "50%", :cx "50%"}]
   [:text#buttonText
    {:fill "#54c6c6",
     :text-anchor "middle",
     :y "133",
     :height "12",
     :x "50%"}
    "launch this"]])

;;GUI labels
(defn gui-labels-comp []
  [:g#ui-labels
   [:line
    {:stroke-width ".5",
     :stroke "#666",
     :y2 "10",
     :x2 "35",
     :y1 "31.8",
     :x1 "56.8"}]
   [:line
    {:stroke-width ".5",
     :stroke "#666",
     :y2 "24.5",
     :x2 "35.5",
     :y1 "46.6",
     :x1 "57.6"}]
   [:line
    {:stroke-width ".5",
     :stroke "#666",
     :y2 "38.9",
     :x2 "35.5",
     :y1 "64.6",
     :x1 "61.1"}]
   [:text#server-label
    {:fill "#666",
     :font-size "8",
     :text-anchor "left",
     :y "10",
     :height "12",
     :x "1"}
    "server"]
   [:text#source-label
    {:fill "#666",
     :font-size "8",
     :text-anchor "left",
     :y "25",
     :height "12",
     :x "1"}
    "source"]
   [:text#stream-label
    {:fill "#666",
     :font-size "8",
     :text-anchor "left",
     :y "40",
     :height "12",
     :x "1"}
    "stream"]])



;;THE SVG
(defn circles-comp []
  [:div#circles
    [:svg {:viewBox "0 0 260 260"}
     [server-base-ring-comp]
     [server-overlay-ring-comp]
     [source-base-ring-comp]
     ; [source-overlay-ring-comp]
     [stream-base-ring-comp]
     [stream-overlay-ring-comp]

     ;;show the button if it's available
     (if (venue-in-state ["available"])
      [server-launch-button-comp])

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

(defn help-comp []
     (if (:help-text-open @page-state) [:div#helpbar.row.clearfix
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
  [:button.tiny.button.btn-gray.btn-hover-green.hollow.device-button {:on-click toggle-source-wizard-action}
   [icon-comp "headphones"]
   (:device-name @page-state)])

(defn toggles-comp []
     [:div#toggles.clearfix
      [:button.tiny.button.btn-gray.btn-hover-green.hollow.float-left {:class (if (:autostart @page-state) "active" "") :on-click toggle-autostart-action}
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

(defn message-container-comp []
      [:div#message-container.medium-4.columns.float-right
     [:h4.section-title.text-center "Messages"]
     [:div#second-message.row.message-row
      {:style
       {
        :display "none"
        :visibility "hidden"
        :opacity 0
        :transform "matrix(1.2, 0, 0, 1.2, 0, 0)"
      }}
      [:div.message-losenge.left.float-left
       [:span.message-text "You're on the air!..."]
       [:span.message-time "Now"]]]
     [:div#first-message.row.message-row
      {:style
        {
        :display "none"
        :visibility "hidden"
        :opacity 0
        :transform "matrix(1.2, 0, 0, 1.2, 0, 0)"}
        }
      [:div.message-losenge.left.float-left
       [:span.message-text
        "Your server is ready! You can now "
        [:strong "choose an audio source"]
        "..."]
       [:span.message-time "Now"]]]
     [:div.row.message-row
      [:div.message-losenge.right.float-right
       [:span.message-text
        "Sorry about that folks, had a technical problem."]
       [:span.message-time "10:29"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "We're back on the air!"]
       [:span.message-time "10:28"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "Oops! We lost you."]
       [:span.message-time "10:27"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "You're On The Air!"]
       [:span.message-time "10:26"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "You may start the stream anytime."]
       [:span.message-time "10:25"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "Your StreamBoxx is connected!"]
       [:span.message-time "10:24"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "Please select a streaming source."]
       [:span.message-time "10:23"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "Your server is ready."]
       [:span.message-time "10:22"]]]
     [:div.row.message-row
      [:div.message-losenge.left.float-left
       [:span.message-text "Your server is starting."]
       [:span.message-time "10:20"]]]])

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


(defn butt-component []
  (let [tilt (reagent/atom 0)
        rotation (anim/spring tilt)
        flip (reagent/atom -90)
        scale (anim/spring flip)
        size (reagent/atom 0)
        width (anim/spring size)
        opacity (reagent/atom .5)
        fade (anim/interpolate-to opacity)]
    (fn a-logo-component []
      [:li.box1-select {
                        :style {
                         ; :transform (str "rotate(" @rotation "deg) rotateY(" (+ 90 @scale) "deg)")
                         :opacity @fade
                        }

         :on-mouse-over (fn logo-mouseover [e]
                          (reset! tilt 15)
                          (reset! opacity 1))
         :on-mouse-out (fn logo-mouseout [e]
                         (reset! tilt 0)
                         (reset! opacity .5))}
       ; [anim/timeout #(reset! size 300) 1000]
       [:a.clearfix
        {:on-click #(select-device-action "butt")}
        [icon-comp "jeeves"]]
       [:br]
       "B.U.T.T"])))

(defn ease-in-out-quart
  [a b duration t]
  (cond
    (<= t 0) a
    (>= t duration) b
    :else
    (let [in-out (/ t (/ duration 2))]
      (if (< in-out 1)
        ;;in
        (+ b (* (Math/pow t 4) (/ (- b a) 2)))
        ;;out
        (+ (* (/ (* (- b a) -1) 2) (- (Math/pow (- in-out 2) 4) 2)) a)))))

; Math.easeInOutQuart = function (t, b, c, d) {
;     t /= d/2;
;     if (t < 1) return c/2*t*t*t*t + b;
;     t -= 2;
;     return -c/2 * (t*t*t*t - 2) + b;
; };

(defn device-option-comp [page icon label delay &{:keys [custom-class] :or {
                                                                            custom-class ""
                                                                            }}]
  (let [
        offset-y (reagent/atom 50)
        drift (anim/interpolate-to offset-y {:easing ease-in-out-quart
                                             :duration 1500})
        opacity (reagent/atom 0)
        fade (anim/interpolate-to opacity {:duration 1500})]

    (fn []
      ^{:key page}
      [:li {:class custom-class
            :on-click #(wizard-page-action page)
            :style {:opacity @fade
                    :margin-top @drift}}
       [anim/timeout (fn []
                       (reset! opacity 1)
                       (reset! offset-y 0))
        delay]

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

; (defn device-option-comp [device]
;   (let [key (device :id)]
;     ^{:key key}
;     [:option {:value key} (device :name)]))

; (defn device-select-comp []
;   [:select#device-selector {:on-change select-device-action
;                             :value (venue-device-id-or-name)}
;    (doall (map device-option-comp (devices)))])

(defn wizard-page-box-comp []
  ; (println (user-owned-devices))
  [:div
   [:h3 "Which StreamBoxx?"]
   [:ul.menu.vertical.medium-horizontal.text-center
    (doall (map #(device-option-comp (:id %) "box" (:name %) 200) (user-owned-devices)))
     ; [device-option-comp "box" "box" "Nietzsche" 0]
     ; [device-option-comp "box" "box" "Kant" 200]
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
     [device-option-comp "icast2" "apple" "iCast2" 600]

    ; [:li {:on-click #(select-device-action "bcms")}
    ;  [:div.itemwrapper
    ;   [icon-comp "android"]
    ;   [:br]
    ;   "Broadcast Myself"]]
    ; [:li {:on-click #(select-device-action "coolmic")}
    ;  [:div.itemwrapper
    ;   [icon-comp "android"]
    ;   [:br]
    ;   "CoolMic"]]
    ; [:li {:on-click #(select-device-action "koalasan")}
    ;  [:div.itemwrapper
    ;   [icon-comp "apple"]
    ;   [:br]
    ;   "KoalaSAN"]]
    ; [:li {:on-click #(select-device-action "icast2")}
    ;  [:div.itemwrapper
    ;   [icon-comp "apple"]
    ;   [:br]
    ;   "iCast2"]]
    ]])



;;main wizard container
(defn devices-wizard-comp []
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
       (condp = (:wizard-page @page-state)
         "start" [wizard-page-start-comp]
         "box" [wizard-page-box-comp]
         "laptop" [wizard-page-laptop-comp]
         "mobile" [wizard-page-mobile-comp]
         "butt" [instructions-for-butt-comp]
         "darkice" [instructions-for-darkice-comp]
         "generic" [instructions-for-generic-comp])])))

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
        [:input {:placeholder "", :type "text"}]
        [:input#hidden-input {:placeholder "", :type "hidden"}]]]
      [:div#chat-send.float-right
       [icon-comp "airplane"]]]]
  )

(defn stage-comp []
  [:div
   ;;navbar
   [navbar-comp]
   [dropdown-menu-comp]

   ;;talkbar
   [talkbar-comp]

   ;;ui
   [:div#ui.row.clearfix.expanded
    ;;left
    [:div#left-side.medium-8.columns.no-pad.text-center
     [toggles-comp]
     [circles-comp]
     (if (:active-talk-speakers @page-state)
       [speakers-comp])]
    ;;right
    [message-container-comp]
    [chat-input-comp]]

   ;;help
   [help-comp]
   ;;[modals-comp]
   (if (:show-source-wizard @page-state) [devices-wizard-comp])])










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
  (reagent/render [stage-comp] (.getElementById js/document "app")))

(defn init! []
  (start-timer)
  (if (.-fayeClient js/window)
    (setup-faye schedule-check-availability)
    (swap! page-state assoc :nopush true))
  (mount-root)
  (when (= (venue-state) "awaiting_stream")
    (toggle-source-wizard-action)
    (wizard-page-action (venue-device-name))))

(add-watch state :now-connected
           (fn [key at0m old new]
             (when (and (not= (get-in old [:venue :state]) "connected")
                        (= (get-in new [:venue :state]) "connected"))
               ;; cancels retries
               (device-selected)
               ;; subscribe to audio & setup audio meter
               (media/source! (icecast-url))
               (js/setTimeout #(spork/setup-analyser-for-media-element "audio") 500)
               )))
