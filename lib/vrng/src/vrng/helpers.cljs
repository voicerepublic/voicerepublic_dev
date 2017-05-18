(ns vrng.helpers
  "Reagent components.")

(if js/audit (.log js/console "loading vrng.helpers"))

(defn icon
  ([name] (icon name ""))
  ([name color]
   [:svg {:style {:color color}
          :dangerouslySetInnerHTML
          {:__html (str "<use xlink:href='#icon-" name "' />")}}]))
