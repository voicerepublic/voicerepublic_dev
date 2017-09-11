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
(defn upload-file
  [[data file]]
  (let [{:keys [headers upload-url]} (cljs.reader/read-string data)
        {file :file} file]
    (PUT upload-url {:format :json
                     :headers headers
                     :body file 
                     :handler #(prn "successfully uploaded file")})))

(defn s3-pipe
  [uploaded {server-url :server-url}]
  (let [signed (async/chan)
        to-sign (async/chan)]
    (async/pipeline-async 3 signed (partial sign-file server-url signed) to-sign)
    (async/pipeline-async 3 uploaded upload-file signed)
  to-sign))
  
(defn make-uploader!
  "Returns the newly created uploader (as a map)."
 [namespace]
  (let [uploader-name (str namespace "-file-input")
        uploaded (async/chan 20)
        uploader {:file-input uploader-name
                  :uploaded uploaded
                  :upload-queue (s3-pipe uploaded {:server-url "http://localhost:3001/sign"})}]
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
                              :on-change file-selected-action}]]]])))

(defn mount-root []
  (reagent/render [root-comp "audio"] (.getElementById js/document "app")))

(defn init! []
  (mount-root))
