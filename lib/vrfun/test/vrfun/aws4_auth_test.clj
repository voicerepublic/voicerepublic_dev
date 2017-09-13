(ns vrfun.aws4-auth-test
  (:require [vrfun.aws4-auth :as sut]
            [clojure.test :refer :all]
            [clojure.string :as s]))

(deftest smoke-test
  (is (+ 2 2) 4))

(defn append-header
  [old to-append]
  (if (nil? old)
    to-append
    (str old "," to-append)))

(defn to-header
  "returns header map entry from string"
  [acc next]
  (let [[key val] (s/split next #":")]
    (update acc key append-header (s/replace (or val "") #"\s+" " "))))

(defn extract-uri
  [path]
  (s/join "" (drop-last (or (re-find #"\S+\?" path) (str path "?")))))

(defn extract-query
  [path]
  (s/join "" (rest (or (re-find #"\?\S+" path) ""))))

(defn parse-request
  "returns parsed request from .req file strings"
  [req]
  (let [line-wise (s/split req #"\n")
        [method path] (s/split (first line-wise) #" ")]
    (merge {:method method
            :uri (extract-uri path)
            :query (extract-query path)}
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

(def test-cases '("get-header-key-duplicate"
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
                  "post-vanilla"
                  "post-vanilla-empty-query-value"
                  "post-vanilla-query"
                  "post-x-www-form-urlencoded"
                  "post-x-www-form-urlencoded-parameters"))

(deftest signature-tests
  (testing "AWS V4 signature:"
    (doseq [name test-cases]
      (testing (str "creating canonical request for " name)
        (let [input-string (resource-string name "req")
              output-string (resource-string name "creq")
              {:keys [method uri headers query]} (parse-request input-string)]
          (is
           (= output-string
              (sut/aws4-auth-canonical-request method uri query (sut/aws4-auth-canonical-headers headers))))
          (str "Returns valid canonical request for " name)))))

    (doseq [name test-cases]
      (testing (str "creating string-to-sign for " name
        (let [input-string (resource-string name "req")
              output-string (resource-string name "sts")
              {:keys [method uri headers query]} (parse-request input-string)
              canonical-headers (sut/aws4-auth-canonical-headers headers)]
          (is
           (= output-string
              (sut/string-to-sign timestamp method uri query short-timestamp
                                  region service canonical-headers)))))))
  (doseq [name test-cases]
    (testing (str "creating signature for " name)
      (let [input-string (resource-string name "req")
            output-string (resource-string name "authz")
            {:keys [method uri headers query]} (parse-request input-string)
            canonical-headers (sut/aws4-auth-canonical-headers headers)
            string-to-sign (sut/string-to-sign timestamp method uri query
                                               short-timestamp region service canonical-headers)]
        (is
         (= output-string
            (sut/signature secret-key short-timestamp region service string-to-sign))))))

  (doseq [name test-cases]
   (testing (str "creating authorization header for " name)
     (let [input-string (resource-string name "req")
           {:keys [method uri headers query]} (parse-request input-string)
           output-string (resource-string name "authz")]
    (is
     (= output-string
        (sut/aws4-authorisation method uri query headers region service access-key-id secret-key)))))))
