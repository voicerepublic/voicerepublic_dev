(ns vrng.core
  (:require vrng.talk
            vrng.venue))

(enable-console-print!)

(defn node-exists? [selector]
  (.querySelector js/document selector))

;; mount namespaces based on rails' controller/action
(defn mount-roots []
  (cond
    (node-exists? ".talks-show") (vrng.talk/init!)
    (node-exists? ".venues-show") (vrng.venue/init!)))

(defn init! []
  (mount-roots))

(defn fig-reload []
  (init!)
  (print "figwheel reload complete!"))

(init!)
