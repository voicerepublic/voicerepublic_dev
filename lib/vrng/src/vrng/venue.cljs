(ns vrng.venue
  (:require
   [reagent.core :as reagent :refer [atom]]
   [reagent.session :as session]
   [secretary.core :as secretary :include-macros true]
   [ajax.core :refer [PUT]]
   goog.string.format
   goog.string))

;;      [cljs.core.async :as async
;;    :refer [<! >! chan close! sliding-buffer put! alts! timeout]])
;;  (:require-macros [cljs.core.async.macros :as m :refer [go alt! go-loop]]))

;; -------------------------
;; State

(defonce state
  (atom (js->clj (.-initialSnapshot js/window) :keywordize-keys true)))

(defonce translations
  (atom (js->clj (.-translations js/window))))

;; -------------------------
;; Audio
;;
;; https://github.com/minasmart/sporktrum/blob/master/src/sporktrum/core.cljs

(set! (.-getUserMedia js/navigator)
      (or (.-getUserMedia js/navigator)
          (.-webkitGetUserMedia js/navigator)
          (.-mozGetUserMedia js/navigator)
          (.-msGetUserMedia js/navigator)))


(set! (.-AudioContext js/window)
      (or (.-AudioContext js/window)
          (.-webkitAudioContext js/window)))

(defonce constraints (js-obj "video" false "audio" true))

;; TODO remove fake data once the whole thing works
(defonce audio (atom {:freq-mags [ {:freq 0, :mag 0}
                                   {:freq 1, :mag 0}
                                   {:freq 2, :mag 0}
                                   {:freq 3, :mag 0}
                                   {:freq 4, :mag 0}
                                   {:freq 5, :mag 0}
                                   {:freq 6, :mag 0}
                                   {:freq 7, :mag 0}
                                   {:freq 8, :mag 0}
                                   {:freq 9, :mag 0}
                                   {:freq 10, :mag 0}
                                   {:freq 11, :mag 0}
                                   {:freq 12, :mag 0}
                                   {:freq 13, :mag 0}
                                   {:freq 14, :mag 0}
                                   {:freq 15, :mag 0}
                                   ]}))

(defn freq-for-bin
  "Get the corresponding frequency for a bin in the fft"
  [bin-index sample-rate fft-size]
  (* bin-index (/ sample-rate fft-size)))

(defn to-non-typed-array
  "Convert a typed array to an array"
  [typed-array]
  (.apply js/Array [] typed-array))

(defn draw []
  (js/requestAnimationFrame draw)
  (let [analyser (:analyser @audio)
        uint8-freq-data (:freq-data @audio)]
    (.getByteFrequencyData analyser uint8-freq-data)
    (let [freq-data (to-non-typed-array uint8-freq-data)
          freq-mags (map-indexed
                      (fn [idx freq] {:freq freq :mag (nth freq-data idx) })
                      (:freqs @audio))]
      (swap! audio assoc :freq-data freq-data) ; debug
      (swap! audio assoc :freq-mags freq-mags))))

(defn configure
  "User media stream callback"
  [stream]
  (let [context (js/AudioContext.)
        element (.getElementById js/document "dev-audio")
        ;;source (.createMediaElementSource context element)
        source (.createMediaStreamSource context stream)
        analyser (.createAnalyser context)]

    ;; set the fft size
    (set! (.-fftSize analyser) 32) ; 32-2048
    (set! (.-minDecibels analyser) -85)
    (set! (.-maxDecibels analyser) -25)
    (set! (.-smoothingTimeConstant analyser) 0.9)

    ;; connect the analyser
    (.connect source analyser)
    ;;(.connect source (.-destination context))

    ;; Save a handle to the source and analyser
    (swap! audio assoc :source source)
    (swap! audio assoc :analyser analyser)

    (swap! audio assoc :sample-rate (.-sampleRate context))
    (swap! audio assoc :fft-size (.-fftSize analyser))
    (swap! audio assoc :freq-bin-count (.-frequencyBinCount analyser))
    (swap! audio assoc :freq-data (js/Uint8Array. (:freq-bin-count @audio)))

    (swap! audio assoc :freqs
           (apply array
                  (map #(freq-for-bin % (:sample-rate @audio) (:fft-size @audio))
                       (range 0 (:freq-bin-count @audio))))))
  (draw))

(defn setup-audio-meter []
  (.getUserMedia js/navigator constraints configure prn))
  ;;(configure))

;; -------------------------
;; generic utils

(defn t [& key]
  (let [keys (flatten (map #(clojure.string/split % ".") key))]
    (reduce get @translations keys)))

(defn millis [datetime]
  (.parse js/Date datetime))

(defn format-countdown [millis]
  (let [base    (/ (Math/abs millis) 1000)
        minute  60
        hour    (* 60 minute)
        day     (* 24 hour)
        days    (int (/ base day))
        hours   (int (/ base hour))
        minutes (- (int (/ base minute)) (* hours minute))
        seconds (- (int base) (* hours hour) (* minutes minute))]
    (cond
      (< millis 0) (str (goog.string.format
                         "%02dh %02dm %02ds"
                         hours minutes seconds) " over due")
      (> hours 48) (str days " " (t "days"))
      :else (goog.string.format
             "%02dh %02dm %02ds"
             hours minutes seconds))))

(defn percentage [current total]
  (min 100 (* current (/ 100 total))))

;; -------------------------
;; Page specific utils

(defn now []
  (* 1000 (:now @state)))

(defn venue []
  (:venue @state))

(defn venue-slug []
  (:slug (venue)))

(defn venue-url []
  (str "/venues/" (venue-slug)))

(defn venue-state []
  (:state (venue)))

(defn venue-name []
  (:name (venue)))

;; TODO sort
(defn talks []
  (:talks (venue)))


(defn talks-by-state [talk-state]
  (filter #(= talk-state (:state %)) (:talks (venue))))

(defn active-talk []
  (or (first (talks-by-state "live"))
      (last (sort :starts_at (talks-by-state "prelive")))))

(defn active-talk-title []
  (:title (active-talk)))

(defn active-talk-state []
  (:state (active-talk)))

(defn active-talk-runtime []
  (- (now) (millis (:started_at (active-talk)))))

(defn active-talk-duration []
  (* 60 1000 (:duration (active-talk))))

(defn time-to-active-talk []
  (- (millis (:starts_at (active-talk))) (now)))

(defn time-to [time]
  (- time (now)))

(defn time-to-available []
  (* (- (:availability (venue)) (:now @state)) 1000))

(defn time-since-provisioning-completed []
  (- (now) (millis (:completed_provisioning_at (venue)))))

(defn time-since-provisioning-started []
  (- (now) (millis (:started_provisioning_at (venue)))))

(defn venue-provisioning-started-at []
  (millis (:provisioning_started_at (venue))))

(defn venue-provisioning-duration []
  (* 1000 (:provisioning_duration (venue))))

(defn active-talk-progress
  ([] (active-talk-progress ""))
  ([suffix] (str (percentage
                  (active-talk-runtime)
                  (active-talk-duration)) suffix)))

(defn server-progress
  ([] (server-progress ""))
  ([suffix] (str (percentage
                  (time-since-provisioning-started)
                  (venue-provisioning-duration)) suffix)))

(defn icecast-url []
  (:stream_url (venue)))


(defn venue-device-id []
  (:device_id (venue)))

(defn venue-device-name []
  (:device_name (venue)))

(defn venue-device-id-or-name []
  (or (venue-device-id) (venue-device-name)))

(defn generic-devices []
  [{:id "butt" :name "B.U.T.T."}
   {:id "darkice" :name "Darkice"}
   {:id "generic" :name "Generic Icecast Client"}])

(defn user-owned-devices []
  (:devices @state))

(defn devices []
  (concat (user-owned-devices) (generic-devices)))

(defn audio-meter-bar-comp [freq-mag]
  ^{:key (:freq freq-mag)}
  [:div {:class "bar-holder"}
   [:div {:class "bar"
          :style {:height (str (:mag freq-mag) "%")}}]])



;; NOTE maybe we should display an approx. audio delay. later we could
;; use the internal microsphone to calculate the exact delay, if on
;; site. It could also be used to detect if on site.
(defn audio-meter-comp []
  [:div.soundbars.text-center.clearfix
   [:div {:id "bars"}
    ;; TODO maybe filter
    (doall (map audio-meter-bar-comp (:freq-mags @audio)))]])

;; -------------------------
;; Messageing

(defn update-atom [atom-data]
  (prn "Snapshot:" atom-data)
  (reset! state atom-data))

(defn venue-message-handler [msg]
  (condp = (:event msg)
    "snapshot" (update-atom (:snapshot msg))
    (prn "Unknown message" msg)))

;; -------------------------
;; Helpers

(defn talk-url [talk]
  (str "/xhr/talks/" (talk :id)))

;; TODO make variadic with &
(defn venue-in-state [venue-states]
  (some #(= (venue-state) %) venue-states))

(defn active-talk-in-state [active-talk-states]
  (some #(= (active-talk-state) %) active-talk-states))

;; -------------------------
;; Actions

(defn request-availability-action []
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "become_available" }}}))

(defn start-server-action []
  (PUT (venue-url)
       {:format :json
        :params { :venue { :event "start_provisioning" }}}))

(defn select-device-action [event]
  (let [device-id-or-name (.. event -target -value)
        numeric (re-matches #"^\d+$" device-id-or-name)
        device-id (if numeric device-id-or-name nil)
        device-name (if numeric nil device-id-or-name)]
    (PUT (venue-url)
         {:format :json
          :params { :venue {:device_id device-id
                            :device_name device-name
                            :event "select_device" }}})))

(defn start-talk-action [talk]
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "start_talk"}}}))

(defn end-talk-action [talk]
  (PUT (talk-url talk)
       {:format :json
        :params { :talk { :event "end_talk"}}}))

;; -------------------------
;; Business Logic

(defn server-status []
  (cond
    (and (venue-in-state ["provisioning"])
         (> (time-since-provisioning-started)
            (venue-provisioning-duration))) "alert"
    (venue-in-state ["provisioning"]) "warning"
    (venue-in-state ["select_device" "awaiting_stream"
                     "connected" "disconnected"]) "success"
    (< (time-to-active-talk) (* 5 60 1000)) "alert"
    (venue-in-state ["available"]) "warning"
    :else "neutral"))

(defn device-status []
  (cond
    (venue-in-state ["provisioning" "awaiting_stream"]) "warning"
    (venue-in-state ["select_device" "disconnected"]) "alert"
    (venue-in-state ["connected"]) "success"
    :else "neutral"))

(defn talk-status []
  (cond
    (and (active-talk-in-state ["live"])
         (venue-in-state ["disconnected" "awaiting_stream"])) "alert"
    (and (active-talk-in-state ["live"])
         (venue-in-state ["connected"])) "success"
    (< (time-to-active-talk) 0) "alert"
    (< (time-to-active-talk) (* 10 60 1000)) "warning"
    :else "neutral"))

;; -------------------------
;; Components

;; NOTE maybe we should display an approx. audio delay. later we could
;; use the internal microsphone to calculate the exact delay, if on
;; site. It could also be used to detect if on site.

(defn audio-comp []
  [:audio {:auto-play "autoplay" :id "audio"}
   [:source {:src (icecast-url) :data-x 1}]])

(defn countdown-comp [millis]
  [:span (format-countdown millis)])

(defn server-start-button-comp []
  [:button { :on-click start-server-action } (t "setup")])

(defn titlebar-comp [title status]
  [:div {:class "titlebar clearfix"}
   [:h4 {:class "title"} title
    [:span {:class (str status " badge float-right")}
     (condp = status
       "success" (goog.string/unescapeEntities "&#x2713;")
       "neutral" "-"
       "warning" "!"
       "alert" "!")]]])

(defn server-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   (cond
     (venue-in-state ["offline"]) ; offline
     [:div {:class "holder"}
      [:p {:class "launchable-in"} "Available in "
       [:span {:class "countdown", :id "time-till-provisioning"}
        [countdown-comp (time-to-available)]]]
      [:p [:a {:class "button success tiny expanded server-start-button disabled"} "LAUNCH SERVER"]]]

     (venue-in-state ["available"]) ; available
     [:div {:class "holder"}
      [:p {:class "launch-advice"} "Start Server Now!"]
      [:p [:a {:class "button success tiny expanded server-start-button"
           :on-click start-server-action} "LAUNCH SERVER"]]]

     (venue-in-state ["provisioning"]) ; provisioning
     [:div {:class "secondary progress server-progress", :role "progressbar",
            :tabindex "0", :aria-valuenow (server-progress), :aria-valuemin "0",
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
  [:select {:on-change #(select-device-action %)
            :value (venue-device-id-or-name)}
   (doall (map device-option-comp (devices)))])

(defn device-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   [:div.status-bar
    [audio-meter-comp]
   [device-select-comp]]])

(defn talk-actionbar-comp []
  [:div {:class "actionbar clearfix"}
   (cond
     (= nil (active-talk)) ; none
     [:div {:class "holder"}
      [:div.status-bar
        [:a {:href "/talks/new"} ">> Schedule your next Talk"]]]

     (active-talk-in-state ["prelive"]) ; prelive
     [:div {:class "holder talk-phase2"}
      [:div.status-bar
        [:span {:class "label scheduled-start"} "Scheduled Start: "
        (format-countdown (time-to-active-talk))
        [:span {:class "clock-msg"}]
        [:span {:class "ago-msg hide"}]]]
      [:a {:class (str "button success talk-start-button expanded"
                       (if (not (venue-in-state ["connected"])) " disabled"))
           :on-click #(start-talk-action (active-talk))} "Start Broadcast"]]

     (active-talk-in-state ["live"]) ; live
     [:div {:class "secondary progress talk-progress"
            :role "progressbar"
            :tabindex "0"
            :aria-valuenow (active-talk-progress)
            :aria-valuemin "0"
            :aria-valuetext (active-talk-progress " percent")
            :aria-valuemax "100"}
      [:div {:class "progress-meter", :style
             {:width (active-talk-progress "%")}}
       [:p {:class "progress-meter-text"}
        [countdown-comp (active-talk-runtime)]]]
      [:a {:href "#"
           :on-click #(end-talk-action (active-talk))
           :class "button tiny alert talk-stop-button hollow has-tip tip-top"
           :data-tooltip ""
           :aria-haspopup "true"
           :data-disable-hover "false"
           :tabindex "1",
           :title "Are you sure you want to stop the stream early?"}
       "Stop Broadcast"]])])

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

;; TODO nick: make it have a fixed with so the audio meter doesn't jump
(defn on-air-comp []
  (let [on (and (venue-in-state ["connected"])
                (active-talk-in-state ["live"]))]
    [:div {:class (str "label on-air" (if on " success" ""))}
     (if on "ON AIR" "OFF AIR")]))







;; ------------------------------ BEGIN UNSTYLED

;; NOTE nick: I think it would suffice to just turn div id:
;; 'instructions' into a modal popup. We could add a cancel button
;; which resets the device selection to none. Clicking cancel will
;; then automatically remove the modal
(defn instructions-for-butt-comp []
  [:div.reveal.tiny {:id "instructions", :data-closable ""}
   [:h4 "Streaming with B.U.T.T."]
   [:p.lead "Simply download the config file below and import it into B.U.T.T. by clicking \"Settings\" > \"Import\" inside the B.U.T.T. application, and push \"Play.\""]
   [:p.clearfix [:a.button.small.hollow.btn-white.btn-hover-red.float-left {:href "#" :data-close ""}
     "Cancel"]
        [:a.button.small.secondary.float-right {:href "./butt"}
    [:svg
      {:dangerouslySetInnerHTML { :__html "<use xlink:href='#icon-download' />" } }]"download config file"]]])


(defn instructions-for-darkice-comp []
  [:div.reveal {:id "instructions", :data-closable ""}
   [:h4 "Streaming with darkice"]
   [:p.lead "Download the config file below and run with..."]
   [:code "sudo darkice -c <your-config-file>"]
   [:p.lead "Note: root permissions are require to use posix realtime scheduling."]
   [:p.clearfix [:a.button.small.hollow.btn-white.btn-hover-red.float-left {:href "#" :data-close ""}
     "Cancel"]
        [:a.button.small.secondary.float-right {:href "./darkice"}
    [:svg
      {:dangerouslySetInnerHTML { :__html "<use xlink:href='#icon-download' />" } }]"download config file"]]])

(defn instructions-for-generic-comp []
  [:div.reveal.medium {:id "instructions", :data-closable ""}
   [:h4 "Streaming with a Generic Icecast Client"]
   [:ul
    [:li "Host/Server: " (:public_ip_address (venue))]
    [:li "User: source"]
    [:li "Password: " (:source_password (venue))]
    [:li "Mountpoint: " (:mount_point (venue))]
    [:p.lead]
   ]
   [:p.text-center [:a.button.small.hollow.btn-red.btn-hover-yellow {:href "#" :data-close ""} "Cancel"]]])


(defn talk-listing-talk-comp [talk]
  ^{:key (:id talk)}
  [:tr
   ;; TODO phil: use momentjs to format date
   ;; https://github.com/cljsjs/packages/tree/master/moment
   ;; http://momentjs.com/
   [:td (:starts_at talk)]
   ;; TODO phil: use momentjs to format relative time in words
   [:td (format-countdown (time-to (millis (:starts_at talk))))]
   [:td (:title talk)]])

(defn talk-listing-comp []
  [:table
   [:tr
    [:th "Scheduled"]
    [:th "Countdown"]
    [:th "Title"]]
   (doall (map talk-listing-talk-comp (talks)))])
;; ------------------------------ END UNSTYLED

(defn instructions-comp []
  (if (venue-in-state ["awaiting_stream"])
    (condp = (venue-device-name)
      "butt"    [instructions-for-butt-comp]
      "darkice" [instructions-for-darkice-comp]
      "generic" [instructions-for-generic-comp]
      nil nil)))

(defn root-comp []
  [:div {:id "page"}
   (if (venue-in-state ["connected"]) [audio-comp])
   [:div.clearfix.row {:id "venue-header"}
    [:div {:class "medium-6 columns"}
     [:h1 {:class "venue-title"} (venue-name)]
     [:p {:class "talk-title"}
      [active-talk-title-prefix-comp] (active-talk-title)]]
    [:div {:class "medium-6 columns dashboard"}
     [on-air-comp]
     ;;[audio-meter-comp]
     [:div {:class "medium-float-right hide listeners"}
      [:span {:class "listener-count"} "210"]
      [:svg
      {:dangerouslySetInnerHTML { :__html "<use xlink:href='#icon-play' />" }}]]]]
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
   ;;[:div "fregs: " (str (:freqs @audio))]
   ;;[:div "freq-data: " (str (:freq-data @audio))]
   ;;[:div "freq-mags: " (str (:freq-mags @audio))]
   ;; TODO phil: separate into two listings
   ;;[talk-listing-comp] ;; "live" "prelive"
   ;;[talk-listing-comp] ;; "postlive" "processing" "archived"
   ])

;; -------------------------
;; Initialize

(defn inc-now [state-map]
  (update-in state-map [:now] inc))

(defn start-timer []
  (js/setInterval #(swap! state inc-now) 1000))

(defn venue-channel []
  (:channel (venue)))

(defn setup-faye []
  (print "Subscribe" (venue-channel))
  (.subscribe js/fayeClient (venue-channel)
              #(venue-message-handler (js->clj %  :keywordize-keys true))))

(defn mount-root []
  (reagent/render [root-comp] (.getElementById js/document "app"))
  (reagent/render [instructions-comp] (.getElementById js/document "modals"))
  )


(defn init! []
  (start-timer)
  (setup-faye)
  ;;(setup-audio-meter)
  (if (= (venue-state) "offline")
    (js/setTimeout request-availability-action (max 2000 (time-to-available))))
  (mount-root))

;; https://www.bignerdranch.com/blog/music-visualization-with-d3-js/
