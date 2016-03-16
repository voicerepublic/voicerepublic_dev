(defproject vrng "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}

  :dependencies [[org.clojure/clojure "1.8.0" :scope "provided"]
                 [org.clojure/clojurescript "1.7.228" :scope "provided"]
                 [reagent "0.5.1"]
                 [reagent-forms "0.5.15"]
                 [reagent-utils "0.1.7"]
                 [secretary "1.2.3"]]

  :plugins [[lein-cljsbuild "1.1.1"]]

  :min-lein-version "2.5.0"

  :clean-targets ^{:protect false}
  [:target-path
   [:cljsbuild :builds :app :compiler :output-dir]
   [:cljsbuild :builds :app :compiler :output-to]]

  :resource-paths ["public"]

  :cljsbuild {:builds {:app {:source-paths ["src"]
                             :compiler {:output-to "public/js/app.js"
                                        :output-dir "public/js/out"
                                        :asset-path   "/out"
                                        :optimizations :none
                                        :pretty-print  true}}}}

  :profiles {:dev {:dependencies [[prone "1.0.2"]
                                  [lein-doo "0.1.6"]
                                  [pjstadig/humane-test-output "0.7.1"]
                                  [lein-figwheel "0.5.0-6"]
                                  [org.clojure/tools.nrepl "0.2.12"]
                                  [com.cemerick/piggieback "0.2.1"]]

                   :plugins [[lein-figwheel "0.5.0-6"]
                             [lein-doo "0.1.6"]]

                   :doo {:build "test"}

                   :injections [(require 'pjstadig.humane-test-output)
                                (pjstadig.humane-test-output/activate!)]

                   :figwheel {:http-server-root "public"
                              :nrepl-port 7002
                              :nrepl-middleware ["cemerick.piggieback/wrap-cljs-repl"]
                              :css-dirs ["public/css"]}

                   :cljsbuild {:builds {:test {:source-paths ["src" "test"]
                                               :compiler {:output-to "resources/public/js/testable.js"
                                                          :main vrng.runner
                                                          :optimizations :none}}

                                        :app {:source-paths ["env/dev/cljs"]
                                              :compiler {:main "vrng.dev"
                                                         :source-map true}}}}

                   :prod {:cljsbuild {:jar true
                                      :builds {:app
                                               {:source-paths ["env/prod/cljs"]
                                                :compiler
                                                {:optimizations :advanced
                                                 :pretty-print false}}}}}}})
