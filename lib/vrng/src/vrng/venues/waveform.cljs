(ns vrng.venues.waveform)

(defn waveform-svg
  "returns actual svg waveform component"
  [{left :left right :right length :length}]
  [:svg {:x 0 :y 0 :width 50 :height 50}
    [:rect {:x 10 :y 10 :width 10 :height 10}]])

(defn test-data
  "temporary test data, value are close to reality"
  []
  {:left [0.00067 0.00046 0.00055 0.00079 0.00067 0.00067 0.00055]
   :right [0.00055 0.00046 0.00055 0.00055 0.00055 0.00055 0.00046 0.00055 0.00055 0.00055]
   :length 2.12})
  
(defn waveform
  "returns waveform reagent component given noise level input"
  ([amplitude-data]
  (let [amplitude (js->clj amplitude-data)]
    (waveform-svg amplitude)))
  ([]
   (waveform test-data)))



  
