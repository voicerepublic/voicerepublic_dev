(ns vrng.core
  (:require
   vrng.talk
   vrng.venue))

(defn init! []
  (vrng.talk/mount-root)
  (vrng.venue/mount-root))
