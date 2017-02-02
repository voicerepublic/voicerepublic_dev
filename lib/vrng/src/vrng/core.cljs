(ns vrng.core
  (:require vrng.talks.core
            vrng.venues.core
            vrng.embeds.core
            [reagent.core :as reagent]))

(enable-console-print!)

(defn node-exists? [selector]
  (.querySelector js/document selector))

;; mount namespaces based on rails' controller/action
(defn mount-roots []
  (cond
    (node-exists? ".embed-show") (vrng.embeds.core/init!)
    (node-exists? ".talks-show") (vrng.talks.core/init!)
    (node-exists? ".venues-show") (vrng.venues.core/init!)))

(defn init! []
  (mount-roots))

(defn fig-reload []
  (init!)
  (print "figwheel reload complete!"))

(def css-transition-group
  (reagent/adapt-react-class js/React.addons.CSSTransitionGroup))

(init!)
