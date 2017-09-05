(ns vrfun.aws4-auth 
  (:require [clojure.string :as str])
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

(defn s3-bucket-get-request [url bucket region access-key-id secret-key]
  (let [uri (str "/" url)
        headers {"Content-Length" "0"
                 "Host" bucket
                 "x-amz-content-sha256" EMPTY_SHA256
                 "x-amz-date" (.format iso8601-date-format (Date.))}
        request (DefaultFullHttpRequest. HttpVersion/HTTP_1_1 HttpMethod/GET uri)
        request-headers (.headers request)]
    (doseq [[k v] headers]
      (.set request-headers ^String k ^String v))
    (.set request-headers "Authorization"
      (aws4-authorisation "GET" uri headers region "s3" access-key-id secret-key))
    request))

(defn s3-bucket-put-request [url content-sha256 content-length mime-type bucket
                             region access-key-id secret-key]
  (let [uri (str "/" url)
        headers {"Host" bucket
                 "Content-Length" (str content-length)
                 "Content-Type" mime-type
                 "x-amz-content-sha256" content-sha256
                 "x-amz-date" (.format iso8601-date-format (Date.))}
        request (DefaultHttpRequest. HttpVersion/HTTP_1_1 HttpMethod/PUT uri)
        request-headers (.headers request)]
    (doseq [[k v] headers]
      (.set request-headers ^String k ^String v))
    (.set request-headers "Authorization"
      (aws4-authorisation "PUT" uri headers region "s3" access-key-id secret-key))
    request))

;; ---------- AWS authentication

(declare aws4-auth-canonical-request aws4-auth-canonical-headers sha-256 hmac-256
  to-utf8)

(defn auth-header [file-name mime-type bucket aws-zone access-key secret-key] 
  (let [headers {"Host" bucket
                 "x-amz-content-sha256" "UNSIGNED-PAYLOAD" 
                 "x-amz-date" (.format iso8601-date-format (Date.))}]

    {:headers
     {:Authorization (aws4-authorisation "POST" "/" headers aws-zone "s3" access-key secret-key)
      :Host bucket
      :x-amz-content-sha256 "UNSIGNED-PAYLOAD"
      :x-amz-date (.format iso8601-date-format (Date.))}
     :upload-url (str "https://s3-eu-central-1.amazonaws.com/vr-euc1-dev-audio-uploads/" file-name)
     }))

(defn aws4-authorisation [method uri headers region service access-key-id secret-key]
  (let [canonical-headers (aws4-auth-canonical-headers headers)
        timestamp (get canonical-headers "x-amz-date")
        short-timestamp (.substring ^String timestamp 0 8)
        string-to-sign (str
                         "AWS4-HMAC-SHA256\n"
                         timestamp "\n"
                         short-timestamp "/" region "/" service "/aws4_request" "\n"
                         (sha-256 (to-utf8 (aws4-auth-canonical-request method uri
                                             canonical-headers))))
        signing-key (-> (hmac-256 (to-utf8 (str "AWS4" secret-key)) short-timestamp)
                        (hmac-256 region)
                        (hmac-256 service)
                        (hmac-256 "aws4_request"))
        signature (hmac-256 signing-key string-to-sign)]
    (str
      "AWS4-HMAC-SHA256 "
      "Credential=" access-key-id "/" short-timestamp "/" region "/" service
      "/aws4_request, "
      "SignedHeaders=" (str/join ";" (keys canonical-headers)) ", "
      "Signature=" (as-hex-str signature))))

(declare stringify-headers)

(defn aws4-auth-canonical-request [method uri canonical-headers]
  (str
    method \newline
    uri    \newline
    \newline                          ; query string
    (stringify-headers canonical-headers)   \newline
    (str/join ";" (keys canonical-headers)) \newline
    (get canonical-headers "x-amz-content-sha256" EMPTY_SHA256)))

(defn aws4-auth-canonical-headers [headers]
  (into (sorted-map)
    (map (fn [[k v]] [(str/lower-case k) (str/trim v)]) headers)))

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
