local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local builtin_map = {
    -- Builtin: save & quit
    ["n|<C-s>"] = map_cu("write"):with_noremap():with_silent():with_desc("edit: Save file"),
    ["n|<C-q>"] = map_cr("wq"):with_desc("edit: Save file and quit"),
    ["n|<A-S-q>"] = map_cr("q!"):with_desc("edit: Force quit"),

    -- Builtin: insert mode
    ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("edit: Delete previous block"),
    ["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("edit: Move cursor to left"),
    ["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("edit: Move cursor to line start"),
    ["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("edit: Save file"),
    ["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("edit: Save file and quit"),

    -- Builtin: command mode
    ["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("edit: Left"),
    ["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("edit: Right"),
    ["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("edit: Home"),
    ["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("edit: End"),
    ["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("edit: Delete"),
    ["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("edit: Backspace"),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
        :with_noremap()
        :with_desc("edit: Complete path of current file"),

    -- Builtin: visual mode

    -- Builtin: suckless
    ["n|Y"] = map_cmd("y$"):with_desc("edit: Yank text to EOL"),
    ["n|D"] = map_cmd("d$"):with_desc("edit: Delete text to EOL"),
    ["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("edit: Next search result"),
    ["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("edit: Prev search result"),
    ["n|J"] = map_cmd("mzJ`z"):with_noremap():with_desc("edit: Join next line"),
    ["n|<S-Tab>"] = map_cr("normal za"):with_noremap():with_silent():with_desc("edit: Toggle code fold"),
    ["n|<Esc>"] = map_callback(function()
            _flash_esc_or_noh()
        end)
        :with_noremap()
        :with_silent()
        :with_desc("edit: Clear search highlight"),
    ["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("edit: Toggle spell check"),
}

bind.nvim_load_mapping(builtin_map)

local plug_map = {
    -- Plugin: dial.nvim
    ["n|<C-a>"] = map_callback(function()
        require("dial.map").manipulate("increment", "normal")
    end),
    ["n|<C-x>"] = map_callback(function()
        require("dial.map").manipulate("decrement", "normal")
    end),
    ["v|<C-a>"] = map_callback(function()
        require("dial.map").manipulate("increment", "visual")
    end),
    ["v|<C-x>"] = map_callback(function()
        require("dial.map").manipulate("decrement", "visual")
    end),
    ["n|g<C-a>"] = map_callback(function()
        require("dial.map").manipulate("increment", "gnormal")
    end),
    ["n|g<C-x>"] = map_callback(function()
        require("dial.map").manipulate("decrement", "gnormal")
    end),
    ["v|g<C-a>"] = map_callback(function()
        require("dial.map").manipulate("increment", "gvisual")
    end),
    ["v|g<C-x>"] = map_callback(function()
        require("dial.map").manipulate("decrement", "gvisual")
    end),
    ["n|<A-C-a>"] = map_cmd(
        [[<Cmd>lua require"dial.command".select_augend_normal("extra")<CR><Cmd>let &opfunc="dial#operator#increment_normal"<CR>g@<Cmd>lua require("dial.command").textobj()<CR>]] --> INJECT: lua
    ):with_noremap(),
    ["n|<A-C-x>"] = map_cmd(
        [[<Cmd>lua require"dial.command".select_augend_normal("extra")<CR><Cmd>let &opfunc="dial#operator#decrement_normal"<CR>g@<Cmd>lua require("dial.command").textobj()<CR>]] --> INJECT: lua
    ):with_noremap(),

    -- Plugin: nvim-spider
    ["nox|w"] = map_cmd("<Cmd>lua require('spider').motion('w', { skipInsignificantPunctuation = false })<CR>")
        :with_noremap()
        :with_silent()
        :with_desc("Spider-w"),
    ["nox|e"] = map_cmd("<Cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = false })<CR>")
        :with_noremap()
        :with_silent()
        :with_desc("Spider-w"),
    ["nox|b"] = map_cmd("<Cmd>lua require('spider').motion('b')<CR>")
        :with_noremap()
        :with_silent()
        :with_desc("Spider-w"),

    -- Plugin: persisted.nvim
    ["n|<leader>ss"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("session: Save"),
    ["n|<leader>sl"] = map_cu("SessionLoad"):with_noremap():with_silent():with_desc("session: Load current"),
    ["n|<leader>sd"] = map_cu("SessionDelete"):with_noremap():with_silent():with_desc("session: Delete"),

    -- Plugin: comment.nvim
    ["n|gcc"] = map_callback(function()
            return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
                or et("<Plug>(comment_toggle_linewise_count)")
        end)
        :with_silent()
        :with_noremap()
        :with_expr()
        :with_desc("edit: Toggle comment for line"),
    ["n|gbc"] = map_callback(function()
            return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
                or et("<Plug>(comment_toggle_blockwise_count)")
        end)
        :with_silent()
        :with_noremap()
        :with_expr()
        :with_desc("edit: Toggle comment for block"),
    ["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Toggle comment for line with operator"),
    ["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Toggle comment for block with operator"),
    ["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Toggle comment for line with selection"),
    ["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Toggle comment for block with selection"),

    -- Plugin: flash.nvim
    ["nv|s"] = map_cmd("<Cmd>lua require('flash').jump()<CR>"):with_noremap():with_desc("jump: Goto one char"),
    ["nv|B"] = map_cmd("<Cmd>lua require('flash').treesitter()<CR>"):with_noremap():with_desc("jump: Goto one char"),
    ["o|r"] = map_cmd("<Cmd>lua require('flash').remote()<CR>"):with_silent():with_noremap():with_desc("Remote Flash"),
    ["ox|R"] = map_cmd("<Cmd>lua require('flash').treesitter_search()<CR>"),
    ["c|<c-s>"] = map_cmd("<Cmd>lua require('flash').toggle()<CR>")
        :with_silent()
        :with_noremap()
        :with_desc("Toggle Flash Search"),

    -- Plugin: nvim-treehopper
    ["o|m"] = map_cu("lua require('tsht').nodes()"):with_silent():with_desc("jump: Operate across syntax tree"),

    -- Plugin: suda.vim
    ["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("editn: Save file using sudo"),

    -- Plugin: neogen.nvim
    ["n|gcd"] = map_cmd("<Cmd>lua require('neogen').generate()<CR>")
        :with_silent()
        :with_noremap()
        :with_desc("editor: Add documentation comments"),

    -- Plugin: ufo.nvim
    ["n|zR"] = map_cmd("<Cmd>lua require('ufo').openAllFolds()<CR>")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Open all folds"),
    ["n|zM"] = map_cmd("<Cmd>lua require('ufo').closeAllFolds()<CR>")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Close all folds"),
    ["n|zp"] = map_cmd("<Cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>")
        :with_silent()
        :with_noremap()
        :with_desc("edit: Preview all folds"),

    -- Plugin: refactoring.nvim
    ["v|<leader>Rt"] = map_cu(":Refactor extract_to_file")
        :with_silent()
        :with_noremap()
        :with_desc("refactoring: Extract to file"),
    ["v|<leader>Rf"] = map_cu(":Refactor extract")
        :with_silent()
        :with_noremap()
        :with_desc("refactoring: Extract function"),
    ["v|<leader>Rv"] = map_cu(":Refactor extract_var")
        :with_silent()
        :with_noremap()
        :with_desc("refactoring: Extract variable"),
    ["n|<leader>Rf"] = map_cu(":Refactor inlien_func")
        :with_silent()
        :with_noremap()
        :with_desc("refactoring: Inline variable"),
    ["n|<leader>Rv"] = map_cu(":Refactor inline_var")
        :with_silent()
        :with_noremap()
        :with_desc("refactoring: Inline variable"),

    -- Plugin: snacks.nvim
    ["n|<leader>`"] = map_callback(Snacks.scratch)
        :with_silent()
        :with_noremap()
        :with_desc("snacks: Toggle scratch buffer"),
    ["n|<leader>."] = map_callback(Snacks.scratch.select)
        :with_silent()
        :with_noremap()
        :with_desc("snacks: Select scratch buffer"),
    ["n|<leader>gg"] = map_callback(Snacks.lazygit)
        :with_silent()
        :with_noremap()
        :with_desc("git: Toggle lazygit"),

    -- Plugin: grug-far
    ["n|<leader>Ss"] = map_callback(function()
            require("grug-far").open()
        end)
        :with_silent()
        :with_noremap()
        :with_desc("editn: Toggle search & replace panel"),
    ["n|<leader>Sp"] = map_callback(function()
            require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end)
        :with_silent()
        :with_noremap()
        :with_desc("editn: search&replace current word (project)"),
    ["v|<leader>Sp"] = map_callback(function()
            require("grug-far").with_visual_selection()
        end)
        :with_silent()
        :with_noremap()
        :with_desc("edit: search & replace current word (project)"),
    ["n|<leader>Sf"] = map_callback(function()
            require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
        end)
        :with_silent()
        :with_noremap()
        :with_desc("editn: search & replace current word (file)"),
}

bind.nvim_load_mapping(plug_map)
