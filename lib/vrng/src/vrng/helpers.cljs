(ns vrng.helpers
  "Reagent components.")

(defn icon [icon]
  [:svg {:dangerouslySetInnerHTML
         {:__html (str "<use xlink:href='#icon-" icon "' />")}}])
