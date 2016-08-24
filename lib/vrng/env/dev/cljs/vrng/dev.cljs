(ns ^:figwheel-no-load vrng.dev
  (:require [vrng.core :as core]
            [figwheel.client :as figwheel :include-macros true]))

(enable-console-print!)

(figwheel/watch-and-reload
  :websocket-url "ws://192.168.178.81/:3449/figwheel-ws"
  :jsload-callback core/mount-roots)

(core/init!)
