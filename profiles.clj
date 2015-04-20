{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-ancient "0.6.3"]
                  [refactor-nrepl "1.0.4-SNAPSHOT"]
                  [cider/cider-nrepl "0.9.0-SNAPSHOT"]
                  [com.jakemccrary/lein-test-refresh "0.7.0"]
                  [lein-vanity "0.2.0"]]
        :repl-options {:init (do
                               (set! *print-length* 200)
                               (require '[clojure.repl :refer :all]
                                        '[print.foo :refer :all]
                                        '[spyscope.core]
                                        'pjstadig.humane-test-output)
                               (pjstadig.humane-test-output/activate!))}
        :jvm-opts ["-XX:-OmitStackTraceInFastThrow"]
        :dependencies [[pjstadig/humane-test-output "0.6.0"]
                       [print-foo "1.0.1"]
                       [spyscope "0.1.5"]
                       [alembic "0.3.2"]
                       [acyclic/squiggly-clojure "0.1.2-SNAPSHOT"]
                       [im.chit/vinyasa.inject "0.3.4"]
                       [im.chit/vinyasa.reimport "0.3.4"]
                       [im.chit/vinyasa.reflection "0.3.4"]
                       [im.chit/vinyasa.lein "0.3.4"]
                       [leiningen #=(leiningen.core.main/leiningen-version)]]
        :injections [(require '[vinyasa.inject :as inject])
                     (inject/in ;; the default injected namespace is `.`

                      ;; inject into clojure.core
                      clojure.core
                      [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]

                      ;; inject into clojure.core with prefix
                      clojure.core >
                      [vinyasa.reimport reimport]
                      [clojure.pprint pprint]
                      [clojure.java.shell sh])]}}
