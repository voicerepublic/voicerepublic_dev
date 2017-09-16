(ns vrfun.aws4-auth
  (:require [clojure.string :as str]
            [ring.util.codec :as codec])
  (:import [io.netty.handler.codec.http DefaultHttpRequest
            DefaultFullHttpRequest DefaultHttpResponse
            HttpMethod HttpVersion LastHttpContent DefaultFullHttpResponse
            HttpContent HttpResponse HttpResponseStatus]
           io.netty.buffer.Unpooled
           io.netty.util.CharsetUtil
           java.security.MessageDigest
           [java.text DateFormat SimpleDateFormat]
           [java.util Date TimeZone ArrayList]
           javax.crypto.Mac
           javax.crypto.spec.SecretKeySpec))

(def EMPTY_SHA256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

(def ^DateFormat iso8601-date-format
  (doto (SimpleDateFormat. "yyyyMMdd'T'HHmmss'Z'")
    (.setTimeZone (TimeZone/getTimeZone "UTC"))))

(declare aws4-authorisation as-hex-str)

;; ---------- AWS authentication

(declare aws4-auth-canonical-request aws4-auth-canonical-headers sha-256 hmac-256
         to-utf8)

(def zone->endpoints
  "Mapping of AWS zones to S3 endpoints as documented here:
   http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region"
  {"us-east-1"      "s3"
   "us-west-1"      "s3-us-west-1"
   "us-west-2"      "s3-us-west-2"
   "eu-west-1"      "s3-eu-west-1"
   "eu-central-1"   "s3-eu-central-1"
   "ap-southeast-1" "s3-ap-southeast-1"
   "ap-southeast-2" "s3-ap-southeast-2"
   "ap-northeast-1" "s3-ap-northeast-1"
   "sa-east-1"      "s3-sa-east-1"})

(defn zone->host
  "Maps a zone to the full host name" 
  [zone]
  (str (get zone->endpoints zone) ".amazonaws.com"))

(defn string-to-sign
  [timestamp method uri query payload short-timestamp region service canonical-headers]
  (str
   "AWS4-HMAC-SHA256\n"
   timestamp "\n"
   short-timestamp "/" region "/" service "/aws4_request" "\n"
   (sha-256 (to-utf8 (aws4-auth-canonical-request method uri query payload
                                                  canonical-headers)))))
(defn signing-key
  [secret-key short-timestamp region service]
  (-> (hmac-256 (to-utf8 (str "AWS4" secret-key)) short-timestamp)
                        (hmac-256 region)
                        (hmac-256 service)
                        (hmac-256 "aws4_request")))
  
(defn signature
  [secret-key short-timestamp region service string-to-sign]
  (-> (signing-key secret-key short-timestamp region service)
      (hmac-256 string-to-sign)
      (as-hex-str)))

(defn query->string 
  [query]
  (->> query
      (sort (fn [[k1 v1] [k2 v2]] (compare v1 v2)))
      (map #(map codec/url-encode %))
      (#(map (fn [pair] (clojure.string/join "=" pair)) %))
      (clojure.string/join "&")))

(defn aws4-authorisation [method uri query headers payload region service access-key-id secret-key]
  (let [canonical-headers (aws4-auth-canonical-headers headers)
        timestamp (get canonical-headers "x-amz-date")
        short-timestamp (.substring ^String timestamp 0 8)
        string-to-sign (string-to-sign timestamp method uri query payload short-timestamp region service
                                           canonical-headers)
        signature (signature secret-key short-timestamp region service string-to-sign)]
    (str
     "AWS4-HMAC-SHA256 "
     "Credential=" access-key-id "/" short-timestamp "/" region "/" service
     "/aws4_request, "
     "SignedHeaders=" (str/join ";" (keys canonical-headers)) ", "
     "Signature=" signature)))

(declare stringify-headers)

(defn encode-uri
  [uri]
  (->> (clojure.string/split uri #"/")
       (map codec/url-encode)
       (clojure.string/join "/")
       (#(if (clojure.string/blank? %) "/" %))))

(defn aws4-auth-canonical-request [method uri query payload canonical-headers]
  (str
   method \newline
   (encode-uri uri) \newline
   (query->string query) \newline
   (stringify-headers canonical-headers)   \newline
   (str/join ";" (keys canonical-headers)) \newline
   (or (get canonical-headers "x-amz-content-sha256")
       (sha-256 (to-utf8 payload))
       EMPTY_SHA256)))

(defn aws4-auth-canonical-headers [headers]
  (into (sorted-map)
        (map (fn [[k v]] [(str/lower-case k) (str/trim (or v ""))]) headers)))

(defn stringify-headers [headers]
  (let [s (StringBuilder.)]
    (doseq [[k v] headers]
      (doto s
        (.append k) (.append ":") (.append v) (.append "\n")))
    (.toString s)))

(defn ^bytes to-utf8 [s]
  (.getBytes (str s) "utf-8"))

(defn ^String sha-256 [bs]
  (let [sha (MessageDigest/getInstance "SHA-256")]
    (.update sha ^bytes bs)
    (as-hex-str (.digest sha))))

(defn hmac-256 [secret-key s]
  (let [mac (Mac/getInstance "HmacSHA256")]
    (.init mac (SecretKeySpec. secret-key "HmacSHA256"))
    (.doFinal mac (to-utf8 s))))

;; ---------- Misc

(defn s3-host [region bucket]
  (str bucket ".s3-" region ".amazonaws.com"))

(defn as-hex [bytes]
  (map #(format "%02x" (if (neg? %) (bit-and % 0xFF) %)) bytes))

(defn ^String as-hex-str [bytes]
  (apply str (as-hex bytes)))
