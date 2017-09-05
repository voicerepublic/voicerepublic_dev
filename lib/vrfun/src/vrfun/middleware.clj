(ns vrfun.middleware

(:require [integrant.core :as ig]
            [ring.util.response :refer [header]]))

(defmethod ig/init-key ::cors [_ _]
  (fn [handler]
    (fn [request]
      (-> (handler request)
          (header "Access-Control-Allow-Origin" "*")
          (header "Access-Control-Allow-Methods" "GET")
          (header "Access-Control-Allow-Headers" "X-CSRF-Token, Content-Type")))))
