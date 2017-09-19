(ns vrng.uploads.core
  (:require [vrng.util :as util]
            [reagent.core :as reagent :refer [atom]]
            [ajax.core :refer [GET PUT]]
            [clojure.core.async :as async :refer [put!]]))

;; There are potentially multiple upload components per site, this is why the state
;; can't be local to the reagent app
(defonce uploaders (atom {}))

;; Allowed audio types for talk upload
(def audio-types "audio/aac,audio/mp4,audio/mpeg,audio/ogg,audio/wav,audio/webm,audio/mp3,audio/3gpp")

(defn- safety-handler 
  "Messge user gets when leaving during ongoing upload"
  []
  (fn []
    "There are ongoing uploads, wait for them to finish"))

(defn- ns->input-field
  [ns]
  (str ns "-file-input"))

(defn- init-safety-net! 
  "Safety net prevents user to accidentally abort uploads"
  []
  (set! (.-onbeforeunload js/window) safety-handler))

(defn- remove-safety-net! []
  (set! (.-onbeforeunload js/window) nil))

(defn- file-selected-action
  "Actual action triggered by user"
  [event]
  (let [target  (.-target event)
        id (.-id target)
        file (.item (.-files target) 0)
        uploader (@uploaders id)
        upload-queue (:upload-queue uploader)]
    (.log js/console id)
    (init-safety-net!)
    (put! upload-queue {:file file})))

(defn- file->map [f]
  {:name (.-name f)
   :type (.-type f)
   :size (.-size f)})

(defn- sign-file
  "Signs a file and puts signature onto the signed channel"
  [server-url signed file]
  (let [f (file->map (file :file))]
    (GET server-url {:format :json
                     :params {:mime-type (f :type)
                              :file-name (f :name)}
                     :handler #(async/put! signed [% file])})))

(defn- update-progress
  "Updates the progress given the update event coming from the upload target server"
  [ns event]
  (let [percent (/ (.-loaded event) (.-total event))]
    (swap! uploaders assoc-in [(ns->input-field ns) :progress] percent)))

(defn- upload-handler
  "Removes safety net once download finished"
 [ns]
 (fn []
   (remove-safety-net!)))

(defn- upload-file
  "Uploads file using upload-url from data"
  [ns [data file]]
  (let [{:keys [headers upload-url]} (cljs.reader/read-string data)
        {file :file} file]
    (swap! uploaders assoc-in [(ns->input-field ns) :last-upload-url] upload-url)
    (PUT upload-url {:format :json
                     :headers headers
                     :body file 
                     :progress-handler (partial update-progress ns)
                     :handler (upload-handler ns)})))

(defn polar-to-cartesian [center-x center-y radius angle-in-degrees]
  (let [angle-in-radians (/ (* (- angle-in-degrees 90) Math/PI) 180)]
    {:x (+ center-x (* radius (.cos js/Math angle-in-radians)))
     :y (+ center-y (* radius (.sin js/Math angle-in-radians)))}))

(defn describe-arc
  "http://jsbin.com/quhujowota/1/edit?html,js,output"
  [x y radius start-angle end-angle]
  (let [start          (polar-to-cartesian x y radius end-angle)
        end            (polar-to-cartesian x y radius start-angle)
        large-arc-flag (if (<= (- end-angle start-angle) 180) "0" "1")]
    (clojure.string/join " " ["M" (:x start) (:y start)
                      "A" radius radius 0 large-arc-flag 0 (:x end) (:y end)])))

(defn s3-pipe
  "Sets up async pipelines to-sign->signed->uploaded"
  [ns uploaded {server-url :server-url}]
  (let [signed (async/chan)
        to-sign (async/chan)]
    (async/pipeline-async 3 signed (partial sign-file server-url signed) to-sign)
    (async/pipeline-async 3 uploaded (partial upload-file ns) signed)
  to-sign))
  
(defn- make-uploader!
  "Returns the newly created uploader (as a map)."
 [ns]
  (let [uploader-name (ns->input-field ns) 
        uploaded (async/chan 20)
        uploader {:file-input uploader-name
                  :progress 0.0
                  :uploaded uploaded
                  :upload-queue (s3-pipe ns uploaded
                                         {:server-url "http://localhost:3002/sign"})}]
    (swap! uploaders assoc uploader-name uploader)
    uploader))

(defn- extract-file-path
  "Returns path including uuid and filename"
  [upload-url]
  (-> upload-url
       (clojure.string/split #"/")
       (#(str (last (drop-last %)) "/" (last %)))))

(defn- ns->tag-name
  "Returns tag-name matching the talk model given the namespace"
  [ns]
  (let [db-id (if (= ns "audio") "user_override" ns)]
  (str "talk[" db-id "_uuid]")))

(defn- hidden-uuid-comp
  "Returns hidden field with file-path as value"
  [ns upload-url]
  (let [file-path (extract-file-path upload-url)]
    [:input {:name (ns->tag-name ns) 
           :type "hidden" :id (str ns "_uuid")
           :value (or file-path "")}]))

(defn- progress-comp
  "Given progress [0.0 - 1.0] draws progress bar"
  [progress]
  [:svg  {:width 40
          :height 40
          :viewBox "0 0 100 100"
          :xmlns "http://www.w3.org/2000/svg"
          :style {:vertical-align "middle"
                  :margin "0 0 0 10px"
                  :display (if (= progress 0.0) "none" "inline")}}
   [:path {:fill "none"
           :stroke (if (= progress 1.0) "#54c667" "#54c6c6")
           :stroke-width 20
           :d (describe-arc 50 50 30 0 (* 359.99 progress))}]])

(defn root-comp
  "Actual upload component"
  [ns types]
  (let [uploader (make-uploader! ns)
        file-input (:file-input uploader)]
    (fn [ns]
      [:div.row.upload-full 
       [:div.medium-12.columns.text-center
        (hidden-uuid-comp ns ((@uploaders (ns->input-field ns)) :last-upload-url))
        [:div.text-center]
        [:div.button-progress-box.text-center
         [:label.button.hollow.btn-purple.btn-hover-yellow
          {:on-click #(.click (util/element-by-id file-input))}
          "Choose a file to upload"]
         [:input.show-for-sr {:id file-input
                              :type "file"
                              :on-change file-selected-action
                              :accept types}]
         (progress-comp ((@uploaders (ns->input-field ns)) :progress))]]])))

(defn mount-root []
  (reagent/render [root-comp "audio" audio-types] (.getElementById js/document "audio-app"))
  (reagent/render [root-comp "slides"] (.getElementById js/document "slides-app")))

(defn init! []
  (mount-root))
