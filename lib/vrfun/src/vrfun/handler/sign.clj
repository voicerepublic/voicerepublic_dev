(ns vrfun.handler.sign
  (:require [ataraxy.core :as ataraxy]
            [ataraxy.response :as response]
            [integrant.core :as ig]
            [vrfun.aws4-auth :refer [aws4-authorisation zone->host]])
  (:import [java.text DateFormat SimpleDateFormat]
           [java.util UUID Date TimeZone]))

(def method "PUT")
(def service "s3")

(def ^DateFormat iso8601-date-format
  (doto (SimpleDateFormat. "yyyyMMdd'T'HHmmss'Z'")
    (.setTimeZone (TimeZone/getTimeZone "UTC"))))

(defn- generate-random-uri
  [file-name bucket]
  (clojure.string/join "/" (list "" bucket (UUID/randomUUID) file-name)))

(defn- auth-header [file-name mime-type bucket aws-zone access-key secret-key]
  (let [headers {"Host" (zone->host aws-zone)
                 "x-amz-content-sha256" "UNSIGNED-PAYLOAD"
                 "x-amz-date" (.format iso8601-date-format (Date.))}
        uri (generate-random-uri file-name bucket)]

    {:headers
     (merge {:Authorization
             (aws4-authorisation method uri "" headers ""
                                 aws-zone service access-key secret-key)}
            headers)
     :upload-url (str "https://" (zone->host aws-zone) uri)
     :uri uri}))

(defn- s3-sign-aws4 [bucket aws-zone access-key secret-key]
  (fn [{{:keys [mime-type file-name]} :params}]
    {:status 200
     :body (pr-str (auth-header file-name mime-type bucket aws-zone access-key secret-key))}))

(defn- s3-sign []
  (let [bucket (or (System/getenv "BUCKET") "vr-euc1-dev-audio-uploads")
        aws-zone (or (System/getenv "AWS_ZONE") "eu-central-1")
        access-key (or (System/getenv "ACCESS_KEY") "AKIAI7HSKHN3FBT2KAZQ")
        secret-key (or (System/getenv "SECRET_KEY") "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")]
    (s3-sign-aws4 bucket aws-zone access-key secret-key)))

(defmethod ig/init-key :vrfun.handler/sign [_ options]
  (s3-sign))

(defmethod ig/init-key :vrfun.handler/options [_ options]
  (fn [_]
    {:status 200}))
