(ns vrfun.handler.sign-test
  (:require [clojure.test :refer :all]
            [kerodon.core :refer :all]
            [kerodon.test :refer :all]
            [integrant.core :as ig]
            [vrfun.handler.sign :as sign]))

(def handler
  (ig/init-key :vrfun.handler/sign {}))

(deftest smoke-test 
  (testing "sign endpoint exists"
    (-> (session handler)
        (visit "sign" :request {:params {:mime-type "foo"}})
        (has (status? 200) "page exists"))))
