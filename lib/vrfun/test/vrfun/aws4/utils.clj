(ns vrfun.aws4.utils
  (:require  [clojure.test :as t]
             [clojure.string :as s]))

(defn- append-header
  [old to-append]
  (if (nil? old)
    to-append
    (str old "," to-append)))

(defn- to-header
  "returns header map entry from string"
  [acc next]
  (if (and (re-matches #"\S*=\S*" next) (not (re-matches #"\S+==" next)))
    acc
    (let [[key val] (s/split next #":")]
      (if (nil? val)
        (update acc (last (keys acc)) append-header (s/replace (or key "") #"\s+" ""))
        (update acc key append-header (s/replace (or val "") #"\s+" " "))))))

(defn- to-payload
  [acc next]
  (if (and (re-matches #"\S*=\S*" next) (not (re-matches #"\S+==" next)))
    next
    acc))

(defn- extract-uri
  [path]
  (->> (or (re-find #"\S+\?" path) (str path "?"))
       (drop-last)
       (s/join "")))

(defn- extract-query
  [path]
  (s/join "" (rest (or (re-find #"\?\S+" path) ""))))

(defn- query->pair
  [query]
  (->> (s/split query #"&")
       (map #(s/split % #"="))
       (into [])))

(defn parse-request
  "returns parsed request from .req file strings"
  [req]
  (let [line-wise (filter #(not (s/blank? %)) (s/split req #"\n"))
        method (second (re-matches #"(\S*) .*" (first line-wise)))
        path (second (re-matches #"\S* (.*) .*" (first line-wise)))]
    (merge {:method method
            :uri (extract-uri path)
            :query (query->pair (extract-query path))}
           (assoc {} :headers (reduce to-header {} (rest line-wise)))
           (assoc {} :payload (reduce to-payload "" (rest line-wise))))))

(defn parse-signature
  [authz]
  (-> (re-find #"Signature=\S+" authz)
      (s/split #"=")
      (last)))

(defn resource-string [dir name ext]
  (-> (str dir "/" name "/" name "." ext)
      (clojure.java.io/resource)
      (slurp)))


