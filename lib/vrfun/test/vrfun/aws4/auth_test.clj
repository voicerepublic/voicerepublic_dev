(ns vrfun.aws4.auth-test
  (:require [vrfun.aws4.auth :as sut]
            [vrfun.aws4.utils :as u]
            [clojure.test :refer :all]
            [clojure.string :as s]))

;; Directory where the test suite lives
(def test-suite-dir  "vrfun/suite")

;; Test data, global in whole test suite
(def timestamp "20150830T123600Z")
(def short-timestamp "20150830")
(def region "us-east-1")
(def service "service")
(def secret-key "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY")
(def access-key-id "AKIDEXAMPLE")

(def test-requests '("get-header-key-duplicate"
                     "get-header-value-multiline"
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
                     "post-sts-header-before"
                     "post-sts-header-after"
                     "post-vanilla"
                     "post-vanilla-empty-query-value"
                     "post-vanilla-query"
                     "post-x-www-form-urlencoded"
                     "post-x-www-form-urlencoded-parameters"
                     "get-relative"
                     "get-relative-relative"
                     "get-slash"
                     "get-slash-dot-slash"
                     "get-slashes"
                     "get-slash-pointless-dot"
                     "get-space"))

(deftest smoke-test
  (is (+ 2 2) 4))

(deftest signature-tests
  (testing "AWS V4 signature:"
    (doseq [name test-requests]
      (let [input-request (u/resource-string test-suite-dir name "req")
            canonical-request (u/resource-string test-suite-dir name "creq")
            string-to-sign (u/resource-string test-suite-dir name "sts")
            authorization (u/resource-string test-suite-dir name "authz")

            {:keys [method uri headers query payload]} (u/parse-request input-request)
            canonical-headers (sut/canonical-headers headers)
            string-to-sign (sut/string-to-sign {:timestamp timestamp
                                                :method method :uri uri
                                                :query query :payload payload
                                                :short-timestamp short-timestamp
                                                :region region :service service
                                                :headers canonical-headers})]

        (testing (str "creating canonical request for " name)
          (is
           (= canonical-request
              (sut/canonical-request {:method method :uri uri
                                      :query query :payload payload
                                      :headers (sut/canonical-headers headers)}))
           (str "returns valid canonical request for " name)))

        (testing (str "creating string-to-sign for " name)
          (is
           (= string-to-sign
              (sut/string-to-sign {:timestamp timestamp :method method
                                   :uri uri :query query :payload payload
                                   :short-timestamp short-timestamp
                                   :region region :service service
                                   :headers canonical-headers}))
           (str "returns valid string-to-sign for " name)))

        (testing (str "creating signature for " name)
          (is
           (= (u/parse-signature authorization)
              (sut/signature {:secret secret-key
                              :short-timestamp short-timestamp
                              :region region :service service
                              :string-to-sign string-to-sign}))
           (str "returns valid signature for " name)))

        (testing (str "creating authorization header for " name)
          (is
           (= authorization
              (sut/authorize {:method method :uri uri :query query :headers headers
                                       :payload payload :region region :service service
                                       :access-key access-key-id :secret secret-key}))
           (str "returns valid authorization header for " name)))))))
