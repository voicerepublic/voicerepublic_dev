(ns vrng.talks.waveform)

(defn normalize-volume-points
  "applies normalization and caps volume at 1"
  [volumes]
  (map #(min 1 (/ (.pow js/Math % 1) 2)) volumes))

(defn volume->points
  "returns 2-tuples given volume data points"
  [volume width]
  (let [step-size (/ width (count volume))]
    (map-indexed #(vector (* %1 step-size) %2) volume)
    ))

(defn top-half
  "scales tuple y coordinates to create top half of waveform"
  [points height]
  (map #(assoc % 1 (+ (* (nth % 1) (/ height -2)) (/ height 2))) points))

(defn bottom-half
  "scales tuple y coordinates to create bottom half of waveform"
  [points height]
  (map #(assoc % 1 (+ (* (nth % 1) (/ height 2)) (/ height 2))) points))

(defn points->coords
  "returns actual svg coordinates given tuples"
  [points height]
  (concat (top-half points height) (reverse (bottom-half points height))))

(defn coords->polygon
  "returns svg polygon given points"
  [coords]
  [:polygon {:points (clojure.string/join " " (map #(clojure.string/join "," %) coords))}])

(defn volume->polygon
  "chains functions for convenience"
  [volume width height]
  (-> volume (volume->points width) (points->coords height) (coords->polygon)))

(defn add-vectors 
  "fills up shorter vector with 0s and adds both vectors together"
  [right left]
  (mapv +
        (if (< (count right) (count left))
            (concat right (repeat 0) )
            right)
        (if (> (count right) (count left))
            (concat left (repeat 0) )
            left)))

(defn waveform-svg
  "returns actual svg waveform component"
  [{left :left right :right duration :duration} width height]
  [:svg.waveform {:style {:position "absolute" :padding "0 126px 0 138px" :color "#ffed00"}
                  :viewBox (str "0 0 " width " " height) :preserveAspectRatio "none" :x 0 :y 0 :width "100%" :height height}
   (let [volume-points (add-vectors right left)]
     (volume->polygon (normalize-volume-points volume-points) width height))
   ])

(defn string->clj
  "transforms json strings to native clojure datastructures"
  [string]
  (js->clj (.parse js/JSON string) :keywordize-keys true))

(defn is-valid-volume-data
  "checks whether there is usable volume data"
  [data]
  (not (clojure.string/blank? data)))

(defn waveform-comp
  "returns waveform reagent component given noise level as input"
  [width height data]
  (if (is-valid-volume-data data) 
   (waveform-svg (string->clj data) width height) ))
