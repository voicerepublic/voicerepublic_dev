(defproject vrfun "0.1.0"
  :description "AWS4 signing service used for S3"
  :url "http://www.voicerepublic.com"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.9.0-alpha20"]
                 [ring/ring-codec "1.0.1"]
                 [duct/core "0.6.1"]
                 [duct/module.logging "0.3.0"]
                 [duct/module.web "0.6.0"]
                 [duct/module.ataraxy "0.2.0"]
                 [io.netty/netty-all "4.0.27.Final"]]
  :plugins [[duct/lein-duct "0.10.0"]]
  :main ^:skip-aot vrfun.main
  :resource-paths ["resources" "target/resources"]
  :prep-tasks     ["javac" "compile" ["run" ":duct/compiler"]]
  :profiles
  {:dev  [:project/dev :profiles/dev]
   :repl {:prep-tasks   ^:replace ["javac" "compile"]
          :repl-options {:init-ns user}}
   :uberjar {:aot :all}
   :profiles/dev {}
   :project/dev  {:source-paths   ["dev/src"]
                  :resource-paths ["dev/resources"]
                  :dependencies   [[integrant/repl "0.2.0"]
                                   [eftest "0.3.1"]
                                   [kerodon "0.8.0"]]}})
