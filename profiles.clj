{:user {:plugins [[lein-localrepo "0.5.3"]
                  [lein-try "0.4.1"]
                  [lein-pprint "1.1.1"]
                  [lein-ancient "0.5.4"]
                  [lein-exec "0.3.2"]
                  [lein-simpleton "1.2.0"]
                  [cider/cider-nrepl "0.1.0-SNAPSHOT"]
                  [lein-difftest "2.0.0"]
                  [org.timmc/nephila "0.2.0"]]
        :repl-options {:nrepl-middleware
                       [cider.nrepl.middleware.info/wrap-info
                        cider.nrepl.middleware.inspect/wrap-inspect]
                       :init (do
                               (require [clojure.tools.namespace.repl
                                         :refer [refresh]])
                               (require [clojure.repl] :refer :all)
                               (require [alembic.still :refer [load-project]]))}
        :dependencies [[org.clojure/tools.namespace "0.2.4"]
                       [org.clojure/tools.trace "0.7.5"]
                       [alembic "0.2.0"]
                       [slamhound "1.5.1"]
                       [print-foo "0.4.7"]
                       [com.cemerick/pomegranate "0.3.0"]]}}
