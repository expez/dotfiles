{:user {:plugins [
                  [lein-localrepo "0.5.3" :exclusions [org.clojure/clojure]]
                  [lein-ancient "0.6.10" :exclusions [org.clojure/clojure]]
                  [lein-license "0.1.6" :exclusions [org.clojure/clojure]]
                  [com.jakemccrary/lein-test-refresh "0.18.1" :exclusions [org.clojure/clojure]]
                  [lein-vanity "0.2.0" :exclusions [org.clojure/clojure]]]
        :license {:author "Lars Andersen"
                  :email  "expez@expez.com"}
        :test-refresh {:quiet true}
        :jvm-opts ["-XX:-OmitStackTraceInFastThrow"]
        :dependencies [[pjstadig/humane-test-output "0.8.1"]]}
 :repl {:dependencies [[print-foo "1.0.2"]
                       [spyscope "0.1.6"]
                       [alembic "0.3.2"]
                       [acyclic/squiggly-clojure "0.1.6"]
                       [im.chit/vinyasa.inject "0.4.7"]
                       [im.chit/vinyasa.reimport "0.4.7"]
                       [im.chit/vinyasa.reflection "0.4.7"]]
        :repl-options {:init (do
                               (set! *print-length* 200)
                               (require '[spyscope.core]
                                        'pjstadig.humane-test-output)
                               (pjstadig.humane-test-output/activate!))}
        :injections [(require '[vinyasa.inject :as inject])
                     (inject/in ;; the default injected namespace is `.`

                      ;; inject into clojure.core
                      clojure.core
                      [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
                      [print.foo :all]

                      ;; inject into clojure.core with prefix
                      clojure.core >
                      [vinyasa.reimport reimport]
                      [clojure.pprint pprint]
                      [clojure.java.shell sh]
                      [clojure.repl :all])]}}
