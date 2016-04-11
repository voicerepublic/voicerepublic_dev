(ns vrng.core
  (:require
   vrng.talk
   vrng.venue))

(defn mount-roots []
  (vrng.talk/mount-root)
  (vrng.venue/mount-root))

(defn init! []
  (mount-roots))
