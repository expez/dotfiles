{:user {:plugins [[lein-ancient "1.0.0-RC3" :exclusions [org.clojure/clojure]]
                  [com.jakemccrary/lein-test-refresh "0.25.0" :exclusions [org.clojure/clojure]]
                  [lein-vanity "0.2.0" :exclusions [org.clojure/clojure]]]
        :license {:author "Lars Andersen"
                  :email  "expez@expez.com"}
        :test-refresh {:quiet true}
        :jvm-opts ["-XX:-OmitStackTraceInFastThrow"]
        :dependencies []}
 :repl {:dependencies [[clj-commons/spyscope "0.1.48"]]
        :repl-options {:init (do
                               (set! *print-length* 200)
                               (require 'spyscope.core))}
        :injections []}}
