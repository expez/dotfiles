{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-try "0.4.1"]
                  [lein-pprint "1.1.1"]
                  [lein-ancient "0.6.2"]
                  [lein-describe "0.2.0"]
                  [lein-exec "0.3.2"]
                  [lein-simpleton "1.2.0"]
                  [refactor-nrepl "0.3.0-SNAPSHOT"]
                  [cider/cider-nrepl "0.9.0-SNAPSHOT"]
                  [lein-vanity "0.2.0"]]
        :repl-options {:init (do
                               (set! *print-length* 200)
                               (require '[clojure.repl :refer :all]
                                        '[print.foo :refer :all]))}
        :jvm-opts ["-XX:-OmitStackTraceInFastThrow"]
        :dependencies [[pjstadig/humane-test-output "0.6.0"]
                       [print-foo "1.0.1"]
                       [spyscope "0.1.5"]
                       [acyclic/squiggly-clojure "0.1.2-SNAPSHOT"]
                       [leiningen #=(leiningen.core.main/leiningen-version)]
                       [io.aviso/pretty "0.1.16"]
                       [com.cemerick/pomegranate "0.3.0"]
                       [im.chit/vinyasa "0.3.0"]]
        :injections [(require 'spyscope.core)
                     (require '[vinyasa.inject :as inject])
                     (require 'io.aviso.repl)

                     (inject/in ;; the default injected namespace is `.`

                      ;; note that `:refer, :all and :exclude can be used
                      [vinyasa.inject :refer [inject [in inject-in]]]
                      [vinyasa.lein :exclude [*project*]]

                      ;; imports all functions in vinyasa.pull
                      [vinyasa.pull :all]

                      ;; same as [cemerick.pomegranate :refer [add-classpath
                      ;;          get-classpath resources]]
                      [cemerick.pomegranate add-classpath get-classpath resources]

                      ;; inject into clojure.core
                      clojure.core
                      [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]

                      ;; inject into clojure.core with prefix
                      clojure.core >
                      [clojure.pprint pprint]
                      [clojure.java.shell sh])

                     (require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}}
