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
        access-key (or (System/getenv "ACCESS_KEY") "AKIAI7HSKHN3FBT2KAZQ")
        secret-key (or (System/getenv "SECRET_KEY") "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")]
    (s3-sign-aws4 bucket aws-zone access-key secret-key)))

(defmethod ig/init-key :vrfun.handler/sign [_ options]
  (s3-sign))

(defmethod ig/init-key :vrfun.handler/options [_ options]
  (fn [_]
    {:status 200}))
