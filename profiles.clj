{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-try "0.4.1"]
                  [lein-pprint "1.1.1"]
                  [lein-ancient "0.5.4"]
                  [lein-describe "0.2.0"]
                  [lein-exec "0.3.2"]
                  [lein-simpleton "1.2.0"]
                  [cider/cider-nrepl "0.7.0-SNAPSHOT"]
                  [lein-difftest "2.0.0"]
                  [org.timmc/nephila "0.2.0"]]
        :repl-options {:nrepl-middleware
                       [cider.nrepl.middleware.classpath/wrap-classpath
                        cider.nrepl.middleware.complete/wrap-complete
                        cider.nrepl.middleware.info/wrap-info
                        cider.nrepl.middleware.inspect/wrap-inspect
                        cider.nrepl.middleware.stacktrace/wrap-stacktrace
                        cider.nrepl.middleware.trace/wrap-trace]
                       :init (do
                               (require '[clojure.tools.namespace.repl
                                          :refer [refresh]])
                               (require '[clojure.repl :refer :all])
                               (require '[alembic.still :refer [load-project]]))}
        :dependencies [[org.clojure/tools.namespace "0.2.4"]
                       [org.clojure/tools.trace "0.7.5"]
                       [alembic "0.2.0"]
                       [slamhound "1.5.2"]
                       [print-foo "0.4.7"]
                       [spyscope "0.1.4"]
                       [im.chit/vinyasa "0.1.8"]
                       [ritz/ritz-nrepl-middleware "0.7.0"]
                       [leiningen "2.3.3"]
                       [com.cemerick/pomegranate "0.3.0"]]
        :injections [(require 'spyscope.core)
                     (require 'vinyasa.inject)
                     (vinyasa.inject/inject 'clojure.core
                                            '[[vinyasa.inject inject]
                                              [vinyasa.pull pull]
                                              [vinyasa.lein lein]
                                              [vinyasa.reimport reimport]])
                     (vinyasa.inject/inject 'clojure.core '>
                                            '[[cemerick.pomegranate add-classpath get-classpath resources]
                                              [clojure.tools.namespace.repl refresh]
                                              [clojure.repl apropos dir doc find-doc source pst
                                               [root-cause >cause]]
                                              [clojure.pprint pprint]
                                              [clojure.java.shell sh]])]}}
