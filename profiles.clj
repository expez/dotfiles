{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-try "0.4.1"]
                  [lein-pprint "1.1.1"]
                  [lein-ancient "0.5.4"]
                  [lein-describe "0.2.0"]
                  [lein-exec "0.3.2"]
                  [lein-simpleton "1.2.0"]
                  [cider/cider-nrepl "0.7.0-SNAPSHOT"]
                  [com.aphyr/prism "0.1.1"]
                  [lein-vanity "0.2.0"]
                  [lein-difftest "2.0.0"]
                  [com.jakemccrary/lein-test-refresh "0.5.0"]
                  [org.timmc/nephila "0.2.0"]]
        :repl-options {:nrepl-middleware
                       [cider.nrepl.middleware.apropos/wrap-apropos
                        cider.nrepl.middleware.classpath/wrap-classpath
                        cider.nrepl.middleware.complete/wrap-complete
                        cider.nrepl.middleware.info/wrap-info
                        cider.nrepl.middleware.inspect/wrap-inspect
                        cider.nrepl.middleware.macroexpand/wrap-macroexpand
                        cider.nrepl.middleware.resource/wrap-resource
                        cider.nrepl.middleware.stacktrace/wrap-stacktrace
                        cider.nrepl.middleware.test/wrap-test
                        cider.nrepl.middleware.trace/wrap-trace]
                       :init (do
                               (set! *print-length* 200)
                               (require '[clojure.tools.namespace.repl
                                          :refer [refresh]])
                               (require '[clojure.repl :refer :all])
                               (require '[alembic.still :refer [load-project]]))}
        :dependencies [[org.clojure/tools.namespace "0.2.4"]
                       [org.clojure/tools.trace "0.7.8"]
                       [alembic "0.2.0"]
                       [pjstadig/humane-test-output "0.6.0"]
                       [print-foo "0.4.7"]
                       [spyscope "0.1.4"]
                       [leiningen #=(leiningen.core.main/leiningen-version)]
                       [im.chit/vinyasa "0.2.2"]
                       [com.aphyr/prism "0.1.1"]
                       [com.cemerick/pomegranate "0.3.0"]]
        :injections [(require 'spyscope.core)
                     (require 'vinyasa.inject)
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
                      [clojure.java.shell sh])

                     (require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}}
