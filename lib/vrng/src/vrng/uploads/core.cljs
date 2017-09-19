(ns vrng.uploads.core
  (:require [vrng.util :as util]
            [reagent.core :as reagent :refer [atom]]
            [s3-beam.client :as s3]
            [ajax.core :refer [GET PUT]]
            [clojure.core.async :as async :refer [put!]]))

(defonce uploaders (atom {}))
(def audio-types "audio/aac,audio/mp4,audio/mpeg,audio/ogg,audio/wav,audio/webm,audio/mp3,audio/3gpp")

(defn- safety-handler []
  (fn []
    "There are ongoing uploads, wait for them to finish"))

(defn- init-safety-net! []
  (set! (.-onbeforeunload js/window) safety-handler))

(defn- remove-safety-net! []
  (set! (.-onbeforeunload js/window) nil))

(defn- file-selected-action [event]
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
  [server-url signed file]
  (let [f (file->map (file :file))]
    (GET server-url {:format :json
                     :params {:mime-type (f :type)
                              :file-name (f :name)}
                     :handler #(async/put! signed [% file])})))


(defn- update-progress
  [ns event]
  (let [percent (/ (.-loaded event) (.-total event))]
    (swap! uploaders assoc-in [(str ns "-file-input") :progress] percent)))

(defn upload-handler
 [ns]
 (fn []
   (remove-safety-net!)))

(defn upload-file
  [ns [data file]]
  (let [{:keys [headers upload-url]} (cljs.reader/read-string data)
        {file :file} file]
    (swap! uploaders assoc-in [(str ns "-file-input") :last-upload-url] upload-url)
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

(defn progress-comp [progress]
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

(defn s3-pipe
  [ns uploaded {server-url :server-url}]
  (let [signed (async/chan)
        to-sign (async/chan)]
    (async/pipeline-async 3 signed (partial sign-file server-url signed) to-sign)
    (async/pipeline-async 3 uploaded (partial upload-file ns) signed)
  to-sign))
  
(defn make-uploader!
  "Returns the newly created uploader (as a map)."
 [ns]
  (let [uploader-name (str ns "-file-input")
        uploaded (async/chan 20)
        uploader {:file-input uploader-name
                  :progress 0.0
                  :uploaded uploaded
                  :upload-queue (s3-pipe ns uploaded
                                         {:server-url "http://localhost:3002/sign"})}]
    (swap! uploaders assoc uploader-name uploader)
    uploader))

(defn- extract-file-path [upload-url]
  (-> upload-url
       (clojure.string/split #"/")
       (#(str (last (drop-last %)) "/" (last %)))))

(defn- ns->tag-name [ns]
  (let [db-id (if (= ns "audio") "user_override" ns)]
  (str "talk[" db-id "_uuid]")))

(defn- hidden-uuid [ns upload-url]
  (let [file-path (extract-file-path upload-url)]
    [:input {:name (ns->tag-name ns) 
           :type "hidden" :id (str ns "_uuid")
           :value (or file-path upload-url "")}]))

(defn root-comp
  [ns types]
  (let [uploader (make-uploader! ns)
        file-input (:file-input uploader)]
    (fn [ns]
      [:div.row.upload-full 
       [:div.medium-12.columns.text-center
        (hidden-uuid ns ((@uploaders (str ns "-file-input")) :last-upload-url))
        [:div.text-center]
        [:div.button-progress-box.text-center
         [:label.button.hollow.btn-purple.btn-hover-yellow
          {:on-click #(.click (util/element-by-id file-input))}
          "Choose a file to upload"]
         [:input.show-for-sr {:id file-input
                              :type "file"
                              :on-change file-selected-action
                              :accept types}]
         (progress-comp ((@uploaders (str ns "-file-input")) :progress))]]])))

(defn mount-root []
  (reagent/render [root-comp "audio" audio-types] (.getElementById js/document "audio-app"))
  (reagent/render [root-comp "slides"] (.getElementById js/document "slides-app")))

(defn init! []
  (mount-root))
