;; http://caniuse.com/#feat=audio-api
(ns vrng.sporktrum
  (:require [reagent.core :as reagent :refer [atom]]))

(if js/audit (.log js/console "loading vrng.sporktrum"))

(enable-console-print!)

;; --- UTILS

(defn to-non-typed-array
  "Convert a typed array to an array"
  [typed-array]
  (.apply js/Array [] typed-array))

(defn freq-for-bin
  "Get the corresponding frequency for a bin in the fft"
  [bin-index sample-rate fft-size]
  (* bin-index (/ sample-rate fft-size)))

;; --- CROSS BROWSER COMPAT

(set! (.-AudioContext js/window)
      (or (.-AudioContext js/window)
          (.-webkitAudioContext js/window)))

;; --- STATE & HELPERS

(defonce audio (atom {:volume 0}))

(swap! audio assoc :browser (.browser js/window))

(if (not (= "ie" (:browser @audio)))
  (swap! audio assoc :context (js/AudioContext.)))

(defn context []
  (:context @audio))

;; --- BUSINESS LOGIC

(defn calculate []
  (js/requestAnimationFrame calculate)
  (let [analyser (:analyser @audio)
        uint8-freq-data (:freq-data @audio)]
    (.getByteFrequencyData analyser uint8-freq-data)
    (let [freq-data (to-non-typed-array uint8-freq-data)
          freq-mags (map-indexed
                     (fn [idx freq] {:freq freq :mag (nth freq-data idx) })
                     (:freqs @audio))]
      (swap! audio assoc :freq-mags freq-mags)
      (swap! audio assoc :volume (/ (reduce + (map :mag freq-mags)) 16))
      )))

(defn configure [source]
  (let [analyser (.createAnalyser (context))]
    (set! (.-fftSize analyser) 32); 2048)
    (set! (.-minDecibels analyser) -85)
    (set! (.-maxDecibels analyser) -25)
    (set! (.-smoothingTimeConstant analyser) 0.9)
    (.connect source analyser)
    (.connect source (.-destination (context)))
    (swap! audio assoc :source source)
    (swap! audio assoc :analyser analyser)
    (swap! audio assoc :sample-rate (.-sampleRate (context)))
    (swap! audio assoc :fft-size (.-fftSize analyser))
    (swap! audio assoc :freq-bin-count (.-frequencyBinCount analyser))
    (swap! audio assoc :freq-data (js/Uint8Array. (:freq-bin-count @audio)))
    (swap! audio assoc :freqs
           (apply array
                  (map #(freq-for-bin % (:sample-rate @audio) (:fft-size @audio))
                       (range 0 (:freq-bin-count @audio)))))
    (js/requestAnimationFrame calculate)))

;; --- MORE HELPERS

(defn source-from-element [element]
  (.createMediaElementSource (context) element))

(defn element-by-id [id]
  (.getElementById js/document id))

;; setup function
(defn setup-analyser-for-media-element [id]
  (configure (source-from-element (element-by-id id))))

(defn audio-meter-bar-comp [freq-mag]
  ^{:key (:freq freq-mag)}
  [:div {:class "bar-holder"}
   [:div {:class "bar"
          :style {:height (str (/ (:mag freq-mag) 2.55) "%")}}]])


;; main component
(defn audio-meter-comp []
  (if (= "ie" (:browser @audio))
    [:div.soundbars.text.center.clearfix.warning
     "(visual audio meter is unsupported by internet explorer)"]
    ;; else
    [:div.soundbars.text-center.clearfix
     [:div {:id "bars"}
      (doall (map audio-meter-bar-comp (:freq-mags @audio)))]]))
