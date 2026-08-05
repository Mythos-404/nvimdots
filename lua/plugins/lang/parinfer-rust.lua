local Plugin = require("core.plugin")

return Plugin:new("Mythos-404/parinfer-rust")
    :lazy(true)
    :ft("query", "fennel", "scheme", "clojure", "lisp", "hy", "yuck", "dune")
    :build("cargo build --release")
