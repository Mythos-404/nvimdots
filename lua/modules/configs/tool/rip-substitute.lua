return function()
    require("rip-substitute").setup({
        popupWin = {
            width = 40,
            border = "single",
        },
        prefill = {
            normal = "treesitterNode", -- "cursorWord"|"treesitterNode"|false
            visual = "selectionFirstLine", -- "selectionFirstLine"|false
        },
        keymaps = { -- normal & visual mode
            confirm = "<CR>",
            abort = "q",
            prevSubst = "<C-p>",
            nextSubst = "<C-n>",
        },
        incrementalPreview = {
            replacementDisplay = "sideBySide", -- "sideBySide"|"overlay"
        },
        regexOptions = {
            -- pcre2 enables lookarounds and backreferences, but performs slower
            pcre2 = true,
            -- disable if you use named capture groups (see README for details)
            autoBraceSimpleCaptureGroups = true,
        },
        editingBehavior = {
            -- Experimental. When typing `()` in the `search` lines, automatically
            -- add `$n` to the `replacement` line.
            autoCaptureGroups = false,
        },
    })
end
