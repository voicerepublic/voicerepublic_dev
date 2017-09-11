(ns vrfun.aws4-auth-test
  (:require [vrfun.aws4-auth :as sut]
            [clojure.test :refer :all]
            [clojure.string :as s]))

(deftest smoke-test
  (is (+ 2 2) 4))

(defn to-header
  "returns header map entry from string"
  [acc next]
  (let [[key val] (s/split next #":")]
    (assoc acc key val)))

(defn parse-request
  "returns parsed request from .req file strings"
  [req]
  (let [line-wise (s/split req #"\n")
        [method uri] (s/split (first line-wise) #" ")]
    (merge {:method method
            :uri uri}
           (assoc {} :headers (reduce to-header {} (rest line-wise))))))

(defn parse-signature
  [authz]
  (-> (re-find #"Signature=\S+" authz)
      (s/split #"=")
      (last)))

;; test data, global in whole test suite
(def timestamp "20150830T123600Z")
(def short-timestamp "20150830")
(def region "us-east-1")
(def service "service")
(def secret-key "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
(def access-key-id "AKIDEXAMPLE")

(deftest post-vanilla
  (let [{:keys [method uri headers]}
        (parse-request (slurp
                        (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.req")))
        canonical-headers (sut/aws4-auth-canonical-headers headers)]

    (testing "creating canoncial request"
      (is
       (= (slurp (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.creq"))
          (sut/aws4-auth-canonical-request method uri (sut/aws4-auth-canonical-headers headers)))
       "Returns valid canonical request"))

    (testing "creating string-to-sign"
      (is
       (= (slurp (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.sts"))
          (sut/string-to-sign timestamp method uri short-timestamp
                              region service canonical-headers))))

    (testing "creating signature"
      (let [string-to-sign (sut/string-to-sign timestamp method uri
                                             short-timestamp region service canonical-headers)]
      (is
       (= (parse-signature
           (slurp (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.authz")))
          (sut/signature secret-key short-timestamp region service string-to-sign)))))

    (testing "creating authorization header")
    (is
     (= (slurp (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.authz"))
        (sut/aws4-authorisation method uri headers region service access-key-id secret-key)))))
