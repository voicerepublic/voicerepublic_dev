(ns vrng.helpers
  "Reagent components.")

(if js/audit (.log js/console "loading vrng.helpers"))

(defn icon [icon]
  [:svg {:dangerouslySetInnerHTML
         {:__html (str "<use xlink:href='#icon-" icon "' />")}}])
