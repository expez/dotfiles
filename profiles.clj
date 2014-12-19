{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-try "0.4.1"]
                  [lein-pprint "1.1.1"]
                  [lein-ancient "0.5.4"]
                  [lein-describe "0.2.0"]
                  [lein-exec "0.3.2"]
                  [lein-simpleton "1.2.0"]
                  [cider/cider-nrepl "0.8.2-SNAPSHOT"]
                  [lein-vanity "0.2.0"]
                  [org.timmc/nephila "0.2.0"]]
        :repl-options {:nrepl-middleware [io.aviso.nrepl/pretty-middleware]
                       :init (do
                               (set! *print-length* 200)
                               (require '[clojure.tools.namespace.repl
                                          :refer [refresh]])
                               (require '[clojure.repl :refer :all]))}
        :jvm-opts ["-XX:-OmitStackTraceInFastThrow"]
        :dependencies [[org.clojure/tools.trace "0.7.8"]
                       [pjstadig/humane-test-output "0.6.0"]
                       [print-foo "0.4.7"]
                       [spyscope "0.1.5"]
                       [org.clojure/tools.namespace "0.2.5"]
                       [leiningen #=(leiningen.core.main/leiningen-version)]
                       [im.chit/iroh "0.1.11"]
                       [io.aviso/pretty "0.1.13"]
                       [im.chit/vinyasa "0.2.2"]
                       [com.cemerick/pomegranate "0.3.0"]]
        :injections [(require '[vinyasa.inject :as inject]
                              'io.aviso.repl
                              'spyscope.core)
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
                      [iroh.core .> .? .* .% .%>]

                      ;; inject into clojure.core with prefix
                      clojure.core >
                      [clojure.pprint pprint]
                      [clojure.tools.trace trace deftrace
                       trace-forms trace-ns trace-vars]
                      [clojure.java.shell sh])

                     (require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}}
