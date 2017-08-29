(ns vrng.uploads.core
  (:require [vrng.util :as util]
            [s3-beam.client :as s3]
            [reagent.core :as reagent :refer [atom]]
            [clojure.core.async :as async :refer [put!]]))

(defonce uploaders (atom {}))

(defn file-selected-action [event]
  (let [target  (.-target event)
        id (.-id target)
        file (.item (.-files target) 0)
        uploader (@uploaders id)
        upload-queue (:upload-queue uploader)]
    ;;(.log js/console uploader)
    ;;(.log js/console id)
    ;;(.log js/console file)
    (put! upload-queue file)))

(defn make-uploader!
  "Returns the newly created uploader (as a map)."
  [namespace]
  (let [uploader-name (str namespace "-file-input")
        uploaded (async/chan 20)
        uploader {:file-input uploader-name
                  :uploaded uploaded
                  :upload-queue (s3/s3-pipe uploaded {:server-url "http://vrfun/sign"})}]
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
