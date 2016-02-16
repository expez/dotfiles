{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.3"]
                  [lein-license "0.1.3"]
                  [com.jakemccrary/lein-test-refresh "0.9.0"]
                  [lein-vanity "0.2.0"]]
        :license {:author "Lars Andersen"
                  :email  "expez@expez.com"}
        :test-refresh {:quiet true}
        :jvm-opts ["-XX:-OmitStackTraceInFastThrow"]
        :dependencies [[pjstadig/humane-test-output "0.6.0"]]}
 :repl {:plugins [[refactor-nrepl "2.0.0-SNAPSHOT"]
                  [cider/cider-nrepl "0.11.0-SNAPSHOT"]]
        :dependencies [[print-foo "1.0.1"]
                       [spyscope "0.1.5"]
                       [alembic "0.3.2"]
                       [acyclic/squiggly-clojure "0.1.5"]
                       [im.chit/vinyasa.inject "0.3.4"]
                       [im.chit/vinyasa.reimport "0.3.4"]
                       [im.chit/vinyasa.reflection "0.3.4"]
                       [org.clojure/tools.nrepl "0.2.12"]]
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
                      ;; [vinyasa.reimport reimport]
                      [clojure.pprint pprint]
                      [clojure.java.shell sh]
                      [clojure.repl :all])]}}
