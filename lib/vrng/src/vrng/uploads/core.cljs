(ns vrng.uploads.core
  (:require [vrng.util :as util]
            [reagent.core :as reagent :refer [atom]]
            [s3-beam.client :as s3]
            [ajax.core :refer [GET PUT]]
            [clojure.core.async :as async :refer [put!]]))

(defonce uploaders (atom {}))

(defn file-selected-action [event]
  (let [target  (.-target event)
        id (.-id target)
        file (.item (.-files target) 0)
        uploader (@uploaders id)
        upload-queue (:upload-queue uploader)]
    (.log js/console uploader)
    (.log js/console id)
    (.log js/console file)
    (put! upload-queue {:file file})))

(defn file->map [f]
  {:name (.-name f)
   :type (.-type f)
   :size (.-size f)})

(defn sign-file
  [server-url signed file]
  (let [f (file->map (file :file))]
    (GET server-url {:format :json
                     :params {:mime-type (f :type)
                              :file-name (f :name)}
                     :handler #(async/put! signed [% file])})))

(defn update-progress
  [namespace event]
  (let [percent (/ (.-loaded event) (.-total event))]
    (swap! uploaders assoc-in [(str namespace "-file-input") :progress] percent)))

(defn upload-file
  [namespace [data file]]
  (let [{:keys [headers upload-url]} (cljs.reader/read-string data)
        {file :file} file]
    (PUT upload-url {:format :json
                     :headers headers
                     :body file 
                     :progress-handler (partial update-progress namespace)
                     :handler #(prn "Successfully uploaded")})))

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
  [namespace uploaded {server-url :server-url}]
  (let [signed (async/chan)
        to-sign (async/chan)]
    (async/pipeline-async 3 signed (partial sign-file server-url signed) to-sign)
    (async/pipeline-async 3 uploaded (partial upload-file namespace) signed)
  to-sign))
  
(defn make-uploader!
  "Returns the newly created uploader (as a map)."
 [namespace]
  (let [uploader-name (str namespace "-file-input")
        uploaded (async/chan 20)
        uploader {:file-input uploader-name
                  :progress 0.0
                  :uploaded uploaded
                  :upload-queue (s3-pipe namespace uploaded {:server-url "http://localhost:3002/sign"})}]
    (swap! uploaders assoc uploader-name uploader)
    uploader))

(defn root-comp [namespace]
  (let [uploader (make-uploader! namespace)
        file-input (:file-input uploader)]
    (fn [namespace]
      [:div.row.upload-full 
       [:div.medium-12.columns.text-center
        [:div.text-center]
        [:div.button-progress-box.text-center
         [:label.button.hollow.btn-purple.btn-hover-yellow
          {:on-click #(.click (util/element-by-id file-input))}
          "Choose a file to upload"]
         [:input.show-for-sr {:id file-input
                              :type "file"
                              :on-change file-selected-action}]
         (progress-comp ((@uploaders (str namespace "-file-input")) :progress))]]])))

(defn mount-root []
  (reagent/render [root-comp "audio"] (.getElementById js/document "app")))

(defn init! []
  (mount-root))
