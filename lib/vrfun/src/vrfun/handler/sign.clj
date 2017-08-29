(ns vrfun.handler.sign
  (:require [ataraxy.core :as ataraxy]
            [s3-beam.handler :as s3b]
            [ataraxy.response :as response] 
            [integrant.core :as ig]))

(defn- s3-sign []
  (let [bucket (or (System/getenv "BUCKET") "vr-euc1-dev-audio-uploads")
        aws-zone (or (System/getenv "AWS_ZONE") "eu-central-1")
        access-key (or (System/getenv "ACCESS_KEY") "access_key")
        secret-key (or (System/getenv "SECRET_KEY") "secret_key")]
    (s3b/s3-sign bucket aws-zone access-key secret-key)))

(defmethod ig/init-key :vrfun.handler/sign [_ options]
  (s3-sign))
