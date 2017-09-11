(ns vrfun.aws4-auth-test
  (:require [vrfun.aws4-auth :as sut]
            [clojure.test :refer :all]))

(deftest smoke-test
  (is (+ 2 2) 4))

(deftest post-vanilla
  (let [method "POST"
        uri "/"
        timestamp "20150830T123600Z"
        short-timestamp "20150830"
        region "us-east-1"
        service "service"
        secret-key "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY"
        headers {"HOST" "example.amazonaws.com"
                 "X-Amz-Date" "20150830T123600Z"}
        canonical-headers (sut/aws4-auth-canonical-headers headers)]

    (testing "post-vanilla: canoncial request"

      (is
       (= (slurp (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.creq"))
          (sut/aws4-auth-canonical-request method uri (sut/aws4-auth-canonical-headers headers)))
       "Returns valid canonical request"))

    (testing "post-vanilla: string-to-sign"
      (is
       (= (slurp (clojure.java.io/resource "vrfun/suite/post-vanilla/post-vanilla.sts"))
          (sut/string-to-sign timestamp method uri short-timestamp
                              region service canonical-headers))))

    (testing "post-vanilla: signature"
      (let [string-to-sign (sut/string-to-sign timestamp method uri
                                             short-timestamp region service canonical-headers)]
      (is
       (= "5da7c1a2acd57cee7505fc6676e4e544621c30862966e37dddb68e92efbe5d6b"
          (sut/signature secret-key short-timestamp region service string-to-sign
                         )))))))
