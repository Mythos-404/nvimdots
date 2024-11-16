---@diagnostic disable: undefined-global

return {
    s(
        { trig = "#!", desc = "Sh shebang" },
        fmt([[#!/usr/bin/env sh {}]], {
            c(1, {
                t("-eo pipefail"),
                t("-evxo pipefail"),
            }),
        })
    ),

    s(
        { trig = "#!bash", desc = "Bash shebang" },
        fmt([[#!/usr/bin/env bash {}]], {
            c(1, {
                t("-eo pipefail"),
                t("-evxo pipefail"),
            }),
        })
    ),
}
