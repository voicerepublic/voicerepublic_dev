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

(def test-suite-dir  "vrfun/suite")

(defn resource-string [name ext]
  (-> (str test-suite-dir "/" name "/" name "." ext)
      (clojure.java.io/resource)
      (slurp)))

;; test data, global in whole test suite
(def timestamp "20150830T123600Z")
(def short-timestamp "20150830")
(def region "us-east-1")
(def service "service")
(def secret-key "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
(def access-key-id "AKIDEXAMPLE")

(def test-cases '(
                  "get-header-key-duplicate"
                  ;"get-header-value-multiline"
                  "get-header-value-order"
                  "get-header-value-trim"
                  "get-unreserved"
                  "get-utf8"
                  "get-vanilla"
                  "get-vanilla-empty-query-key"
                  "get-vanilla-query"
                  "get-vanilla-query-order-key"
                  "get-vanilla-query-order-key-case"
                  "get-vanilla-query-order-value"
                  "get-vanilla-query-unreserved"
                  "get-vanilla-utf8-query"
                  "post-header-key-case"
                  "post-header-key-sort"
                  "post-header-value-case"
                  "post-vanilla"
                  "post-vanilla-empty-query-value"
                  "post-vanilla-query"
                  ;"post-x-www-form-urlencoded"
                  ;"post-x-www-form-urlencoded-parameters"
                  ))

(deftest post-vanilla
  (let [{:keys [method uri headers]} (parse-request (resource-string "post-vanilla" "req"))
        canonical-headers (sut/aws4-auth-canonical-headers headers)]

    (testing "creating canoncial request"
      (doseq [name test-cases]
        (prn name)
        (let [input-string (resource-string name "req")
              {:keys [method uri headers]} (parse-request input-string)]
          (is
           (= input-string)
           (sut/aws4-auth-canonical-request method uri (sut/aws4-auth-canonical-headers headers)))
          (str "Returns valid canonical request for " name))))

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
