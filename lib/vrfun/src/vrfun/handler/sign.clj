(ns vrfun.handler.sign
  (:require [ataraxy.core :as ataraxy]
            [ataraxy.response :as response] 
            [integrant.core :as ig]
            [vrfun.aws4-auth :refer [auth-header]]))

(defn- s3-sign-aws4 [bucket aws-zone access-key secret-key]
  (fn [{{:keys [mime-type file-name]} :params}]
    (prn mime-type)
    (prn file-name)
    {:status 200
     :body (pr-str (auth-header file-name mime-type bucket aws-zone access-key secret-key))}))

(defn- s3-sign []
  (let [bucket (or (System/getenv "BUCKET") "vr-euc1-dev-audio-uploads")
        aws-zone (or (System/getenv "AWS_ZONE") "eu-central-1")
        access-key (or (System/getenv "ACCESS_KEY") "AKIAIGKSA6ESEFZV4DQA")
        secret-key (or (System/getenv "SECRET_KEY") "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")]
    (s3-sign-aws4 bucket aws-zone access-key secret-key)))

(defmethod ig/init-key :vrfun.handler/sign [_ options]
  (s3-sign))
