(ns vrng.venues.state
  (:require
      [reagent.core :as reagent :refer [atom]]
      [vrng.util :as u :refer [state]]
))

(defonce page-state (atom {:messages []
                           :autostart false
                           :launched false
                           :instructions true
                           :dropdown-menu-open false
                           :talkbar-expanded false
                           :help-text-open false
                           :hide-stop-button false
                           :device-name (:device_name (:venue @state))
                           :stats {:listener_count 0}}))

(defonce user
  (atom (js->clj (.-user js/window) :keywordize-keys true)))
