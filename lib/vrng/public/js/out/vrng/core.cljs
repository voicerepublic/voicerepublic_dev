(ns vrng.core
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]))

(defonce state (atom (js->clj (.-initialState js/window) :keywordize-keys true)))

;; shortcuts

(def venue-state (:state (:venue @state)))
(def venue-name (:name (:venue @state)))

(defn next-talk []
  (:talks @state))


;; -------------------------
;; Views

(defn home-page []
  [:section { :id "claim" :class "dark" }
   [:div { :class "row" }
    [:header
     [:h1 venue-name]
     [:h2 venue-state]]]])


;; -------------------------
;; Initialize app

(defn mount-root []
  (reagent/render [home-page] (.getElementById js/document "app")))

(defn init! []
  (mount-root))
