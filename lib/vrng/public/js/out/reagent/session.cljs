(ns reagent.session
  (:refer-clojure :exclude [get get-in reset! swap!])
  (:require [reagent.core :as reagent :refer [atom]]))

(def state (atom {}))

(defn get
  "Get the key's value from the session, returns nil if it doesn't exist."
  [k & [default]]
  (clojure.core/get @state k default))

(defn put! [k v]
  (clojure.core/swap! state assoc k v))

(defn get-in
 "Gets the value at the path specified by the vector ks from the session,
  returns nil if it doesn't exist."
  [ks & [default]]
  (clojure.core/get-in @state ks default))

(defn swap!
  "Replace the current session's value with the result of executing f with
  the current value and args."
  [f & args]
  (apply clojure.core/swap! state f args))

(defn clear!
  "Remove all data from the session and start over cleanly."
  []
  (clojure.core/reset! state {}))

(defn reset! [m]
  (clojure.core/reset! state m))

(defn remove!
  "Remove a key from the session"
  [k]
  (clojure.core/swap! state dissoc k))

(defn assoc-in!
  "Associates a value in the session, where ks is a
   sequence of keys and v is the new value and returns
   a new nested structure. If any levels do not exist,
   hash-maps will be created."
  [ks v]
  (clojure.core/swap! state #(assoc-in % ks v)))

(defn get!
  "Destructive get from the session. This returns the current value of the key
  and then removes it from the session."[k & [default]]
  (let [cur (get k default)]
    (remove! k)
    cur))

(defn get-in!
  "Destructive get from the session. This returns the current value of the path
  specified by the vector ks and then removes it from the session."
  [ks & [default]]
    (let [cur (clojure.core/get-in @state ks default)]
      (assoc-in! ks nil)
      cur))

(defn update!
  "Updates a value in session where k is a key and f
   is the function that takes the old value along with any
   supplied args and return the new value. If key is not
   present it will be added."
  [k f & args]
  (clojure.core/swap!
    state
    #(apply (partial update % k f) args)))
  
(defn update-in!
  "'Updates a value in the session, where ks is a
   sequence of keys and f is a function that will
   take the old value along with any supplied args and return
   the new value. If any levels do not exist, hash-maps
   will be created."
  [ks f & args]
  (clojure.core/swap!
    state
    #(apply (partial update-in % ks f) args)))
